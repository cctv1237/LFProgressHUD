//
//  LFProgressHUD.h
//  LFProgressHUD
//
//  Created by LongFan on 16/5/18.
//  Copyright © 2016年 Long Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LFProgressHUDType) {
    LFProgressHUDTypeDone,
    LFProgressHUDTypeError
};

typedef NS_ENUM(NSInteger, LFProgressType) {
    LFProgressTypeRollInfinity,
    LFProgressTypeRollProgress
};

@interface LFProgressHUD : UIView

+ (void)showHUDWithType:(LFProgressHUDType)HUDType duration:(NSTimeInterval)duration contentString:(NSString *)string;
+ (void)showHUDWithImage:(UIImage *)image duration:(NSTimeInterval)duration contentString:(NSString *)string;

+ (void)showProgressWithType:(LFProgressType)progressType;
+ (void)updateProgress:(CGFloat)progress;

+ (void)dissmiss;

@end
