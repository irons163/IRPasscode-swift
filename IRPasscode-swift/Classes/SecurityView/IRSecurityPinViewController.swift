//
//  IRSecurityPinViewController.swift
//  IRPasscode-swift
//
//  Created by Phil on 2021/2/23.
//  Copyright © 2021 Phil. All rights reserved.
//

import UIKit

protocol IRSecurityPinViewControllerDelegate {

/*
 Will be called when pinCodeToCheck isEqualTo: entered PinCode
 */

    func pinCodeViewController(controller: IRSecurityPinViewController, didVerifiedPincodeSuccessfully pinCode: String?)

/*
 Will be called when entered pin code don't match pinCodeToCheck;
 */

    func pinCodeViewController(controller: IRSecurityPinViewController, didFailVerificationWithCount failsCount: UInt)

/*
 Will be called when pin code created
 */

    func pinCodeViewController(controller: IRSecurityPinViewController, didCreatePinCode pinCode: String?)

/*
 Will be called when pin code changed
 */

    func pinCodeViewController(controller: IRSecurityPinViewController, didChangePinCode pinCode: String?)

    func pinCodeViewControllerDidCancel(controller: IRSecurityPinViewController)
    
}

extension IRSecurityPinViewControllerDelegate {
    
    func pinCodeViewController(controller: IRSecurityPinViewController, didFailVerificationWithCount failsCount: UInt) {}
    
}

class IRSecurityPinViewController: UIViewController, IRPasscodeViewDelegate {

    @IBOutlet fileprivate weak var pinCodeView: IRPasscodeView?
    @IBOutlet fileprivate weak var titleLabel: UILabel?
    @IBOutlet fileprivate weak var messageLabel: UILabel?
    @IBOutlet fileprivate weak var cancelButton: UIButton?

    //You can set it on order to compare entered pin code with this var.
    var pinCodeToCheck: String?

    //Failed attempts incrementer
    private(set) var failedAttempts: UInt = 0

    //Set this property to YES if you want to reset your current pinCode.
    //Note: self.pinCodeToCheck must be non nil; Will raise an exception othervise
    var shouldResetPinCode: Bool = false

    var cancellable: Bool = false

    //Delegate
    var delegate: IRSecurityPinViewControllerDelegate?
    
    private var _firstTimePinVerified: Bool = false
    private var firstTimeEnteredPin: String?

    //You can override it for initial properties
    open func commonInit() {
        self.enterYourPinString = Bundle.IR_localizedStringForKey(key: "EnterPinString")
        self.createYourPinString =  Bundle.IR_localizedStringForKey(key:"CreatePinString")
        self.enterOnceAgainString =  Bundle.IR_localizedStringForKey(key:"EnterOnceAgainString")
        
        self.pinsDontMatchTryOnceAgainString =  Bundle.IR_localizedStringForKey(key:"PinsDontMatchTryOnceAgainString")
    }

    open func unlockPinCode() {
        self.pinCodeView?.pinCode = self.pinCodeToCheck
    }

    /*
     Strings.
     You can override all of them to show messages like alerts, set labels, etc...
     */

    open var enterYourPinString: String?
    open var createYourPinString: String?
    open var pinVerifiedString: String?

    open var pinsDontMatchTryOnceAgainString: String?
    open var pinCreatedString: String?
    open var enterOnceAgainString: String?


    /*
     
     If not overrided, all of them will just NSLog about what message was shown.
     You should override them to show message in your custom UI (labels, alerts, etc...);
     
     */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pinCodeView?.delegate = self;
        self.cancelButton?.isHidden = !self.cancellable;
        
        assert(self.pinCodeView != nil, "pinCodeView is not initialized");
        self.commonInit()
        self.setupDefaultMessage()
    }

    // MARK: - Pin Code View Delegate
    func didEnterPinCode(in view: IRPasscodeView, withPinCode pinCode: String?)
    {
        // Small Hack to give time to show the last entered number
        let delayInSeconds = 0.15;
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            view.pinCode = nil;
            
            //Verify case
            if (self.pinCodeToCheck != nil && !self.shouldResetPinCode) {
                self.verifyPinWithEntered(pinCode: pinCode)
            } else if (self.pinCodeToCheck != nil && self.shouldResetPinCode) {
                self.changePinWithEntered(pinCode: pinCode)
            } else {
                self.setEnteredPin(pinCode: pinCode)
            }
        }
    }

    // MARK: - Pins Logic
    func verifyPinWithEntered(pinCode: String?) {
        //Pins matched
        if (self.pinCodeToCheck == pinCode) {
            
            self.delegate?.pinCodeViewController(controller: self, didVerifiedPincodeSuccessfully: pinCode)
            
            self.showPinVerifiedMessage()
        } else {
            self.failedAttempts += 1
            
            self.delegate?.pinCodeViewController(controller: self, didFailVerificationWithCount: self.failedAttempts)
            self.showPinsDontMatchMessage()
        }
    }

    func setEnteredPin(pinCode: String?) {
        
        //This is first attempt
        if (self.firstTimeEnteredPin == nil) {
            self.firstTimeEnteredPin = pinCode
            
            //Message
            self.showEnterOnceAgainMessage()
            
            //Here we should compare them
        } else {
            
            //They are equal
            if (pinCode == self.firstTimeEnteredPin) {
                self.delegate?.pinCodeViewController(controller: self, didCreatePinCode: pinCode)
                
                //Message
                self.showPinCreatedMessage()
                
                //Passwords don't match. Let's go over again
            } else {
                
                self.firstTimeEnteredPin = nil;
                self.failedAttempts += 1
                
                self.delegate?.pinCodeViewController(controller: self, didFailVerificationWithCount: self.failedAttempts)
                
                //Message
                self.showPinsDontMatchMessage()
            }
        }
    }

    func changePinWithEntered(pinCode: String?) {
        //User have not verified password yet
        if (_firstTimePinVerified == false) {
            
            //user entered valid
            if (self.pinCodeToCheck == pinCode) {
                
                _firstTimePinVerified = true
                
                //Message
                self.showCreateThePinMessage()
            } else {
                
                //Notify about fail
                self.failedAttempts += 1
                self.delegate?.pinCodeViewController(controller: self, didFailVerificationWithCount: self.failedAttempts)
                
                //Message
                self.showPinsDontMatchMessage()
            }
        } else {
            
            //Create new password
            if (self.firstTimeEnteredPin == nil) {
                self.firstTimeEnteredPin = pinCode
                
                self.showEnterOnceAgainMessage()
            } else {
                
                //Everything is good
                if (self.firstTimeEnteredPin == pinCode) {
                    
                    self.delegate?.pinCodeViewController(controller: self, didChangePinCode: pinCode)
                    
                    self.showPinCreatedMessage()
                    
                    //Password don't match. Let's go to step 2
                } else {
                    
                    self.firstTimeEnteredPin = nil
                    self.failedAttempts += 1
                    
                    self.delegate?.pinCodeViewController(controller: self, didFailVerificationWithCount: self.failedAttempts)
                    //Message
                    self.showPinsDontMatchMessage()
                }
            }
        }
    }

    // MARK: - Messages
    func setupDefaultMessage() {
        //Verify case
        if (self.pinCodeToCheck != nil && self.cancellable) {
            self.showEnterYourOldPinMessage()
        } else if (self.pinCodeToCheck != nil && !self.shouldResetPinCode) {
            self.showEnterYourPinMessage()
        } else if (self.pinCodeToCheck != nil && self.shouldResetPinCode) {
            self.showEnterYourOldPinMessage()
        } else {
            self.showCreateThePinMessage()
        }
    }

    /*
     
     Sample messages you can override them.
     
     */

    open func showCreateThePinMessage() {
        self.titleLabel?.text = self.createYourPinString;
        self.messageLabel?.text = Bundle.IR_localizedStringForKey(key: "CreatePinMsgString");
    }

    open func showEnterOnceAgainMessage() {
        self.titleLabel?.text = self.enterOnceAgainString;
        self.messageLabel?.text = Bundle.IR_localizedStringForKey(key: "ConfirmPinMsgString");
    }

    open func showPinCreatedMessage() {
    //    self.titleLabel.text = self.pinCreatedString;
    }

    open func showPinsDontMatchMessage() {
        self.messageLabel?.text = self.pinsDontMatchTryOnceAgainString;
    }

    open func showEnterYourPinMessage() {
        self.titleLabel?.text = self.enterYourPinString;
        self.messageLabel?.text = Bundle.IR_localizedStringForKey(key: "EnterPinMsgString");
    }

    open func showEnterYourOldPinMessage() {
        self.titleLabel?.text = self.enterYourPinString;
        self.messageLabel?.text = Bundle.IR_localizedStringForKey(key: "EnterOldPinMsgString");
    }

    open func showPinVerifiedMessage() {
    //    self.titleLabel.text = self.pinCreatedString;
    }
    
    @IBAction fileprivate func numberClick(_ sender: UIButton) {
        self.pinCodeView?.pinCode = String.init(format: "%@%@", ((self.pinCodeView?.pinCode) != nil) ? self.pinCodeView!.pinCode!: "", (sender.titleLabel?.text != nil) ? sender.titleLabel!.text! : "")
    }
    
    @IBAction fileprivate func cancelClick(_ sender: UIButton) {
        self.delegate?.pinCodeViewControllerDidCancel(controller: self)
    }
    
    @IBAction fileprivate func deleteClick(_ sender: UIButton) {
        if(self.pinCodeView?.pinCode?.count ?? 0 > 0) {
            self.pinCodeView?.pinCode = String((self.pinCodeView?.pinCode?.prefix((self.pinCodeView?.pinCode!.count)! - 1))!)
        }
    }
}
