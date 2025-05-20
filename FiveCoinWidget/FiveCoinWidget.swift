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
            ForEach(entry.coins.prefix(1)) { coin in
                HStack(spacing: 8) {
                    if let logoURL = coin.logoURL, let url = URL(string: logoURL) {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            } else {
                                ProgressView()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    } else {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(coin.name)
                        .font(.system(size: 18, weight: .bold))
                }
                                
                VStack(alignment: .leading, spacing: 6) {
                    Text("$ \(coin.currentPrice?.formattedTurkishStyle ?? "-")")
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack {
                        Text("Daily:")
                            .font(.system(size: 16, weight: .semibold))
                        
                        if let change = coin.priceChangePercentage24h {
                            Text("\(String(format: "%.2f", change))%")
                                .foregroundColor(change >= 0 ? .green : .red)
                                .font(.body)
                                .fontWeight(.medium)
                        } else {
                            Text("N/A")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .foregroundStyle(.primary)
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

struct CoinEntry: TimelineEntry {
    let date: Date
    let coins: [Coin]
    
}

struct CoinProvider: TimelineProvider {
    
    let userDefaults = UserDefaults(suiteName: "group.com.burakkaya.fivecoin")
    
    func placeholder(in context: Context) -> CoinEntry {
        print("Placeholder çağrıldı")
        return CoinEntry(date: Date(), coins: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (CoinEntry) -> Void) {
        let coins = loadSelectedCoins()
        print("Snapshot çağrıldı - Coin sayısı: \(coins.count)")
        let entry = CoinEntry(date: Date(), coins: coins)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CoinEntry>) -> Void) {
        let coins = loadSelectedCoins()
        print("Timeline oluşturuluyor... Coin sayısı: \(coins.count)")
        
        let entry = CoinEntry(date: Date(), coins: coins)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
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
    maxSupply: 21000000
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
    maxSupply: nil
)

#Preview(as: .systemSmall) {
    FiveCoinWidget()
} timeline: {
    CoinEntry(
        date: Date(),
        coins: [sampleCoin, sampleEthereum]
    )
}
