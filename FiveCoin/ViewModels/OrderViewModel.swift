//
//  OrderViewModel.swift
//  FiveCoin
//
//  Created by Burak Kaya on 27.06.2025.
//

import Foundation

final class OrderManager: ObservableObject {
    static let shared = OrderManager()

    @Published private(set) var orders: [Order] = []

    private init() {
        loadOrders()
    }

    func addOrder(_ order: Order) {
        orders.append(order)
        saveOrders()
    }

    func delete(order: Order) {
        orders.removeAll { $0.id == order.id }
        saveOrders()
    }

    func deleteOrders(at offsets: IndexSet, for itemID: String) {
        let filteredOrders = getOrders(for: itemID)
        let ordersToDelete = offsets.map { filteredOrders[$0] }
        for order in ordersToDelete {
            delete(order: order)
        }
    }

    func getOrders(for itemID: String) -> [Order] {
        orders.filter { $0.itemID == itemID }
    }

    private func saveOrders() {
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: "orders")
        }
    }

    private func loadOrders() {
        if let data = UserDefaults.standard.data(forKey: "orders"),
           let decoded = try? JSONDecoder().decode([Order].self, from: data) {
            self.orders = decoded
        }
    }
}
