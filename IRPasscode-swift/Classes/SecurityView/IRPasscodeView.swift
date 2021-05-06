//
//  IRPasscodeView.swift
//  IRPasscode-swift
//
//  Created by Phil on 2021/2/23.
//  Copyright © 2021 Phil. All rights reserved.
//

import UIKit

protocol IRPasscodeViewDelegate {
    func didEnterPinCode(in view: IRPasscodeView, withPinCode pinCode: String?)
}

extension IRPasscodeViewDelegate {
    func didEnterPinCode(in view: IRPasscodeView, withPinCode pinCode: String?) {}
}

let IRDefinedPinsCount = 4

class IRPasscodeView: UIView {
    
    var delegate: IRPasscodeViewDelegate?
    var pinCode: String? {
        willSet {
            //Trimmed text
            let enteredCode = self.trimmedStringWithMaxLenght(sourceString: newValue)
            
            self.fakeTextField.text = enteredCode
        }
        didSet {
            //Colorize pins
            self.colorizePins()
            
            //Notify delegate if needed
            self.checkForEnteredPin()
        }
    }
    var normalPinImage: UIImage?
    var selectedPinImage: UIImage?
    
    var pinViewsArray: [UIImageView]?
    var fakeTextField: UITextField = UITextField.init(frame: CGRect.zero)
    
    private(set) var isInitialized: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    func commonInit() {
        if (!self.isInitialized) {
            //You can freely use background color in XIB's
            self.backgroundColor = .clear
            
            self.normalPinImage = UIImage.imageNamedForCurrentBundle(named: "pinViewUnSelected")
            self.selectedPinImage = UIImage.imageNamedForCurrentBundle(named: "pinViewSelected")
            
            //Fake text field
            self.fakeTextField.keyboardType = .numberPad
            self.fakeTextField.addTarget(self, action: #selector(textFieldTextChanged(textField:)), for: .editingChanged)
           
            self.addSubview(self.fakeTextField)
        
            //Build pins
            self.buildPins()
            
            //Tap gesture
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureOccured(tapGesture:)))
            self.addGestureRecognizer(tapGesture)
            
            self.isInitialized = true
        }
    }

// MARK: - Build View
    func buildPins() {
        //Remove old pins
        self.pinViewsArray?.forEach({ $0.removeFromSuperview() })
        
        let width = self.bounds.size.width
        let itemWidth = floor(width / CGFloat(IRDefinedPinsCount))
        
        //Add pincodes
        var pinCodesContainer = [UIImageView]()
        for i in 0..<IRDefinedPinsCount {
            let pinImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: self.bounds.size.height))
            pinImageView.image = self.normalPinImage
            pinImageView.highlightedImage = self.selectedPinImage
            pinImageView.contentMode = .scaleAspectFit

            pinImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin]
            self.addSubview(pinImageView)
            
            pinCodesContainer.append(pinImageView)
        }
        
        self.pinViewsArray = pinCodesContainer
    }

// MARK: - Images
    func setNormalPinImage(normalPinImage: UIImage) {
        self.normalPinImage = normalPinImage;
        
        //Set normal image
        self.pinViewsArray?.forEach { $0.image = normalPinImage }
    }

    func setSelectedPinImage(selectedPinImage: UIImage) {
        self.selectedPinImage = selectedPinImage;
        
        //Set selected image
        self.pinViewsArray?.forEach({ $0.highlightedImage = selectedPinImage })
    }

// MARK: - UITextField
    @objc func textFieldTextChanged(textField: UITextField) {
        //Trimmed text
        textField.text = self.trimmedStringWithMaxLenght(sourceString: textField.text);
        
        self.pinCode = textField.text
        
        //Colorize pins
        self.colorizePins()
        
        //Notify delegate if needed
        self.checkForEnteredPin()
    }

// MARK: - ColorizeViews
    func colorizePins() {
        let pinsEntered = self.pinCode?.count
        let itemsCount = self.pinViewsArray?.count ?? 0
        for i in 0..<itemsCount {
            let pinImageView = self.pinViewsArray?[i]
            pinImageView?.isHighlighted = i < (pinsEntered ?? 0)
        }
    }

// MARK: - Delegate
    func checkForEnteredPin() {
        if (self.pinCode?.count == IRDefinedPinsCount) {
            self.delegate?.didEnterPinCode(in: self, withPinCode: self.pinCode)
        }
    }

// MARK: - Gestures
    @objc func tapGestureOccured(tapGesture: UITapGestureRecognizer) {
        self.becomeFirstResponder()
    }

// MARK: - Helpers
    func trimmedStringWithMaxLenght(sourceString: String?) -> String? {
        var newString = sourceString
        if (sourceString?.count ?? 0 > IRDefinedPinsCount) {
            newString = String(sourceString!.prefix(IRDefinedPinsCount))
        }
        return newString
    }
}
