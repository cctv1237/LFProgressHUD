//
//  LFProgressHUD.m
//  LFProgressHUD
//
//  Created by LongFan on 16/3/23.
//  Copyright © 2016年 Long Fan. All rights reserved.
//

#import "LFProgressHUD.h"

static NSString * const kLFProgressHUDImageNameDone = @"lf_progresshud_done";
static NSString * const kLFProgressHUDImageNameError = @"lf_progresshud_error";
static NSString * const kLFProgressHUDImageNameCircle = @"lf_progresshud_progress_circle";

static CGFloat const kLFProgressHUDMaxTextWidth = 210.0;

@interface LFProgressHUD ()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UIView *HUDView;
@property (nonatomic, strong) UIImageView *HUDLogoView;
@property (nonatomic, strong) UILabel *HUDLabel;

@property (nonatomic, strong) UIImageView *progressLogoView;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UIControl *touchPreventer;

@property (nonatomic, strong) CABasicAnimation *rotationAnimation;

@end

@implementation LFProgressHUD

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.userInteractionEnabled = YES;
        self.alpha = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)layoutHUDViews
{
    self.HUDView.frame = CGRectMake(0, 0, kLFProgressHUDMaxTextWidth, self.frame.size.height);
    
    [self.HUDLogoView sizeToFit];
    self.HUDLogoView.frame = CGRectMake((kLFProgressHUDMaxTextWidth - self.HUDLogoView.frame.size.width)/2,
                                        0,
                                        self.HUDLogoView.frame.size.width,
                                        self.HUDLogoView.frame.size.height);
    self.HUDLabel.frame = CGRectMake(0,
                                     self.HUDLogoView.frame.size.height + 16,
                                     kLFProgressHUDMaxTextWidth,
                                     [self.HUDLabel sizeThatFits:CGSizeMake(kLFProgressHUDMaxTextWidth, FLT_MAX)].height);
    self.HUDView.frame = CGRectMake(0,
                                    0,
                                    kLFProgressHUDMaxTextWidth,
                                    self.HUDLabel.frame.origin.y + self.HUDLabel.frame.size.height);
    self.HUDView.center = self.center;
}

- (void)layoutProgressViews
{
    [self.progressLogoView sizeToFit];
    self.progressLogoView.center = self.center;
    
    [self.progressLabel sizeToFit];
    self.progressLabel.center = self.center;
    self.progressLabel.frame = CGRectMake(self.progressLabel.frame.origin.x,
                                          self.progressLogoView.frame.origin.y + self.progressLogoView.frame.size.height + 9,
                                          self.progressLabel.frame.size.width,
                                          self.progressLabel.frame.size.height);
}

#pragma mark - Class methods
+ (LFProgressHUD *)sharedInstance {
    static dispatch_once_t once;
    static LFProgressHUD *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        
    });
    return sharedView;
}

+ (void)showHUDWithType:(LFProgressHUDType)HUDType duration:(NSTimeInterval)duration contentString:(NSString *)string
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] addBaseViewToWindow];
        [[self sharedInstance] showHUDWithType:HUDType duration:duration contentString:string];
    });
}

+ (void)showHUDWithImage:(UIImage *)image duration:(NSTimeInterval)duration contentString:(NSString *)string
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] addBaseViewToWindow];
        [[self sharedInstance] showHUDWithImage:image duration:duration contentString:string];
    });
}

+ (void)showProgressWithType:(LFProgressType)progressType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] addBaseViewToWindow];
        [[self sharedInstance] showProgressWithType:progressType];
    });
}

+ (void)updateProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] updateProgress:progress];
    });
}

+ (void)dissmiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] dissmiss];
    });
}

#pragma mark - Instance methods
- (void)showHUDWithType:(LFProgressHUDType)HUDType duration:(NSTimeInterval)duration contentString:(NSString *)string
{
    [self showHUDWithImage:[self imageWithHudType:HUDType] duration:duration contentString:string];
}

- (void)showHUDWithImage:(UIImage *)image duration:(NSTimeInterval)duration contentString:(NSString *)string
{
    [self addSubview:self.HUDView];
    
    self.HUDLogoView.image = image;
    [self.HUDView addSubview:self.HUDLogoView];
    
    self.HUDLabel.text = string;
    [self.HUDView addSubview:self.HUDLabel];
    
    [self layoutHUDViews];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:2 << 16 animations:^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.progressLogoView.alpha = 0;
        strongSelf.progressLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [UIView animateKeyframesWithDuration:0.2 delay:0 options:1 << 16 animations:^{
            
            strongSelf.alpha = 1;
            strongSelf.HUDLogoView.alpha = 1;
            strongSelf.HUDLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            [UIView animateKeyframesWithDuration:0.2 delay:duration options:2 << 16 animations:^{
                
                strongSelf.alpha = 0;
                strongSelf.HUDLogoView.alpha = 0;
                strongSelf.HUDLabel.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [strongSelf dissmiss];
                
            }];
        }];
    }];
}

- (void)showProgressWithType:(LFProgressType)progressType
{
    self.progressLogoView.image = [self imageWithProgressType:progressType];
    [self addSubview:self.progressLogoView];
    
    if (progressType == LFProgressTypeRollProgress) {
        [self addSubview:self.progressLabel];
        [self updateProgress:0.0];
    } else {
        [self.progressLabel removeFromSuperview];
        [self layoutProgressViews];
    }
    
    [self addSubview:self.touchPreventer];
    self.touchPreventer.frame = self.bounds;
    
    [self.progressLogoView.layer addAnimation:self.rotationAnimation forKey:@"rotaionCircle"];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:2 << 16 animations:^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.HUDLogoView.alpha = 0;
        strongSelf.HUDLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [UIView animateKeyframesWithDuration:0.2 delay:0 options:1 << 16 animations:^{
            
            strongSelf.alpha = 1;
            strongSelf.progressLogoView.alpha = 1;
            strongSelf.progressLabel.alpha = 1;
            
        } completion:nil];
    }];
    
}

- (void)updateProgress:(CGFloat)progress
{
    self.progressLabel.text = [NSString stringWithFormat:@"%ld%%", (long)(progress*100)];
    [self layoutProgressViews];
}

- (void)dissmiss
{
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:2 << 16 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.alpha = 0;
        strongSelf.progressLogoView.alpha = 0;
        strongSelf.HUDLogoView.alpha = 0;
        strongSelf.HUDLabel.alpha = 0;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.progressLogoView.layer removeAllAnimations];
        
        strongSelf.HUDView.frame = CGRectZero;
        strongSelf.HUDLogoView.frame = CGRectZero;
        strongSelf.HUDLabel.frame = CGRectZero;
        strongSelf.progressLogoView.frame = CGRectZero;
        
        [strongSelf.baseView removeFromSuperview];
    }];
}

#pragma mark - event response
- (void)emptyResponse:(UIControl *)view
{
    //do nothing
}

#pragma mark - private
- (void)addBaseViewToWindow
{
    if(!self.baseView.superview){
        [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.baseView];
                *stop = YES;
            }
        }];
    } else {
        [self.baseView.superview bringSubviewToFront:self.baseView];
    }
    
    if (!self.superview) {
        [self.baseView addSubview:self];
    }
}

- (UIImage *)imageWithHudType:(LFProgressHUDType)type
{
    UIImage *image;
    
    switch (type) {
        case LFProgressHUDTypeDone:
            image = [UIImage imageNamed:kLFProgressHUDImageNameDone];
            break;
            
        case LFProgressHUDTypeError:
            image = [UIImage imageNamed:kLFProgressHUDImageNameError];
            break;
            
        default:
            image = [UIImage imageNamed:kLFProgressHUDImageNameDone];
            break;
    }
    
    return image;
}

- (UIImage *)imageWithProgressType:(LFProgressType)type
{
    UIImage *image;
    
    switch (type) {
        case LFProgressTypeRollInfinity:
            image = [UIImage imageNamed:kLFProgressHUDImageNameCircle];
            break;
            
        case LFProgressTypeRollProgress:
            image = [UIImage imageNamed:kLFProgressHUDImageNameCircle];
            break;
            
        default:
            image = [UIImage imageNamed:kLFProgressHUDImageNameCircle];
            break;
    }
    
    return image;
}

#pragma mark - getters & setters
- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
    }
    return _baseView;
}

- (UIView *)HUDView
{
    if (_HUDView == nil) {
        _HUDView = [[UIView alloc] init];
    }
    return _HUDView;
}

- (UIImageView *)HUDLogoView
{
    if (_HUDLogoView == nil) {
        _HUDLogoView = [[UIImageView alloc] init];
        _HUDLogoView.alpha = 0;
    }
    return _HUDLogoView;
}

- (UILabel *)HUDLabel
{
    if (_HUDLabel == nil) {
        _HUDLabel = [[UILabel alloc] init];
        _HUDLabel.textColor = [UIColor whiteColor];
        _HUDLabel.font = [UIFont systemFontOfSize:11];
        _HUDLabel.textAlignment = NSTextAlignmentCenter;
        _HUDLabel.numberOfLines = 0;
        _HUDLabel.alpha = 0;
    }
    return _HUDLabel;
}

- (UIImageView *)progressLogoView
{
    if (_progressLogoView == nil) {
        _progressLogoView = [[UIImageView alloc] init];
        _progressLogoView.alpha = 0;
    }
    return _progressLogoView;
}

- (UILabel *)progressLabel
{
    if (_progressLabel == nil) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = [UIFont systemFontOfSize:11];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.alpha = 0;
    }
    return _progressLabel;
}

- (UIControl *)touchPreventer
{
    if (_touchPreventer == nil) {
        _touchPreventer = [[UIControl alloc] init];
        [_touchPreventer addTarget:self action:@selector(emptyResponse:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchPreventer;
}

- (CABasicAnimation *)rotationAnimation
{
    if (_rotationAnimation == nil) {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat: - M_PI * 2.0 ];
        _rotationAnimation.duration = 0.8;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.repeatCount = MAXFLOAT;
        _rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    return _rotationAnimation;
}

@end
