//
//  OrdersListView.swift
//  FiveCoin
//
//  Created by Burak Kaya on 27.06.2025.
//

import SwiftUI

struct OrdersListView: View {
    let item: SelectedItem
    @ObservedObject var orderManager: OrderManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("#0F2027"), Color("#203A43"), Color("#2C5364")],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("Order History")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }

            
            List {
                let coinOrders = orderManager.getOrders(for: item.id)
                
                if coinOrders.isEmpty {
                    Text("There are no orders for this item yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(coinOrders) { order in
                        VStack(alignment: .leading) {
                            Text("Price: $\(String(format: "%.2f", order.price))")
                                .fontWeight(.bold)
                            
                            if let type = order.orderType {
                                Text("Type: \(type.rawValue)")
                                    .font(.caption)
                                    .foregroundColor(type == .buy ? .green : .red)
                            }
                            
                            if let note = order.note, !note.isEmpty {
                                Text("Note: \(note)")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        delete(at: indexSet)
                    }
                }
            }
            .navigationTitle("\(item.name) Orders")
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black.opacity(0.3), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        let orders = orderManager.getOrders(for: item.id)
        for index in offsets {
            let order = orders[index]
            orderManager.delete(order: order)
        }
    }
}

#Preview {
    let exampleCoin = Coin(
        id: "bitcoin",
        symbol: "BTC",
        name: "Bitcoin",
        logoURL: "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
        currentPrice: 45000.0,
        marketCap: nil,
        marketCapRank: 1,
        fullyDilutedValuation: nil,
        totalVolume: nil,
        high24h: 46000,
        low24h: 43000,
        priceChange24h: nil,
        priceChangePercentage24h: -3.25,
        marketCapChange24h: nil,
        marketCapChangePercentage24h: nil,
        circulatingSupply: nil,
        totalSupply: nil,
        maxSupply: nil,
        platforms: [:]
    )

    let selected = SelectedItem(id: exampleCoin.id, type: .coin(exampleCoin))

    let manager = OrderManager.shared
    manager.addOrder(Order(
        id: UUID(),
        itemID: exampleCoin.id,
        price: 123.45,
        note: "Takip et",
        orderType: .buy,
        date: Date()
    ))

    return NavigationStack {
        OrdersListView(item: selected, orderManager: manager)
    }
}
