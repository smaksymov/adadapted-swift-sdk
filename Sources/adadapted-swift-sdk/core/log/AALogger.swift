//
//  Created by Brett Clifton on 11/6/23.
//

import Foundation
import Logging

class AALogger {
    static let logger = Logger(label: "adadapted-swift-sdk")
    static let instance = AALogger()
    private static var isDebugLoggingEnabled = false
    private static var disableLogging = false
    
    static func enableDebugLogging() {
        AALogger.isDebugLoggingEnabled = true
    }
    
    static func disableAllLogging() {
        disableLogging = true
    }
    
    static func logError(message: String) {
        if !disableLogging {
            let msg = Logger.Message(stringLiteral: message)
            AALogger.logger.error(msg)
        }
    }
    
    static func logInfo(message: String) {
        if !disableLogging {
            let msg = Logger.Message(stringLiteral: message)
            AALogger.logger.info(msg)
        }
    }
    
    static func logDebug(message: String) {
        if AALogger.isDebugLoggingEnabled && !disableLogging {
            let msg = Logger.Message(stringLiteral: message)
            AALogger.logger.notice(msg)
        }
    }
}
