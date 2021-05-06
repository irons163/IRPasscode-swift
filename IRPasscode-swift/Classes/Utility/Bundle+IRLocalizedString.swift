//
//  Bundle+IRLocalizedString.swift
//  IRPasscode-swift
//
//  Created by Phil on 2021/2/23.
//  Copyright © 2021 Phil. All rights reserved.
//

import Foundation

extension Bundle {
    static let bundleName = "IRPasscodeBundle"
    
    class func safeBundle() -> Bundle? {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            
            // Bundle should be present here when the package is linked into a framework.
            Utilities.getCurrentBundle().resourceURL,
            
            // For command-line tools.
            Bundle.main.bundleURL,
        ]
        
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named ID3TagEditor_ID3TagEditorTests")
        
        //        return bundle
    }
    
    class func IR_localizedStringForKey(key: String) -> String? {
        return Bundle.IR_localizedStringForKey(key: key, value: nil)
    }
    
    class func IR_localizedStringForKey(key: String, language: String?) -> String? {
        if (language == nil) {
            return Bundle.IR_localizedStringForKey(key: key, value: nil)
        }
        
        return Bundle.IR_localizedStringForKey(key: key, value: nil, language: language)
    }
    
    class func IR_localizedStringForKey(key: String, value: String?) -> String? {
        var language = Locale.preferredLanguages.first
        if (language != nil) && language!.hasPrefix("en") {
            language = "en"
        } else if (language != nil) && language!.hasPrefix("zh") {
            if (language != nil) && language!.contains("Hans") {
                language = "zh-Hans"
            } else {
                language = "zh-Hant"
            }
        } else {
            language = "en"
        }
        
        return Bundle.IR_localizedStringForKey(key: key, value: value, language: language)
    }
    
    class func IR_localizedStringForKey(key: String, value: String?, language: String?) -> String? {
        let bundle = Bundle.init(path: (Bundle.safeBundle()?.path(forResource: language, ofType: "lproj"))!)
        let newValue = (bundle?.localizedString(forKey: key, value: value, table: nil))!
        return Bundle.main.localizedString(forKey: key, value: newValue, table: nil)
    }
}
