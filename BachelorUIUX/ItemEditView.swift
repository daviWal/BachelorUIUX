//
//  ItemEditView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 24.04.2026.
//

import SwiftUI

struct ItemEditView: View {
    let itemID: Int
    @EnvironmentObject var itemStore: ItemStore
    @Environment(\.dismiss) private var dismiss

    @State private var editedName: String = ""
    @State private var editedDescription: String = ""

    private var item: AppItem? {
        itemStore.items.first { $0.id == itemID }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $editedName)
                        .autocorrectionDisabled()
                }

                Section("Description") {
                    TextEditor(text: $editedDescription)
                        .frame(minHeight: 100)
                }

                Section {
                    Button("Save Changes") {
                        itemStore.update(
                            id: itemID,
                            name: editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                ? (item?.name ?? "")
                                : editedName,
                            description: editedDescription
                        )
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .onAppear {
            editedName        = item?.name        ?? ""
            editedDescription = item?.description ?? ""
        }
    }
}

#Preview {
    let store = ItemStore()
    return ItemEditView(itemID: 0)
        .environmentObject(store)
}
