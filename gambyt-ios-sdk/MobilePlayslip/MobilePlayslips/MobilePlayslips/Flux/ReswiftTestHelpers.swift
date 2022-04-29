//
//  ReswiftTestHelpers.swift
//  mal-ios
//
//  Created by Noah Karman on 10/16/20.
//  Copyright © 2020 Interaction Gaming. All rights reserved.
//

import Foundation
import ReSwift

#if TESTING

struct ResetStoreForTesting: Action { }

func getInitialAppState() -> AppState {
    return AppState(playslips: PlayslipsStateType())
}

#endif
