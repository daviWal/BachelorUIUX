//
//  HelpView.swift
//  BachelorUIUX
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        List {
            Section("Getting Started") {
                helpRow(
                    question: "How do I navigate the app?",
                    answer: "Use the navigation controls to move between screens."
                )
                helpRow(
                    question: "How do I find my profile?",
                    answer: "Access your profile through the navigation menu or tab bar."
                )
            }
            Section("Account") {
                helpRow(
                    question: "How do I edit my profile?",
                    answer: "Go to Profile and tap Edit Profile."
                )
                helpRow(
                    question: "How do I change my settings?",
                    answer: "Open the Settings screen from the navigation menu."
                )
            }
            Section("Contact") {
                helpRow(
                    question: "Need more help?",
                    answer: "Contact us at support@example.com"
                )
            }
        }
        .background(Color(.systemBackground))
    }

    private func helpRow(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(question)
                .fontWeight(.semibold)
            Text(answer)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        HelpView()
            .navigationTitle("Help")
    }
}
