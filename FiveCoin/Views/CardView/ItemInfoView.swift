//
//  ItemInfoView.swift
//  FiveCoin
//
//  Created by Burak Kaya on 6.07.2025.
//

import SwiftUI

struct ItemInfoView: View {
    let item: SelectedItem

    private var logoURL: String? {
        switch item.type {
        case .coin(let c):
            return c.logoURL
        case .dex:
            return nil
        }
    }

    private var priceUsd: Double? {
        switch item.type {
        case .coin(let c):
            return c.currentPrice
        case .dex(let d):
            return Double(d.priceUsd ?? "")
        }
    }

    private var priceChangePercentage24h: Double? {
        switch item.type {
        case .coin(let c):
            return c.priceChangePercentage24h
        case .dex:
            return nil
        }
    }

    private var high24h: Double? {
        switch item.type {
        case .coin(let c):
            return c.high24h
        case .dex:
            return nil
        }
    }

    private var low24h: Double? {
        switch item.type {
        case .coin(let c):
            return c.low24h
        case .dex:
            return nil
        }
    }

    private var marketCapRank: Int? {
        switch item.type {
        case .coin(let c):
            return c.marketCapRank
        case .dex:
            return nil
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                if let rank = marketCapRank {
                    Text("Rank: \(rank)")
                } else {
                    Text("Rank: N/A")
                }
            }
            .font(.caption2)
            .padding(6)
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
            .frame(maxWidth: .infinity, alignment: .leading)

            if let logoURL, let url = URL(string: logoURL) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit().frame(width: 64, height: 64).clipShape(Circle())
                    } else if phase.error != nil {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .foregroundColor(Color("#f7931a"))
                    } else {
                        ProgressView().frame(width: 64, height: 64)
                    }
                }
            } else {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color("#f7931a"))
            }

            Text(item.name)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(1)
                .foregroundColor(.white)

            Text(item.symbol.uppercased())
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)

            if let price = priceUsd {
                Text("$\(String(format: "%.2f", price))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            } else {
                Text("Price: N/A")
                    .font(.title3)
                    .foregroundColor(.white)
            }

            if let change = priceChangePercentage24h {
                Text("\(String(format: "%.2f", change))%")
                    .foregroundColor(change >= 0 ? .green : .red)
                    .font(.body)
                    .fontWeight(.medium)
            } else {
                Text("Change: N/A")
                    .font(.body)
                    .foregroundColor(.white)
            }

            if let high = high24h, let low = low24h {
                HStack {
                    Text("High: \(String(format: "%.2f", high))")
                    Text("Low: \(String(format: "%.2f", low))")
                }
                .font(.callout)
                .foregroundColor(.white)
            } else {
                HStack {
                    Text("High: N/A")
                    Text("Low: N/A")
                }
                .font(.callout)
                .foregroundColor(.white)
            }
        }
    }
}
