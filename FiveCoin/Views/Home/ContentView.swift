//
//  ContentView.swift
//  5Coin
//
//  Created by Burak Kaya on 5.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coinVM = CoinViewModel()
    @StateObject var dexVM = DexScreenerViewModel()
    @StateObject var combinedVM: CombinedViewModel
    
    @State private var isSelectingCoins = false
    
    init() {
        let coinVM = CoinViewModel()
        let dexVM = DexScreenerViewModel()
        _coinVM = StateObject(wrappedValue: coinVM)
        _dexVM = StateObject(wrappedValue: dexVM)
        _combinedVM = StateObject(wrappedValue: CombinedViewModel(coinVM: coinVM, dexVM: dexVM))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color("#0F2027"), Color("#203A43"), Color("#2C5364")],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("5Coin 🚀")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                        Button {
                            isSelectingCoins.toggle()
                        }
                        label: {
                            Label("Select Coin", systemImage: "bitcoinsign.circle")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color("#97897B"))
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(combinedVM.selectedItems) { item in
                                ItemCardView(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .frame(height: 500)
                    
                    Spacer()
                }
                .sheet(isPresented: $isSelectingCoins) {
                    CoinSelectionView(coinVM: coinVM, dexVM: dexVM, totalSelectedCount: combinedVM.selectedItems.count)
                }
                .onAppear {
                    coinVM.fetchCoins()
                    dexVM.fetchInitialPairs()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
