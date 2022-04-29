//
//  RootReducer.swift
//  mal-ios
//
//  Created by Noah Karman on 5/16/19.
//  Copyright © 2019 Interaction Gaming. All rights reserved.
//

import Foundation
import ReSwift

func rootReducer(action: Action, state: AppState?) -> AppState {
    
    #if TESTING
    if action is ResetStoreForTesting {
        return getInitialAppState()
    }
    #endif
    
    guard let state = state else {
        return AppState(playslips: PlayslipsStateType())
    }

    return AppState(playslips: mobilePlayslipsReducer(action: action, state: state.playslips))

}
