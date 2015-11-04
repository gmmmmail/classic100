// 
// EEHUDView.m 
// Created by Yoshiki Kudo on 11/12/05.
//
// Copyright (c) 2012 Yoshiki Kudo All rights reserved.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "EEHUDView.h"
#import <QuartzCore/QuartzCore.h>

#import "EEHUDViewConstants.h"
#import "EEAnimationHandler.h"




#pragma mark - ** EEHUDViewController **
@interface EEHUDViewController : UIViewController  {
    
    UIView *hudView_;
    UILabel *message_;
    EEHUDResultView *resultView_;
    EEProgressView *_progressView;
    BOOL _isShowProgress;
}
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UILabel *message;
@property (nonatomic, strong) EEHUDResultView *resultView;
@property (nonatomic, strong) EEProgressView *progressView;
@property (nonatomic, assign) BOOL isShowProgress;

- (void)willChangeStatusBarOrientationNotification:(NSNotification *)notification;
- (void)didChangeStatusBarOrientationNotification:(NSNotification *)notification;

@end

@implementation EEHUDViewController
@synthesize hudView = hudView_;
@synthesize message = message_;
@synthesize resultView = resultView_;
@synthesize progressView = _progressView;
@synthesize isShowProgress = _isShowProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // notifiation
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(willChangeStatusBarOrientationNotification:)
                       name:UIApplicationWillChangeStatusBarOrientationNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(didChangeStatusBarOrientationNotification:)
                       name:UIApplicationDidChangeStatusBarOrientationNotification
                     object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [center removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 無ければ作る
    if (!self.hudView) [self hudView];
    if (!self.message) [self message];
    if (!self.resultView) [self resultView];
    if (!self.progressView) [self progressView];
}

- (void)loadView
{
    CGRect fullRect = [[UIScreen mainScreen] bounds];
    UIView *baseView = [[UIView alloc] initWithFrame:fullRect];
    baseView.backgroundColor = [UIColor clearColor];
    baseView.userInteractionEnabled = NO;
    self.view = baseView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.hudView = nil;
    self.message = nil;
    self.resultView = nil;
    self.progressView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    /***************************************************************
     回転は目的に応じて
     
        EEHUDViewConstants.h
     
     内の各定数項を変更してください ( ** iOS6以降のみ対応する場合は変更する必要ありません **)
     ***************************************************************/
    
    BOOL boolSwitch;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            boolSwitch = EEHUD_INTERFACE_ORIENTATION_PORTRAIT;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            boolSwitch = EEHUD_INTERFACE_ORIENTATION_LANDSCAPE_LEFT;
            break;
        case UIInterfaceOrientationLandscapeRight:
            boolSwitch = EEHUD_INTERFACE_ORIENTATION_LANDSCAPE_RIGHT;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            boolSwitch = EEHUD_INTERFACE_ORIENTATION_PORTRAIT_UPSIDEDOWN;
            break;
        default:
            boolSwitch = YES;
            break;
    }
    
    return boolSwitch;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotate{
    return YES;
}
#endif

- (void)viewDidLayoutSubviews
{
    CGRect hudRect = self.hudView.frame;
    
    CGFloat height = EEHUD_VIEW_HEIGHT;
    CGFloat width = EEHUD_VIEW_WIDTH;
    
    if (self.isShowProgress) {
        height = EEHUD_VIEW_HEIGHT + EEHUD_VIEW_HEIGHT_PROGRESS + 2.0*EEHUD_VIEW_MARGIN_VERTICAL_PROGRESS;
    }
    
    hudRect.size.height = height;
    
    CGSize fullSize = [[UIScreen mainScreen] bounds].size;
    
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    if (!statusBarHidden) fullSize.height -= 20.0;
    
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            hudRect.origin = CGPointMake((fullSize.width - width)*0.5, (fullSize.height - height)*0.5);
            break;
        case UIInterfaceOrientationLandscapeLeft:
//            hudRect.origin = CGPointMake((fullSize.height - width)*0.5, (fullSize.width - height)*0.5);
             hudRect.origin = CGPointMake((fullSize.width - width)*0.5, (fullSize.height - height)*0.5);
            break;
        case UIInterfaceOrientationLandscapeRight:
//            hudRect.origin = CGPointMake((fullSize.height - width)*0.5, (fullSize.width - height)*0.5);
            hudRect.origin = CGPointMake((fullSize.width - width)*0.5, (fullSize.height - height)*0.5);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            hudRect.origin = CGPointMake((fullSize.width - width)*0.5, (fullSize.height - height)*0.5);
            break;
        default:
            hudRect.origin = CGPointMake((fullSize.width - width)*0.5, (fullSize.height - height)*0.5);
            break;
    }
    
    self.hudView.frame = hudRect;
}

#pragma mark - Getter
- (UIView *)hudView
{
    if (!hudView_) {
        
        CGSize fullSize = [[UIScreen mainScreen] bounds].size;
        
        CGRect rect;
        rect.origin.x = (fullSize.width - EEHUD_VIEW_WIDTH) * 0.5;
        rect.origin.y = (fullSize.height - EEHUD_VIEW_HEIGHT) * 0.5;
        rect.size.width = EEHUD_VIEW_WIDTH;
        rect.size.height = EEHUD_VIEW_HEIGHT;
        
        hudView_ = [[UIView alloc] initWithFrame:rect];
        
        hudView_.backgroundColor = EEHUD_COLOR_HUDVIEW;
        hudView_.layer.cornerRadius = EEHUD_VIEW_CORNER_RADIUS;
        hudView_.clipsToBounds = YES;
        
    }
    
    if (!hudView_.superview) {
        [self.view addSubview:hudView_];
    }
    
    return hudView_;
}

- (UILabel *)message
{
    if (!message_) {
        
        /***
         message
         ***/
        CGRect messageRect = CGRectMake(EEHUD_VIEW_BOTHENDS_MARGIN,
                                        EEHUD_VIEW_HEIGHT - EEHUD_LABEL_HEIGHT - EEHUD_LABEL_BOTTOM_MARGIN,
                                        EEHUD_VIEW_WIDTH - 2.0*EEHUD_VIEW_BOTHENDS_MARGIN,
                                        EEHUD_LABEL_HEIGHT);
        message_ = [[UILabel alloc] initWithFrame:messageRect];
        message_.backgroundColor = [UIColor clearColor];
        message_.textAlignment = NSTextAlignmentCenter;
        message_.font = EEHUD_LABEL_FONT;
        message_.textColor = EEHUD_LABEL_TEXTCOLOR;
        
    }
    
    if (!message_.superview) {
        [self.hudView addSubview:message_];
    }
    
    return message_;
}

- (EEHUDResultView *)resultView
{
    if (!resultView_) {
        
        /***
         resultView
         ***/
        CGRect rect;
        rect.origin = CGPointMake(EEHUD_VIEW_BOTHENDS_MARGIN, EEHUD_IMAGE_ORIGINY);
        rect.size.width = EEHUD_IMAGE_WIDTH - 2.0 * EEHUD_VIEW_BOTHENDS_MARGIN;
        rect.size.height = EEHUD_IMAGE_HEIGHT;
        
        resultView_ = [[EEHUDResultView alloc] initWithFrame:rect];
        resultView_.backgroundColor = [UIColor clearColor];
        
    }
    
    if (!resultView_.superview) {
        [self.hudView addSubview:resultView_];
    }
    
    return resultView_;
}

- (UIView *)progressView
{
    if (!_progressView) {
        
        UIView *hud = [self hudView];
        
        CGRect rect = CGRectZero;
        rect.origin.x = EEHUD_VIEW_MARGIN_HORIZONTAL_PROGRESS;
        rect.origin.y = EEHUD_VIEW_HEIGHT + EEHUD_VIEW_MARGIN_VERTICAL_PROGRESS;
        rect.size.width = hud.frame.size.width - 2.0*EEHUD_VIEW_MARGIN_HORIZONTAL_PROGRESS;
        rect.size.height = EEHUD_VIEW_HEIGHT_PROGRESS;
        
        _progressView = [[EEProgressView alloc] initWithFrame:rect];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.layer.opacity = 0.0;
        
        // 
        _isShowProgress = NO;
    }
    
    if (!_progressView.superview) {
        //[self.view addSubview:_progressView];
        [self.hudView addSubview:_progressView];
    }
    
    return _progressView;
}

#pragma mark - Notification
- (void)willChangeStatusBarOrientationNotification:(NSNotification *)notification
{
//    EEHUDView *window = (EEHUDView *)[[UIApplication sharedApplication] keyWindow];
//    
//    if ([window respondsToSelector:@selector(appealTimer)]) {
//        NSTimer *appealTimer = [window performSelector:@selector(appealTimer)];
//        LOG(@"timer:%@, isValid:%d", appealTimer, appealTimer.isValid);
//        [appealTimer invalidate];
//    }
    
}

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)notification
{
//    EEHUDView *window = (EEHUDView *)[[UIApplication sharedApplication] keyWindow];
//    
//    if ([window respondsToSelector:@selector(appealTimer)]) {
//        NSTimer *appealTimer = [window performSelector:@selector(appealTimer)];
//        LOG(@"timer:%@, isValid:%d", appealTimer, appealTimer.isValid);
//        [appealTimer fire];
//    }
}

#pragma mark - Setter
- (void)setIsShowProgress:(BOOL)isShowProgress
{
    __weak EEProgressView *progressView = self.progressView;
    __weak UIView *hud = self.hudView;
    
    if (_isShowProgress != isShowProgress) {
        
        //LOG(@"isShowProrgess:%d", isShowProgress);
        
        if (isShowProgress) {
            // NO -> YES
            
            CGSize fromSize = hud.bounds.size;
            fromSize.height = EEHUD_VIEW_HEIGHT;
            
            CGSize toSize = hud.bounds.size;
            toSize.height = EEHUD_VIEW_HEIGHT + EEHUD_VIEW_HEIGHT_PROGRESS + 2.0*EEHUD_VIEW_MARGIN_VERTICAL_PROGRESS;
            
            CABasicAnimation *expand = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
            expand.fromValue = [NSValue valueWithCGSize:fromSize];
            expand.toValue = [NSValue valueWithCGSize:toSize];
            expand.removedOnCompletion = NO;
            expand.fillMode = kCAFillModeForwards;
            expand.duration = EEHUD_DURATION_SHOW_PROGRESS_RANGE;
            
            //hud.layer.anchorPoint = CGPointMake(0.5, 0.0);
            
            expand.stopHandlerBlock = ^(CAAnimation *anim, BOOL finished){
                
                CALayer *layer = anim.addedLayer;
                CALayer *pLayer = layer.presentationLayer;
                layer.bounds = pLayer.bounds;
                
                [layer removeAnimationForKey:anim.animationKey];
                
                // 代入
                _isShowProgress = isShowProgress;
                
                // alpha
                CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
                alpha.fromValue = [NSNumber numberWithFloat:0.0];
                alpha.toValue = [NSNumber numberWithFloat:1.0];
                alpha.fillMode = kCAFillModeForwards;
                alpha.removedOnCompletion = NO;
                alpha.duration = EEHUD_DURATION_FADEIN_PROGRESS;
                alpha.stopHandlerBlock = ^(CAAnimation *anim, BOOL finished){
                    
                    CALayer *layer = anim.addedLayer;
                    CALayer *pLayer = layer.presentationLayer;
                    
                    layer.opacity = pLayer.opacity;
                    [layer removeAnimationForKey:anim.animationKey];
                    
                };
                
                EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
                [handler registerAnimation:alpha toLayer:progressView.layer forKey:@"in_progress"];
                
            };
            
            EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
            [handler registerAnimation:expand toLayer:hud.layer forKey:EEHUD_KEY_SHOW_PROGRESS];
            
        }else {
            // YES -> NO
            
            // alpha
            CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
            alpha.fromValue = [NSNumber numberWithFloat:1.0];
            alpha.toValue = [NSNumber numberWithFloat:0.0];
            alpha.fillMode = kCAFillModeForwards;
            alpha.removedOnCompletion = NO;
            alpha.duration = EEHUD_DURATION_FADEOUT_PROGRESS;
            alpha.stopHandlerBlock = ^(CAAnimation *anim, BOOL finished){
                
                CALayer *layer = anim.addedLayer;
                CALayer *pLayer = layer.presentationLayer;
                
                layer.opacity = pLayer.opacity;
                [layer removeAnimationForKey:anim.animationKey];
                
                // 
                CGSize toSize = hud.bounds.size;
                toSize.height = EEHUD_VIEW_HEIGHT;
                
                CGSize fromSize = hud.bounds.size;
                fromSize.height = EEHUD_VIEW_HEIGHT + EEHUD_VIEW_HEIGHT_PROGRESS + 2.0*EEHUD_VIEW_MARGIN_VERTICAL_PROGRESS;
                
                CABasicAnimation *reduction = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
                reduction.fromValue = [NSValue valueWithCGSize:fromSize];
                reduction.toValue = [NSValue valueWithCGSize:toSize];
                reduction.removedOnCompletion = NO;
                reduction.fillMode = kCAFillModeForwards;
                reduction.duration = EEHUD_DURATION_HIDE_PROGRESS_RANGE;
                reduction.stopHandlerBlock = ^(CAAnimation *anim, BOOL finished){
                    
                    CALayer *layer = anim.addedLayer;
                    CALayer *pLayer = layer.presentationLayer;
                    layer.bounds = pLayer.bounds;
                    
                    [layer removeAnimationForKey:anim.animationKey];
                    
                    // 代入
                    _isShowProgress = isShowProgress;
                };
                
                EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
                [handler registerAnimation:reduction toLayer:hud.layer forKey:EEHUD_KEY_HIDE_PROGRESS];
            };
            
            EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
            [handler registerAnimation:alpha toLayer:progressView.layer forKey:@"out_progress"];
        }
    }
}

@end

#pragma mark - Constant
typedef enum EEHUDViewState_{
    EEHUDViewStateTransparent = 0,          // 非表示時
    EEHUDViewStateAnimatingIn = 1,          // 表示時のアニメーション中
    EEHUDViewStateAppeal = 2,               // 表示中
    EEHUDViewStateCalledHideAnimation = 3,  // タイマー発動してhideAnimation:が呼ばれたとこ
    EEHUDViewStateAnimatingOut = 4          // 表示終わって消す為のアニメーション中
}EEHUDViewState;

#pragma mark - ** EEHUDView **
@interface EEHUDView ()
{
    EEHUDViewController *viewController_;
    
    NSTimer *appealTimer_;
    NSTimer *_appealTimerInProgress;
    
    CGFloat time_;
    
    NSString *_progressMessage;
}

@property (nonatomic) EEHUDViewShowStyle showStyle;
@property (nonatomic) EEHUDViewHideStyle hideStyle;
@property (nonatomic) EEHUDResultViewStyle resultViewStyle;
@property (nonatomic) EEHUDActivityViewStyle activityViewStyle;
@property (nonatomic) EEHUDViewState state;

@property (nonatomic, weak) UIWindow *previousKeyWindow;
@property (nonatomic, strong) EEHUDViewController *viewController;
@property (nonatomic, strong) NSTimer *appealTimer;
@property (nonatomic, strong) NSTimer *appealTimerInProgress;
@property (nonatomic) CGFloat time;
@property (nonatomic, strong) NSString *progressMessage;

- (id)myInitWithFrame:(CGRect)frame;
+ (id)sharedView;
- (void)growlWithMessage:(NSString *)message
               showStyle:(EEHUDViewShowStyle)showStyle
               hideStyle:(EEHUDViewHideStyle)hideStyle
         resultViewStyle:(EEHUDResultViewStyle)resultViewStyle
                showTime:(float)time;
- (void)showProgressWithMessage:(NSString *)message
                      showStyle:(EEHUDViewShowStyle)showStyle
              activityViewStyle:(EEHUDActivityViewStyle)activityStyle;
- (void)hideProgressWithMessage:(NSString *)message
                      hideStyle:(EEHUDViewHideStyle)hideStyle
                resultViewStyle:(EEHUDResultViewStyle)resultViewStyle
                       showTime:(float)time;
- (void)updateProgress:(float)progress;

// show
- (void)showAnimation;

- (void)fadeInAnimation;
- (void)lutzInAnimation;
- (void)shakeInAnimation;
- (void)noAnimeInAnimation;
- (void)fromRightAnimation;
- (void)fromLeftAnimation;
- (void)fromTopAnimation;
- (void)fromBottomAnimation;
- (void)fromZAxisNegativeStrong:(BOOL)isStrong;

/******************************************/

// hide
- (void)hideAnimation:(NSTimer *)timer;

- (void)fadeOutAnimation;
- (void)lutzOutAnimation;
- (void)shakeOutAnimation;
- (void)noAnimeOutAnimation;
- (void)toRightAnimation;
- (void)toLeftAnimation;
- (void)toTopAnimation;
- (void)toBottomAnimation;
- (void)crushOutAnimation;
- (void)toZAxisNegativeStrong:(BOOL)isStrong;
/******************************************/

- (void)cleaning;
- (void)makeTimer;

- (EEAnimationDidStartHandlerBlock)startHandlerBlock;
- (EEAnimationDidStopHandlerBlock)stopHandlerBlock;

- (void)appealEndInProgress:(NSTimer *)timer;

@end

#pragma mark - Implementation
@implementation EEHUDView

@synthesize showStyle;
@synthesize hideStyle;
@synthesize resultViewStyle;
@synthesize state;
@synthesize activityViewStyle;

@synthesize previousKeyWindow;
@synthesize viewController = viewController_;
@synthesize appealTimer = appealTimer_;
@synthesize appealTimerInProgress = _appealTimerInProgress;
@synthesize time = time_;
@synthesize progressMessage = _progressMessage;

static EEHUDView *sharedInstance_ = nil;

+ (id)sharedView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance_) {
            sharedInstance_ = [[self alloc] myInitWithFrame:[[UIScreen mainScreen] bounds]];
        }
    });
    
    return sharedInstance_;
}

#pragma mark - Initializer
- (id)initWithFrame:(CGRect)frame 
{	
    return nil;
}

- (id)init
{
    return nil;
}

- (id)myInitWithFrame:(CGRect)frame
{
    EEHUDView *object = [super initWithFrame:frame];
    if (object) {
		object.userInteractionEnabled = NO;
        object.backgroundColor = [UIColor clearColor];
        object.state = EEHUDViewStateTransparent;
    }
	
    return object;
}

#pragma mark - Common
+ (void)growlWithMessage:(NSString *)message
               showStyle:(EEHUDViewShowStyle)showStyle
               hideStyle:(EEHUDViewHideStyle)hideStyle
         resultViewStyle:(EEHUDResultViewStyle)resultViewStyle
                showTime:(float)time
{
    [[EEHUDView sharedView] growlWithMessage:message
                                   showStyle:showStyle
                                   hideStyle:hideStyle
                             resultViewStyle:resultViewStyle
                                    showTime:time];
}

+ (void)showProgressWithMessage:(NSString *)message
                      showStyle:(EEHUDViewShowStyle)showStyle
              activityViewStyle:(EEHUDActivityViewStyle)activityStyle
{
    [[EEHUDView sharedView] showProgressWithMessage:message
                                          showStyle:showStyle
                                  activityViewStyle:activityStyle];
}

+ (void)hideProgressWithMessage:(NSString *)message
                      hideStyle:(EEHUDViewHideStyle)hideStyle
                resultViewStyle:(EEHUDResultViewStyle)resultViewStyle
                       showTime:(float)time
{
    [[EEHUDView sharedView] hideProgressWithMessage:message
                                          hideStyle:hideStyle
                                    resultViewStyle:resultViewStyle
                                           showTime:time];
}

+ (void)updateProgress:(float)progress
{
    [[EEHUDView sharedView] updateProgress:progress];
}

+ (BOOL)isShowing
{
    BOOL is = NO;
    
    EEHUDView *hud = [EEHUDView sharedView];
    if (hud.previousKeyWindow) {
        is = YES;
    }
    
    return is;
}

+ (NSString *)message
{
    EEHUDView *hud = [EEHUDView sharedView];
    NSString *currentMessage = hud.viewController.message.text;
    if (currentMessage) {
        return currentMessage;
    }else {
        return @"";
    }
}

#pragma mark - Private
- (void)growlWithMessage:(NSString *)aMessage
               showStyle:(EEHUDViewShowStyle)aShowStyle
               hideStyle:(EEHUDViewHideStyle)aHideStyle
         resultViewStyle:(EEHUDResultViewStyle)aResultViewStyle
                showTime:(float)aTime
{
    //LOG(@" --------- (show growl) state:%d ---------", self.state);
    
    if (!self.viewController) {
        self.viewController = [[EEHUDViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    if (!self.viewController.view.superview) {
        self.rootViewController = viewController_;
    }
    
    /* show */
    if(![self isKeyWindow]) {
        
        [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIWindow *window = (UIWindow*)obj;
            if(window.windowLevel == UIWindowLevelNormal && ![[window class] isEqual:[EEHUDView class]]) {
                self.previousKeyWindow = window;
                *stop = YES;
            }
        }];
        
        [self makeKeyAndVisible];
    }
    
    if (self.viewController.isShowProgress) {
        
        /******************************
         
         hideProgressはタイマー時間を FLT_MAXから有限時間に帰るだけ -> EEHUDViewStateApealのまま (ただしisShowProgress=NOにして先消してるはず)
         
         ●EEHUDViewStateTransparent = 0,          // 非表示時 -> 無い
         ●EEHUDViewStateAnimatingIn = 1,          // 表示時のアニメーション中 -> 無い
         
         ●EEHUDViewStateAppeal = 2,               // 表示中 (hideのtimeがprogress隠すアニメーションより遅ければ progress フェードアウト中もここ)
         アニメーションせず内容を差し替え
         タイマー(appealTimerInProgress)無ければ発動
         あれば時間差し替え
         
         ●EEHUDViewStateCalledHideAnimation = 3,  // タイマー発動してhideAnimation:が呼ばれたとこ
         もうすぐ自動的に消す為のアニメーション開始する
         そんなに時間無いはずなので何もしない
         
         ●EEHUDViewStateAnimatingOut = 4,         // 表示終わって消す為のアニメーション中 
                                                     (hideのtimeがprogress隠すアニメーションより短ければ progressフェードアウトはここ)
         今動いてるアニメーションを削除
         表示アニメーションからスタート
         
         ******************************/
        
        switch (self.state) {
            case EEHUDViewStateAppeal:
                
                self.viewController.message.text = aMessage;
                self.viewController.resultView.viewStyle = aResultViewStyle;
                
                if (!self.appealTimerInProgress) {
                    self.appealTimerInProgress = [NSTimer scheduledTimerWithTimeInterval:aTime
                                                                                  target:self
                                                                                selector:@selector(appealEndInProgress:)
                                                                                userInfo:nil
                                                                                 repeats:NO];
                }else {
                    [self.appealTimerInProgress setFireDate:[NSDate dateWithTimeIntervalSinceNow:aTime]];
                }
                
                break;
            case EEHUDViewStateCalledHideAnimation:
                
                break;
            case EEHUDViewStateAnimatingOut:
                
                self.viewController.message.text = aMessage;
                self.viewController.resultView.viewStyle = aResultViewStyle;
                
                self.showStyle = aShowStyle;
                self.hideStyle = aHideStyle;
                
                self.time = aTime;
                
                // 状態変更
                self.state = EEHUDViewStateAnimatingIn;
                
                // アニメーションスタート
                for (NSString *key in [self.viewController.hudView.layer animationKeys]) {
                    if (![key isEqualToString:EEHUD_KEY_SHOW_PROGRESS] && ![key isEqualToString:EEHUD_KEY_HIDE_PROGRESS]) {
                        [self.viewController.hudView.layer removeAnimationForKey:key];
                    }
                }
                [self showAnimation];
                
                break;
            default:
                break;
        }
        
    }else {
        
        /******************************
         ●EEHUDViewStateTransparent = 0,          // 非表示時
         アニメーションスタート(特に問題無し)
         
         ●EEHUDViewStateAnimatingIn = 1,          // 表示時のアニメーション中
         表示開始した時に呼ばれた場合はアニメーションはそのまま
         内容とアピール時間を差し替え
         
         ●EEHUDViewStateAppeal = 2,               // 表示中
         アニメーションせず内容とアピール時間を差し替え
         タイマー既に発動してるのでタイマーのリフレッシュが必要
         
         ●EEHUDViewStateCalledHideAnimation = 3,  // タイマー発動してhideAnimation:が呼ばれたとこ
         もうすぐ自動的に消す為のアニメーション開始する
         そんなに時間無いはずなので何もしない
         
         ●EEHUDViewStateAnimatingOut = 4          // 表示終わって消す為のアニメーション中
         今動いてるアニメーションを削除
         表示アニメーションからスタート
         ******************************/
        switch (self.state) {
            case EEHUDViewStateTransparent:
                
                // 状態変更
                self.state = EEHUDViewStateAnimatingIn;
                
                // 代入
                self.viewController.message.text = aMessage;
                self.viewController.resultView.viewStyle = aResultViewStyle;
                
                self.showStyle = aShowStyle;
                self.hideStyle = aHideStyle;
                
                self.time = aTime;
                
                // アニメーションスタート
                [self showAnimation];
                
                break;
            case EEHUDViewStateAnimatingIn:
                
                self.viewController.message.text = aMessage;
                self.viewController.resultView.viewStyle = aResultViewStyle;
                
                self.showStyle = aShowStyle;
                self.hideStyle = aHideStyle;
                
                break;
                
            case EEHUDViewStateAppeal:
                
                self.viewController.message.text = aMessage;
                self.viewController.resultView.viewStyle = aResultViewStyle;
                
                self.hideStyle = aHideStyle;
                
                // タイマーリフレッシュ
                [self.appealTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:aTime]];
                
                break;
            case EEHUDViewStateCalledHideAnimation:
                
                break;
            case EEHUDViewStateAnimatingOut:
                
                self.viewController.message.text = aMessage;
                self.viewController.resultView.viewStyle = aResultViewStyle;
                
                self.showStyle = aShowStyle;
                self.hideStyle = aHideStyle;
                
                self.time = aTime;
                
                // 状態変更
                self.state = EEHUDViewStateAnimatingIn;
                
                // アニメーションスタート
                for (NSString *key in [self.viewController.hudView.layer animationKeys]) {
                    if (![key isEqualToString:EEHUD_KEY_SHOW_PROGRESS] && ![key isEqualToString:EEHUD_KEY_HIDE_PROGRESS]) {
                        [self.viewController.hudView.layer removeAnimationForKey:key];
                    }
                }
                [self showAnimation];
                
                break;
            default:
                break;
        }
    }
    
}

- (void)showProgressWithMessage:(NSString *)aMessage
                      showStyle:(EEHUDViewShowStyle)aShowStyle
              activityViewStyle:(EEHUDActivityViewStyle)anActivityStyle
{
    //LOG(@" --------- (show progress) state:%d ---------", self.state);
    
    if (!self.viewController) {
        self.viewController = [[EEHUDViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    if (!self.viewController.view.superview) {
        self.rootViewController = viewController_;
    }
    
    /* show */
    if(![self isKeyWindow]) {
        
        [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIWindow *window = (UIWindow*)obj;
            if(window.windowLevel == UIWindowLevelNormal && ![[window class] isEqual:[EEHUDView class]]) {
                self.previousKeyWindow = window;
                *stop = YES;
            }
        }];
        
        [self makeKeyAndVisible];
    }
    
    
    
    if (!self.viewController.isShowProgress) {
        
        /******************************
         状態によって処理変える。
         ●EEHUDViewStateTransparent = 0,          // 非表示時
         アニメーションスタート(特に問題無し)
         アピール時間はFLT_MAXに
         
         ●EEHUDViewStateAnimatingIn = 1,          // 表示時のアニメーション中
         表示アニメーション中なのでそれはそのまま
         handlerにそのまま突っ込めば終わり次第アニメーションしてくれるはず
         アピール時間はFLT_MAXに
         
         ●EEHUDViewStateAppeal = 2,               // 表示中
         内容とアピール時間を差し替え
         そのまま拡張アニメスタート
         タイマー既に発動してるのでタイマーのリフレッシュが必要 (アピール時間はFLT_MAXに)
         
         ●EEHUDViewStateCalledHideAnimation = 3,  // タイマー発動してhideAnimation:が呼ばれたとこ
         もうすぐ自動的に消す為のアニメーション開始する
         そんなに時間無いはずなのでdelayかけてアニメーション削除し、再スタート
         アピール時間はFLT_MAXに
         
         ●EEHUDViewStateAnimatingOut = 4          // 表示終わって消す為のアニメーション中
         今動いてるアニメーションを削除
         表示アニメーションからスタート
         アピール時間はFLT_MAXに
         ******************************/
        switch (self.state) {
            case EEHUDViewStateTransparent:
                
                // 状態変更
                self.state = EEHUDViewStateAnimatingIn;
                
                self.progressMessage = aMessage;
                self.viewController.message.text = aMessage;
                self.viewController.progressView.progress = 0.0;
                self.showStyle = aShowStyle;
                self.time = FLT_MAX;
                
                [self showAnimation];
                self.viewController.resultView.activityStyle = anActivityStyle;
                
                break;
                
            case EEHUDViewStateAnimatingIn:
                
                self.progressMessage = aMessage;
                self.viewController.message.text = aMessage;
                self.viewController.progressView.progress = 0.0;
                self.time = FLT_MAX;
                
                self.viewController.resultView.activityStyle = anActivityStyle;
                
                break;
                
            case EEHUDViewStateAppeal:
                
                self.progressMessage = aMessage;
                self.viewController.message.text = aMessage;
                self.viewController.progressView.progress = 0.0;
                
                [self.appealTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:FLT_MAX]];
                
                self.viewController.resultView.activityStyle = anActivityStyle;
                
                break;
                
            case EEHUDViewStateAnimatingOut:
                
                self.progressMessage = aMessage;
                self.viewController.message.text = aMessage;
                self.viewController.progressView.progress = 0.0;
                self.showStyle = aShowStyle;
                self.time = FLT_MAX;
                
                // 状態変更
                self.state = EEHUDViewStateAnimatingIn;
                
                // アニメーションスタート
                for (NSString *key in [self.viewController.hudView.layer animationKeys]) {
                    [self.viewController.hudView.layer removeAnimationForKey:key];
                }
                [self showAnimation];
                
                self.viewController.resultView.activityStyle = anActivityStyle;
                
                break;
            default:
                break;
        }
        
        // 状態変更
        self.viewController.isShowProgress = YES;
    }
    
}

- (void)hideProgressWithMessage:(NSString *)message
                      hideStyle:(EEHUDViewHideStyle)aHideStyle
                resultViewStyle:(EEHUDResultViewStyle)aResultViewStyle
                       showTime:(float)time
{
    //LOG(@" --------- (hide progress) state:%d ---------", self.state);
    
    if (self.viewController.isShowProgress) {
        
        /************
         Appeal中のはず (progress表示中でもgrowlに切り替えた状態でも)
         ************/
        switch (self.state) {
            case EEHUDViewStateAppeal:
                
                // タイマーあるなら消去しとく
                if (self.appealTimerInProgress) {
                    [self.appealTimerInProgress invalidate];
                    self.appealTimerInProgress = nil;
                }
                
                self.viewController.isShowProgress = NO;
                
                // タイマーリフレッシュ
                [self.appealTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
                
                self.progressMessage = nil;
                
                self.viewController.message.text = message;
                self.viewController.resultView.viewStyle = aResultViewStyle;
                
                self.hideStyle = aHideStyle;
                
                break;
                
            default:
                break;
        }
    }
    
}

- (void)updateProgress:(float)aProgress
{
    float progress = 0.0;
    if (aProgress > 1.0) {
        progress = 1.0;
    }else if (aProgress < 0.0) {
        progress = 0.0;
    }else {
        progress = aProgress;
    }
    
    self.viewController.progressView.progress = progress;
}

#pragma mark - Private
#pragma mark ** show **
- (void)showAnimation
{    
    switch (self.showStyle) {
        case EEHUDViewShowStyleFadeIn:
            
            [self fadeInAnimation];
            break;
            
        case EEHUDViewShowStyleLutz:
            
            [self lutzInAnimation];
            break;
        
        case EEHUDViewShowStyleShake:
            
            [self shakeInAnimation];
            break;
            
        case EEHUDViewShowStyleFromLeft:
            
            [self fromLeftAnimation];
            break;
            
        case EEHUDViewShowStyleFromRight:
            
            [self fromRightAnimation];
            break;
            
        case EEHUDViewShowStyleNoAnime:
            
            [self noAnimeInAnimation];
            break;
            
        case EEHUDViewShowStyleFromTop:
            
            [self fromTopAnimation];
            break;
            
        case EEHUDViewShowStyleFromBottom:
            
            [self fromBottomAnimation];
            break;
        
        case EEHUDViewShowStyleFromZAxisNegative:
            
            [self fromZAxisNegativeStrong:NO];
            break;
            
        case EEHUDViewShowStyleFromZAxisNegativeStrong:
            
            [self fromZAxisNegativeStrong:YES];
            break;
        
        default:
            break;
    }
}

- (void)fadeInAnimation
{
    CGFloat fromAlpha = 0.0;
    CGFloat toAlpha = 1.0;
    
    CGRect fromRect = self.viewController.hudView.frame;
    fromRect.size.width *= EEHUD_SIZERATIO_FADEIN;
    fromRect.size.height *= EEHUD_SIZERATIO_FADEIN;
    
    CGRect toRect = self.viewController.hudView.frame;
    
    CGFloat duration = EEHUD_DURATION_FADEIN;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 拡大
    CABasicAnimation *expandAnime;
    expandAnime = [CABasicAnimation animationWithKeyPath:@"bounds"];
    expandAnime.fromValue = [NSValue valueWithCGRect:fromRect];
    expandAnime.toValue = [NSValue valueWithCGRect:toRect];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, expandAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"fadein"];
}

- (void)lutzInAnimation
{
    CGFloat fromAlpha = 0.0;
    CGFloat toAlpha = 1.0;
    
    CGFloat duration = EEHUD_DURATION_LUTZIN;
    
    CGRect fromRect = self.viewController.hudView.bounds;
    fromRect.size.width *= EEHUD_SIZERATIO_LUTZIN;
    fromRect.size.height *= EEHUD_SIZERATIO_LUTZIN;
    
    CGRect toRect = self.viewController.hudView.bounds;
    
    //
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point2.y -= EEHUD_HEIGHT_JUMP_LUTZIN;
    
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    alphaAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    alphaAnime.removedOnCompletion = NO;
    alphaAnime.fillMode = kCAFillModeForwards;
    alphaAnime.duration = duration * 0.5;
    alphaAnime.beginTime = 0.0;
    
    // 拡大
    CABasicAnimation *expandAnime;
    expandAnime = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    expandAnime.fromValue = [NSValue valueWithCGSize:fromRect.size];
    expandAnime.toValue = [NSValue valueWithCGSize:toRect.size];
    expandAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    expandAnime.removedOnCompletion = NO;
    expandAnime.fillMode = kCAFillModeForwards;
    expandAnime.duration = duration * 0.5;
    expandAnime.beginTime = 0.0;
    
    // jumpUP
    CABasicAnimation *jumpUpAnime;
    jumpUpAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    jumpUpAnime.fromValue = [NSValue valueWithCGPoint:point1];
    jumpUpAnime.toValue = [NSValue valueWithCGPoint:point2];
    jumpUpAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    jumpUpAnime.duration = duration * 0.5;
    jumpUpAnime.beginTime = 0.0;
    
    // jumpDown
    CABasicAnimation *jumpDownAnime;
    jumpDownAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    jumpDownAnime.fromValue = [NSValue valueWithCGPoint:point2];
    jumpDownAnime.toValue = [NSValue valueWithCGPoint:point1];
    jumpDownAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    jumpDownAnime.duration = duration * 0.5;
    jumpDownAnime.beginTime = duration * 0.5;
    
    // 回転
    CABasicAnimation *rotateAnime;
    rotateAnime = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotateAnime.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotateAnime.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f)];
    rotateAnime.repeatCount = EEHUD_COUNT_ROTATION_LUTZIN;
    rotateAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotateAnime.duration = duration / (float)EEHUD_COUNT_ROTATION_LUTZIN;
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:
                                    alphaAnime,
                                    expandAnime,
                                    jumpUpAnime,
                                    jumpDownAnime,
                                    rotateAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    //allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"lutzin"];
}

- (void)shakeInAnimation
{
    CGFloat fromAlpha = 0.0;
    CGFloat toAlpha = 1.0;
    
    CGFloat duration = EEHUD_DURATION_SHAKEIN;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    alphaAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnime.removedOnCompletion = NO;
    alphaAnime.fillMode = kCAFillModeForwards;
    alphaAnime.duration = duration * 0.5;
    alphaAnime.beginTime = 0.0;
    
    // シェイク
    CAKeyframeAnimation *shakeAnime;
    shakeAnime = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CGFloat shakeTheta = 0.5 * EEHUD_THETA_DEGREE_SHAKEIN * M_PI / 180.0;
    NSMutableArray *transforms = [NSMutableArray array];
    NSMutableArray *timingFunctions = [NSMutableArray array];
    NSMutableArray *durations = [NSMutableArray array];
    
    for (int i = 0; i < EEHUD_COUNT_SHAKEIN; i++) {
        
        /* transform */
        if (i == 0) {
            [transforms addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f)]];
            [durations addObject:[NSNumber numberWithFloat:0.0]];
            
        }else if (i == EEHUD_COUNT_SHAKEIN - 1){
            [transforms addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f)]];
            [durations addObject:[NSNumber numberWithFloat:(i - 0.5)/((CGFloat)EEHUD_COUNT_SHAKEIN - 1.0)]];
            
        }else if (i % 2 == 0){
            [transforms addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(shakeTheta, 0.0f, 0.0f, 1.0f)]];
            [durations addObject:[NSNumber numberWithFloat:(i - 0.5)/((CGFloat)EEHUD_COUNT_SHAKEIN - 1.0)]];
            
        }else {
            [transforms addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(- shakeTheta, 0.0f, 0.0f, 1.0f)]];
            [durations addObject:[NSNumber numberWithFloat:(i - 0.5)/((CGFloat)EEHUD_COUNT_SHAKEIN - 1.0)]];
            
        }
        
        /* timingFunction */
        if (i == 0) {
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
        }else {
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        }
    }
    
    shakeAnime.values = transforms;
    shakeAnime.timingFunctions = timingFunctions;
    shakeAnime.keyTimes = durations;
    shakeAnime.duration = duration;
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, shakeAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    //allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"shakein"];
}

- (void)noAnimeInAnimation
{
    CGFloat fromAlpha = 0.0;
    CGFloat toAlpha = 1.0;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    alphaAnime.removedOnCompletion = NO;
    alphaAnime.fillMode = kCAFillModeForwards;
    alphaAnime.duration = EEHUD_DURATION_NOANIME;
    //alphaAnime.startHandlerBlock = [self startHandlerBlock];
    alphaAnime.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:alphaAnime toLayer:self.viewController.hudView.layer forKey:@"noanimein"];
}

- (void)fromRightAnimation
{
    CGFloat fromAlpha = 0.0;
    CGFloat toAlpha = 1.0;
    
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point1.x += EEHUD_LENGTH_FROM_RIGHT;
    
    CGFloat duration = EEHUD_DURATION_FROM_RIGHT;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 移動
    CABasicAnimation *moveAnime;
    moveAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnime.fromValue = [NSValue valueWithCGPoint:point1];
    moveAnime.toValue = [NSValue valueWithCGPoint:point2];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, moveAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"fromRight"];
}

- (void)fromLeftAnimation
{
    CGFloat fromAlpha = 0.0;
    CGFloat toAlpha = 1.0;
    
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point1.x -= EEHUD_LENGTH_FROM_LEFT;
    
    CGFloat duration = EEHUD_DURATION_FROM_LEFT;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 移動
    CABasicAnimation *moveAnime;
    moveAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnime.fromValue = [NSValue valueWithCGPoint:point1];
    moveAnime.toValue = [NSValue valueWithCGPoint:point2];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, moveAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"fromLeft"];
}

- (void)fromTopAnimation
{
    CGFloat fromAlpha = 0.0;
    CGFloat toAlpha = 1.0;
    
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point1.y -= EEHUD_LENGTH_FROM_TOP;
    
    CGFloat duration = EEHUD_DURATION_FROM_TOP;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 移動
    CABasicAnimation *moveAnime;
    moveAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnime.fromValue = [NSValue valueWithCGPoint:point1];
    moveAnime.toValue = [NSValue valueWithCGPoint:point2];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, moveAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"fromTop"];
}

- (void)fromBottomAnimation
{
    CGFloat fromAlpha = 0.0;
    CGFloat toAlpha = 1.0;
    
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point1.y += EEHUD_LENGTH_FROM_BOTTOM;
    
    CGFloat duration = EEHUD_DURATION_FROM_BOTTOM;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 移動
    CABasicAnimation *moveAnime;
    moveAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnime.fromValue = [NSValue valueWithCGPoint:point1];
    moveAnime.toValue = [NSValue valueWithCGPoint:point2];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, moveAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"fromBottom"];
}

- (void)fromZAxisNegativeStrong:(BOOL)isStrong;
{
    __weak EEHUDView *me = self;
    
    CATransform3D transform = self.viewController.view.layer.sublayerTransform;
    
    transform.m34 = EEHUD_ZPOSITION_TRANSFORM_M34;
    self.viewController.view.layer.sublayerTransform = transform;
    
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = [NSNumber numberWithFloat:0.0];
    alpha.toValue = [NSNumber numberWithFloat:1.0];
    
    CGFloat from = EEHUD_ZPOSITION_FROM;
    if (isStrong) {
        from = EEHUD_ZPOSITION_FROM_STRONG;
    }
    
    CABasicAnimation *zPosition = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    zPosition.fromValue = [NSNumber numberWithFloat:from];
    zPosition.toValue = [NSNumber numberWithFloat:EEHUD_ZPOSITION_TO];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:alpha, zPosition, nil];
    //group.removedOnCompletion = NO;
    //group.fillMode = kCAFillModeForwards;
    group.duration = EEHUD_DURATION_ZPOSITION_IN;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    group.stopHandlerBlock = ^(CAAnimation *anim, BOOL finished){
        
        CATransform3D transform = me.viewController.view.layer.sublayerTransform;
        transform.m34 = 0.0;
        me.viewController.view.layer.sublayerTransform = transform;
        
    };
    
    //
    CABasicAnimation *kari = [CABasicAnimation animationWithKeyPath:@"opacity"];
    kari.fromValue = [NSNumber numberWithFloat:1.0];
    kari.toValue = [NSNumber numberWithFloat:1.0];
    kari.duration = 0.01;
    kari.stopHandlerBlock = [self stopHandlerBlock];
    
    CALayer *layer = self.viewController.hudView.layer;
    
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:group toLayer:layer forKey:@"zPositionIn"];
    [handler registerAnimation:kari toLayer:layer forKey:@"kariIn"];
}

#pragma mark ** hide **
- (void)hideAnimation:(NSTimer *)timer;
{
    // 状態更新
    self.state = EEHUDViewStateCalledHideAnimation;
    
    switch (self.hideStyle) {
        case EEHUDViewHideStyleFadeOut:
            
            [self fadeOutAnimation];
            break;
            
        case EEHUDViewHideStyleLutz:
            
            [self lutzOutAnimation];
            break;
            
        case EEHUDViewHideStyleShake:
            
            [self shakeOutAnimation];
            break;
            
        case EEHUDViewHideStyleToRight:
            
            [self toRightAnimation];
            break;
            
        case EEHUDViewHideStyleToLeft:
            
            [self toLeftAnimation];
            break;
            
        case EEHUDViewHideStyleNoAnime:
            
            [self noAnimeOutAnimation];
            break;
            
        case EEHUDViewHideStyleToBottom:
            
            [self toBottomAnimation];
            break;
            
        case EEHUDViewHideStyleToTop:
            
            [self toTopAnimation];
            break;
            
        case EEHUDViewHideStyleCrush:
            
            [self crushOutAnimation];
            break;
            
        case EEHUDViewHideStyleToZAxisNegative:
            
            [self toZAxisNegativeStrong:NO];
            break;
            
        case EEHUDViewHideStyleToZAxisNegativeStrong:
            
            [self toZAxisNegativeStrong:YES];
            break;
            
        default:
            break;
    }
}

- (void)fadeOutAnimation
{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0.0;
    
    CGRect fromRect = self.viewController.hudView.frame;
    CGRect toRect = self.viewController.hudView.frame;
    toRect.size.width *= EEHUD_SIZERATIO_FADEOUT;
    toRect.size.height *= EEHUD_SIZERATIO_FADEOUT;
    
    CGFloat duration = EEHUD_DURATION_FADEOUT;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 拡大
    CABasicAnimation *expandAnime;
    expandAnime = [CABasicAnimation animationWithKeyPath:@"bounds"];
    expandAnime.fromValue = [NSValue valueWithCGRect:fromRect];
    expandAnime.toValue = [NSValue valueWithCGRect:toRect];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, expandAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"fadeOut"];
}

- (void)lutzOutAnimation
{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0.0;
    
    CGFloat duration = EEHUD_DURATION_LUTZOUT;
    
    CGRect fromRect = self.viewController.hudView.bounds;
    
    CGRect toRect = self.viewController.hudView.bounds;
    toRect.size.width *= EEHUD_SIZERATIO_LUTZOUT;
    toRect.size.height *= EEHUD_SIZERATIO_LUTZOUT;
    
    //
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point2.y -= EEHUD_HEIGHT_JUMP_LUTZOUT;
    
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    alphaAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    alphaAnime.removedOnCompletion = NO;
    alphaAnime.fillMode = kCAFillModeForwards;
    alphaAnime.duration = duration * 0.5;
    alphaAnime.beginTime = duration * 0.5;
    
    // 拡大
    CABasicAnimation *expandAnime;
    expandAnime = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    expandAnime.fromValue = [NSValue valueWithCGSize:fromRect.size];
    expandAnime.toValue = [NSValue valueWithCGSize:toRect.size];
    expandAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    expandAnime.removedOnCompletion = NO;
    expandAnime.fillMode = kCAFillModeForwards;
    expandAnime.duration = duration * 0.5;
    expandAnime.beginTime = 0.0;
    
    // jumpUP
    CABasicAnimation *jumpUpAnime;
    jumpUpAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    jumpUpAnime.fromValue = [NSValue valueWithCGPoint:point1];
    jumpUpAnime.toValue = [NSValue valueWithCGPoint:point2];
    jumpUpAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    jumpUpAnime.duration = duration * 0.5;
    jumpUpAnime.beginTime = 0.0;
    
    // jumpDown
    CABasicAnimation *jumpDownAnime;
    jumpDownAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    jumpDownAnime.fromValue = [NSValue valueWithCGPoint:point2];
    jumpDownAnime.toValue = [NSValue valueWithCGPoint:point1];
    jumpDownAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    jumpDownAnime.duration = duration * 0.5;
    jumpDownAnime.beginTime = duration * 0.5;
    
    // 回転
    CABasicAnimation *rotateAnime;
    rotateAnime = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotateAnime.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotateAnime.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f)];
    rotateAnime.repeatCount = EEHUD_COUNT_ROTATION_LUTZOUT;
    rotateAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotateAnime.duration = duration / (float)EEHUD_COUNT_ROTATION_LUTZOUT;
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:
                                    alphaAnime,
                                    expandAnime,
                                    jumpUpAnime,
                                    jumpDownAnime,
                                    rotateAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"lutzOut"];
}

- (void)shakeOutAnimation
{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0.0;
    
    CGFloat duration = EEHUD_DURATION_SHAKEIN;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    alphaAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnime.removedOnCompletion = NO;
    alphaAnime.fillMode = kCAFillModeForwards;
    alphaAnime.duration = duration * 0.7;
    alphaAnime.beginTime = 0.3 * duration;
    
    // シェイク
    CAKeyframeAnimation *shakeAnime;
    shakeAnime = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CGFloat shakeTheta = 0.5 * EEHUD_THETA_DEGREE_SHAKEIN * M_PI / 180.0;
    NSMutableArray *transforms = [NSMutableArray array];
    NSMutableArray *timingFunctions = [NSMutableArray array];
    NSMutableArray *durations = [NSMutableArray array];
    
    for (int i = 0; i < EEHUD_COUNT_SHAKEIN; i++) {
        
        /* transform */
        if (i == 0) {
            [transforms addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f)]];
            [durations addObject:[NSNumber numberWithFloat:0.0]];
            
        }else if (i == EEHUD_COUNT_SHAKEIN - 1){
            [transforms addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f)]];
            [durations addObject:[NSNumber numberWithFloat:(i - 0.5)/((CGFloat)EEHUD_COUNT_SHAKEIN - 1.0)]];
            
        }else if (i % 2 == 0){
            [transforms addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(shakeTheta, 0.0f, 0.0f, 1.0f)]];
            [durations addObject:[NSNumber numberWithFloat:(i - 0.5)/((CGFloat)EEHUD_COUNT_SHAKEIN - 1.0)]];
            
        }else {
            [transforms addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(- shakeTheta, 0.0f, 0.0f, 1.0f)]];
            [durations addObject:[NSNumber numberWithFloat:(i - 0.5)/((CGFloat)EEHUD_COUNT_SHAKEIN - 1.0)]];
            
        }
        
        /* timingFunction */
        if (i == 0) {
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
        }else {
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        }
    }
    
    shakeAnime.values = transforms;
    shakeAnime.timingFunctions = timingFunctions;
    shakeAnime.keyTimes = durations;
    shakeAnime.duration = duration;
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, shakeAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"shakeOut"];
}

- (void)noAnimeOutAnimation
{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0.0;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    alphaAnime.removedOnCompletion = NO;
    alphaAnime.fillMode = kCAFillModeForwards;
    alphaAnime.duration = EEHUD_DURATION_NOANIME;
    alphaAnime.startHandlerBlock = [self startHandlerBlock];
    alphaAnime.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:alphaAnime toLayer:self.viewController.hudView.layer forKey:@"noAnimeOut"];
    
}

- (void)toRightAnimation
{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0.0;
    
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point2.x += EEHUD_LENGTH_TO_RIGHT;
    
    CGFloat duration = EEHUD_DURATION_TO_RIGHT;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 移動
    CABasicAnimation *moveAnime;
    moveAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnime.fromValue = [NSValue valueWithCGPoint:point1];
    moveAnime.toValue = [NSValue valueWithCGPoint:point2];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, moveAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"toRight"];
}

- (void)toLeftAnimation
{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0.0;
    
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point2.x -= EEHUD_LENGTH_TO_LEFT;
    
    CGFloat duration = EEHUD_DURATION_TO_LEFT;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 移動
    CABasicAnimation *moveAnime;
    moveAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnime.fromValue = [NSValue valueWithCGPoint:point1];
    moveAnime.toValue = [NSValue valueWithCGPoint:point2];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, moveAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"toLeft"];
}

- (void)toTopAnimation
{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0.0;
    
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point2.y -= EEHUD_LENGTH_TO_TOP;
    
    CGFloat duration = EEHUD_DURATION_TO_TOP;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 移動
    CABasicAnimation *moveAnime;
    moveAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnime.fromValue = [NSValue valueWithCGPoint:point1];
    moveAnime.toValue = [NSValue valueWithCGPoint:point2];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, moveAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"toTop"];
}

- (void)toBottomAnimation
{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0.0;
    
    CGPoint point1 = self.viewController.hudView.layer.position;
    CGPoint point2 = point1;
    point2.y += EEHUD_LENGTH_TO_BOTTOM;
    
    CGFloat duration = EEHUD_DURATION_TO_BOTTOM;
    
    // 透明度
    CABasicAnimation *alphaAnime;
    alphaAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnime.fromValue = [NSNumber numberWithFloat:fromAlpha];
    alphaAnime.toValue = [NSNumber numberWithFloat:toAlpha];
    
    // 移動
    CABasicAnimation *moveAnime;
    moveAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnime.fromValue = [NSValue valueWithCGPoint:point1];
    moveAnime.toValue = [NSValue valueWithCGPoint:point2];
    
    // 合体
    CAAnimationGroup *allAnimationGroup;
    allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = [NSArray arrayWithObjects:alphaAnime, moveAnime, nil];
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    allAnimationGroup.duration = duration;
    allAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    allAnimationGroup.startHandlerBlock = [self startHandlerBlock];
    allAnimationGroup.stopHandlerBlock = [self stopHandlerBlock];
    
    // start
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:allAnimationGroup toLayer:self.viewController.hudView.layer forKey:@"toBottom"];
}

- (void)crushOutAnimation
{
    UIView *resultView = self.viewController.resultView;
    UILabel *messageLabel = self.viewController.message;
    UIView *hudView = self.viewController.hudView;
    
    CGSize resultSize = resultView.bounds.size;
    CGSize messageSize = messageLabel.bounds.size;
    
    CABasicAnimation *crush = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    crush.fromValue = [NSValue valueWithCGSize:CGSizeMake(EEHUD_VIEW_WIDTH, EEHUD_VIEW_HEIGHT)];
    crush.toValue = [NSValue valueWithCGSize:CGSizeMake(EEHUD_VIEW_WIDTH, 0.0)];
    crush.duration = EEHUD_DURATION_CRUSHOUT_TOTAL;
    crush.startHandlerBlock = [self startHandlerBlock];
    crush.stopHandlerBlock = [self stopHandlerBlock];
    
    CABasicAnimation *crush1 = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    crush1.fromValue = [NSValue valueWithCGSize:resultSize];
    crush1.toValue = [NSValue valueWithCGSize:CGSizeMake(resultSize.width, 0.0)];
    crush1.duration = EEHUD_DURATION_CRUSHOUT_TOTAL;
    crush1.fillMode = kCAFillModeForwards;
    crush1.removedOnCompletion = NO;
    
    CABasicAnimation *move1 = [CABasicAnimation animationWithKeyPath:@"position"];
    move1.fromValue = [NSValue valueWithCGPoint:resultView.layer.position];
    move1.toValue = [NSValue valueWithCGPoint:CGPointMake(resultView.layer.position.x, 0.0)];
    
    CABasicAnimation *crush2 = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    crush2.fromValue = [NSValue valueWithCGSize:messageSize];
    crush2.toValue = [NSValue valueWithCGSize:CGSizeMake(messageSize.width, 0.0)];
    crush2.duration = EEHUD_DURATION_CRUSHOUT_TOTAL;
    crush2.fillMode = kCAFillModeForwards;
    crush2.removedOnCompletion = NO;
    
    CABasicAnimation *move2 = [CABasicAnimation animationWithKeyPath:@"position"];
    move2.fromValue = [NSValue valueWithCGPoint:messageLabel.layer.position];
    move2.toValue = [NSValue valueWithCGPoint:CGPointMake(messageLabel.layer.position.x, 0.0)];
    
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.animations = [NSArray arrayWithObjects:crush1, move1, nil];
    group1.duration = EEHUD_DURATION_CRUSHOUT_TOTAL;
    
    CAAnimationGroup *group2 = [CAAnimationGroup animation];
    group2.animations = [NSArray arrayWithObjects:crush2, move2, nil];
    group2.duration = EEHUD_DURATION_CRUSHOUT_TOTAL;
    
    // add
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:group1 toLayer:resultView.layer forKey:@"crushOut"];
    [handler registerAnimation:group2 toLayer:messageLabel.layer forKey:@"crushOut"];
    [handler registerAnimation:crush toLayer:hudView.layer forKey:@"crushOut"];
    
}

- (void)toZAxisNegativeStrong:(BOOL)isStrong
{
    CATransform3D transform = self.viewController.view.layer.sublayerTransform;
    
    transform.m34 = EEHUD_ZPOSITION_TRANSFORM_M34;
    self.viewController.view.layer.sublayerTransform = transform;
    
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = [NSNumber numberWithFloat:1.0];
    alpha.toValue = [NSNumber numberWithFloat:0.0];
    
    CGFloat to = EEHUD_ZPOSITION_FROM;
    if (isStrong) {
        to = EEHUD_ZPOSITION_FROM_STRONG;
    }
    
    CABasicAnimation *zPosition = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    zPosition.fromValue = [NSNumber numberWithFloat:EEHUD_ZPOSITION_TO];
    zPosition.toValue = [NSNumber numberWithFloat:to];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:alpha, zPosition, nil];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = EEHUD_DURATION_ZPOSITION_OUT;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.startHandlerBlock = [self startHandlerBlock];
    group.stopHandlerBlock = [self stopHandlerBlock];
    
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:group toLayer:self.viewController.hudView.layer forKey:@"zPositionOut"];
}

#pragma mark - Other
- (void)makeTimer
{
    // 状態遷移
    self.state = EEHUDViewStateAppeal;
    
    // なぜかこのタイミングでタイマー発動
    self.appealTimer = [NSTimer scheduledTimerWithTimeInterval:self.time
                                                        target:self
                                                      selector:@selector(hideAnimation:)
                                                      userInfo:nil
                                                       repeats:NO];
}

- (EEAnimationDidStartHandlerBlock)startHandlerBlock
{
    __weak EEHUDView *me = self;
    
    void (^block)(CAAnimation *anim);
    block = ^(CAAnimation *anim){
        
        switch (me.state) {
            case EEHUDViewStateCalledHideAnimation:
                
                // 状態更新 (アニメーション発動してからの方が良さげ)
                self.state = EEHUDViewStateAnimatingOut;
                
            default:
                break;
        }
    };
    
    return block;
}

- (EEAnimationDidStopHandlerBlock)stopHandlerBlock
{
    __weak EEHUDView *me = self;
    
    void (^block)(CAAnimation *anim, BOOL finished);
    block = ^(CAAnimation *anim, BOOL finished){
        
        if (finished) {
            
            switch (me.state) {
                case EEHUDViewStateAnimatingIn:
                    
                    // 状態更新
                    me.state = EEHUDViewStateAppeal;
                    
                    // アニメーション消去 (resultViewとmessage出てくる)
                    [me.viewController.hudView.layer removeAnimationForKey:anim.animationKey];
                    
                    // なぜかこのタイミングでタイマー発動
                    me.appealTimer = [NSTimer scheduledTimerWithTimeInterval:self.time
                                                                      target:self
                                                                    selector:@selector(hideAnimation:)
                                                                    userInfo:nil
                                                                     repeats:NO];
                    
                    break;
                    
                case EEHUDViewStateAnimatingOut:
                    
//                    LOG(@"AnimatingOut");
//                    LOG(@"me:%@", me);
//                    LOG(@"viewCon:%@", me.viewController);
//                    LOG(@"isShow:%d", me.viewController.isShowProgress);
                    
                    // アニメーション削除
                    [me.viewController.hudView.layer removeAnimationForKey:anim.animationKey];
                    
                    // 全て終わったのでprogress状態じゃなければ初期化
                    if (!me.viewController.isShowProgress) {
                        [me cleaning];
                        
                    }else {
                        // progress状態へ戻す
                        // たぶんここは来ないはず
                        self.state = EEHUDViewStateTransparent;
                        [EEHUDView showProgressWithMessage:self.progressMessage
                                                 showStyle:EEHUDViewShowStyleFadeIn
                                         activityViewStyle:self.viewController.resultView.activityStyle];
                        
                    }
                    
                    
                    break;
                    
                default:
                    break;
            }
            
            
        }
    };
    
    return block;
}

- (void)appealEndInProgress:(NSTimer *)timer
{
    if ((self.state == EEHUDViewStateAppeal) && (self.viewController.isShowProgress == YES)) {
        
        // timer初期化
        [_appealTimerInProgress invalidate];
        self.appealTimerInProgress = nil;
        
        // 表示差し替えて再びアニメーション開始
        self.viewController.message.text = self.progressMessage;
        self.viewController.resultView.activityStyle = self.viewController.resultView.activityStyle;
    }
}

#pragma mark - END
- (void)cleaning
{
    if (self.appealTimer) {
        [self.appealTimer invalidate];
        self.appealTimer = nil;
    }
    
    if (self.appealTimerInProgress) {
        [self.appealTimerInProgress invalidate];
        self.appealTimerInProgress = nil;
    }
    
    if (self.viewController.hudView.superview) {
        [self.viewController.hudView removeFromSuperview];
    }
    self.viewController.hudView = nil;
    
    if (self.viewController.view.superview) {
        [self.viewController.view removeFromSuperview];
    }
    
    self.progressMessage = nil;
    
    self.viewController = nil;
    
    self.state = EEHUDViewStateTransparent;
    
    [sharedInstance_.previousKeyWindow makeKeyWindow];
    sharedInstance_.previousKeyWindow = nil;
    
}

@end

