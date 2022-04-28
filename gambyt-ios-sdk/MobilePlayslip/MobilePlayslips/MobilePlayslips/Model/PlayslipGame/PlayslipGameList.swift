//
//  PlayslipGameList.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/19/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct PlayslipGameList: Decodable {
    let games: [PlayslipGame]
    
    init?(jsonDocument: Data) {
        do {
            let obj = try JSONDecoder().decode(PlayslipGameList.self, from:  jsonDocument)
            self = obj
        }
        catch {
            print(error)
            return nil
        }
    }
}
