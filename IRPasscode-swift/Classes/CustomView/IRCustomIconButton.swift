//
//  IRCustomIconButton.swift
//  IRPasscode-swift
//
//  Created by Phil on 2021/2/23.
//  Copyright © 2021 Phil. All rights reserved.
//

import UIKit

enum IconContentMode: Int {
    case IconContentModeCenter
    case IconContentModeLeft
    case IconContentModeRight
}

@IBDesignable
class IRCustomIconButton: UIButton {

    #if !TARGET_INTERFACE_BUILDER
    @IBInspectable var imageViewContentMode: UIView.ContentMode
    {
        set {
            self.setImageViewContentMode(imageViewContentMode: newValue)
        }
        get {
            return self.imageView?.contentMode ?? .scaleToFill
        }
    }
    #else
    @IBInspectable var imageViewContentMode: Int
    {
        set {
            self.setImageViewContentMode(imageViewContentMode: UIView.ContentMode(rawValue: newValue) ?? .scaleToFill)
        }
        get {
            return (self.imageView?.contentMode)!.rawValue
        }
    }
    #endif

    @IBInspectable var iconContentMode: Int = 0
    {
        didSet {
            self.refreshUI()
        }
    }

    var sizePersent: CGSize = CGSize.zero
    @IBInspectable var iconSizePersent: CGSize
    {
        set {
            sizePersent = newValue
            
            if(newValue.width < 0){
                sizePersent.width = 0;
            }
            if(newValue.height < 0){
                sizePersent.height = 0;
            }

            self.invalidateIntrinsicContentSize()
            self.setNeedsLayout()
        }
        get {
            return sizePersent
        }
    }
    @IBInspectable var cornerRadius: Float
    {
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
        get {
            Float(self.layer.cornerRadius)
        }
    }
    @IBInspectable var borderWidth: Float
    {
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
        get {
            Float(self.layer.borderWidth)
        }
    }
    @IBInspectable var borderColor: UIColor
    {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            UIColor.init(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    @IBInspectable var titleEdgeTop: Float = 0
    {
        didSet {
            var newEdge: UIEdgeInsets = self.titleEdgeInsets
            newEdge.top = CGFloat(titleEdgeTop)
            self.titleEdgeInsets = newEdge
        }
    }
    @IBInspectable var titleEdgeLeft: Float = 0
    {
        didSet {
            var newEdge: UIEdgeInsets = self.titleEdgeInsets
            newEdge.left = CGFloat(titleEdgeLeft)
            self.titleEdgeInsets = newEdge
        }
    }
    @IBInspectable var titleEdgeBottom: Float = 0
    {
        didSet {
            var newEdge: UIEdgeInsets = self.titleEdgeInsets
            newEdge.bottom = CGFloat(titleEdgeBottom)
            self.titleEdgeInsets = newEdge
        }
    }
    @IBInspectable var titleEdgeRight: Float = 0
    {
        didSet {
            var newEdge: UIEdgeInsets = self.titleEdgeInsets
            newEdge.right = CGFloat(titleEdgeRight)
            self.titleEdgeInsets = newEdge
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }

    func setImageViewContentMode(imageViewContentMode: UIView.ContentMode) {
        self.imageView?.contentMode = imageViewContentMode

        self.refreshUI()
    }

    func refreshUI() {
        self.imageView?.invalidateIntrinsicContentSize()
        self.imageView?.setNeedsLayout()
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let superContentRect = super.imageRect(forContentRect: contentRect)

        var imageSize = superContentRect.size

        if self.iconSizePersent.width == 0 {
            imageSize.width = 0
        } else {
            imageSize.width = imageSize.width * self.iconSizePersent.width
        }

        if self.iconSizePersent.height == 0 {
            imageSize.height = 0
        } else {
            imageSize.height = imageSize.height * self.iconSizePersent.height
        }

        var tmp = contentRect
        tmp.size = imageSize

        var tmpPoint = contentRect.origin

        switch IconContentMode.init(rawValue: self.iconContentMode) {
        case .IconContentModeCenter:
            tmpPoint.x = tmpPoint.x + (contentRect.size.width - imageSize.width) / 2;
            tmpPoint.y = tmpPoint.y + (contentRect.size.height - imageSize.height) / 2;
            break
        case .IconContentModeLeft:
            tmpPoint.y = tmpPoint.y + (contentRect.size.height - imageSize.height) / 2;
            break
        case .IconContentModeRight:
            tmpPoint.x = tmpPoint.x + (contentRect.size.width - imageSize.width);
            tmpPoint.y = tmpPoint.y + (contentRect.size.height - imageSize.height) / 2;
            break
        default:
            break
        }

        tmp.origin = tmpPoint

        return tmp
    }
}
