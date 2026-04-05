//
//  DetailView.swift
//  BachelorUIUX
//

import SwiftUI

struct DetailView: View {
    let itemTitle: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)

                Text(itemTitle)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("This is the detail view for \(itemTitle). Here you would find more information about this item, including descriptions, metadata, and any actions you can take.")
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    detailRow(label: "Category", value: "General")
                    detailRow(label: "Status", value: "Active")
                    detailRow(label: "Last updated", value: "Today")
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(itemTitle: "Item 1")
            .navigationTitle("Item 1")
    }
}
