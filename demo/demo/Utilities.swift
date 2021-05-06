//
//  Utilities.swift
//  demo
//
//  Created by Phil on 2021/4/27.
//  Copyright © 2021 Phil. All rights reserved.
//

import Foundation
import IRPasscode_swift

class Utilities {
    class open func openSecurityPinPage() {
        if ((IRSecurityPinManager.sharedInstance.pinCode) != nil) {
            IRSecurityPinManager.sharedInstance.presentSecurityPinViewControllerForUnlock(animated: true, completion: nil, result: nil)
        }
    }

    class open func removeSecurityPin() {
        IRSecurityPinManager.sharedInstance.removePinCode()
    }
}
