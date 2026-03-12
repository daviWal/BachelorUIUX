//
//  ContentView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 10.03.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                NavigationLink(destination: BurgerContentView()) {
                    Text("Version 1")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }

                NavigationLink(destination: TabBarContentView()) {
                    Text("Version 2")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }

                Button(action: {
                    // Placeholder – no navigation yet
                }) {
                    Text("Version 3")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Select Test Version")
        }
    }
}

#Preview {
    ContentView()
}
