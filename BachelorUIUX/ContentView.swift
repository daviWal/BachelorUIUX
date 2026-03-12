//
//  ContentView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 10.03.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                ItemsView()
                    .tabItem {
                        Label("Items", systemImage: "tray.full" )
                    }
                    .tag(1)

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(2)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let threshold: CGFloat = 50

                        if horizontalAmount < -threshold {
                            selectedTab = min(selectedTab + 1, 2)
                        } else if horizontalAmount > threshold {
                            selectedTab = max(selectedTab - 1, 0)
                        }
                    }
            )
            .navigationTitle("Home screen")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Settings", systemImage: "gear") {
                        }

                        Button("Help", systemImage: "questionmark.circle") {
                        }

                        Button("Logout", systemImage: "rectangle.portrait.and.arrow.right") {
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
