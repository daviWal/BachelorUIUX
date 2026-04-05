//
//  MainMenuContentView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 25.03.2026.
//

import SwiftUI

struct MainMenuContentView: View {
    var onBackToTestSelection: (() -> Void)? = nil
    @State private var selectedScreen = 0

    var body: some View {
        NavigationStack {
            Group {
                switch selectedScreen {
                case 0:
                    mainMenuView
                case 1:
                    ItemsView()
                case 2:
                    ProfileView(onBackToTestSelection: onBackToTestSelection)
                case 3:
                    HelpView()
                case 4:
                    SettingsView()
                default:
                    mainMenuView
                }
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        handleSwipe(value)
                    }
            )
            .navigationTitle(titleForScreen(selectedScreen))
            .toolbar {
                if selectedScreen != 0 {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            selectedScreen = 0
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
            }
        }
    }

    private var mainMenuView: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Home Screen")
                .font(.title)
                .bold()

            VStack(spacing: 16) {
                Button { selectedScreen = 1 } label: {
                    Label("Items", systemImage: "tray.full")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(14)
                }

                Button { selectedScreen = 2 } label: {
                    Label("Profile", systemImage: "person")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(14)
                }

                Button { selectedScreen = 3 } label: {
                    Label("Help", systemImage: "questionmark.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(14)
                }

                Button { selectedScreen = 4 } label: {
                    Label("Settings", systemImage: "gear")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(14)
                }
            }
        }
        .padding()
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
        let threshold: CGFloat = 50

        guard abs(horizontalAmount) > abs(verticalAmount) else { return }

        if horizontalAmount < -threshold {
            selectedScreen = min(selectedScreen + 1, 2)
        } else if horizontalAmount > threshold {
            selectedScreen = max(selectedScreen - 1, 0)
        }
    }
}

#Preview {
    MainMenuContentView()
}
