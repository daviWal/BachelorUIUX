//
//  ItemsView.swift
//  BachelorUIUX
//
//  Created by David Walitza on 12.03.2026.
//

import SwiftUI

struct ItemsView: View {
    private let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

    var body: some View {
        List(items, id: \.self) { item in
            NavigationLink(destination: DetailView(itemTitle: item).navigationTitle(item)) {
                Label(item, systemImage: "doc.text")
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        ItemsView()
            .navigationTitle("Items")
    }
}
