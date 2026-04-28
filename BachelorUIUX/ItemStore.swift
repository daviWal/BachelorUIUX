//
//  ItemStore.swift
//  BachelorUIUX
//
//  Created by David Walitza on 24.04.2026.
//

import Foundation
import Combine

enum ItemStatus: String, CaseIterable, Identifiable {
    case active   = "Active"
    case archived = "Archived"
    case draft    = "Draft"
    var id: String { rawValue }
}

struct AppItem: Identifiable {
    let id: Int
    var name: String
    var description: String
    var lastUpdated: Date
    var createdDate: Date
    var isFavorite: Bool
    var status: ItemStatus
}

class ItemStore: ObservableObject {
    @Published var items: [AppItem] = ItemStore.defaultItems()

    func update(id: Int, name: String, description: String) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items[idx].name        = name
        items[idx].description = description
        items[idx].lastUpdated = Date()
    }

    func toggleFavorite(id: Int) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items[idx].isFavorite.toggle()
    }

    func setStatus(id: Int, status: ItemStatus) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items[idx].status = status
    }

    // MARK: - Default data

    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var c = DateComponents()
        c.year = year; c.month = month; c.day = day
        return Calendar.current.date(from: c) ?? Date()
    }

    private static func defaultItems() -> [AppItem] {
        [
            AppItem(
                id: 0,
                name: "Item 1",
                description: "This item contains an overview of the most recent changes and updates. Review it regularly to stay informed.",
                lastUpdated: date(2026, 4, 24),
                createdDate: date(2026, 1, 10),
                isFavorite: false,
                status: .active
            ),
            AppItem(
                id: 1,
                name: "Item 2",
                description: "A collection of reference materials and key contacts. Use this item when you need to look up essential information quickly.",
                lastUpdated: date(2026, 4, 15),
                createdDate: date(2026, 1, 22),
                isFavorite: false,
                status: .active
            ),
            AppItem(
                id: 2,
                name: "Item 3",
                description: "Draft notes from the planning phase. Some sections are still incomplete and will be updated in the next revision.",
                lastUpdated: date(2026, 3, 28),
                createdDate: date(2026, 2, 5),
                isFavorite: false,
                status: .draft
            ),
            AppItem(
                id: 3,
                name: "Item 4",
                description: "Archive of completed tasks and closed tickets. Kept for reference — no further action required.",
                lastUpdated: date(2026, 4, 2),
                createdDate: date(2025, 11, 18),
                isFavorite: false,
                status: .active
            ),
            AppItem(
                id: 4,
                name: "Item 5",
                description: "Personal notes and reminders. Contents are private and may be updated at any time without prior notice.",
                lastUpdated: date(2026, 3, 10),
                createdDate: date(2025, 9, 3),
                isFavorite: false,
                status: .active
            ),
        ]
    }
}
