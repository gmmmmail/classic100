//
//  LLFoldView.h
//  AnimStudy
//
//  Created by lai on 15/4/8.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LLFoldViewDelegate <NSObject>

-(void)tap:(NSInteger)index;
-(void)cancelTheme;

@end

@interface LLFoldView : UIView

@property(nonatomic,strong) NSArray *images;
@property (readwrite, retain) id<LLFoldViewDelegate> delegate;

-(void)initView;
-(void)open;
-(void)close;
@end
