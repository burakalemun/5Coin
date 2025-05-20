//
//  AddOrderSheet.swift
//  FiveCoin
//
//  Created by Burak Kaya on 25.06.2025.
//

import SwiftUI

struct AddOrderSheet: View {
    let item: SelectedItem
    @Environment(\.dismiss) var dismiss
    @Namespace private var namespace

    @State private var price: String = ""
    @State private var note: String = ""
    @State private var orderType: OrderType = .buy

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color("#0F2027"), Color("#203A43"), Color("#2C5364")],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("\(item.name) Order")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    HStack(spacing: 0) {
                        ForEach(OrderType.allCases) { type in
                            Text(type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(orderType == type ? .white : .white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    ZStack {
                                        if orderType == type {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(type == .buy ? Color.green : Color.red)
                                                .matchedGeometryEffect(id: "orderType", in: namespace)
                                        }
                                    }
                                )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        orderType = type
                                    }
                                }
                        }
                    }
                    .padding(4)
                    .background(Color.white.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)


                    VStack(alignment: .leading, spacing: 16) {
                        Text("Price ($)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        TextField("Enter price", text: $price)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                           
                        Text("Note (optional)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        TextField("Note", text: $note)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)

                    Spacer()

                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(12)

                        Button("Save") {
                            let cleanString = price.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
                            if let doublePrice = Double(cleanString) {
                                let newOrder = Order(
                                    id: UUID(),
                                    itemID: item.id,
                                    price: doublePrice,
                                    note: note.isEmpty ? nil : note,
                                    orderType: orderType,
                                    date: Date()
                                )
                                OrderManager.shared.addOrder(newOrder)
                            }
                            dismiss()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.7))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
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

    return AddOrderSheet(item: selected)
}
