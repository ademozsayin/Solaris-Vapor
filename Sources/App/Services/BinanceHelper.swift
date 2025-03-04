import Vapor

struct BinanceHelper {
    /// Converts a Binance price string to a `Double`
    static func parsePrice(_ priceString: String) -> Double? {
        return Double(priceString)
    }

    /// Formats a price change percentage
    static func formatPercentage(_ percent: String) -> String {
        return "\(percent)%"
    }
}