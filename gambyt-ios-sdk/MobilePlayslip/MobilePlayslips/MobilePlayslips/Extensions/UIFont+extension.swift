//
//  UIFont+extension.swift
//  mal-ios
//
//  Created by Nick Peterson on 8/15/19.
//  Copyright © 2019 Interaction Gaming. All rights reserved.
//

import UIKit

public extension UIFont {
    private enum Font: String {
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case boldSlab = "Slab-Bold"

        case regular = "Regular"
        case regularSlab = "Slab-Regular"
        case italic = "Italic"

        case ganache = "Ganache"

        var name: String {
            switch self {
            case .boldSlab, .regularSlab:
                return "Roboto\(self.rawValue)"
            case .ganache:
                return "Ganache"
            default: return "Roboto-\(self.rawValue)"
            }
        }
    }

    private static func font(_ font: Font, size: CGFloat) -> UIFont? {
        return UIFont(name: font.name, size: size)
    }
}

// MARK - Font Methods

public extension UIFont {
    static func igBoldFont(size: CGFloat) -> UIFont {
        return font(.bold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func igBoldSlabFont(size: CGFloat) -> UIFont {
        return font(.boldSlab, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func igBoldItalicFont(size: CGFloat) -> UIFont {
        return font(.boldItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func igRegularFont(size: CGFloat) -> UIFont {
        return font(.regular, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func igRegularSlabFont(size: CGFloat) -> UIFont {
        return font(.regularSlab, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func igItalicsFont(size: CGFloat) -> UIFont {
        return font(.italic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func ganache(size: CGFloat) -> UIFont {
        return font(.ganache, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
}
