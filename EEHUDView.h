// 
// EEHUDView.h 
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

#import <UIKit/UIKit.h>
#import "EEHUDResultView.h"
#import "EEProgressView.h"

typedef enum _EEHUDViewShowStyle {
    EEHUDViewShowStyleFadeIn = 0,
    EEHUDViewShowStyleLutz = 1,
    EEHUDViewShowStyleShake = 2,
    EEHUDViewShowStyleNoAnime = 3,
    EEHUDViewShowStyleFromRight = 4,
    EEHUDViewShowStyleFromLeft = 5,
    EEHUDViewShowStyleFromTop = 6,
    EEHUDViewShowStyleFromBottom = 7,
    EEHUDViewShowStyleFromZAxisNegative = 8,
    EEHUDViewShowStyleFromZAxisNegativeStrong = 9
} EEHUDViewShowStyle;

typedef enum _EEHUDViewHideStyle {
    EEHUDViewHideStyleFadeOut = 0,
    EEHUDViewHideStyleLutz = 1,
    EEHUDViewHideStyleShake = 2,
    EEHUDViewHideStyleNoAnime = 3,
    EEHUDViewHideStyleToLeft = 4,
    EEHUDViewHideStyleToRight = 5,
    EEHUDViewHideStyleToBottom = 6,
    EEHUDViewHideStyleToTop = 7,
    EEHUDViewHideStyleCrush = 8,
    EEHUDViewHideStyleToZAxisNegative = 9,
    EEHUDViewHideStyleToZAxisNegativeStrong = 10
} EEHUDViewHideStyle;

@interface EEHUDView : UIWindow

+ (void)growlWithMessage:(NSString *)message
               showStyle:(EEHUDViewShowStyle)showStyle
               hideStyle:(EEHUDViewHideStyle)hideStyle
         resultViewStyle:(EEHUDResultViewStyle)resultViewStyle
                showTime:(float)time;

+ (void)showProgressWithMessage:(NSString *)message
                      showStyle:(EEHUDViewShowStyle)showStyle
              activityViewStyle:(EEHUDActivityViewStyle)activityStyle;
+ (void)hideProgressWithMessage:(NSString *)message
                      hideStyle:(EEHUDViewHideStyle)hideStyle
                resultViewStyle:(EEHUDResultViewStyle)resultViewStyle
                       showTime:(float)time;

+ (void)updateProgress:(float)progress;


// HUD表示してるかどうか
+ (BOOL)isShowing;

// 表示しているmessage
+ (NSString *)message;

@end
