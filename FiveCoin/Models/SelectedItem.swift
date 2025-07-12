//
//  SelectedItem.swift
//  FiveCoin
//
//  Created by Burak Kaya on 21.06.2025.
//

struct SelectedItem: Identifiable, Equatable {
    enum ItemType: Equatable {
        case coin(Coin)
        case dex(DexScreenerPair)

        static func == (lhs: ItemType, rhs: ItemType) -> Bool {
            switch (lhs, rhs) {
            case let (.coin(c1), .coin(c2)):
                return c1.id == c2.id
            case let (.dex(d1), .dex(d2)):
                return d1.pairAddress == d2.pairAddress
            default:
                return false
            }
        }
    }

    let id: String
    let type: ItemType

    var name: String {
        switch type {
        case .coin(let c): return c.name
        case .dex(let d): return d.baseToken?.symbol ?? "N/A"
        }
    }

    var symbol: String {
        switch type {
        case .coin(let c): return c.symbol.uppercased()
        case .dex(let d): return d.baseToken?.symbol?.uppercased() ?? "N/A"
        }
    }

    var logoURL: String? {
        switch type {
        case .coin(let c): return c.logoURL
        case .dex(let d): return d.baseToken?.address
        }
    }

    var priceUsd: Double? {
        switch type {
        case .coin(let c): return c.currentPrice
        case .dex(let d): return Double(d.priceUsd ?? "")
        }
    }

    static func == (lhs: SelectedItem, rhs: SelectedItem) -> Bool {
        lhs.id == rhs.id
    }
}
