//
//  IRSecurityPinButton.swift
//  IRPasscode-swift
//
//  Created by Phil on 2021/2/23.
//  Copyright © 2021 Phil. All rights reserved.
//

import Foundation

class IRSecurityPinButton: IRCustomIconButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.initButton()
    }
    
    func initButton() {
        self.setBackgroundImage(self.imageFromColor(color: UIColor.colorWithColorCodeString("FF18937B")), for: .highlighted)
    }
    
    func imageFromColor(color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
