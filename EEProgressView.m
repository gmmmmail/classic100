//
// EEProgressView.m
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

#import "EEProgressView.h"
#import "EEHUDViewConstants.h"

@interface EEProgressView ()
{
    float _progress;
}

@end

@implementation EEProgressView

@synthesize progress = _progress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.progress = 0.0;
    }
    return self;
}

- (void)setProgress:(float)progress
{
    if (progress > 1.0) {
        progress = 1.0;
    }else if (progress < 0.0) {
        progress = 0.0;
    }
    
    _progress = progress;
    if (progress != 0.0) {
        [self setNeedsDisplay];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGFloat width = rect.size.width;
    CGFloat realWidth = width * _progress;
    CGFloat height = rect.size.height;
    CGFloat minWidth = height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0.0, height*0.5);
    if (realWidth <= minWidth) {
        CGPathAddArc(path, NULL,
                     height*0.5, height*0.5, 
                     height*0.5, 0.0, 2.0*M_PI, YES);
    }else {
        
        CGPathAddArc(path, NULL,
                     height*0.5, height*0.5, 
                     height*0.5, M_PI, 3.0*M_PI_2, NO);
        CGPathAddLineToPoint(path, NULL, realWidth - height*0.5, 0.0);
        CGPathAddArc(path, NULL, 
                     realWidth - height*0.5, height*0.5, 
                     height*0.5, 3.0*M_PI_2, 5.0*M_PI_2, NO);
        CGPathAddLineToPoint(path, NULL, height*0.5, height);
        CGPathAddArc(path, NULL, height*0.5, height*0.5, 
                     height*0.5, 5.0*M_PI_2, 6.0*M_PI_2, NO);
    }
    
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    UIColor *color = EEHUD_COLOR_PROGRESS;
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillPath(context);
}

@end
