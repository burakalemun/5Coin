//
//  CoinViewModel.swift
//  5Coin
//
//  Created by Burak Kaya on 5.05.2025.
//

import Foundation
import Combine

class CoinViewModel: ObservableObject {
    @Published var selectedCoins: [Coin] = [] {
        didSet {
            saveSelectedCoins()
        }
    }
    
    @Published var allCoins: [Coin] = []

    private let baseURL = "https://api.coingecko.com/api/v3/coins/markets"
    private let currency = "usd"
    private let selectedKey = "SelectedCoinsKey"

    init() {
        loadSelectedCoins()
        fetchAllCoins()
    }

    func fetchAllCoins() {
        var fetchedCoins: [Coin] = []
        let dispatchGroup = DispatchGroup()

        for page in 1...2 {
            dispatchGroup.enter()
            fetchCoins(forPage: page) { coins in
                fetchedCoins.append(contentsOf: coins)
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.allCoins = fetchedCoins
        }
    }

    func addCoin(_ coin: Coin) {
        guard selectedCoins.count < 5 else { return }
        guard !selectedCoins.contains(where: { $0.id == coin.id }) else { return }
        selectedCoins.append(coin)
    }

    func removeCoin(_ coin: Coin) {
        selectedCoins.removeAll { $0.id == coin.id }
    }

    func filteredCoins(searchQuery: String) -> [Coin] {
        if searchQuery.isEmpty {
            return allCoins
        }

        return allCoins.filter {
            $0.name.lowercased().contains(searchQuery.lowercased()) ||
            $0.symbol.lowercased().contains(searchQuery.lowercased()) ||
            "\($0.logoURL ?? "")".lowercased().contains(searchQuery.lowercased()) ||
            "\($0.currentPrice ?? 0)".contains(searchQuery) ||
            "\($0.marketCap ?? 0)".contains(searchQuery) ||
            "\($0.totalVolume ?? 0)".contains(searchQuery) ||
            "\($0.high24h ?? 0)".contains(searchQuery) ||
            "\($0.low24h ?? 0)".contains(searchQuery)
        }
    }

    private func fetchCoins(forPage page: Int, completion: @escaping ([Coin]) -> Void) {
        let urlString = "\(baseURL)?vs_currency=\(currency)&order=market_cap_desc&per_page=50&page=\(page)&sparkline=false"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API Hatası: \(error)")
                completion([])
                return
            }

            guard let data = data else {
                completion([])
                return
            }

            do {
                let decoder = JSONDecoder()
                let coins = try decoder.decode([Coin].self, from: data)
                completion(coins)
            } catch {
                completion([])
            }
        }.resume()
    }

    private func saveSelectedCoins() {
        let preferences = UserPreferences(selectedCoins: selectedCoins)
        if let data = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(data, forKey: selectedKey)
        }
    }

    private func loadSelectedCoins() {
        guard let data = UserDefaults.standard.data(forKey: selectedKey),
              let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
            return
        }

        self.selectedCoins = preferences.selectedCoins
    }
}
