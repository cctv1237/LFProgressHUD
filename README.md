# LFProgressHUD

`LFProgressHUD` is an iOS drop-in class that displays a translucent HUD with an indicator and/or labels.

## Requirements

`LFProgressHUD` works on iOS 8+ and requires ARC to build. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework

You will need the latest developer tools in order to build `LFProgressHUD`. Old Xcode versions might work, but compatibility will not be explicitly maintained.

## Adding LFProgressHUD to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add LFProgressHUD to your project.

1. Add a pod entry for LFProgressHUD to your Podfile `pod 'LFProgressHUD', '~> 0.1.0'`
2. Install the pod(s) by running `pod install`.
3. Include LFProgressHUD wherever you need it with `#import "LFProgressHUD.h"`.

### Source files

Alternatively you can directly add the `LFProgressHUD.h` and `LFProgressHUD.m` source files to your project.

1. Download the [latest code version](https://github.com/cctv1237/LFProgressHUD/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `LFProgressHUD.h` and `LFProgressHUD.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
3. Include LFProgressHUD wherever you need it with `#import "LFProgressHUD.h"`.

### Static library

You can also add LFProgressHUD as a static library to your project or workspace.

1. Download the [latest code version](https://github.com/matej/LFProgressHUD/downloads) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `LFProgressHUD.xcodeproj` onto your project or workspace (use the "Product Navigator view").
3. Select your target and go to the Build phases tab. In the Link Binary With Libraries section select the add button. On the sheet find and add `libLFProgressHUD.a`. You might also need to add `LFProgressHUD` to the Target Dependencies list.
4. Include LFProgressHUD wherever you need it with `#import <LFProgressHUD/LFProgressHUD.h>`.

## Usage

The main guideline you need to follow when dealing with LFProgressHUD while running long-running tasks is keeping the main thread work-free, so the UI can be updated promptly. The recommended way of using LFProgressHUD is therefore to set it up on the main thread and then spinning the task, that you want to perform, off onto a new thread.

```objective-c
[LFImagePicker show];
```

You can add the HUD on any view or window. It is however a good idea to avoid adding the HUD to certain `UIKit` views with complex view hierarchies - like `UITableView` or `UICollectionView`. Those can mutate their subviews in unexpected ways and thereby break HUD display. 

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
