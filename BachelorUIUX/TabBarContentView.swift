//
//  TabBarContentView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 12.03.2026.
//

import SwiftUI

struct TabBarContentView: View {
    var onBackToTestSelection: (() -> Void)? = nil
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(0)

                ItemsView()
                    .tabItem { Label("Items", systemImage: "tray.full") }
                    .tag(1)

                ProfileView(onBackToTestSelection: onBackToTestSelection)
                    .tabItem { Label("Profile", systemImage: "person") }
                    .tag(2)

                HelpView()
                    .tabItem { Label("Help", systemImage: "questionmark.circle") }
                    .tag(3)

                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }
                    .tag(4)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 30)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let threshold: CGFloat = 50

                        if horizontalAmount < -threshold {
                            selectedTab = min(selectedTab + 1, 4)
                        } else if horizontalAmount > threshold {
                            selectedTab = max(selectedTab - 1, 0)
                        }
                    }
            )
            .navigationTitle(titleForTab(selectedTab))
        }
    }

    private func titleForTab(_ tab: Int) -> String {
        switch tab {
        case 0: return "Home"
        case 1: return "Items"
        case 2: return "Profile"
        case 3: return "Help"
        case 4: return "Settings"
        default: return "Home"
        }
    }
}

#Preview {
    TabBarContentView()
}
