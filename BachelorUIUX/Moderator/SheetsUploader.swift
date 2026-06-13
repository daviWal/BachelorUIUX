//
//  SheetsUploader.swift
//  BachelorUIUX
//
//
//  Created by David Walitza on 14.04.2026.
//
//  Appends one row per completed session to a Google Sheets spreadsheet.
//  Authentication: service-account JWT → OAuth2 access token (1-hour TTL, cached).
//  No third-party dependencies — uses only URLSession and the Security framework.
//

import Foundation
import Security

enum SheetsUploaderError: Error {
    case notConfigured
    case keyParsingFailed
    case signingFailed
    case tokenFetchFailed(String)
    case sheetWriteFailed(String)
}

class SheetsUploader {

    // MARK: - Token cache

    private var cachedToken: String?
    private var tokenExpiry: Date?

    // MARK: - Sheet state

    /// nil = not yet checked; true/false = result of first upload's header probe.
    private var sheetHasHeader: Bool?

    // MARK: - Public API

    func appendRow(participantID: String, ageGroup: String, session: VariantSession) async throws {
        guard SheetsConfig.isConfigured else { throw SheetsUploaderError.notConfigured }

        let token = try await fetchAccessToken()

        let formatter = ISO8601DateFormatter()
        let start  = formatter.string(from: session.startTime)
        let end    = session.endTime.map { formatter.string(from: $0) } ?? ""
        let dur    = session.duration.map { String(format: "%.1f", $0) } ?? ""
        let row    = [participantID, ageGroup, session.variant, start, end, dur]

        try await appendToSheet(row: row, token: token)
    }

    // MARK: - OAuth2

    private func fetchAccessToken() async throws -> String {
        if let token = cachedToken, let expiry = tokenExpiry, Date() < expiry {
            return token
        }
        let jwt = try makeJWT()
        let body = "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(jwt)"

        var req = URLRequest(url: URL(string: "https://oauth2.googleapis.com/token")!)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.httpBody = body.data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: req)

        struct TokenResponse: Decodable { let access_token: String; let expires_in: Int }
        guard let resp = try? JSONDecoder().decode(TokenResponse.self, from: data) else {
            let msg = String(data: data, encoding: .utf8) ?? "no body"
            throw SheetsUploaderError.tokenFetchFailed(msg)
        }
        cachedToken = resp.access_token
        tokenExpiry = Date().addingTimeInterval(Double(resp.expires_in) - 60)
        return resp.access_token
    }

    // MARK: - JWT

    private func makeJWT() throws -> String {
        let now = Int(Date().timeIntervalSince1970)
        let header  = #"{"alg":"RS256","typ":"JWT"}"#
        let payload = """
        {"iss":"\(SheetsConfig.serviceAccountEmail)",\
        "scope":"https://www.googleapis.com/auth/spreadsheets",\
        "aud":"https://oauth2.googleapis.com/token",\
        "exp":\(now + 3600),"iat":\(now)}
        """

        let headerB64  = base64url(Data(header.utf8))
        let payloadB64 = base64url(Data(payload.utf8))
        let message    = Data((headerB64 + "." + payloadB64).utf8)

        let pkcs8DER = try pemToDER(SheetsConfig.privateKeyPEM)
        let pkcs1DER = try pkcs8ToPkcs1(pkcs8DER)

        let attrs: [CFString: Any] = [
            kSecAttrKeyType:  kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
        ]
        var cfErr: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(pkcs1DER as CFData, attrs as CFDictionary, &cfErr) else {
            throw SheetsUploaderError.keyParsingFailed
        }
        guard let sigData = SecKeyCreateSignature(
            secKey, .rsaSignatureMessagePKCS1v15SHA256, message as CFData, &cfErr
        ) else {
            throw SheetsUploaderError.signingFailed
        }
        return headerB64 + "." + payloadB64 + "." + base64url(sigData as Data)
    }

    // MARK: - PEM / DER helpers

    private func pemToDER(_ pem: String) throws -> Data {
        // Normalize literal \n sequences to actual newlines (handles keys pasted from JSON files).
        let normalized = pem.replacingOccurrences(of: "\\n", with: "\n")
        let b64 = normalized
            .components(separatedBy: "\n")
            .map  { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.hasPrefix("-----") && !$0.isEmpty }
            .joined()
        guard let der = Data(base64Encoded: b64) else { throw SheetsUploaderError.keyParsingFailed }
        return der
    }

    /// Strips the PKCS#8 wrapper to produce the PKCS#1 RSAPrivateKey DER that
    /// the Security framework expects.
    private func pkcs8ToPkcs1(_ der: Data) throws -> Data {
        var i = der.startIndex

        func readByte() throws -> UInt8 {
            guard i < der.endIndex else { throw SheetsUploaderError.keyParsingFailed }
            defer { i = der.index(after: i) }
            return der[i]
        }

        func readLen() throws -> Int {
            let first = try readByte()
            guard first & 0x80 != 0 else { return Int(first) }
            let numBytes = Int(first & 0x7f)
            guard numBytes > 0, numBytes <= 4 else { throw SheetsUploaderError.keyParsingFailed }
            var len = 0
            for _ in 0..<numBytes { len = (len << 8) | Int(try readByte()) }
            return len
        }

        func skipTag(_ expected: UInt8) throws {
            guard try readByte() == expected else { throw SheetsUploaderError.keyParsingFailed }
        }

        func skip(_ n: Int) throws {
            guard let end = der.index(i, offsetBy: n, limitedBy: der.endIndex) else {
                throw SheetsUploaderError.keyParsingFailed
            }
            i = end
        }

        try skipTag(0x30); _ = try readLen()                    // outer SEQUENCE
        try skipTag(0x02); try skip(try readLen())              // INTEGER version = 0
        try skipTag(0x30); try skip(try readLen())              // algorithm SEQUENCE
        try skipTag(0x04); let keyLen = try readLen()           // OCTET STRING (contains PKCS1)

        guard let keyEnd = der.index(i, offsetBy: keyLen, limitedBy: der.endIndex) else {
            throw SheetsUploaderError.keyParsingFailed
        }
        return der[i..<keyEnd]
    }

    // MARK: - Sheets API

    private func appendToSheet(row: [String], token: String) async throws {
        let base = "https://sheets.googleapis.com/v4/spreadsheets/\(SheetsConfig.spreadsheetID)"
        let encodedSheet = SheetsConfig.sheetName
            .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? SheetsConfig.sheetName

        // On first upload of this app session, probe A1 to decide if we need a header row.
        if sheetHasHeader == nil {
            let checkURL = URL(string: "\(base)/values/\(encodedSheet)!A1")!
            var checkReq = URLRequest(url: checkURL)
            checkReq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            if let (checkData, _) = try? await URLSession.shared.data(for: checkReq) {
                struct ValuesResp: Decodable { let values: [[String]]? }
                let existing = (try? JSONDecoder().decode(ValuesResp.self, from: checkData))?.values
                sheetHasHeader = (existing != nil && existing!.isEmpty == false)
            } else {
                sheetHasHeader = true  // assume headers exist if the check fails
            }
        }

        var rowsToWrite: [[String]] = []
        if sheetHasHeader == false {
            rowsToWrite.append(["participant_id", "age_group", "variant", "start", "end", "duration_s"])
            sheetHasHeader = true
        }
        rowsToWrite.append(row)

        let appendURL = URL(string:
            "\(base)/values/\(encodedSheet)!A1:append?valueInputOption=USER_ENTERED&insertDataOption=INSERT_ROWS"
        )!
        var req = URLRequest(url: appendURL)
        req.httpMethod = "POST"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: ["values": rowsToWrite])

        let (respData, httpResp) = try await URLSession.shared.data(for: req)
        if let http = httpResp as? HTTPURLResponse, http.statusCode != 200 {
            let msg = String(data: respData, encoding: .utf8) ?? "status \(http.statusCode)"
            throw SheetsUploaderError.sheetWriteFailed(msg)
        }
    }

    // MARK: - Helpers

    private func base64url(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
