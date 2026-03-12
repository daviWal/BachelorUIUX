//
//  ProfileView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 10.03.2026.
//

import SwiftUI

struct ProfileView: View {


    @State var isPresented: Bool = false
    @State var isEditing: Bool = false
    @State var isEditingName: Bool = false
    @State var isEditingEmail: Bool = false
    @State var isEditingPhone: Bool = false


    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 48))
                .foregroundStyle(.tint)
            HStack {
                Text("settings")
                Image(systemName: "gear")
                    .font(.system(size: 24))
                    .foregroundStyle(.tint)
                if isPresented {
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        Text("Close")
                    }
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

//#Preview {
//    ProfileView()
//}
