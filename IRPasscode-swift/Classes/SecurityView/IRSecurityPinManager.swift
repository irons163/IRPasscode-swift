//
//  IRSecurityPinManager.swift
//  IRPasscode-swift
//
//  Created by Phil on 2021/2/23.
//  Copyright © 2021 Phil. All rights reserved.
//

import Foundation
import KeychainAccess

open class IRSecurityPinManager: IRSecurityPinViewControllerDelegate {
    
    let kCurrentPinKey = "kCurrentPinKey"
    
    public enum IRSecurityResultType {
        case Created
        case Verified
        case Changed
    }
    
    public typealias ResultBlock = ((_ type: IRSecurityResultType) -> ())?
    
    open private(set) var pinCode: String? {
        willSet {
            self.pinCode = newValue
            self.keychainStore?[kCurrentPinKey] = self.pinCode
        }
    }
    
    
    var fingerPrintIcon: UIButton?
    var referenceBtn: UIButton?

    var securityPinViewController: IRSecurityPinViewController?
    open var result: ResultBlock?
    var window: UIWindow?
    var keychainStore: Keychain?
    
    private init() {
        self.keychainStore = Keychain.init()
        self.pinCode = self.keychainStore?[kCurrentPinKey] ?? nil
    }
    
    static public let sharedInstance = IRSecurityPinManager()
    
    func presentSecurityPinViewController(animated: Bool, completion: (() -> ())?, cancellable: Bool, isChangeCode: Bool) {
        var flag: Bool = false
        if((self.window) != nil) {
            flag = false
        }
        self.securityPinViewController?.dismiss(animated: false, completion: nil)
        self.cleanup()
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        if #available(iOS 13.0, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                self.window?.windowScene = currentWindowScene
            }
        }
        
        self.window?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.window?.isOpaque = false
        
        self.window?.rootViewController = UIViewController.init()
        self.window?.makeKeyAndVisible()
        
        self.securityPinViewController = nil;
    //    IRSecurityPinViewController *securityPinViewController = [IRSecurityPinViewController new];
        let xibBundle = Bundle.init(for: IRSecurityPinViewController.self)
        let securityPinViewController = IRSecurityPinViewController.init(nibName: "IRSecurityPinViewController", bundle: xibBundle)
        securityPinViewController.delegate = self;
        securityPinViewController.cancellable = cancellable;
        self.securityPinViewController = securityPinViewController;
        if((self.pinCode) != nil) {
            securityPinViewController.pinCodeToCheck = self.pinCode
        }
        if(isChangeCode) {
            securityPinViewController.shouldResetPinCode = isChangeCode;
        }
        securityPinViewController.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(securityPinViewController, animated: flag, completion: completion)
    }
    
    func presentSecurityPinViewController(animated: Bool, cancellable: Bool, isChangeCode: Bool, usePolicyDeviceOwnerAuthentication: Bool, completion: (() -> ())?, result: ResultBlock) {
        self.result = result
        self.presentSecurityPinViewController(animated: animated, completion: completion, cancellable: cancellable, isChangeCode: isChangeCode)
        
        if usePolicyDeviceOwnerAuthentication {
            IRFingerPrintVerify.fingerPrintLocalAuthenticationFallBackTitle(fallBackTitle: "", reasonTitle: Bundle.IR_localizedStringForKey(key: "PasscodeLock") ?? "") { (isSuccess, error, referenceMsg) in
                if isSuccess {
                    self.securityPinViewController?.unlockPinCode()
                }
            }
        }
    }

    open func presentSecurityPinViewControllerForChangePasscode(animated: Bool, completion: (() -> ())?, result: ResultBlock) {
        self.presentSecurityPinViewController(animated: animated, cancellable: true, isChangeCode: true, usePolicyDeviceOwnerAuthentication: true, completion: completion, result: result)
    }
    
    open func presentSecurityPinViewControllerForCreate(animated: Bool, completion: (() -> ())?, result: ResultBlock) {
        self.presentSecurityPinViewController(animated: animated, cancellable: true, isChangeCode: false, usePolicyDeviceOwnerAuthentication: false, completion: completion, result: result)
    }
    
    open func presentSecurityPinViewControllerForRemove(animated: Bool, completion: (() -> ())?, result: ResultBlock) {
        self.presentSecurityPinViewController(animated: animated, cancellable: true, isChangeCode: false, usePolicyDeviceOwnerAuthentication: true, completion: completion, result: result)
    }
    
    open func presentSecurityPinViewControllerForUnlock(animated: Bool, completion: (() -> ())?, result: ResultBlock) {
        self.presentSecurityPinViewController(animated: animated, cancellable: false, isChangeCode: false, usePolicyDeviceOwnerAuthentication: true, completion: completion, result: result)
    }
    
    
    
    func cleanup() {
        UIApplication.shared.delegate?.window??.makeKey()
        self.window?.removeFromSuperview()
        self.window = nil
    }

    public func removePinCode() {
        self.pinCode = nil
    }

    // MARK: - Delegates
    //Create
    func pinCodeViewController(controller: IRSecurityPinViewController, didCreatePinCode pinCode: String?) {
        self.pinCode = pinCode
        
        controller.dismiss(animated: true, completion: nil)
        self.cleanup()
        
        if (self.result! != nil) {
            self.result!!(.Created)
        }
    }
    
    //Verify
    func pinCodeViewController(controller: IRSecurityPinViewController, didVerifiedPincodeSuccessfully pinCode: String?) {
        controller.dismiss(animated: true, completion: nil)
        self.cleanup()
        
        if (self.result! != nil) {
            self.result!!(.Verified)
        }
    }

    //Change
    func pinCodeViewController(controller: IRSecurityPinViewController, didChangePinCode pinCode: String?) {
        self.pinCode = pinCode
        controller.dismiss(animated: true, completion: nil)
        self.cleanup()
        
        if (self.result! != nil) {
            self.result!!(.Changed)
        }
    }

    //Cancel
    func pinCodeViewControllerDidCancel(controller: IRSecurityPinViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.cleanup()
        
        if (self.result! != nil) {
            self.result!!(.Changed)
        }
    }

    // MARK: - Alert
//    - (void)showAlertWithMessage:(NSString *)message {
//
//    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//    //                                                    message:message
//    //                                                   delegate:nil
//    //                                          cancelButtonTitle:@"Dismiss"
//    //                                          otherButtonTitles:nil];
//    //    [alert show];
//    }
//
//    - (UIButton *)fingerPrintIcon
//    {
//    //    if (!_fingerPrintIcon) {
//    //        _fingerPrintIcon = [UIButton buttonWithType:UIButtonTypeCustom];
//    //        [_fingerPrintIcon setImage:[UIImage imageNamed:@"open_lock_way_finger"] forState:UIControlStateNormal];
//    //        _fingerPrintIcon.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    //        _fingerPrintIcon.bounds = CGRectMake(0, 0, MAIN_SIZE.width/2, MAIN_SIZE.height/4);
//    //        _fingerPrintIcon.center = self.view.center;
//    //        [_fingerPrintIcon addTarget:self action:@selector(fingerPrintIconAction:) forControlEvents:UIControlEventTouchUpInside];
//    //        [self.view addSubview:_fingerPrintIcon];
//    //    }
//        return _fingerPrintIcon;
//    }
//    - (void)fingerPrintIconAction:(UIButton *)btn
//    {
//        [self referenceBtnAction:_referenceBtn];
//    }
//    - (UIButton *)referenceBtn
//    {
//    //    if (!_referenceBtn) {
//    //        _referenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //        //        [_referenceBtn mhd_buttonWithTitle:@"点击验证指纹" backColor:[UIColor colorWithRed:0/255.0 green:204/255.0 blue:173/255.0 alpha:1] font:17 titleColor:[UIColor whiteColor] cornerRadius:5];
//    //        [_referenceBtn setTitle:@"点击验证指纹" forState:UIControlStateNormal];
//    //        _referenceBtn.bounds = CGRectMake(0, 0, MAIN_SIZE.width/2, 30);
//    //        _referenceBtn.center = CGPointMake(self.view.center.x, _fingerPrintIcon.center.y+MAIN_SIZE.height/8);
//    //        _referenceBtn.titleLabel.adjustsFontSizeToFitWidth = true;
//    //        [_referenceBtn addTarget:self action:@selector(referenceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    //        [self.view addSubview:_referenceBtn];
//    //    }
//        return _referenceBtn;
//    }
//    - (void)referenceBtnAction:(UIButton *)btn
//    {
//        [IRFingerPrintVerify fingerPrintLocalAuthenticationFallBackTitle:@"Fail" localizedReason:@"fail" callBack:^(BOOL isSuccess, NSError * _Nullable error, NSString *referenceMsg) {
//            [btn setTitle:referenceMsg forState:UIControlStateNormal];
//        }];
//    }
}
