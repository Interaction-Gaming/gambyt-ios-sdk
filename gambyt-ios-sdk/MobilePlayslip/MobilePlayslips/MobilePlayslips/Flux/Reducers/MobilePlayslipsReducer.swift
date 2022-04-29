//
//  MobilePlayslipsReducer.swift
//  mal-ios
//
//  Created by Noah Karman on 5/24/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation
import ReSwift

func mobilePlayslipsReducer(action: Action, state: PlayslipsStateType?) -> PlayslipsStateType {
    var state = state ?? PlayslipsStateType()
    
    switch action {
    case let action as HydrateGameConfigurationSuccess:
        state.games = action.games
    case let action as HydrateGameConfigurationFailure:
        state.error = action.error
    case let action as SavePlayslipToCartAction:
        state.playslipCart.append(action.playslip)
    case let action as DeletePlayslipFromCartAction:
        if let indexToRemove = state.playslipCart.firstIndex(of: action.playslipToRemove) {
            state.playslipCart.remove(at: indexToRemove)
        }
    default:
        return state
    }
    
    return state
}
