//
//  Order.swift
//  FiveCoin
//
//  Created by Burak Kaya on 27.06.2025.
//

import Foundation

enum OrderType: String, Codable, CaseIterable, Identifiable {
    case buy = "Buy"
    case sell = "Sell"
    
    var id: String { self.rawValue }
}

struct Order: Identifiable, Codable {
    let id: UUID
    let itemID: String
    let price: Double
    let note: String?
    let orderType: OrderType?
    let date: Date
}

