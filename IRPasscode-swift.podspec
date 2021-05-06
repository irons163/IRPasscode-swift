Pod::Spec.new do |spec|
  spec.name         = "IRPasscode-swift"
  spec.version      = "0.2.0"
  spec.summary      = "A powerful passcode of iOS."
  spec.description  = "A powerful passcode of iOS."
  spec.homepage     = "https://github.com/irons163/IRPasscode-swift.git"
  spec.license      = "MIT"
  spec.author       = "irons163"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/irons163/IRPasscode-swift.git", :tag => spec.version.to_s }
  spec.source_files  = "IRPasscode-swift/**/*.swift", "IRPasscode-swift/**/IRPasscode_swift.h"
  spec.exclude_files = "IRPasscode-swift/ThirdParty/**/*"
  spec.public_header_files = 'IRPasscode-swift/**/IRPasscode_swift.h'
  spec.resources = ["IRPasscode-swift/**/*.xib", "IRPasscode-swift/**/*.xcassets", "IRPasscode-swift/**/IRPasscodeBundle.bundle"]
#  spec.framework = 'XCTest'
  spec.dependency "KeychainAccess"
end
