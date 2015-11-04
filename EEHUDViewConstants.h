// 
// EEHUDViewConstants.h
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

// interface orientation
#define EEHUD_INTERFACE_ORIENTATION_PORTRAIT                YES
#define EEHUD_INTERFACE_ORIENTATION_LANDSCAPE_LEFT          NO
#define EEHUD_INTERFACE_ORIENTATION_LANDSCAPE_RIGHT         NO
#define EEHUD_INTERFACE_ORIENTATION_PORTRAIT_UPSIDEDOWN     NO

// HUDView (golden ratio)
#define EEHUD_VIEW_WIDTH                        161.8
#define EEHUD_VIEW_HEIGHT                       100.0
#define EEHUD_VIEW_BOTHENDS_MARGIN              5.0
#define EEHUD_VIEW_CORNER_RADIUS                7.0
#define EEHUD_VIEW_HEIGHT_PROGRESS              8.0
#define EEHUD_VIEW_MARGIN_VERTICAL_PROGRESS      6.0
#define EEHUD_VIEW_MARGIN_HORIZONTAL_PROGRESS   8.0

// image
#define EEHUD_IMAGE_ORIGINY 10.0
#define EEHUD_IMAGE_WIDTH 161.8
#define EEHUD_IMAGE_HEIGHT 60.0

// label
#define EEHUD_LABEL_BOTTOM_MARGIN       5.0
#define EEHUD_LABEL_HEIGHT              20.0
#define EEHUD_LABEL_FONT                [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
#define EEHUD_LABEL_TEXTCOLOR           [UIColor whiteColor]

// color of HUDView
#define EEHUD_COLOR_HUDVIEW [UIColor colorWithWhite:0.0 alpha:0.75]
#define EEHUD_COLOR_LABEL [UIColor whiteColor]
#define EEHUD_COLOR_IMAGE [UIColor whiteColor]
#define EEHUD_COLOR_PROGRESS [UIColor colorWithWhite:1.0 alpha:0.75]

// 
//#define EEHUD_DURATION_STARTWAIT    3.0

// animation (Fade)
#define EEHUD_SIZERATIO_FADEIN          0.95
#define EEHUD_SIZERATIO_FADEOUT         0.95
#define EEHUD_DURATION_FADEIN           0.25
#define EEHUD_DURATION_FADEOUT          0.25

// animation (Lutz)
#define EEHUD_SIZERATIO_LUTZIN          0.95
#define EEHUD_SIZERATIO_LUTZOUT         0.95
#define EEHUD_DURATION_LUTZIN           0.4
#define EEHUD_DURATION_LUTZOUT          0.4
#define EEHUD_COUNT_ROTATION_LUTZIN     8
#define EEHUD_COUNT_ROTATION_LUTZOUT    8
#define EEHUD_HEIGHT_JUMP_LUTZIN        30.0
#define EEHUD_HEIGHT_JUMP_LUTZOUT       30.0

// animation (Shake)
#define EEHUD_THETA_DEGREE_SHAKEIN      12.0
#define EEHUD_THETA_DEGREE_SHAKEOUT     12.0
#define EEHUD_COUNT_SHAKEIN             9           // odd
#define EEHUD_COUNT_SHAKEOUT            9           // odd
#define EEHUD_DURATION_SHAKEIN          0.3
#define EEHUD_DURATION_SHAKEOUT         0.3

// animation (Holizontal Slide)
#define EEHUD_LENGTH_FROM_LEFT          10.0
#define EEHUD_LENGTH_FROM_RIGHT         10.0
#define EEHUD_LENGTH_TO_LEFT            10.0
#define EEHUD_LENGTH_TO_RIGHT           10.0
#define EEHUD_DURATION_FROM_LEFT        0.25
#define EEHUD_DURATION_FROM_RIGHT       0.25
#define EEHUD_DURATION_TO_LEFT          0.25
#define EEHUD_DURATION_TO_RIGHT         0.25

// animation (Vertical Slide)
#define EEHUD_LENGTH_FROM_BOTTOM        10.0
#define EEHUD_LENGTH_FROM_TOP           10.0
#define EEHUD_LENGTH_TO_BOTTOM          10.0
#define EEHUD_LENGTH_TO_TOP             10.0
#define EEHUD_DURATION_FROM_BOTTOM      0.25
#define EEHUD_DURATION_FROM_TOP         0.25
#define EEHUD_DURATION_TO_BOTTOM        0.25
#define EEHUD_DURATION_TO_TOP           0.25


// animation (no anime)
#define EEHUD_DURATION_NOANIME          0.001

// animation (progress hide)
#define EEHUD_DURATION_SHOW_PROGRESS_RANGE      0.3
#define EEHUD_DURATION_HIDE_PROGRESS_RANGE      0.3
#define EEHUD_DURATION_FADEIN_PROGRESS          0.2
#define EEHUD_DURATION_FADEOUT_PROGRESS         0.2
#define EEHUD_KEY_HIDE_PROGRESS         @"EEHUD_KEY_HIDE_PROGRESS"
#define EEHUD_KEY_SHOW_PROGRESS         @"EEHUD_KEY_SHOW_PROGRESS"

// animation (crush)
#define EEHUD_DURATION_CRUSHOUT_TOTAL           0.15

// animation (zPosition)
#define EEHUD_ZPOSITION_FROM                500
#define EEHUD_ZPOSITION_FROM_STRONG         1100
#define EEHUD_ZPOSITION_TO                  0
#define EEHUD_ZPOSITION_TRANSFORM_M34       -1.0/2000.0
#define EEHUD_DURATION_ZPOSITION_IN         0.3
#define EEHUD_DURATION_ZPOSITION_OUT        0.3

// turn arround
#define EEHUD_RADIUS_TURN_ARROUND       20.0

// view tag
#define EEHUD_TAG_PROGRESSVIEW          10000

