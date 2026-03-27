//
//  ProfileView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 10.03.2026.
//

import SwiftUI

struct ProfileView: View {

    var onBackToTestSelection: (() -> Void)? = nil

    @State private var name: String = "YOUR NAME"
    @State private var email: String = "some@example.com"
    @State private var activeAction: ProfileAction? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.tint)

                    Text(name)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                VStack(spacing: 12) {
                    profileRowButton(action: .editProfile,      systemImage: "person")
                    profileRowButton(action: .accountSettings,  systemImage: "gear")
                    profileRowButton(action: .notifications,    systemImage: "bell")
                    profileRowButton(action: .privacy,          systemImage: "lock")
                    profileRowButton(action: .helpAndSupport,   systemImage: "questionmark.circle")
                }

                VStack(spacing: 12) {
                    Button {
                        handleExitAction()
                    } label: {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.12))
                            .foregroundStyle(.red)
                            .cornerRadius(14)
                    }
                }
                .padding(.top, 8)

                Spacer(minLength: 20)

                Button {
                    handleExitAction()
                } label: {
                    Label("Back to Test Selection", systemImage: "arrow.uturn.left")
                        .font(.footnote)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.blue.opacity(0.12))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .sheet(item: $activeAction) { action in
            ProfilePopupView(action: action, name: $name, email: $email)
        }
    }

    private func profileRowButton(action: ProfileAction, systemImage: String) -> some View {
        Button {
            activeAction = action
        } label: {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .frame(width: 24)
                    .foregroundStyle(.tint)

                Text(action.rawValue)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }

    private func handleExitAction() {
        onBackToTestSelection?()
    }
}

#Preview {
    ProfileView()
}
