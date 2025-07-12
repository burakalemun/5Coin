//
//  FiveCoinWidget.swift
//  FiveCoinWidget
//
//  Created by Burak Kaya on 17.05.2025.
//

import WidgetKit
import SwiftUI

struct FiveCoinWidgetEntryView : View {
    var entry: CoinProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !entry.coins.isEmpty {
                ForEach(entry.coins.prefix(1)) { coin in
                    CoinRow(coin: coin)
                }
            }

            if !entry.dexPairs.isEmpty {
                ForEach(entry.dexPairs.prefix(1)) { pair in
                    DexPairRow(pair: pair)
                }
            }
        }
        .foregroundStyle(.primary)
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

struct CoinRow: View {
    let coin: Coin

    var body: some View {
        HStack(spacing: 8) {
            if let logoURL = coin.logoURL, let url = URL(string: logoURL) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit().frame(width: 24, height: 24)
                    } else {
                        ProgressView().frame(width: 24, height: 24)
                    }
                }
            } else {
                Image(systemName: "questionmark.circle.fill")
                    .resizable().scaledToFit().frame(width: 24, height: 24)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name).font(.system(size: 16, weight: .bold))

                Text("$ \(coin.currentPrice?.formattedTurkishStyle ?? "-")")
                    .font(.subheadline)

                if let change = coin.priceChangePercentage24h {
                    Text("\(String(format: "%.2f", change))%")
                        .font(.caption)
                        .foregroundColor(change >= 0 ? .green : .red)
                }
            }
        }
    }
}

struct DexPairRow: View {
    let pair: DexScreenerPair

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(pair.baseToken?.symbol?.uppercased() ?? "N/A") / \(pair.quoteToken?.symbol?.uppercased() ?? "N/A")")
                .font(.system(size: 16, weight: .bold))

            if let price = pair.priceUsd {
                Text("Price: $\(price)")
                    .font(.subheadline)
            }
        }
    }
}


struct CoinEntry: TimelineEntry {
    let date: Date
    let coins: [Coin]
    let dexPairs: [DexScreenerPair]
    
}

struct CoinProvider: TimelineProvider {
    
    let userDefaults = UserDefaults(suiteName: "group.com.burakkaya.fivecoin")
    
    func placeholder(in context: Context) -> CoinEntry {
        print("Placeholder çağrıldı")
        return CoinEntry(date: Date(), coins: [], dexPairs: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (CoinEntry) -> Void) {
        let coins = loadSelectedCoins()
        print("Snapshot çağrıldı - Coin sayısı: \(coins.count)")
        let entry = CoinEntry(date: Date(), coins: coins, dexPairs: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CoinEntry>) -> Void) {
        let coins = loadSelectedCoins()
        let dexPairs = loadSelectedDexPairs()
        print("Timeline oluşturuluyor... Coin sayısı: \(coins.count)")
        
        let entry = CoinEntry(date: Date(), coins: coins, dexPairs: dexPairs)
        let nextUpdate = Calendar.current.date(byAdding: .second, value: 30, to: Date())!

        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadSelectedCoins() -> [Coin] {
        guard let data = userDefaults?.data(forKey: "selectedCoins") else {
            print("Widget: Veri bulunamadı.")
            return []
        }
        
        do {
            let decoded = try JSONDecoder().decode([Coin].self, from: data)
            print("Widget: \(decoded.count) coin yüklendi.")
            return decoded
        } catch {
            print("Widget: Decode hatası - \(error)")
            return []
        }
    }
    
    private func loadSelectedDexPairs() -> [DexScreenerPair] {
        guard let data = userDefaults?.data(forKey: "selectedDexPairs") else {
            print("Widget: DEX verisi bulunamadı.")
            return []
        }

        do {
            let decoded = try JSONDecoder().decode([DexScreenerPair].self, from: data)
            print("Widget: \(decoded.count) DEX coin yüklendi.")
            return decoded
        } catch {
            print("Widget: Decode hatası - \(error)")
            return []
        }
    }
}

struct FiveCoinWidget: Widget {
    let kind: String = "FiveCoinWidget"

    var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: CoinProvider()) { entry in
                FiveCoinWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Coin Tracker")
            .description("Displays prices of selected coins.")
            .supportedFamilies([.systemSmall, .systemMedium])
        }
}

let sampleDex = DexScreenerPair(
    chainId: nil,
    dexId: nil,
    url: nil,
    pairAddress: "0x123",
    labels: nil,
    baseToken: Token(address: nil, name: "Ethereum", symbol: "ETH"),
    quoteToken: Token(address: nil, name: nil, symbol: nil),
    priceNative: nil,
    priceUsd: "1800",
    volume: nil,
    priceChange: nil,
    liquidity: nil,
    fdv: nil,
    marketCap: nil,
    pairCreatedAt: nil
)
let sampleCoin = Coin(
    id: "bitcoin",
    symbol: "btc",
    name: "Bitcoin",
    logoURL: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
    currentPrice: 67000.0,
    marketCap: 1300000000,
    marketCapRank: 1,
    fullyDilutedValuation: 1400000000,
    totalVolume: 36000000,
    high24h: 68000,
    low24h: 66000,
    priceChange24h: 1000,
    priceChangePercentage24h: 1.5,
    marketCapChange24h: 10000000,
    marketCapChangePercentage24h: 0.8,
    circulatingSupply: 19000000,
    totalSupply: 21000000,
    maxSupply: 21000000,
    platforms: ["solana": "0x123456789abcdef"]
)

let sampleEthereum = Coin(
    id: "ethereum_preview",
    symbol: "eth",
    name: "Ethereum",
    logoURL: "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
    currentPrice: 3100.0,
    marketCap: 400000000,
    marketCapRank: 2,
    fullyDilutedValuation: 450000000,
    totalVolume: 25000000,
    high24h: 3200,
    low24h: 3000,
    priceChange24h: 100,
    priceChangePercentage24h: 3.33,
    marketCapChange24h: 8000000,
    marketCapChangePercentage24h: 2.0,
    circulatingSupply: 120000000,
    totalSupply: 120000000,
    maxSupply: nil,
    platforms: ["solana": "0x123456789abcdef"]

)

#Preview(as: .systemSmall) {
    FiveCoinWidget()
} timeline: {
    CoinEntry(
        date: Date(),
        coins: [sampleCoin],
        dexPairs: [sampleDex]
    )
}

