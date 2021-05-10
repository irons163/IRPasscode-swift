![Build Status](https://img.shields.io/badge/build-%20passing%20-brightgreen.svg)
![Platform](https://img.shields.io/badge/Platform-%20iOS%20-blue.svg)

# IRPasscode-swift 

- IRPasscode-swift is a powerful passcode for iOS.

## Features
- 4 Pin support.
- FingerPrint support.
- High Security - KeyChain support.

## Install
### Git
- Git clone this project.
- Copy this project into your own project.
- Add the .xcodeproj into you  project and link it as embed framework.
#### Options
- You can remove the `demo` and `ScreenShots` folder.

### Cocoapods
- Add `pod 'IRPasscode-swift'`  in the `Podfile`
- `pod install`

## Usage

### Basic
- Open `Passcode Setting Page`.
```obj-c
#import <IRPasscode/IRPasscode.h>

NSBundle *xibBundle = [NSBundle bundleForClass:[IRPasscodeLockSettingViewController class]];
IRPasscodeLockSettingViewController *vc = [[IRPasscodeLockSettingViewController alloc] initWithNibName:@"IRPasscodeLockSettingViewController" bundle:xibBundle];
[self.navigationController pushViewController:vc animated:YES];
```

- Open `Passcode verify page`.
```obj-c
if ([IRSecurityPinManager sharedInstance].pinCode)
    [[IRSecurityPinManager sharedInstance] presentSecurityPinViewControllerForUnlockWithAnimated:YES completion:nil result:nil];
```

## Screenshots
| Demo | Passcode Settings |
|:---:|:---:|
| ![Demo](./ScreenShots/demo1.png) | ![Passcode Settings](./ScreenShots/demo2.png) |
| Set Passcode  | Confirm Passcode |
| ![Set Passcode](./ScreenShots/demo3.png) | ![Confirm Passcode](./ScreenShots/demo4.png) |
| Confirm Passcode Fail | Change Passcode |
| ![Confirm Passcode Fail](./ScreenShots/demo5.png) | ![Change Passcode](./ScreenShots/demo6.png) |
| Unlock Passcode | Demo Private Data |
| ![Unlock Passcode](./ScreenShots/demo7.png) | ![Demo Private Data](./ScreenShots/demo8.png) |
