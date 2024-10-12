import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xff) / 255
        let green = Double((rgbValue >> 8) & 0xff) / 255
        let blue = Double(rgbValue & 0xff) / 255
        
        self.init(red: red, green: green, blue: blue)
    }
}
