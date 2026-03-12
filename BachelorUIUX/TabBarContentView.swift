//
//  TabBarContentView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 12.03.2026.
//

import SwiftUI

struct TabBarContentView: View {
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
        }
    }
}

#Preview {
    TabBarContentView()
}
