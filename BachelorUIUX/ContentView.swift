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
    @State private var showModerator = false
    @StateObject private var sessionManager = SessionManager()

    var body: some View {
        Group {
            switch selectedVersion {
            case .selection:
                selectionView
            case .version1:
                BurgerContentView(onBackToTestSelection: {
                    sessionManager.endSession()
                    selectedVersion = .selection
                })
            case .version2:
                TabBarContentView(onBackToTestSelection: {
                    sessionManager.endSession()
                    selectedVersion = .selection
                })
            case .version3:
                MainMenuContentView(onBackToTestSelection: {
                    sessionManager.endSession()
                    selectedVersion = .selection
                })
            }
        }
        .sheet(isPresented: $showModerator) {
            ModeratorView(sessionManager: sessionManager)
        }
    }

    private var selectionView: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button {
                    sessionManager.startSession(variant: "Version 1")
                    selectedVersion = .version1
                } label: {
                    Text("Version 1")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }

                Button {
                    sessionManager.startSession(variant: "Version 2")
                    selectedVersion = .version2
                } label: {
                    Text("Version 2")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }

                Button {
                    sessionManager.startSession(variant: "Version 3")
                    selectedVersion = .version3
                } label: {
                    Text("Version 3")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        showModerator = true
                    } label: {
                        Label("Moderator", systemImage: "person.badge.clock")
                            .font(.footnote)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.indigo.opacity(0.12))
                            .cornerRadius(10)
                    }

                    Button(role: .destructive) {
                        sessionManager.reset()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.footnote)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.red.opacity(0.10))
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 8)
            }
            .padding()
            .navigationTitle("Select Test Version")
        }
    }
}

#Preview {
    ContentView()
}
