//
//  NumberFormatter+Extensions.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-03.
//

import Foundation

extension NumberFormatter {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
