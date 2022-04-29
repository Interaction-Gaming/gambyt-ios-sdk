//
//  Array+extension.swift
//  mal-ios
//
//  Created by Brendan Lau on 11/11/20.
//  Copyright © 2020 Interaction Gaming. All rights reserved.
//

import Foundation

extension Array {
    func split() -> ([Element], [Element]) {
        let half = count / 2 + count % 2
        let head = self[0..<half]
        let tail = self[half..<count]

        return (Array(head), Array(tail))
    }
}

extension Array where Element: Hashable {
    func difference(other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
