//
//  SessionManager.swift
//  BachelorUIUX
//
//  Created by David Walitza on 05.04.2026.
//

import Foundation
import Combine

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

    private var activeSession: VariantSession?

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
        activeSession = nil
    }

    /// Active variant name, if a session is currently running.
    var activeVariant: String? {
        activeSession?.variant
    }

    /// Resets all session data for the next participant.
    func reset() {
        activeSession = nil
        sessions = []
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
