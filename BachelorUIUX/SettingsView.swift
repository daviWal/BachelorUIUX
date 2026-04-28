//
//  SettingsView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 02.04.2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var locationEnabled = false
    @State private var darkModeEnabled = false

    var body: some View {
        List {
            Section("Notifications") {
                Toggle("Push Notifications", isOn: $notificationsEnabled)
            }
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }
            Section("Privacy") {
                Toggle("Location Access", isOn: $locationEnabled)
            }
            Section("About") {
                LabeledContent("Version", value: "1.2")
                LabeledContent("Build", value: "1")
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .navigationTitle("Settings")
    }
}
