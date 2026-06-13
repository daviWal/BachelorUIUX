//
//  ItemsView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 12.03.2026.
//

import SwiftUI

struct ItemsView: View {
    @EnvironmentObject var itemStore: ItemStore

    var body: some View {
        List(itemStore.items) { item in
            NavigationLink(destination: DetailView(itemID: item.id)) {
                HStack {
                    Label(item.name, systemImage: "doc.text")
                    Spacer()
                    if item.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        ItemsView()
            .navigationTitle("Items")
            .environmentObject(ItemStore())
    }
}
