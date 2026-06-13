//
//  SessionManager.swift
//  BachelorUIUX
//
//  Created by David Walitza on 05.04.2026.
//

import Foundation
import Combine

enum UploadStatus {
    case uploading
    case uploaded
    case failed
}

struct VariantSession: Identifiable {
    let id = UUID()
    let variant: String
    let startTime: Date
    var endTime: Date?

    var duration: TimeInterval? {
        guard let end = endTime else { return nil }
        return end.timeIntervalSince(startTime)
    }
}

class SessionManager: ObservableObject {
    @Published var participantID: String = ""
    @Published var ageGroup: String = "Gen Z"
    @Published var sessions: [VariantSession] = []
    @Published var uploadStatuses: [UUID: UploadStatus] = [:]

    private var activeSession: VariantSession?
    private let uploader = SheetsUploader()

    /// Call when the participant taps a version button.
    func startSession(variant: String) {
        if activeSession != nil {
            endSession()
        }
        activeSession = VariantSession(variant: variant, startTime: Date())
    }

    /// Call when the participant taps "Back to Test Selection".
    func endSession() {
        guard var session = activeSession else { return }
        session.endTime = Date()
        sessions.append(session)
        uploadStatuses[session.id] = .uploading
        activeSession = nil

        let pid = participantID
        let ag  = ageGroup
        Task {
            do {
                try await uploader.appendRow(participantID: pid, ageGroup: ag, session: session)
                await MainActor.run { self.uploadStatuses[session.id] = .uploaded }
            } catch {
                print("[SheetsUploader] Upload failed: \(error)")
                await MainActor.run { self.uploadStatuses[session.id] = .failed }
            }
        }
    }

    /// Active variant name, if a session is currently running.
    var activeVariant: String? {
        activeSession?.variant
    }

    /// Resets all session data for the next participant.
    func reset() {
        activeSession = nil
        sessions = []
        uploadStatuses = [:]
        participantID = ""
        ageGroup = "Gen Z"
    }

    func exportCSV() -> String {
        let formatter = ISO8601DateFormatter()
        var lines = ["participant_id,age_group,variant,start,end,duration_s"]
        for s in sessions {
            let start = formatter.string(from: s.startTime)
            let end = s.endTime.map { formatter.string(from: $0) } ?? ""
            let dur = s.duration.map { String(format: "%.1f", $0) } ?? ""
            lines.append("\(participantID),\(ageGroup),\(s.variant),\(start),\(end),\(dur)")
        }
        return lines.joined(separator: "\n")
    }
}
