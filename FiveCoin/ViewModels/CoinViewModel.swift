//
//  CoinViewModel.swift
//  5Coin
//
//  Created by Burak Kaya on 5.05.2025.
//

import Foundation
import Combine
import WidgetKit


// MARK: - CoinGecko ViewModel
class CoinViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var selectedCoins: [Coin] = [] {
        didSet {
            saveSelectedCoins()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://api.coingecko.com/api/v3/coins/markets"
    private let currency = "usd"
    private let userDefaults = UserDefaults(suiteName: "group.com.burakkaya.fivecoin")
    private let selectedKey = "selectedCoins"

    init() {
        loadSelectedCoins()
        fetchCoins()
    }
    
    func fetchCoins(query: String = "") {
        var urlStr = "\(baseURL)?vs_currency=\(currency)&order=market_cap_desc&per_page=50&page=1&sparkline=false"
        if !query.isEmpty {
            urlStr += "&ids=\(query.lowercased())"
        }
        guard let url = URL(string: urlStr) else {
            DispatchQueue.main.async { self.allCoins = [] }
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
    }
    
    func addCoin(_ coin: Coin) {
        guard selectedCoins.count < 5 else { return }
        guard !selectedCoins.contains(where: { $0.id == coin.id }) else { return }
        selectedCoins.append(coin)
    }
    
    func removeCoin(_ coin: Coin) {
        selectedCoins.removeAll { $0.id == coin.id }
    }
    
    private func saveSelectedCoins() {
        do {
            let data = try JSONEncoder().encode(selectedCoins)
            userDefaults?.set(data, forKey: selectedKey)
        } catch {
            print("Coin encode hatası: \(error)")
        }
    }
    
    private func loadSelectedCoins() {
        guard let data = userDefaults?.data(forKey: selectedKey) else { return }
        do {
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            selectedCoins = coins
        } catch {
            print("Coin decode hatası: \(error)")
        }
    }
    
    func addCoin(_ coin: Coin, totalSelectedCount: Int) {
        guard totalSelectedCount < 5 else { return }
        if selectedCoins.contains(where: { $0.id == coin.id }) { return }
        selectedCoins.append(coin)
    }
}


// MARK: - DexScreener ViewModel
class DexScreenerViewModel: ObservableObject {
    @Published var allPairs: [DexScreenerPair] = []
    @Published var selectedPairs: [DexScreenerPair] = [] {
        didSet {
            saveSelectedPairs()
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults(suiteName: "group.com.burakkaya.fivecoin")
    private let selectedKey = "selectedDexPairs"

    init() {
        loadSelectedPairs()
        fetchInitialPairs()
    }

    func fetchInitialPairs() {
        fetchPairs(query: "solana")
    }

    func fetchPairs(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.dexscreener.com/latest/dex/search/?q=\(encodedQuery)") else {
            DispatchQueue.main.async { self.allPairs = [] }
            print("⚠️ URL oluşturulamadı, query: \(query)")
            return
        }

        print("🔍 Arama yapılıyor: \(url.absoluteString)")

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                if let jsonStr = String(data: data, encoding: .utf8) {
                    print("📥 Arama JSON (ilk 500 karakter): \(jsonStr.prefix(500))")
                }
                return data
            }
            .decode(type: DexScreenerResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("❌ Decode hatası: \(error.localizedDescription)")
                } else {
                    print("✅ Decode tamam")
                }
            }, receiveValue: { [weak self] response in
                self?.allPairs = response.pairs ?? []
                print("✅ Pair sayısı: \(self?.allPairs.count ?? 0)")
            })
            .store(in: &cancellables)
    }

    func addPair(_ pair: DexScreenerPair) {
        guard selectedPairs.count < 5 else { return }
        guard let newID = pair.pairAddress else { return }
        guard !selectedPairs.contains(where: { $0.pairAddress == newID }) else { return }
        selectedPairs.append(pair)
    }

    func removePair(_ pair: DexScreenerPair) {
        guard let targetID = pair.pairAddress else { return }
        selectedPairs.removeAll { $0.pairAddress == targetID }
    }

    private func saveSelectedPairs() {
        do {
            let data = try JSONEncoder().encode(selectedPairs)
            userDefaults?.set(data, forKey: selectedKey)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("❌ Encode hatası: \(error.localizedDescription)")
        }
    }

    private func loadSelectedPairs() {
        guard let data = userDefaults?.data(forKey: selectedKey) else { return }
        do {
            let pairs = try JSONDecoder().decode([DexScreenerPair].self, from: data)
            selectedPairs = pairs
        } catch {
            print("❌ Decode hatası (Local storage): \(error.localizedDescription)")
        }
    }
    
    func addPair(_ pair: DexScreenerPair, currentCoinCount: Int) {
        if selectedPairs.count + currentCoinCount >= 5 { return }
        if selectedPairs.contains(where: { $0.pairAddress == pair.pairAddress }) { return }
        selectedPairs.append(pair)
    }
}
