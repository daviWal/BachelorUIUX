//
//  BurgerContentView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 12.03.2026.
//

import SwiftUI

struct BurgerContentView: View {
    var onBackToTestSelection: (() -> Void)? = nil
    @State private var selectedScreen = 0

    var body: some View {
        NavigationStack {
            Group {
                switch selectedScreen {
                case 0:
                    HomeView()
                case 1:
                    ItemsView()
                case 2:
                    ProfileView(onBackToTestSelection: onBackToTestSelection)
                case 3:
                    HelpView()
                case 4:
                    SettingsView()
                default:
                    HomeView()
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 30)
                    .onEnded { value in
                        handleSwipe(value)
                    }
            )
            .navigationTitle(titleForScreen(selectedScreen))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Home", systemImage: "house") {
                            selectedScreen = 0
                        }
                        Button("Items", systemImage: "tray.full") {
                            selectedScreen = 1
                        }
                        Button("Profile", systemImage: "person") {
                            selectedScreen = 2
                        }
                        Button("Help", systemImage: "questionmark.circle") {
                            selectedScreen = 3
                        }
                        Button("Settings", systemImage: "gear") {
                            selectedScreen = 4
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        }
    }

    private func titleForScreen(_ screen: Int) -> String {
        switch screen {
        case 0: return "Home"
        case 1: return "Items"
        case 2: return "Profile"
        case 3: return "Help"
        case 4: return "Settings"
        default: return "Home"
        }
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height

        guard abs(horizontalAmount) > abs(verticalAmount) else { return }

        if horizontalAmount < -50 {
            goToNextScreen()
        } else if horizontalAmount > 50 {
            goToPreviousScreen()
        }
    }

    private func goToNextScreen() {
        selectedScreen = min(selectedScreen + 1, 4)
    }

    private func goToPreviousScreen() {
        selectedScreen = max(selectedScreen - 1, 0)
    }
}

#Preview {
    BurgerContentView()
}
