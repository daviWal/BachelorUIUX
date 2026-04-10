//
//  ProfilePopupView.swift
//  BachelorUIUX
//

import SwiftUI

enum ProfileAction: String, Identifiable {
    case editProfile     = "Edit Profile"
    case accountSettings = "Account Settings"
    case notifications   = "Notifications"
    case privacy         = "Privacy"
    case helpAndSupport  = "Help & Support"

    var id: String { rawValue }
}

struct ProfilePopupView: View {
    let action: ProfileAction
    @Binding var name: String
    @Binding var email: String
    @Environment(\.dismiss) private var dismiss

    @State private var editedName: String = ""
    @State private var editedEmail: String = ""

    var body: some View {
        NavigationStack {
            Group {
                switch action {
                case .editProfile:
                    editProfileContent
                default:
                    placeholderContent
                }
            }
            .navigationTitle(action.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .onAppear {
            editedName = name
            editedEmail = email
        }
    }

    private var editProfileContent: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $editedName)
            }
            Section("Email") {
                TextField("Email", text: $editedEmail)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            Section {
                Button("Save Changes") {
                    name = editedName
                    email = editedEmail
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var placeholderContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Not yet available")
                .font(.headline)
            Text("This feature is not part of the current test version.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ProfilePopupView(
        action: .editProfile,
        name: .constant("YOUR NAME"),
        email: .constant("some@example.com")
    )
}
