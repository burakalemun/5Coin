//
//  CoinSelectionView.swift
//  FiveCoin
//
//  Created by Burak Kaya on 5.05.2025.
//

import SwiftUI

struct CoinSelectionView: View {
    enum CoinSource: String, CaseIterable, Identifiable {
        case coingecko = "Stock Exchange Coins"
        case dexscreener = "DEX / Solana Coins"
        var id: String { self.rawValue }
    }

    @State private var selectedSource: CoinSource = .coingecko
    @State private var searchQuery: String = ""

    @ObservedObject var coinVM: CoinViewModel
    @ObservedObject var dexVM: DexScreenerViewModel
    let totalSelectedCount: Int

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color("#0F2027"), Color("#203A43"), Color("#2C5364")],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack {
                    pickerSection
                    searchField

                    if selectedSource == .coingecko {
                        CoinGeckoSection(coinVM: coinVM, totalSelectedCount: totalSelectedCount)
                            .foregroundStyle(.black)
                    } else {
                        DexScreenerSection(dexVM: dexVM, totalSelectedCount: totalSelectedCount)
                            .foregroundStyle(.black)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Selected Coins")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                }
            }
        }
    }

    @Namespace private var pickerNamespace

    private var pickerSection: some View {
        HStack(spacing: 0) {
            ForEach(CoinSource.allCases) { source in
                Text(source.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        ZStack {
                            if selectedSource == source {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color("#97897B"))
                                    .matchedGeometryEffect(id: "picker", in: pickerNamespace)
                            }
                        }
                    )
                    .foregroundColor(selectedSource == source ? .white : .primary.opacity(0.6))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedSource = source
                            searchQuery = ""
                        }
                    }
            }
        }
        .padding(3)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray5)))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(height: 36)
        .padding(.horizontal)
        .padding(.top, 15)
    }

    private var searchField: some View {
        TextField("Search Coins", text: $searchQuery)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .onChange(of: searchQuery) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    guard newValue == searchQuery else { return }
                    if selectedSource == .coingecko {
                        coinVM.fetchCoins(query: newValue)
                    } else {
                        dexVM.fetchPairs(query: newValue)
                    }
                }
            }
            .onAppear {
                if selectedSource == .coingecko {
                    coinVM.fetchCoins(query: "")
                } else {
                    dexVM.fetchPairs(query: "solana")
                }
            }
            .onChange(of: selectedSource) { newSource in
                if newSource == .coingecko {
                    coinVM.fetchCoins(query: "")
                } else {
                    dexVM.fetchPairs(query: "solana")
                }
            }
    }
}

// MARK: - CoinGecko Section
struct CoinGeckoSection: View {
    @ObservedObject var coinVM: CoinViewModel
    let totalSelectedCount: Int
    
    var body: some View {
        VStack(spacing: 10) {
            if !coinVM.selectedCoins.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(coinVM.selectedCoins) { coin in
                            SelectedCoinView(coin: coin) {
                                coinVM.removeCoin(coin)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            List {
                ForEach(coinVM.allCoins) { coin in
                    HStack(spacing: 12) {
                        if let urlStr = coin.logoURL, let url = URL(string: urlStr) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 30, height: 30)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "questionmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text(coin.name)
                                .font(.body)
                            
                            if let price = coin.currentPrice {
                                Text("Price: $\(String(format: "%.4f", price))")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Price: N/A")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            coinVM.addCoin(coin, totalSelectedCount: totalSelectedCount)
                        }) {
                            Text("Select")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color("#97897B"))
                                )
                                .disabled(totalSelectedCount >= 5 && !coinVM.selectedCoins.contains(where: { $0.id == coin.id }))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: - DexScreener Section
struct DexScreenerSection: View {
    @ObservedObject var dexVM: DexScreenerViewModel
    let totalSelectedCount: Int

    var body: some View {
        VStack(spacing: 10) {
            if !dexVM.selectedPairs.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(dexVM.selectedPairs.compactMap { $0.pairAddress != nil ? $0 : nil }, id: \.pairAddress!) { pair in
                            SelectedDexPairView(pair: pair) {
                                dexVM.removePair(pair)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            List {
                ForEach(dexVM.allPairs.compactMap { $0.pairAddress != nil ? $0 : nil }, id: \.pairAddress!) { pair in
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            let base = pair.baseToken?.symbol ?? "N/A"
                            let quote = pair.quoteToken?.symbol ?? "N/A"
                            
                            Text("\(base.uppercased()) / \(quote.uppercased())")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            if let priceStr = pair.priceUsd, let price = Double(priceStr) {
                                Text("Price: $\(String(format: "%.4f", price))")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Price: N/A")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        }

                        Spacer()

                        Button(action: {
                            dexVM.addPair(pair, currentCoinCount: dexVM.selectedPairs.count)
                        }) {
                            Text("Select")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color("#97897B"))
                                )
                        }
                        .disabled(totalSelectedCount >= 5 && !dexVM.selectedPairs.contains(where: { $0.pairAddress == pair.pairAddress }))
                        .foregroundColor(.white)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: - Selected Coin View

struct SelectedCoinView: View {
    let coin: Coin
    let onRemove: () -> Void

    var body: some View {
        VStack(spacing: 5) {
            if let logoURL = coin.logoURL, let url = URL(string: logoURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    case .failure(_):
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    default:
                        ProgressView().frame(width: 40, height: 40)
                    }
                }
            } else {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }

            Text(coin.symbol.uppercased())
                .font(.caption)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

// MARK: - Selected Dex Pair View

struct SelectedDexPairView: View {
    let pair: DexScreenerPair
    let onRemove: () -> Void

    var body: some View {
        VStack(spacing: 5) {
            Text((pair.baseToken?.symbol ?? "N/A").uppercased())
                .font(.caption)
                .padding(4)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(6)
            Text((pair.quoteToken?.symbol ?? "N/A").uppercased())
                .font(.caption)
                .padding(4)
                .background(Color.green.opacity(0.2))
                .cornerRadius(6)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}


#Preview {
    CoinSelectionView(coinVM: CoinViewModel(), dexVM: DexScreenerViewModel(), totalSelectedCount: 0)
}
