//
//  LottoLog.swift
//  LottoLog
//
//  Created by Noah Karman on 12/4/19.
//  Copyright © 2019 Interaction Gaming. All rights reserved.
//

import Foundation
import os

let bundleId = Bundle.main.bundleIdentifier ?? "invalid_bundle_id"

private let app_subsystem = bundleId
private let flux_subsystem = bundleId + ".flux"
private let ui_subsystem = bundleId + ".ui"
private let network_subsystem = bundleId + ".network"
private let scanner_subsystem = bundleId + ".scanner"
private let ng_subsystem = bundleId + ".neogames"

class LLDummyDelegate: LLCloudLoggerDelegate {
    func cloudLog(msg: StaticString, args: CVarArg?) {
        // do nothing until the Host application assigns a delegate
    }
}

public struct LottoLog {
    public static var cloudLogDelegate: LLCloudLoggerDelegate = LLDummyDelegate()
    
    public static let flux = LLSubsystem(log: OSLog(subsystem: flux_subsystem, category: "FLUX"), cloudLogDelegate: cloudLogDelegate)
    public static let network = LLSubsystem(log: OSLog(subsystem: network_subsystem, category: "NETWORK"), cloudLogDelegate: cloudLogDelegate)
    public static let scanner = LLSubsystem(log: OSLog(subsystem: scanner_subsystem, category: "SCANNER"), cloudLogDelegate: cloudLogDelegate)
    public static let standard = LLSubsystem(log: OSLog(subsystem: app_subsystem, category: "app"), cloudLogDelegate: cloudLogDelegate)
    public static let neogames = LLSubsystem(log: OSLog(subsystem: ng_subsystem, category: "NG"), cloudLogDelegate: cloudLogDelegate)
}

private enum LLEmoji: String {
    case error = "⚠️☠️⚠️"
    case info = "ℹ️"
    case debug = "🐞🐛"
    case std = ""
}

public protocol LLCloudLoggerDelegate {
    func cloudLog(msg: StaticString, args: CVarArg?)
}

public struct LLSubsystem {
    let log: OSLog
    let cloudLogDelegate: LLCloudLoggerDelegate?
    
    private func log(msg: StaticString, args: CVarArg?, type: OSLogType) {
        if let args = args {
            os_log(msg, log: log, type: type, args)
        } else {
            os_log(msg, log: log, type: type)
        }
    }
    
    private func cloudLog(msg: StaticString, args: CVarArg?) {
        cloudLogDelegate?.cloudLog(msg: msg, args: args)
    }
    
    public func std(msg: StaticString, args: CVarArg?) {
        cloudLog(msg: msg, args: args)
        
        log(msg: msg, args: args, type: .default)
    }

    public func error(msg: StaticString, args: CVarArg?) {
        cloudLog(msg: msg, args: args)
        
        let str: StaticString = "%@"
        let newArgs = String.init(format: "\(msg)", arguments: [args ?? ""])
        let strArgs = String.init(format: "\(LLEmoji.error.rawValue) \(str)", arguments: [newArgs])
        log(msg: str, args: strArgs, type: .error)
    }
    
    public func info(msg: StaticString, args: CVarArg?) {
        cloudLog(msg: msg, args: args)
        
        let str: StaticString = "%@"
        let newArgs = String.init(format: "\(msg)", arguments: [args ?? ""])
        let strArgs = String.init(format: "\(LLEmoji.info.rawValue) \(str)", arguments: [newArgs])
        log(msg: str, args: strArgs, type: .info)
    }
    
    public func debug(msg: StaticString, args: CVarArg?) {
        let str: StaticString = "%@"
        let newArgs = String.init(format: "\(msg)", arguments: [args ?? ""])
        let strArgs = String.init(format: "\(LLEmoji.debug.rawValue) \(str)", arguments: [newArgs])
        log(msg: str, args: strArgs, type: .debug)
    }
}
