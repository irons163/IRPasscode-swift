//
//  ViewController.swift
//  demo
//
//  Created by Phil on 2020/9/30.
//  Copyright © 2020 Phil. All rights reserved.
//

import UIKit
import IRPasscode_swift

class ViewController: UIViewController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction fileprivate func demoButtonClick(_ sender: Any) {
        let xibBundle = Bundle.init(for: IRPasscodeLockSettingViewController.self)
        let vc = IRPasscodeLockSettingViewController.init(nibName: "IRPasscodeLockSettingViewController", bundle: xibBundle)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction fileprivate func demoUnlockButtonClick(_ sender: Any) {
        let vc = PrivateDataViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}

