// 
// EEProgressHUDResultView.m 
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

#import "EEHUDViewConstants.h"
#import "EEAnimationHandler.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    EEHUDResultViewStyleNoView = 0
};
//typedef int EEHUDResultViewStyle;

enum {
    EEHUDActivityViewStyleNoView = 0
};
//typedef int EEHUDActivityViewStyle;


@interface EEHUDCircleView :UIView
@end

@implementation EEHUDCircleView
- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat yohaku = 2.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, width*0.5, height*0.5, width*0.5 - yohaku, 0.0, 2.0f*M_PI, YES);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillPath(context);
}
@end

#import "EEHUDResultView.h"

@interface EEHUDResultView ()

@property (nonatomic, weak) UIView *animationView;
@property (nonatomic, weak) CAShapeLayer *shapeLayer;

/***
 draw
 ***/
- (void)drawOK:(CGRect)rect;
- (void)drawNG:(CGRect)rect;
- (void)drawChecked:(CGRect)rect;
- (void)drawUpArrow:(CGRect)rect;
- (void)drawDownArrow:(CGRect)rect;
- (void)drawRightArrow:(CGRect)rect;
- (void)drawLeftArrow:(CGRect)rect;
- (void)drawPlay:(CGRect)rect;
- (void)drawPause:(CGRect)rect;
//- (void)drawZero:(CGRect)rect;
//- (void)drawOne:(CGRect)rect;
//- (void)drawTwo:(CGRect)rect;
//- (void)drawThree:(CGRect)rect;
//- (void)drawFour:(CGRect)rect;
//- (void)drawFive:(CGRect)rect;
//- (void)drawSix:(CGRect)rect;
//- (void)drawSeven:(CGRect)rect;
//- (void)drawEight:(CGRect)rect;
//- (void)drawNine:(CGRect)rect;
- (void)drawExclamation:(CGRect)rect;
- (void)drawCloud:(CGRect)rect;
- (void)drawCloudUp:(CGRect)rect;
- (void)drawCloudDown:(CGRect)rect;
- (void)drawMail:(CGRect)rect;
- (void)drawMicrophone:(CGRect)rect;
- (void)drawLocation:(CGRect)rect;
- (void)drawHome:(CGRect)rect;
- (void)drawTweet:(CGRect)rect;
- (void)drawClock:(CGRect)rect;
- (void)drawWifiFull:(CGRect)rect;
- (void)drawWifiEmpty:(CGRect)rect;
//- (void)drawTurnArround:(CGRect)rect;
//- (void)drawElectrocardiogram:(CGRect)rect;
/*****************************************/

- (void)startAnimation;

/***
 Animation
 ***/
- (void)animationStartTurnArround;
- (void)animationStartElectrocardiogram;
- (void)animationStartBeat;
/*****************************************/

- (void)refreshSomeLayers;

@end

@implementation EEHUDResultView
@synthesize viewStyle = viewStyle_;
@synthesize activityStyle = _activityStyle;

@synthesize animationView = _animationView;
@synthesize shapeLayer = _shapeLayer;

- (void)setViewStyle:(EEHUDResultViewStyle)aViewStyle
{
    [self refreshSomeLayers];
    
    viewStyle_ = aViewStyle;
    [self setNeedsDisplay];
}

- (void)setActivityStyle:(EEHUDActivityViewStyle)anActivityStyle
{
    if (viewStyle_ != EEHUDResultViewStyleNoView) {
        viewStyle_ = EEHUDResultViewStyleNoView;
        [self setNeedsDisplay];
    }
    
    _activityStyle = anActivityStyle;
    
    // animation
    [self startAnimation];
}

- (void)refreshSomeLayers
{
    [self.animationView.layer removeAllAnimations];
    [self.animationView removeFromSuperview];
    self.animationView = nil;
    
    [self.shapeLayer removeAllAnimations];
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
}

- (void)dealloc
{
    [self refreshSomeLayers];
}

#pragma mark - Animation
- (void)startAnimation
{
    // 初期化
    [self refreshSomeLayers];
    
    //LOG(@"activityStyle:%d", self.activityStyle);
    
    // 振り分け
    switch (self.activityStyle) {
        case EEHUDActivityViewStyleTurnAround:
            [self animationStartTurnArround];
            break;
            
        case EEHUDActivityViewStyleElectrocardiogram:
            [self animationStartElectrocardiogram];
            break;
            
        case EEHUDActivityViewStyleBeat:
            [self animationStartBeat];
            break;
            
        default:
            break;
    }
}

- (void)animationStartTurnArround
{
    CGRect rect = self.bounds;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat circleR = r * 0.4;
    CGFloat size = 10.0;
    
    CGRect circleRect = CGRectZero;
    circleRect.origin = CGPointMake(center.x - size*0.5f, center.y - circleR - 2.0f - size);      // 2.0: line width
    circleRect.size = CGSizeMake(size, size);
    
    EEHUDCircleView *aView = [[EEHUDCircleView alloc] initWithFrame:circleRect];
    aView.backgroundColor = [UIColor clearColor];
    
    self.animationView = aView;
    
    [self addSubview:aView];
    
    // animation
    CAKeyframeAnimation *turn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat turnArroundRadius = circleR + 2.0f + size*0.5;
    CGPathAddArc(path, NULL, center.x, center.y, turnArroundRadius, -M_PI_2, 1.5f*M_PI, YES);
    
    turn.path = path;
    CGPathRelease(path);
    
    turn.duration = 1.0;
    turn.repeatCount = HUGE_VALF;
    
    turn.calculationMode = kCAAnimationPaced;
    
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:turn toLayer:aView.layer forKey:@"turnArround"];
    //[aView.layer addAnimation:turn forKey:nil];
}

- (void)animationStartElectrocardiogram
{
    CGRect rect = self.bounds;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    //CGFloat oneSide = (width < height) ? width : height;
    
    CGFloat verticalSpace = 15.0;
    CGFloat offsetY = 7.0;
    CGFloat mainWidth = 70.0f;
    CGPoint realCenter = CGPointMake(center.x, center.y + offsetY);
    
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(verticalSpace, realCenter.y)];
    [path addLineToPoint:CGPointMake(realCenter.x - mainWidth*0.5, realCenter.y)];
    [path addCurveToPoint:CGPointMake(realCenter.x - mainWidth*0.5 + 6.0f, realCenter.y)
            controlPoint1:CGPointMake(realCenter.x - mainWidth*0.5 + 3.0f, realCenter.y - 6.0f)
            controlPoint2:CGPointMake(realCenter.x - mainWidth*0.5 + 3.0f, realCenter.y - 6.0f)];
    [path addLineToPoint:CGPointMake(realCenter.x - mainWidth*0.5 + 14.0f, realCenter.y)];
    [path addCurveToPoint:CGPointMake(realCenter.x - mainWidth*0.5 + 22.0f, realCenter.y - 15.0f)
            controlPoint1:CGPointMake(realCenter.x - mainWidth*0.5 + 19.0f, realCenter.y)
            controlPoint2:CGPointMake(realCenter.x - mainWidth*0.5 + 20.0f, realCenter.y - 15.0f)];
    [path addCurveToPoint:CGPointMake(realCenter.x - mainWidth*0.5 + 28.0f, realCenter.y)
            controlPoint1:CGPointMake(realCenter.x - mainWidth*0.5 + 24.0f, realCenter.y - 15.0f)
            controlPoint2:CGPointMake(realCenter.x - mainWidth*0.5 + 27.0f, realCenter.y)];
    [path addCurveToPoint:realCenter
            controlPoint1:CGPointMake(realCenter.x - mainWidth*0.5 + 33.0f, realCenter.y + 25.0f)
            controlPoint2:CGPointMake(realCenter.x - 2.0f, realCenter.y + 25.0f)];
    [path addQuadCurveToPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 27.0f, realCenter.y - 33.0f)
                 controlPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 32.0f, realCenter.y - 33.0f)];
    [path addQuadCurveToPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 18.0f, realCenter.y - 15.0f)
                 controlPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 24.0f, realCenter.y - 33.0f)];
    [path addQuadCurveToPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 10.0f, realCenter.y)
                 controlPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 18.0f, realCenter.y - 12.0f)];
    [path addQuadCurveToPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 5.0f, realCenter.y + 5.0f)
                 controlPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 6.0f, realCenter.y + 5.0f)];
    [path addQuadCurveToPoint:CGPointMake(realCenter.x + mainWidth*0.5, realCenter.y)
                 controlPoint:CGPointMake(realCenter.x + mainWidth*0.5 - 4.0f, realCenter.y + 5.0f)];
    [path addLineToPoint:CGPointMake(width - verticalSpace, realCenter.y)];
    
    
    // shapeLayer
    CAShapeLayer *aLayer = [CAShapeLayer layer];
    aLayer.frame = self.layer.bounds;
    aLayer.bounds = CGRectInset(self.layer.bounds, verticalSpace, 0.0);
    aLayer.path = path.CGPath;
    aLayer.strokeColor = [(UIColor *)EEHUD_COLOR_IMAGE CGColor];
    aLayer.fillColor = nil;
    aLayer.lineWidth = 3.0;
    aLayer.lineJoin = kCALineJoinBevel;
    aLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:aLayer];
    
    self.shapeLayer = aLayer;
    
    // animation
    
    NSNumber *oneF = [NSNumber numberWithFloat:1.0f];
    NSNumber *zeroF = [NSNumber numberWithFloat:0.0f];
    NSNumber *timePoint1 = [NSNumber numberWithFloat:0.10f];
    NSNumber *timePoint3 = [NSNumber numberWithFloat:0.70f];
    
    CAMediaTimingFunction *easeIn = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CAMediaTimingFunction *easeOut = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CAMediaTimingFunction *linear = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEnd.fromValue = zeroF;
    strokeEnd.toValue = oneF;
    
    // dev
    //strokeEnd.duration = 1.2f;
    
    
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.values = [NSArray arrayWithObjects:zeroF, oneF, oneF, zeroF, nil];
    opacity.keyTimes = [NSArray arrayWithObjects:zeroF, timePoint1, timePoint3, oneF, nil];
    opacity.timingFunctions = [NSArray arrayWithObjects:easeOut, linear ,easeIn, nil];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:strokeEnd, opacity, nil];
    group.repeatCount = HUGE_VALF;
    group.duration = 1.2f;
    
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:group toLayer:aLayer forKey:@"electrocardiogram"];
    //[aLayer addAnimation:group forKey:nil];
}

- (void)animationStartBeat
{
    CGRect rect = self.bounds;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat minRatio = 0.30;
    CGFloat maxRatio = 0.55;
    
    CGMutablePathRef minArc = CGPathCreateMutable();
    CGPathAddArc(minArc, NULL, center.x, center.y, r*minRatio, 0.0, 2.0*M_PI, YES);
    
    CGMutablePathRef maxArc = CGPathCreateMutable();
    CGPathAddArc(maxArc, NULL, center.x, center.y, r*maxRatio, 0.0, 2.0*M_PI, YES);
    
    CAShapeLayer *aLayer = [CAShapeLayer layer];
    aLayer.frame = self.layer.bounds;
    aLayer.path = minArc;
    aLayer.fillColor = [(UIColor *)EEHUD_COLOR_IMAGE CGColor];
    
    [self.layer addSublayer:aLayer];
    self.shapeLayer = aLayer;
    
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"path"];
    bounce.fromValue = (__bridge_transfer id)minArc;
    bounce.toValue = (__bridge_transfer id)maxArc;
    bounce.duration = 0.6f;
    bounce.repeatCount = HUGE_VALF;
    bounce.autoreverses = YES;
    bounce.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    EEAnimationHandler *handler = [EEAnimationHandler sharedHandler];
    [handler registerAnimation:bounce toLayer:aLayer forKey:@"beat"];
}

#pragma mark - Common


#pragma mark - drawRect:
- (void)drawRect:(CGRect)rect
{
    //CGFloat width = self.bounds.size.width;             // 180
    //CGFloat height = self.bounds.size.height;           // 60
    CGFloat width = rect.size.width;                        // 151
    CGFloat height = rect.size.height;                      // 60
    
    // = height
    CGFloat oneSide = (width < height) ? width : height;
    
    CGPoint center = CGPointMake(width * 0.5, height * 0.5);
    CGFloat r = (oneSide * 0.5);
    
    /***********************
     (180, 60)のサイズのはず
     描画エリアは中心の(60, 60)にしてる。
        => 揃えた方が綺麗に見えるはず
     ************************/
    
    // 定義
    CGPoint hidariue;
    CGFloat innerMargin;
    
    EEHUDResultViewStyle style = self.viewStyle;
    
    switch (style) {
        case EEHUDResultViewStyleOK:
            [self drawOK:rect];
            
            break;
        case EEHUDResultViewStyleNG:
            [self drawNG:rect];
            
            break;
        case EEHUDResultViewStyleChecked:
            [self drawChecked:rect];
                        
            break;
        case EEHUDResultViewStyleUpArrow:
            [self drawUpArrow:rect];
            
            break;
        case EEHUDResultViewStyleDownArrow:
            [self drawDownArrow:rect];
            
            break;
        case EEHUDResultViewStyleRightArrow:
            [self drawRightArrow:rect];
            
            break;
        case EEHUDResultViewStyleLeftArrow:
            [self drawLeftArrow:rect];
            
            break;
        case EEHUDResultViewStylePlay:
            [self drawPlay:rect];
            
            break;
        case EEHUDResultViewStylePause:
            [self drawPause:rect];
            
            break;
        case EEHUDResultViewStyleZero:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"0" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
            [@"0" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            
            break;
            
        case EEHUDResultViewStyleOne:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"1" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
            
            [@"1" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            
            break;
            
        case EEHUDResultViewStyleTwo:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"2" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
                [@"2" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            break;
            
        case EEHUDResultViewStyleThree:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"3" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
            
            [@"3" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            
            break;
            
        case EEHUDResultViewStyleFour:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"4" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
            
            [@"4" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            
            break;
            
        case EEHUDResultViewStyleFive:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"5" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
            [@"5" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            
            break;
            
        case EEHUDResultViewStyleSix:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"6" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
            [@"6" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            
            break;
            
        case EEHUDResultViewStyleSeven:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"7" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
            [@"7" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            break;
            
        case EEHUDResultViewStyleEight:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"8" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];
                [@"8" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            break;
            
        case EEHUDResultViewStyleNine:
            
            innerMargin = 12.0;
            hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
            
            [EEHUD_COLOR_IMAGE set];
            
//            [@"9" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0)
//                     withFont:[UIFont fontWithName:@"Helvetica-Bold" size:60.0]];

            [@"9" drawAtPoint:CGPointMake(hidariue.x + 4.0, hidariue.y - 17.0) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:60.0]}];
            
            break;
            
        case EEHUDResultViewStyleExclamation:
            [self drawExclamation:rect];
            
            break;
        case EEHUDResultViewStyleCloud:
            [self drawCloud:rect];
            
            break;
        case EEHUDResultViewStyleCloudUp:
            [self drawCloudUp:rect];
            
            break;
        case EEHUDResultViewStyleCloudDown:
            [self drawCloudDown:rect];
            
            break;
        case EEHUDResultViewStyleMail:
            [self drawMail:rect];
            
            break;
        case EEHUDResultViewStyleMicrophone:
            [self drawMicrophone:rect];
            
            break;
        case EEHUDResultViewStyleLocation:
            [self drawLocation:rect];
            
            break;
        case EEHUDResultViewStyleHome:
            [self drawHome:rect];
            
            break;
        case EEHUDResultViewStyleTweet:
            [self drawTweet:rect];
        
            break;
        case EEHUDResultViewStyleClock:
            [self drawClock:rect];
            
            break;
        case EEHUDResultViewStyleWifiFull:
            [self drawWifiFull:rect];
            
            break;
        case EEHUDResultViewStyleWifiEmpty:
            [self drawWifiEmpty:rect];
            
            break;
        default:    // EEHUDResultViewStyleNoView
            
            break;
    }
    
    
    
}

#pragma mark - Draw
- (void)drawOK:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat circleR = r * 0.7;
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, center.x, center.y, circleR, 0.0, 2*M_PI, YES);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 8.0);
    
    CGContextStrokePath(context);
}

- (void)drawNG:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 12.0;
    CGPoint hidariue = CGPointMake(center.x - r + innerMargin, center.y - r + innerMargin);
    CGPoint hidarishita = CGPointMake(center.x - r + innerMargin, center.y + r - innerMargin);
    CGPoint migiue = CGPointMake(center.x + r - innerMargin, center.y - r + innerMargin);
    CGPoint migishita = CGPointMake(center.x + r - innerMargin, center.y + r - innerMargin);
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, hidariue.x, hidariue.y);
    CGPathAddLineToPoint(path, NULL, migishita.x, migishita.y);
    CGPathMoveToPoint(path, NULL, migiue.x, migiue.y);
    CGPathAddLineToPoint(path, NULL, hidarishita.x, hidarishita.y);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 8.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextStrokePath(context);
}

- (void)drawChecked:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 12.0;
    CGPoint start = CGPointMake(center.x - r + innerMargin, center.y);
    CGPoint relay = CGPointMake(center.x - 0.2*r, center.y + r - innerMargin);
    CGPoint migiue = CGPointMake(center.x + r*1.2 - innerMargin, center.y - r + innerMargin);
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, migiue.x, migiue.y);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 8.0);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextStrokePath(context);
}

- (void)drawUpArrow:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 12.0;
    CGPoint start = CGPointMake(center.x - 0.8*(r-innerMargin), center.y - 0.2*(r-innerMargin));
    CGPoint relay = CGPointMake(center.x, center.y - (r-innerMargin));
    CGPoint end = CGPointMake(center.x + 0.8*(r-innerMargin), center.y - 0.2*(r-innerMargin));
    CGPoint bottom = CGPointMake(center.x, center.y + (r-innerMargin));
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);
    CGPathMoveToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, bottom.x, bottom.y);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 8.0);
    CGContextSetLineJoin(context, kCGLineCapRound);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextStrokePath(context);
}

- (void)drawDownArrow:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 12.0;
    CGPoint start = CGPointMake(center.x - 0.8*(r-innerMargin), center.y + 0.2*(r-innerMargin));
    CGPoint relay = CGPointMake(center.x, center.y + (r-innerMargin));
    CGPoint end = CGPointMake(center.x + 0.8*(r-innerMargin), center.y + 0.2*(r-innerMargin));
    CGPoint up = CGPointMake(center.x, center.y - (r-innerMargin));
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);
    CGPathMoveToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, up.x, up.y);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 8.0);
    CGContextSetLineJoin(context, kCGLineCapRound);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextStrokePath(context);
}

- (void)drawRightArrow:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 12.0;
    CGPoint start = CGPointMake(center.x + 0.2*(r-innerMargin), center.y - 0.8*(r-innerMargin));
    CGPoint relay = CGPointMake(center.x + (r-innerMargin), center.y);
    CGPoint end = CGPointMake(center.x + 0.2*(r-innerMargin), center.y + 0.8*(r-innerMargin));
    CGPoint left = CGPointMake(center.x - (r-innerMargin), center.y);
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);
    CGPathMoveToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, left.x, left.y);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 8.0);
    CGContextSetLineJoin(context, kCGLineCapRound);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextStrokePath(context);
}

- (void)drawLeftArrow:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 12.0;
    CGPoint start = CGPointMake(center.x - 0.2*(r-innerMargin), center.y - 0.8*(r-innerMargin));
    CGPoint relay = CGPointMake(center.x - (r-innerMargin), center.y);
    CGPoint end = CGPointMake(center.x - 0.2*(r-innerMargin), center.y + 0.8*(r-innerMargin));
    CGPoint right = CGPointMake(center.x + (r-innerMargin), center.y);
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);
    CGPathMoveToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, right.x, right.y);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 8.0);
    CGContextSetLineJoin(context, kCGLineCapRound);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextStrokePath(context);
}

- (void)drawPlay:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 12.0;
    CGPoint start = CGPointMake(center.x + r - innerMargin, center.y);
    CGPoint relay = CGPointMake(center.x - r + r*(2.0-sqrt(3.0))/2 + innerMargin, center.y + r - innerMargin);
    CGPoint end = CGPointMake(center.x - r + r*(2.0-sqrt(3.0))/2 + innerMargin , center.y - r + innerMargin);
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, relay.x, relay.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);
    
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 8.0);
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillPath(context);
}

- (void)drawPause:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat cornerR = 2.0;
    CGFloat lineLength = 35.0;
    CGFloat lineWidth = 7.0;
    
    CGFloat lengthHalf = lineLength * 0.5;
    CGFloat widthHalf = lineWidth * 0.5;
    
    CGFloat innerMargin = 15.0;
    CGPoint left = CGPointMake(center.x - r + innerMargin, center.y - lengthHalf);
    CGPoint right = CGPointMake(center.x + r - innerMargin, center.y - lengthHalf);
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    
    CGPathMoveToPoint(path, NULL, left.x - widthHalf, left.y - cornerR);
    CGPathAddArc(path, NULL, left.x - widthHalf, left.y, cornerR, 3.0*M_PI_2, M_PI, YES);
    CGPathAddLineToPoint(path, NULL, left.x - widthHalf - cornerR, left.y + lineLength);
    CGPathAddArc(path, NULL, left.x - widthHalf, left.y + lineLength, cornerR, M_PI, M_PI_2, YES);
    CGPathAddLineToPoint(path, NULL, left.x + widthHalf, left.y + lineLength + cornerR);
    CGPathAddArc(path, NULL, left.x + widthHalf, left.y + lineLength, cornerR, M_PI_2, 0.0, YES);
    CGPathAddLineToPoint(path, NULL, left.x + widthHalf + cornerR, left.y);
    CGPathAddArc(path, NULL, left.x + widthHalf, left.y, cornerR, 0.0, 3.0*M_PI_2, YES);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, right.x - widthHalf, right.y - cornerR);
    CGPathAddArc(path, NULL, right.x - widthHalf, right.y, cornerR, 3.0*M_PI_2, M_PI, YES);
    CGPathAddLineToPoint(path, NULL, right.x - widthHalf - cornerR, right.y + lineLength);
    CGPathAddArc(path, NULL, right.x - widthHalf, right.y + lineLength, cornerR, M_PI, M_PI_2, YES);
    CGPathAddLineToPoint(path, NULL, right.x + widthHalf, right.y + lineLength + cornerR);
    CGPathAddArc(path, NULL, right.x + widthHalf, right.y + lineLength, cornerR, M_PI_2, 0.0, YES);
    CGPathAddLineToPoint(path, NULL, right.x + widthHalf + cornerR, right.y);
    CGPathAddArc(path, NULL, right.x + widthHalf, right.y, cornerR, 0.0, 3.0*M_PI_2, YES);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillPath(context);
}

- (void)drawExclamation:(CGRect)rect
{
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(71, 46, 8, 8)];
    [[UIColor whiteColor] setFill];
    [ovalPath fill];
    
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(75, 40)];
    [bezierPath addCurveToPoint: CGPointMake(70, 9.67) controlPoint1: CGPointMake(70, 40) controlPoint2: CGPointMake(70, 14.67)];
    [bezierPath addCurveToPoint: CGPointMake(75, 5) controlPoint1: CGPointMake(70, 9.67) controlPoint2: CGPointMake(70.5, 5)];
    [bezierPath addCurveToPoint: CGPointMake(80, 9.67) controlPoint1: CGPointMake(79.5, 5) controlPoint2: CGPointMake(80, 9.67)];
    [bezierPath addCurveToPoint: CGPointMake(75, 40) controlPoint1: CGPointMake(80, 14.67) controlPoint2: CGPointMake(80, 40)];
    [bezierPath closePath];
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    
}

- (void)drawCloud:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 2.0;
    CGFloat bothExpansion = 12.0;
    CGPoint hidarishita = CGPointMake(center.x - r + innerMargin - bothExpansion, center.y + r - innerMargin);
    CGPoint migishita = CGPointMake(center.x + r - innerMargin + bothExpansion, center.y + r - innerMargin);
    /*********************************************************************************/
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // cloud
    [path moveToPoint:CGPointMake(hidarishita.x + 5.0, hidarishita.y)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 15.0, hidarishita.y - 24.0)
            controlPoint1:CGPointMake(hidarishita.x - 8.0, hidarishita.y - 13.0)
            controlPoint2:CGPointMake(hidarishita.x + 5.0, hidarishita.y - 30.0)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 35.0, hidarishita.y - 30.0)
            controlPoint1:CGPointMake(hidarishita.x + 12.0, hidarishita.y - 40.0) 
            controlPoint2:CGPointMake(hidarishita.x + 31.0, hidarishita.y - 44.0)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 67.0, hidarishita.y - 8.0)
            controlPoint1:CGPointMake(hidarishita.x + 50.0, hidarishita.y - 70.0)
            controlPoint2:CGPointMake(hidarishita.x + 95.0, hidarishita.y - 28.0)];
    [path addCurveToPoint:CGPointMake(migishita.x - 5.0, migishita.y)
            controlPoint1:CGPointMake(hidarishita.x + 70.0, hidarishita.y - 15.0)
            controlPoint2:CGPointMake(migishita.x + 5.0, migishita.y - 10.0)];
    [path closePath];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 3.0;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [EEHUD_COLOR_IMAGE set];
    [path stroke];
}

- (void)drawCloudUp:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 2.0;
    CGFloat bothExpansion = 12.0;
    CGPoint hidarishita = hidarishita = CGPointMake(center.x - r + innerMargin - bothExpansion, center.y + r - innerMargin);
    CGPoint migishita = CGPointMake(center.x + r - innerMargin + bothExpansion, center.y + r - innerMargin);
    /*********************************************************************************/
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // cloud
    [path moveToPoint:CGPointMake(hidarishita.x + 5.0, hidarishita.y)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 15.0, hidarishita.y - 24.0)
            controlPoint1:CGPointMake(hidarishita.x - 8.0, hidarishita.y - 13.0)
            controlPoint2:CGPointMake(hidarishita.x + 5.0, hidarishita.y - 30.0)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 35.0, hidarishita.y - 30.0)
            controlPoint1:CGPointMake(hidarishita.x + 12.0, hidarishita.y - 40.0) 
            controlPoint2:CGPointMake(hidarishita.x + 31.0, hidarishita.y - 44.0)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 67.0, hidarishita.y - 8.0)
            controlPoint1:CGPointMake(hidarishita.x + 50.0, hidarishita.y - 70.0)
            controlPoint2:CGPointMake(hidarishita.x + 95.0, hidarishita.y - 28.0)];
    [path addCurveToPoint:CGPointMake(migishita.x - 5.0, migishita.y)
            controlPoint1:CGPointMake(hidarishita.x + 70.0, hidarishita.y - 15.0)
            controlPoint2:CGPointMake(migishita.x + 5.0, migishita.y - 10.0)];
    [path closePath];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 3.0;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [EEHUD_COLOR_IMAGE set];
    [path stroke];
    
    [path removeAllPoints];
    
    // UP

    CGFloat triangleHeight = 10.0;
    CGFloat triangleFloat = 5.0;
    [path moveToPoint:CGPointMake(center.x - triangleHeight, center.y + r - innerMargin - triangleFloat)];
    [path addLineToPoint:CGPointMake(center.x, center.y + r - innerMargin - triangleHeight - triangleFloat)];
    [path addLineToPoint:CGPointMake(center.x + triangleHeight, center.y + r - innerMargin - triangleFloat)];
    [path closePath];
    
    [path stroke];
}

- (void)drawCloudDown:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 2.0;
    CGFloat bothExpansion = 12.0;
    CGPoint hidarishita = hidarishita = CGPointMake(center.x - r + innerMargin - bothExpansion, center.y + r - innerMargin);
    CGPoint migishita = CGPointMake(center.x + r - innerMargin + bothExpansion, center.y + r - innerMargin);
    /*********************************************************************************/
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // cloud
    [path moveToPoint:CGPointMake(hidarishita.x + 5.0, hidarishita.y)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 15.0, hidarishita.y - 24.0)
            controlPoint1:CGPointMake(hidarishita.x - 8.0, hidarishita.y - 13.0)
            controlPoint2:CGPointMake(hidarishita.x + 5.0, hidarishita.y - 30.0)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 35.0, hidarishita.y - 30.0)
            controlPoint1:CGPointMake(hidarishita.x + 12.0, hidarishita.y - 40.0) 
            controlPoint2:CGPointMake(hidarishita.x + 31.0, hidarishita.y - 44.0)];
    [path addCurveToPoint:CGPointMake(hidarishita.x + 67.0, hidarishita.y - 8.0)
            controlPoint1:CGPointMake(hidarishita.x + 50.0, hidarishita.y - 70.0)
            controlPoint2:CGPointMake(hidarishita.x + 95.0, hidarishita.y - 28.0)];
    [path addCurveToPoint:CGPointMake(migishita.x - 5.0, migishita.y)
            controlPoint1:CGPointMake(hidarishita.x + 70.0, hidarishita.y - 15.0)
            controlPoint2:CGPointMake(migishita.x + 5.0, migishita.y - 10.0)];
    [path closePath];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 3.0;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [EEHUD_COLOR_IMAGE set];
    [path stroke];
    
    [path removeAllPoints];
    
    // DOWN
    CGFloat triangleHeight = 10.0;
    [path moveToPoint:CGPointMake(center.x - triangleHeight, center.y + r - innerMargin - triangleHeight)];
    [path addLineToPoint:CGPointMake(center.x + triangleHeight, center.y + r - innerMargin - triangleHeight)];
    [path addLineToPoint:CGPointMake(center.x, center.y + r - innerMargin)];
    [path closePath];
    
    [path stroke];
}

- (void)drawMail:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat innerMargin = 11.0;
    CGFloat bothExpansion = 10.0;
    CGPoint hidariue = CGPointMake(center.x - r + innerMargin - bothExpansion, center.y - r + innerMargin);
    CGPoint migishita = CGPointMake(center.x + r - innerMargin + bothExpansion, center.y + r - innerMargin);
    CGPoint migiue = CGPointMake(center.x + r - innerMargin + bothExpansion, center.y - r + innerMargin);
    CGPoint hidarishita = CGPointMake(center.x - r + innerMargin - bothExpansion, center.y + r - innerMargin);
    /*********************************************************************************/
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:hidariue];
    [path addLineToPoint:migiue];
    [path addLineToPoint:migishita];
    [path addLineToPoint:hidarishita];
    [path addLineToPoint:hidariue];
    [path moveToPoint:CGPointMake(hidariue.x, hidariue.y + 5.0)];
    [path addLineToPoint:CGPointMake(center.x, hidarishita.y - 10.0)];
    [path addLineToPoint:CGPointMake(migiue.x, migiue.y + 5.0)];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 4.0;
    
    [EEHUD_COLOR_IMAGE set];
    [path stroke];
}

- (void)drawMicrophone:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat ueMargin = 2.0;
    CGFloat hidariMargin = 7.0;
    //CGFloat migiMargin = 7.0;
    CGFloat shitaMargin = 0.0;
    
    CGPoint hidariue = CGPointMake(center.x - r + hidariMargin, center.y - r + ueMargin);
    CGPoint hidarishita = CGPointMake(center.x - r + hidariMargin, center.y + r - shitaMargin);
    /*********************************************************************************/
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(center.x - 7.0, hidariue.y + 10.0)];
    [path addArcWithCenter:CGPointMake(center.x, hidariue.y + 10.0)
                    radius:7.0
                startAngle:M_PI
                  endAngle:0.0
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(center.x + 7.0, center.y - 4.0)];
    [path addArcWithCenter:CGPointMake(center.x, center.y + 7.0 - 4.0)
                    radius:7.0
                startAngle:0.0
                  endAngle:M_PI
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(center.x - 7.0, hidariue.y + 10.0)];
    [path closePath];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 3.0;
    
    [EEHUD_COLOR_IMAGE set];
    [path fill];
    
    // 
    path = nil;
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(center.x + 7.0 + 5.0, center.y - 4.0 - 1.0)];
    [path addLineToPoint:CGPointMake(center.x + 7.0 + 5.0, center.y - 4.0)];
    [path addArcWithCenter:CGPointMake(center.x, center.y + 7.0 - 4.0)
                    radius:12.0
                startAngle:0.0
                  endAngle:M_PI
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(center.x - 7.0 - 5.0, center.y - 4.0 - 1.0)];
    
    [path moveToPoint:CGPointMake(center.x, center.y + 7.0 - 4.0 + 12.0)];
    [path addLineToPoint:CGPointMake(center.x, hidarishita.y - 3.0)];
    [path moveToPoint:CGPointMake(center.x - 7.0, hidarishita.y - 3.0)];
    [path addLineToPoint:CGPointMake(center.x + 7.0, hidarishita.y - 3.0)];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 4.0;
    
    [EEHUD_COLOR_IMAGE set];
    [path stroke];
}

- (void)drawLocation:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat ueMargin = 2.0;
    CGFloat hidariMargin = 5.0;
    //CGFloat migiMargin = 5.0;
    CGFloat shitaMargin = -4.0;
    
    CGPoint hidariue = CGPointMake(center.x - r + hidariMargin, center.y - r + ueMargin);
    //CGPoint migiue = CGPointMake(center.x + r - migiMargin, center.y - r + ueMargin);
    CGPoint hidarishita = CGPointMake(center.x - r + hidariMargin, center.y + r - shitaMargin);
    //CGPoint migishita = CGPointMake(center.x + r - migiMargin, center.y + r - shitaMargin);
    /*********************************************************************************/
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(center.x - 2, hidarishita.y - 7)];
    [path addLineToPoint:CGPointMake(center.x, hidarishita.y - 5)];
    [path addLineToPoint:CGPointMake(center.x + 2, hidarishita.y - 7)];
    [path addLineToPoint:CGPointMake(center.x + 20.0, hidariue.y + 24.0)];
    [path addArcWithCenter:CGPointMake(center.x, hidariue.y + 20.0)
                    radius:(sqrt(416))
                startAngle:atan(5.0/20.0)
                  endAngle:(M_PI - atan(5.0/20.0))
                 clockwise:NO];
    [path closePath];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 4.0;
    
    [path addArcWithCenter:CGPointMake(center.x, center.y - 9.0)
                    radius:9.0
                startAngle:0.0
                  endAngle:1.999999*M_PI
                 clockwise:YES];
    
    [EEHUD_COLOR_IMAGE set];
    [path fill];
}

- (void)drawHome:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat ueMargin = 5.0;
    CGFloat hidariMargin = -5.0;
    CGFloat migiMargin = -5.0;
    CGFloat shitaMargin = 0.0;
    
    CGPoint hidariue = CGPointMake(center.x - r + hidariMargin, center.y - r + ueMargin);
    CGPoint migiue = CGPointMake(center.x + r - migiMargin, center.y - r + ueMargin);
    CGPoint migishita = CGPointMake(center.x + r - migiMargin, center.y + r - shitaMargin);
    CGPoint hidarishita = CGPointMake(center.x - r + hidariMargin, center.y + r - shitaMargin);
    
    CGFloat theta = atan((center.y + 2.0 - hidariue.y)/(center.x - hidariue.x));
    /*********************************************************************************/
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(center.x, hidariue.y)];
    [path addLineToPoint:CGPointMake(hidariue.x, center.y + 2.0)];
    [path addCurveToPoint:CGPointMake(hidariue.x + 9.0*sin(theta) + 9.0*2.0*cos(theta), center.y + 2.0 + 9.0*cos(theta) - 2.0*9.0*sin(theta))
            controlPoint1:CGPointMake(hidariue.x + 9.0*sin(theta), center.y + 2.0 + 9.0*cos(theta))
            controlPoint2:CGPointMake(hidariue.x + 9.0*sin(theta) + 9.0*cos(theta), center.y + 2.0 + 9.0*cos(theta) - 9.0*sin(theta))];
    [path addLineToPoint:CGPointMake(center.x, hidariue.y + 9.0/cos(atan((center.y + 2.0 - hidariue.y)/(center.x - hidariue.x))))];
    [path addLineToPoint:CGPointMake(migiue.x - 9.0*sin(theta) - 9.0*2.0*cos(theta), center.y + 2.0 + 9.0*cos(theta) - 2.0*9.0*sin(theta))];
    [path addCurveToPoint:CGPointMake(migiue.x, center.y + 2.0)
            controlPoint1:CGPointMake(migiue.x - 9.0*sin(theta) - 9.0*cos(theta), center.y + 2.0 + 9.0*cos(theta) - 9.0*sin(theta))
            controlPoint2:CGPointMake(migiue.x - 9.0*sin(theta), center.y + 2.0 + 9.0*cos(theta))];
    [path closePath];
    
    path.lineWidth = 1.0;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    
    [EEHUD_COLOR_IMAGE set];
    [path fill];
    
    path = nil;
    path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(center.x - 10.0, hidarishita.y)];
    [path addLineToPoint:CGPointMake(center.x - 10.0, hidarishita.y - 5.0)];
    [path addArcWithCenter:CGPointMake(center.x, hidarishita.y - 5.0)
                    radius:10.0
                startAngle:M_PI
                  endAngle:0.0
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(center.x + 10.0, migishita.y)];
    [path addLineToPoint:CGPointMake(center.x + 20.0, migishita.y)];
    [path addLineToPoint:CGPointMake(center.x + 20.0, migishita.y - 20.0)];
    [path addLineToPoint:CGPointMake(center.x, migishita.y - 20.0 - (20.0*tan(theta)))];
    [path addLineToPoint:CGPointMake(center.x - 20.0, hidarishita.y - 20.0)];
    [path addLineToPoint:CGPointMake(center.x - 20.0, hidarishita.y)];
    [path closePath];
    
    path.lineWidth = 4.0;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [EEHUD_COLOR_IMAGE set];
    [path fill];
}

- (void)drawTweet:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat ueMargin = 5.0;
    CGFloat hidariMargin = -5.0;
    CGFloat migiMargin = -5.0;
    CGFloat shitaMargin = 0.0;
    
    CGPoint hidariue = CGPointMake(center.x - r + hidariMargin, center.y - r + ueMargin);
    CGPoint migiue = CGPointMake(center.x + r - migiMargin, center.y - r + ueMargin);
    //CGPoint migishita = CGPointMake(center.x + r - migiMargin, center.y + r - shitaMargin);
    CGPoint hidarishita = CGPointMake(center.x - r + hidariMargin, center.y + r - shitaMargin);
    /*********************************************************************************/
    
    UIBezierPath *path;
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(hidariue.x, 
                                                             hidariue.y, 
                                                             migiue.x - hidariue.x, 
                                                             hidarishita.y - hidariue.y - 8.0)];
    
    [path addArcWithCenter:CGPointMake(center.x - 15.0, center.y)
                    radius:4.0
                startAngle:0.0
                  endAngle:1.999999*M_PI
                 clockwise:YES];
    [path closePath];
    
    [path addArcWithCenter:CGPointMake(center.x - 0.0, center.y)
                    radius:4.0
                startAngle:0.0
                  endAngle:1.999999*M_PI
                 clockwise:YES];
    [path closePath];
    
    [path addArcWithCenter:CGPointMake(center.x + 15.0, center.y)
                    radius:4.0
                startAngle:0.0
                  endAngle:1.999999*M_PI
                 clockwise:YES];
    [path closePath];
    
    path.usesEvenOddFillRule = YES;
    [EEHUD_COLOR_IMAGE set];
    [path fill];
    
    path = nil;
    path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(hidarishita.x + 10.0, hidarishita.y - 15.0)];
    [path addQuadCurveToPoint:CGPointMake(hidarishita.x + 15.0, hidarishita.y)
                 controlPoint:CGPointMake(hidarishita.x + 20.0, hidarishita.y - 10.0)];
    [path addLineToPoint:CGPointMake(hidarishita.x + 40.0, hidarishita.y - 10.0)];
    [path closePath];
    
    [EEHUD_COLOR_IMAGE set];
    [path fill];
}

- (void)drawClock:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat ueMargin = 5.0;
    CGFloat hidariMargin = 5.0;
    CGFloat migiMargin = 5.0;
    CGFloat shitaMargin = 5.0;
    
    CGPoint hidariue = CGPointMake(center.x - r + hidariMargin, center.y - r + ueMargin);
    CGPoint migiue = CGPointMake(center.x + r - migiMargin, center.y - r + ueMargin);
    CGPoint hidarishita = CGPointMake(center.x - r + hidariMargin, center.y + r - shitaMargin);
    /*********************************************************************************/
    
    UIBezierPath *path;
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(hidariue.x, hidariue.y, (migiue.x - hidariue.x), hidarishita.y - hidariue.y)];
    
    path.lineWidth = 4.0;
    [EEHUD_COLOR_IMAGE set];
    [path stroke];
    
    path = nil;
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(center.x, center.y - 11.0)];
    [path addLineToPoint:center];
    [path addLineToPoint:CGPointMake(center.x + 11.0, center.y)];
    
    path.lineWidth = 5.0;
    path.lineCapStyle = kCGLineCapRound;
    
    [EEHUD_COLOR_IMAGE set];
    [path stroke];
}

- (void)drawWifiFull:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat ueMargin = 5.0;
    CGFloat shitaMargin = 5.0;
    
    CGPoint shita = CGPointMake(center.x, center.y + r - shitaMargin);
    CGFloat realHeight = 2.0f*r - ueMargin - shitaMargin;
    
    CGFloat theta = -M_PI_2;
    CGFloat coordinateTheta = (-M_PI - theta)*0.5;
    CGFloat lineWidth = 13.0;
    CGFloat lineSpace = (realHeight - 3.0f * lineWidth) * 0.5;
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGAffineTransform toGenten = CGAffineTransformMakeTranslation(shita.x, shita.y);
    CGAffineTransform rotate = CGAffineTransformRotate(toGenten, coordinateTheta);

    CGPathMoveToPoint(path, &rotate, 0.0, 0.0);
    CGPathAddLineToPoint(path, &rotate, lineWidth, 0.0);
    CGPathAddArc(path, &rotate, 0.0, 0.0, lineWidth, 0.0, theta, YES);
    CGPathCloseSubpath(path);
    
    CGPathMoveToPoint(path, &rotate, lineWidth + lineSpace, 0.0);
    CGPathAddLineToPoint(path, &rotate, 2.0f*lineWidth + lineSpace, 0.0);
    CGPathAddArc(path, &rotate, 0.0f, 0.0f, 2.0f*lineWidth + lineSpace, 0.0, theta, YES);
    CGPathAddLineToPoint(path, &rotate, 0.0, - (lineWidth + lineSpace));
    CGPathAddArc(path, &rotate, 0.0f, 0.0f, lineWidth + lineSpace, theta, 0.0, NO);
    CGPathCloseSubpath(path);
    
    CGPathMoveToPoint(path, &rotate, 2.0f*lineWidth + 2.0f*lineSpace, 0.0f);
    CGPathAddLineToPoint(path, &rotate, 3.0f*lineWidth + 2.0f*lineSpace, 0.0f);
    CGPathAddArc(path, &rotate, 0.0, 0.0, 3.0f*lineWidth + 2.0f*lineSpace, 0.0, theta, YES);
    CGPathAddLineToPoint(path, &rotate, 0.0, - (2.0f*lineWidth + 2.0f*lineSpace));
    CGPathAddArc(path, &rotate, 0.0f, 0.0f, 2.0f*lineWidth + 2.0f*lineSpace, theta, 0.0, NO); 
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillPath(context);
}

- (void)drawWifiEmpty:(CGRect)rect
{
    /** definition *******************************************************************/
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = CGPointMake(rect.origin.x + width*0.5, rect.origin.y + height*0.5);
    
    CGFloat oneSide = (width < height) ? width : height;
    CGFloat r = oneSide * 0.5;
    
    CGFloat ueMargin = 5.0;
    CGFloat shitaMargin = 5.0;
    
    CGPoint shita = CGPointMake(center.x, center.y + r - shitaMargin);
    CGFloat realHeight = 2.0f*r - ueMargin - shitaMargin;
    
    CGFloat theta = -M_PI_2;
    CGFloat coordinateTheta = (-M_PI - theta)*0.5;
    CGFloat lineWidth = 13.0;
    CGFloat lineSpace = (realHeight - 3.0f * lineWidth) * 0.5;
    /*********************************************************************************/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGAffineTransform toGenten = CGAffineTransformMakeTranslation(shita.x, shita.y);
    CGAffineTransform rotate = CGAffineTransformRotate(toGenten, coordinateTheta);
    
    CGPathMoveToPoint(path, &rotate, 0.0, 0.0);
    CGPathAddLineToPoint(path, &rotate, 3.0f*lineWidth + 2.0f*lineSpace, 0.0f);
    CGPathAddArc(path, &rotate, 0.0f, 0.0f, 3.0f*lineWidth + 2.0f*lineSpace, 0.0, theta, YES);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    CGContextSetLineWidth(context, 2.0);
    
    UIColor *color = EEHUD_COLOR_IMAGE;
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextStrokePath(context);
}

@end
