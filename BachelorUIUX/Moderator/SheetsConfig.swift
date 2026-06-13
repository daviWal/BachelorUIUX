//
//  SheetsConfig.swift
//  BachelorUIUX
//
//  Reads credentials from Secrets.json at runtime.
//  Secrets.json is gitignored — copy Secrets.example.json to Secrets.json
//  and fill in your values before building.
//

import Foundation

enum SheetsConfig {

    private static let secrets: [String: String] = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: String]
        else { return [:] }
        return dict
    }()

    static var spreadsheetID: String       { secrets["spreadsheetID"] ?? "" }
    static var serviceAccountEmail: String { secrets["serviceAccountEmail"] ?? "" }
    static var privateKeyPEM: String       { secrets["privateKeyPEM"] ?? "" }
    static let sheetName = "Sheet1"

    static var isConfigured: Bool {
        !spreadsheetID.isEmpty &&
        !serviceAccountEmail.isEmpty &&
        !privateKeyPEM.isEmpty
    }
}
