//
//  ContentView.swift
//  5Coin
//
//  Created by Burak Kaya on 5.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CoinViewModel()
    @State private var isSelectingCoins = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("5Coin 🚀")
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    Button {
                        isSelectingCoins.toggle()
                    } label: {
                        Label("Select Coin", systemImage: "bitcoinsign.circle")
                            .foregroundStyle(Color.primary)
                            
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)

                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.selectedCoins) { coin in
                                CoinCardView(coin: coin)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .frame(height: 500)
                }
                Spacer()
            }
            .sheet(isPresented: $isSelectingCoins) {
                CoinSelectionView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchAllCoins()
            }
        }
    }
}

#Preview {
    ContentView()
}
