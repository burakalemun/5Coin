# 🪙 5Coin 📱🚀

**5Coin**, kullanıcıların hem merkezi (CoinGecko) hem de merkeziyetsiz (DexScreener) coin’leri arayıp seçebildiği, bu coin’ler için sipariş (order) ekleyebildiği sade ve şık bir iOS uygulamasıdır.  
**5Coin** is a sleek iOS app where users can search and select both centralized (CoinGecko) and decentralized (DexScreener) coins, and add orders to track them.

---

## 🧠 Özellikler / Features

- 🔍 Coin arama & filtreleme (CoinGecko + DexScreener) / Search & filter coins from CoinGecko & DexScreener  
- ⭐ Coin seçimi (maksimum 5 adet) / Select up to 5 coins  
- ➕ Coin bazlı sipariş (order) ekleme / Add buy/sell orders for selected coins  
- 📋 Sipariş listesi görünümü / View all your tracked orders  
- 🔄 Gerçek zamanlı fiyat verisi / Live price data  
- 💾 Seçilen coin’leri saklama (AppStorage + UserDefaults) / Save selected coins locally  
- 🎯 SwiftUI + Combine altyapısı / Built with SwiftUI & Combine

---

## ⚙️ Teknolojiler / Tech Stack

- SwiftUI  
- Combine  
- CoinGecko API  
- DexScreener API  
- AppStorage & UserDefaults  
- MVVM mimarisi  
- Custom View Components (ItemCard, ItemInfo, SearchBar, etc.)

---

## 🛠 Kurulum / Setup

Projeyi lokalinde çalıştırmak için aşağıdaki adımları izle:

To run the project locally, follow these steps:

```bash
git clone https://github.com/burakalemun/5Coin.git
cd 5Coin
open 5Coin.xcodeproj
```

Xcode ile projeyi aç ve simülatörde başlat.

Open with Xcode and run on Simulator.

---

## 📂 Dosya Yapısı / File Structure
```
Views/
│
├── Home/
│   ├── ContentView.swift
│   ├── OrdersListView.swift
│   └── SearchBar.swift
│
├── CoinSelection/
│   ├── CoinSelectionView.swift
│   ├── ItemCardView.swift
│   └── ItemInfoView.swift
│
└── Order/
    └── AddOrderSheet.swift
```

---

## 📸 Ekran Görüntüleri / Screenshots

<table>
  <tr>
    <th>Merkezi Coin / Centralized Coin</th>
    <th>Merkeziyetsiz Coin / Decentralized Coin</th>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/3b120bed-bdbf-4b03-b356-da4ffb2049f1" width="500"><br>
      <em>ContentView</em>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/4e261d6b-56ac-45e2-9a39-8c3205958cd2" width="500"><br>
      <em>ContentView</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/455ce56d-927f-4696-96e4-ba3c8d892438" width="500"><br>
      <em>CoinSelectionView</em>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/4e2e5ded-5bca-4359-aec5-c8bddc356d35" width="500"><br>
      <em>CoinSelectionView</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/40807943-45b5-425a-9b7d-e430a8eb5005" width="500"/></br>
      <em>AddOrderSheet</em>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/3834a75b-a353-4bbf-9a75-c51604d113fb" width="500"/></br>
      <em>OrdersListView</em>
    </td>
  </tr>
</table>

---

🧊 Made with ❤️ by Burak Kaya
