//
//  Extensions.swift
//  FiveCoin
//
//  Created by Burak Kaya on 20.05.2025.
//

import Foundation

extension Double {
    var formattedTurkishStyle: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "-"
    }
}

