//
//  IRFingerPrintVerify.swift
//  IRPasscode-swift
//
//  Created by Phil on 2021/2/23.
//  Copyright © 2021 Phil. All rights reserved.
//

import Foundation
import LocalAuthentication

class IRFingerPrintVerify {
    
    class open func fingerPrintLocalAuthenticationFallBackTitle(fallBackTitle: String, reasonTitle: String, callBack: @escaping (_ isSuccess: Bool, _ error: Error?, _ referenceMsg: String) -> ()) {
        let context = LAContext.init()
        context.localizedFallbackTitle = fallBackTitle
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            NSLog("[IRFingerPrintVerify] FingerPrint Supported")
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonTitle) { (success: Bool, error: Error?) in
                OperationQueue.main.addOperation {
                    var errorCode: LAError.Code?
                    if let error = error as! LAError? {
                        print(error.code)
                        errorCode = error.code
                    }
                    callBack(success, error, self.referenceErrorCode(errorCode: errorCode, fallBackStr: fallBackTitle))
                }
            }
        } else {
            NSLog("[IRFingerPrintVerify] FingerPrint Not Support")
            OperationQueue.main.addOperation {
                var errorCode: LAError.Code?
                if let error = error as! LAError? {
                    print(error.code)
                    errorCode = error.code
                }
                callBack(false, error, self.referenceErrorCode(errorCode: errorCode, fallBackStr: fallBackTitle))
            }
        }
    }
    
    class open func referenceErrorCode(errorCode: LAError.Code?, fallBackStr: String) -> String {
        switch errorCode {
        case LAError.authenticationFailed:
            return "Authentication Failed"
        case LAError.userCancel:
            return "User Cancel Touch ID"
        case LAError.userFallback:
            return fallBackStr
        case LAError.systemCancel:
            return "System Cancel"
        case LAError.passcodeNotSet:
            return "Passcode Not Set"
        case LAError.touchIDNotAvailable:
            return "Touch ID Not Availabl"
        case LAError.touchIDNotEnrolled:
            return "Touch ID Not Enrolled"
        case LAError.touchIDLockout:
            return "Touch ID Lockout"
        case LAError.appCancel:
            return "App Cancel"
        case LAError.invalidContext:
            return "Invalid Context"
        case LAError.notInteractive:
            return "Not Interactive"
        default:
            return "Success"
        }
    }
}

