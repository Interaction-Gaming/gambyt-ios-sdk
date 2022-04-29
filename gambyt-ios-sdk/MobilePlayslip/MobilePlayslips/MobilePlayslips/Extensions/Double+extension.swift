//
//  Double+extension.swift
//  mal-ios
//
//  Created by Kory Dondzila on 8/6/19.
//  Copyright © 2019 Interaction Gaming. All rights reserved.
//

import Foundation

extension Double {
    func withPrecision(_ value: Int = 1) -> Double {
        let offset = pow(10, Double(value))
        return (self * offset).rounded() / offset
    }
    
    static func equal(_ lhs: Double, _ rhs: Double, precision value: Int? = nil) -> Bool {
        guard let value = value else {
            return lhs == rhs
        }
        
        return lhs.withPrecision(value) == rhs.withPrecision(value)
    }

    func truncate(places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }

    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        return String(formatter.string(from: number) ?? "")
    }

    func formatDollarsString(fractionDigits: Int = 2) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.maximumFractionDigits = fractionDigits
        currencyFormatter.minimumFractionDigits = fractionDigits
        if let formattedNumString = currencyFormatter.string(from: NSNumber(value: self)) {
            return "$" + formattedNumString
        }
        return nil
    }
    
    func formatCentString() -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.minimumFractionDigits = 0
        if let formattedNumString = currencyFormatter.string(from: NSNumber(value: self)) {
            return formattedNumString + "¢"
        }
        return nil
    }
    
    func formatTruncatedDollarOrCents() -> String? {
        if self < 1.0 {
            let newValue = self * 100
            return newValue.formatCentString()
        } else {
            return self.formatDollarsString(fractionDigits: 0)
        }
    }
}
