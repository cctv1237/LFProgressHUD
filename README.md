# LFProgressHUD

[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-0.1.1-green.svg?style=flat)](https://cocoapods.org) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://opensource.org/licenses/MIT)

`LFProgressHUD` is an iOS class that displays a full screen HUD with custom indicator and/or labels. `LFProgressHUD` can also display dynamic progress in any thread.

[![Introduction](https://github.com/cctv1237/LFProgressHUD/blob/master/LFProgressHUD.gif)](https://github.com/cctv1237/LFProgressHUD/blob/master/LFProgressHUD.gif)

## Requirements

`LFProgressHUD` works on iOS 8.0+ and requires ARC to build. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework
* QuartzCore.framework

You will need the latest developer tools in order to build `LFProgressHUD`. Old Xcode versions might work, but compatibility will not be explicitly maintained.

## Adding LFProgressHUD to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add LFProgressHUD to your project.

1. Add a pod entry for LFProgressHUD to your Podfile `pod 'LFProgressHUD', '~> 0.1.1'`
2. Install the pod(s) by running `pod install`.
3. Include LFProgressHUD wherever you need it with `#import <LFProgressHUD/LFProgressHUD.h>`.

### Source files

Alternatively you can directly add the `LFProgressHUD.h` and `LFProgressHUD.m` source files to your project.

1. Download the [latest code version](https://github.com/cctv1237/LFProgressHUD/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `LFProgressHUD.h` and `LFProgressHUD.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
3. Include LFProgressHUD wherever you need it with `#import "LFProgressHUD.h"`.

## Usage

#### New in 0.1.1
Custom Progress Image.

LFProgressHUD can help you dealing with program which is running time-consuming operation such as API call back and disk writing. Public methods of LFProgressHUD  are running in the main thead so that you can use it in some asynchronous tasks.

### Use as Notice

You can simply add an custom-appear-time notice. 

```objective-c
[LFProgressHUD showHUDWithType:LFProgressHUDTypeDone duration:0.8 contentString:@"Done"];
```

Or custom your own notice image.

```objective-c
[LFProgressHUD showHUDWithImage:[UIImage imageNamed:@"yao_ming"] duration:0.8 contentString:@"U ask me?"];
```

### Use as Progress

You can add an Progress with 2 types, infinity roll animation and roll with live progress. 

```objective-c
[LFProgressHUD showProgressWithType:LFProgressTypeRollInfinity progressImage:nil];
[LFProgressHUD showProgressWithType:LFProgressTypeRollProgress progressImage:nil];
```

If you are using LFProgressTypeRollProgress, you can update progress as follow

```objective-c
[LFProgressHUD updateProgress:0.6];
```

And to dissmiss 

```objective-c
[LFProgressHUD dissmiss];
```

See more in demo and welcome to post issues.

Enjoy.

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
