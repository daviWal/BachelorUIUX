//
//  DetailView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 02.04.2026.
//

import SwiftUI

struct DetailView: View {
    let itemID: Int
    @EnvironmentObject var itemStore: ItemStore

    @State private var showEditSheet     = false
    @State private var showStatusPicker  = false

    private var item: AppItem? {
        itemStore.items.first { $0.id == itemID }
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    var body: some View {
        Group {
            if let item {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Icon
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.tint)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 16)

                        // Name
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(.semibold)

                        // Description
                        Text(item.description)
                            .foregroundStyle(.secondary)

                        Divider()

                        // Metadata
                        VStack(alignment: .leading, spacing: 12) {
                            // Status — tappable
                            Button {
                                showStatusPicker = true
                            } label: {
                                HStack {
                                    Text("Status")
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Text(item.status.rawValue)
                                            .fontWeight(.medium)
                                            .foregroundStyle(statusColor(item.status))
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .buttonStyle(.plain)

                            detailRow(
                                label: "Last Updated",
                                value: Self.dateFormatter.string(from: item.lastUpdated)
                            )
                            detailRow(
                                label: "Created",
                                value: Self.dateFormatter.string(from: item.createdDate)
                            )
                        }
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                .navigationTitle(item.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 16) {
                            // Favourite toggle
                            Button {
                                itemStore.toggleFavorite(id: itemID)
                            } label: {
                                Image(systemName: item.isFavorite ? "star.fill" : "star")
                                    .foregroundStyle(item.isFavorite ? .yellow : .secondary)
                                    .animation(.easeInOut(duration: 0.2), value: item.isFavorite)
                            }
                            // Edit
                            Button {
                                showEditSheet = true
                            } label: {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showEditSheet) {
                    ItemEditView(itemID: itemID)
                        .environmentObject(itemStore)
                }
                .confirmationDialog("Change Status", isPresented: $showStatusPicker, titleVisibility: .visible) {
                    ForEach(ItemStatus.allCases) { status in
                        Button(status.rawValue) {
                            itemStore.setStatus(id: itemID, status: status)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            } else {
                Text("Item not found.")
                    .foregroundStyle(.secondary)
            }
        }
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

    private func statusColor(_ status: ItemStatus) -> Color {
        switch status {
        case .active:   return .green
        case .draft:    return .orange
        case .archived: return .secondary
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(itemID: 0)
            .environmentObject(ItemStore())
    }
}
