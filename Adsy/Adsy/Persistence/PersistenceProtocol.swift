//
//  PersistenceProtocol.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-04.
//

import Foundation
import SwiftData

protocol PersistenceProtocol {
    var modelContext: ModelContext? { get }

    func fetchItems<T: PersistentModel>() -> [T]

    @discardableResult
    func removeItem<T: PersistentModel>(_ item: T) -> T?

    @discardableResult
    func addItem<T: PersistentModel>(_ item: T) -> T?
}

extension PersistenceProtocol {
    func fetchItems<T: PersistentModel>() -> [T] {
        let fetchDescriptor = FetchDescriptor<T>()
        let items = try? modelContext?.fetch(fetchDescriptor)
        return items ?? []
    }

    @discardableResult
    func removeItem<T: PersistentModel>(_ item: T) -> T? {
        modelContext?.delete(item)
        do {
            try modelContext?.save()
            return item
        } catch {
            return nil
        }
    }

    @discardableResult
    func addItem<T: PersistentModel>(_ item: T) -> T? {
        modelContext?.insert(item)
        do {
            try modelContext?.save()
            return item
        } catch {
            return nil
        }
    }
}
