//
//  CombinedViewModel.swift
//  FiveCoin
//
//  Created by Burak Kaya on 21.06.2025.
//

import Foundation
import Combine

class CombinedViewModel: ObservableObject {
    @Published var selectedItems: [SelectedItem] = []

    private var cancellables = Set<AnyCancellable>()

    let coinVM: CoinViewModel
    let dexVM: DexScreenerViewModel

    init(coinVM: CoinViewModel, dexVM: DexScreenerViewModel) {
        self.coinVM = coinVM
        self.dexVM = dexVM

        Publishers.CombineLatest(coinVM.$selectedCoins, dexVM.$selectedPairs)
            .map { coins, pairs in
                var items: [SelectedItem] = []

                items.append(contentsOf: coins.map { SelectedItem(id: $0.id, type: .coin($0)) })
                items.append(contentsOf: pairs.map { SelectedItem(id: $0.pairAddress ?? UUID().uuidString, type: .dex($0)) })

                return items
            }
            .assign(to: \.selectedItems, on: self)
            .store(in: &cancellables)
    }

    func addCoin(_ coin: Coin) {
        coinVM.addCoin(coin)
    }

    func removeCoin(_ coin: Coin) {
        coinVM.removeCoin(coin)
    }

    func addDexPair(_ pair: DexScreenerPair) {
        dexVM.addPair(pair)
    }

    func removeDexPair(_ pair: DexScreenerPair) {
        dexVM.removePair(pair)
    }
}
