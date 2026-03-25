//
//  ContentView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 10.03.2026.
//

import SwiftUI

struct ContentView: View {
    enum TestVersion {
        case selection
        case version1
        case version2
        case version3
    }

    @State private var selectedVersion: TestVersion = .selection

    var body: some View {
        Group {
            switch selectedVersion {
            case .selection:
                selectionView
            case .version1:
                BurgerContentView()
            case .version2:
                TabBarContentView()
            case .version3:
                placeholderView
            }
        }
    }

    private var selectionView: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button {
                    selectedVersion = .version1
                } label: {
                    Text("Version 1")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }

                Button {
                    selectedVersion = .version2
                } label: {
                    Text("Version 2")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }

                Button {
                    selectedVersion = .version3
                } label: {
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

    private var placeholderView: some View {
        VStack(spacing: 20) {
            Text("Version 3")
                .font(.largeTitle)
                .bold()

            Text("Not implemented yet")
                .foregroundStyle(.secondary)

            Button("Back to selection") {
                selectedVersion = .selection
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
