//
//  DexScreenerData.swift
//  FiveCoin
//
//  Created by Burak Kaya on 17.06.2025.
//

import Foundation

struct PriceChange: Codable {
    let someKey: Double?
}

struct DexScreenerPair: Codable, Identifiable {
    var id: String { pairAddress! }
    
    let chainId: String?
    let dexId: String?
    let url: String?
    let pairAddress: String?
    let labels: [String]?
    let baseToken: Token?
    let quoteToken: Token?
    let priceNative: String?
    let priceUsd: String?
    let volume: Volume?
    let priceChange: [String: Double]?
    let liquidity: Liquidity?
    let fdv: Double?
    let marketCap: Double?
    let pairCreatedAt: Int64?
}

struct DexScreenerResponse: Codable {
    let schemaVersion: String?
    let pairs: [DexScreenerPair]?
}

struct Token: Codable {
    let address: String?
    let name: String?
    let symbol: String?
}

struct BuySell: Codable {
    let buys: Int?
    let sells: Int?
}

struct Volume: Codable {
    let h24: Double?
    let h6: Double?
    let h1: Double?
    let m5: Double?
}

struct Liquidity: Codable {
    let usd: Double?
    let base: Double?
    let quote: Double?
}

