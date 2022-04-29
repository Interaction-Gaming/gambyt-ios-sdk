//
//  MobilePlayslipsActions.swift
//  mal-ios
//
//  Created by Noah Karman on 5/24/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import ReSwift

struct HydrateGameConfigurationRequest: Action { }

struct HydrateGameConfigurationSuccess: Action {
    let games: [PlayslipGame]
}

struct HydrateGameConfigurationFailure: Action {
    let error: String
}

struct SavePlayslipToCartAction: Action {
    let playslip: Playslip
}

struct DeletePlayslipFromCartAction: Action {
    let playslipToRemove: Playslip
}
