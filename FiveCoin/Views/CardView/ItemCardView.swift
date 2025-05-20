//
//  ItemCardView.swift
//  FiveCoin
//
//  Created by Burak Kaya on 21.06.2025.
//

import SwiftUI

struct ItemCardView: View {
    let item: SelectedItem
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.07), Color.white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .background(
                    Color.white.opacity(0.03)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
                .shadow(radius: 5)

            VStack(spacing: 12) {
                ItemInfoView(item: item)

                Spacer()
            }
            .padding()
            .padding(.top, 16)

            HStack {
                NavigationLink {
                    OrdersListView(item: item, orderManager: OrderManager.shared)
                } label: {
                    Text("View Orders")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color("#97897B"))
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .padding()
                }

                Spacer()

                Button {
                    showAddOrderSheet = true
                } label: {
                    Text("Add Order")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color("#97897B"))
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .padding()
                }
                .sheet(isPresented: $showAddOrderSheet) {
                    AddOrderSheet(item: item)
                        .presentationDetents([.height(500)])
                }
            }
        }
        .frame(width: 350, height: 400)
        .padding(.vertical, 20)
    }

    @State private var showAddOrderSheet = false
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
        platforms: ["solana": "0x123456789abcdef"]
    )

    let exampleDexPair = DexScreenerPair(
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

    let exampleSelectedCoin = SelectedItem(id: exampleCoin.id, type: .coin(exampleCoin))
    let exampleSelectedDex = SelectedItem(id: exampleDexPair.pairAddress ?? UUID().uuidString, type: .dex(exampleDexPair))

    VStack(spacing: 20) {
        ItemCardView(item: exampleSelectedCoin)
        ItemCardView(item: exampleSelectedDex)
    }
    .padding()
}
