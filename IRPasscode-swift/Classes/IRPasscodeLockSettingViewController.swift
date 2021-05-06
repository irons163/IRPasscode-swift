//
//  IRPasscodeLockSettingViewController.swift
//  IRPasscode-swift
//
//  Created by Phil on 2021/2/23.
//  Copyright © 2021 Phil. All rights reserved.
//

import UIKit

open class IRPasscodeLockSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet fileprivate weak var tableView: UITableView?

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = Bundle.IR_localizedStringForKey(key:"PasscodeLock")
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView?.reloadData()
    }

    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (IRSecurityPinManager.sharedInstance.pinCode != nil) {
            return 2
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = Bundle.IR_localizedStringForKey(key:"PasscodeLock")
            let switchview = UISwitch.init()
            if(IRSecurityPinManager.sharedInstance.pinCode != nil) {
                switchview.isOn = true
            }
                
            cell.accessoryView = switchview
            cell.selectionStyle = .none
            switchview.addTarget(self, action: #selector(updateLockEnabled), for: .valueChanged)
            break
        case 1:
            cell.textLabel?.text = Bundle.IR_localizedStringForKey(key:"ChangePasscode")
            cell.accessoryType = .disclosureIndicator
            break
        default:
            break
        }
        
        return cell;
    }
    
    @objc func updateLockEnabled(sender: UISwitch) {
        if (!sender.isOn) {
            IRSecurityPinManager.sharedInstance.presentSecurityPinViewControllerForRemove(animated: true, completion: nil, result: { (type) in
                if(type == .Verified) {
                    IRSecurityPinManager.sharedInstance.removePinCode()
                }
                self.tableView?.reloadData()
            })
        } else {
            IRSecurityPinManager.sharedInstance.presentSecurityPinViewControllerForCreate(animated: true, completion: nil) { (type) in
                self.tableView?.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let cellHeight = 80.0
        
        if IRSecurityPinManager.sharedInstance.pinCode != nil {
            return 2
        }
        
        return CGFloat(cellHeight)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.size.width, height: 28))
        footer.backgroundColor = .white
        
        let devicesCountLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: footer.frame.size.width - 25, height: 80))
        devicesCountLabel.text = Bundle.IR_localizedStringForKey(key:"PasscodeHintString")
        devicesCountLabel.numberOfLines = 0;
        devicesCountLabel.font = UIFont.systemFont(ofSize: 13)
        devicesCountLabel.textColor = .gray
        devicesCountLabel.baselineAdjustment = .alignCenters
        footer.addSubview(devicesCountLabel)

        let separatorLineView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: footer.frame.size.width, height: 0.5))
        separatorLineView.backgroundColor = .lightGray
        footer.addSubview(separatorLineView)

        footer.clipsToBounds = true
        return footer;
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            IRSecurityPinManager.sharedInstance.presentSecurityPinViewControllerForChangePasscode(animated: true, completion: nil, result: nil)
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
