//
//  CoinSelectionView.swift
//  FiveCoin
//
//  Created by Burak Kaya on 5.05.2025.
//

import SwiftUI

struct CoinSelectionView: View {
    @ObservedObject var viewModel = CoinViewModel()
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {

                TextField("Search Coins", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if !viewModel.selectedCoins.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.selectedCoins, id: \.id) { coin in
                                VStack(spacing: 5) {
                                    if let logoURL = coin.logoURL, let url = URL(string: logoURL) {
                                        AsyncImage(url: url) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                    .clipShape(Circle())
                                            } else {
                                                ProgressView()
                                                    .frame(width: 40, height: 40)
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
                                    
                                    Button(action: {
                                        viewModel.removeCoin(coin)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                List {
                    ForEach(viewModel.filteredCoins(searchQuery: searchQuery)) { coin in
                        HStack {
                            if let logoURL = coin.logoURL, let url = URL(string: logoURL) {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                    } else {
                                        ProgressView()
                                            .frame(width: 30, height: 30)
                                    }
                                }
                            } else {
                                Image(systemName: "questionmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            
                            Text(coin.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.addCoin(coin)
                            }) {
                                Text("Select")
                                    .foregroundColor(.blue)
                            }
                            .disabled(viewModel.selectedCoins.count >= 5 && !viewModel.selectedCoins.contains(where: { $0.id == coin.id }))
                            
                        }
                    }
                }
                .navigationTitle("Select Coins")
            }
        }
    }
}

#Preview {
    CoinSelectionView(viewModel: CoinViewModel())
}
