//
//  ModeratorView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 05.04.2026.
//

import SwiftUI

struct ModeratorView: View {
    @ObservedObject var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss
    // group a = gen z group b = 50-65
    private let ageGroups = ["Group A", "Group B"]
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .medium
        f.dateStyle = .none
        return f
    }()

    var body: some View {
        NavigationStack {
            List {
                Section("Participant") {
                    TextField("Participant ID (e.g. P01)", text: $sessionManager.participantID)
                        .autocorrectionDisabled()
                    Picker("Age Group", selection: $sessionManager.ageGroup) {
                        ForEach(ageGroups, id: \.self) { Text($0) }
                    }
                }

                Section("Session Log") {
                    if sessionManager.sessions.isEmpty && sessionManager.activeVariant == nil {
                        Text("No sessions recorded yet.")
                            .foregroundStyle(.secondary)
                    }

                    if let active = sessionManager.activeVariant {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(active).fontWeight(.semibold)
                                Text("In progress…").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "timer")
                                .foregroundStyle(.orange)
                        }
                    }

                    ForEach(sessionManager.sessions.reversed()) { session in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(session.variant).fontWeight(.semibold)
                                if let start = session.endTime.map({ _ in session.startTime }) {
                                    Text(dateFormatter.string(from: start))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            HStack(spacing: 6) {
                                if let dur = session.duration {
                                    Text(formatDuration(dur))
                                        .monospacedDigit()
                                        .foregroundStyle(.green)
                                }
                                uploadIcon(for: session.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Moderator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(
                        item: sessionManager.exportCSV(),
                        subject: Text("Session Log"),
                        message: Text("BachelorUIUX session data")
                    ) {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                    .disabled(sessionManager.sessions.isEmpty)
                }
            }
        }
    }

    @ViewBuilder
    private func uploadIcon(for id: UUID) -> some View {
        switch sessionManager.uploadStatuses[id] {
        case .uploading:
            Image(systemName: "icloud.and.arrow.up")
                .foregroundStyle(.blue)
        case .uploaded:
            Image(systemName: "checkmark.icloud")
                .foregroundStyle(.green)
        case .failed:
            Image(systemName: "exclamationmark.icloud")
                .foregroundStyle(.red)
        case nil:
            EmptyView()
        }
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let s = Int(seconds)
        if s < 60 {
            return "\(s)s"
        } else {
            return "\(s / 60)m \(s % 60)s"
        }
    }
}

#Preview {
    let manager = SessionManager()
    manager.participantID = "P01"
    manager.ageGroup = "Gen Z"
    return ModeratorView(sessionManager: manager)
}
