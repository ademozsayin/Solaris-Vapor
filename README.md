# Solaris-Vapor

# 🚀 Binance WebSocket & REST API with Vapor

## 📌 Project Overview
This is a **Vapor backend** that provides:
- **REST API** to fetch top gainers from Binance.
- **WebSocket API** to receive real-time Binance price updates.
- **Concurrency-safe WebSocket handling** to prevent duplicate subscriptions.

## 🏗️ Project Structure
```
Sources/
└── App/
    ├── Controllers/
    │   ├── CryptoController.swift   # Handles REST API routes
    │   ├── WebSocketsController.swift  # Handles WebSocket routes
    ├── Services/
    │   ├── BinanceService.swift  # Fetches Binance API data & manages WebSocket connections
    │   ├── WebSocketService.swift  # Handles WebSocket connections
    ├── Helpers/
    │   ├── BinanceHelper.swift  # Utility functions for Binance API
    ├── Models/
    │   ├── CryptoStats.swift  # Data model for Binance stats
    ├── WebSockets/
    │   ├── WebSocketClients.swift  # Manages active WebSocket clients
    │   ├── ActiveWebSocketSubscriptions.swift  # Prevents duplicate WebSocket subscriptions
    ├── configure.swift  # Configures the Vapor application
    ├── routes.swift  # Registers all routes
    ├── entrypoint.swift  # Application entrypoint
```

## ⚙️ Setup & Installation
### **1️⃣ Install Dependencies**
```sh
brew install vapor
vapor new BinanceVapor --branch=main
```

### **2️⃣ Configure & Run the Project**
```sh
cd BinanceVapor
swift run
```

### **3️⃣ API Endpoints**
#### **🔹 Fetch Top Gainers (REST API)**
```
GET /api/gainers
```
📌 **Response Example:**
```json
[
    { "symbol": "BTCUSDT", "lastPrice": "50200.00", "priceChangePercent": "5.5" },
    { "symbol": "ETHUSDT", "lastPrice": "3500.00", "priceChangePercent": "4.2" }
]
```

#### **🔹 Subscribe to Real-Time Gainers (WebSocket)**
```
ws://127.0.0.1:8080/top-gainers
```
📌 **Expected WebSocket Messages:**
```json
{
    "symbol": "BTCUSDT",
    "lastPrice": "50300.00",
    "priceChangePercent": "6.1"
}
```

#### **🔹 Subscribe to Binance Data for a Specific Symbol**
```
ws://127.0.0.1:8080/binance?type=ticker&symbol=BTCUSDT
```
📌 **Expected WebSocket Messages:**
```json
{
    "symbol": "BTCUSDT",
    "price": "50320.00",
    "change": "5.9%"
}
```

## 🛠 Features & Improvements
- **Prevents duplicate Binance WebSocket subscriptions** using `ActiveWebSocketSubscriptions`.
- **Efficiently broadcasts updates** to all active WebSocket clients.
- **Modular structure** for scalability.
- **Uses Swift Concurrency (`async/await`) for better performance.**

## 🏆 Contributing
1. Fork the repo 🍴
2. Create a new branch: `git checkout -b feature-branch` 🌿
3. Commit your changes: `git commit -m 'Add new feature 🚀'`
4. Push to branch: `git push origin feature-branch` 📤
5. Submit a PR 🎉

## 📜 License
This project is licensed under **MIT License**.

---
🚀 **Built with Vapor & Swift for real-time Binance trading updates!** 🔥

