//
//  BurgerContentView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 12.03.2026.
//

import SwiftUI

struct BurgerContentView: View {
    enum Screen {
            case home
            case items
            case profile
        }

        @State private var selectedScreen: Screen = .home

        var body: some View {
            NavigationStack {
                Group {
                    switch selectedScreen {
                    case .home:
                        HomeView()
                    case .items:
                        ItemsView()
                    case .profile:
                        ProfileView()
                    }
                }
                .navigationTitle(titleForScreen(selectedScreen))
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button("Home", systemImage: "house") {
                                selectedScreen = .home
                            }

                            Button("Items", systemImage: "list.bullet") {
                                selectedScreen = .items
                            }

                            Button("Profile", systemImage: "person") {
                                selectedScreen = .profile
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
            }
        }

        private func titleForScreen(_ screen: Screen) -> String {
            switch screen {
            case .home:
                return "Home"
            case .items:
                return "Items"
            case .profile:
                return "Profile"
            }
        }
    }
#Preview {
    BurgerContentView()
}
