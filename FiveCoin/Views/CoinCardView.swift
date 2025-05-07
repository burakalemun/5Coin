//
//  CoinCardView.swift
//  5Coin
//
//  Created by Burak Kaya on 5.05.2025.
//

import SwiftUICore
import SwiftUI

struct CoinCardView: View {
    let coin: Coin

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(radius: 5)

            VStack(spacing: 12) {
                if let logoURL = coin.logoURL, let url = URL(string: logoURL) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                        } else {
                            ProgressView()
                                .frame(width: 64, height: 64)
                        }
                    }
                } else {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }

                Text(coin.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(1)

                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)

                if let currentPrice = coin.currentPrice {
                    Text("$\(String(format: "%.2f", currentPrice))")
                        .font(.title3)
                        .fontWeight(.bold)
                } else {
                    Text("Price: N/A")
                        .font(.title3)
                        .foregroundColor(.gray)
                }

                if let change = coin.priceChangePercentage24h {
                    Text("\(String(format: "%.2f", change))%")
                        .foregroundColor(change >= 0 ? .green : .red)
                        .font(.body)
                        .fontWeight(.medium)
                } else {
                    Text("Change: N/A")
                        .font(.body)
                        .foregroundColor(.gray)
                }

                if let high = coin.high24h, let low = coin.low24h {
                    HStack {
                        Text("High: \(String(format: "%.2f", high))")
                            .font(.callout)
                        Text("Low: \(String(format: "%.2f", low))")
                            .font(.callout)
                            .padding(.leading, 12)
                    }
                } else {
                    HStack {
                        Text("High: N/A")
                            .font(.callout)
                        Text("Low: N/A")
                            .font(.callout)
                            .padding(.leading, 12)
                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding()
            .padding(.top, 60)

            if let rank = coin.marketCapRank {
                Text("Rank: \(rank)")
                    .font(.caption2)
                    .padding(6)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding([.top, .leading], 10)
            } else {
                Text("Rank: N/A")
                    .font(.caption2)
                    .padding(6)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding([.top, .leading], 10)
            }
        }
        .frame(width: 350, height: 400)
        .padding(.vertical, 20)
    }
}


#Preview {
    CoinCardView(coin: Coin(id: "bitcoin", symbol: "BTC", name: "Bitcoin", logoURL: "https://cryptologos.cc/logos/bitcoin-btc-logo.png", currentPrice: 45000.0, marketCap: nil, marketCapRank: 1, fullyDilutedValuation: nil, totalVolume: nil, high24h: 46000, low24h: 43000, priceChange24h: nil, priceChangePercentage24h: -3.25, marketCapChange24h: nil, marketCapChangePercentage24h: nil, circulatingSupply: nil, totalSupply: nil, maxSupply: nil))
}
