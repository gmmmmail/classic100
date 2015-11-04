// 
// EEProgressHUDResultView.h 
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
#import <QuartzCore/QuartzCore.h>

typedef enum _EEHUDResultViewStyle {
    EEHUDResultViewStyleOK = 1,
    EEHUDResultViewStyleNG = 2,
    EEHUDResultViewStyleChecked = 3,
    EEHUDResultViewStyleUpArrow = 4,
    EEHUDResultViewStyleDownArrow = 5,
    EEHUDResultViewStyleRightArrow = 6,
    EEHUDResultViewStyleLeftArrow = 7,
    EEHUDResultViewStylePlay = 8,
    EEHUDResultViewStylePause = 9,
    EEHUDResultViewStyleZero = 10,
    EEHUDResultViewStyleOne = 11,
    EEHUDResultViewStyleTwo = 12,
    EEHUDResultViewStyleThree = 13,
    EEHUDResultViewStyleFour = 14,
    EEHUDResultViewStyleFive = 15,
    EEHUDResultViewStyleSix = 16,
    EEHUDResultViewStyleSeven = 17,
    EEHUDResultViewStyleEight = 18,
    EEHUDResultViewStyleNine = 19,
    EEHUDResultViewStyleExclamation = 20,
    EEHUDResultViewStyleCloud = 21,
    EEHUDResultViewStyleCloudUp = 22,
    EEHUDResultViewStyleCloudDown = 23,
    EEHUDResultViewStyleMail = 24,
    EEHUDResultViewStyleMicrophone = 25,
    EEHUDResultViewStyleLocation = 26,
    EEHUDResultViewStyleHome = 27,
    EEHUDResultViewStyleTweet = 28,
    EEHUDResultViewStyleClock = 29,
    EEHUDResultViewStyleWifiFull = 30,
    EEHUDResultViewStyleWifiEmpty = 31
} EEHUDResultViewStyle;

typedef enum _EEHUDActivityViewStyle {
    EEHUDActivityViewStyleTurnAround = 1,
    EEHUDActivityViewStyleElectrocardiogram = 2,
    EEHUDActivityViewStyleBeat = 3
} EEHUDActivityViewStyle;

@interface EEHUDResultView : UIView {
    
    EEHUDResultViewStyle viewStyle_;
    EEHUDActivityViewStyle _activityStyle;
}
@property (nonatomic) EEHUDResultViewStyle viewStyle;
@property (nonatomic) EEHUDActivityViewStyle activityStyle;

@end
