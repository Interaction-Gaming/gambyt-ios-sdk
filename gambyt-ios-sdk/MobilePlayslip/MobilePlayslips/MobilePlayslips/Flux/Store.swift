//
//  Store.swift
//  MobilePlayslips
//
//  Created by Brendan Lau on 4/28/22.
//

import Foundation
import ReSwift

struct AppState: StateType, Equatable {
    let playslips: PlayslipsStateType
}

struct PlayslipsStateType: Equatable {
    var games: [PlayslipGame] = []
    var playslipCart: [Playslip] = []
    var error: String? = nil
}

typealias middleware = (@escaping DispatchFunction, @escaping () -> AppState?) -> (@escaping DispatchFunction) -> DispatchFunction

let appStore = Store<AppState>(
    reducer: rootReducer,
    state: nil,
    middleware: []
)
