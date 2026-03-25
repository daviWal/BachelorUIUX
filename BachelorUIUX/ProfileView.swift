//
//  ProfileView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 10.03.2026.
//

import SwiftUI

struct ProfileView: View {

    var onBackToTestSelection: (() -> Void)? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.tint)

                    Text("YOUR NAME")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("some@example.com")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                VStack(spacing: 12) {
                    profileRow(title: "Edit Profile", systemImage: "person")
                    profileRow(title: "Account Settings", systemImage: "gear")
                    profileRow(title: "Notifications", systemImage: "bell")
                    profileRow(title: "Privacy", systemImage: "lock")
                    profileRow(title: "Help & Support", systemImage: "questionmark.circle")
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
    }

    private func profileRow(title: String, systemImage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: 24)
                .foregroundStyle(.tint)

            Text(title)
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

    private func handleExitAction() {
        onBackToTestSelection?()
    }
}

#Preview {
    ProfileView()
}
