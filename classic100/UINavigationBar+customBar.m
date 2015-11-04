//
//  UINavigationBar+customBar.m
//  cuntomNavigationBar
//
//  Created by Edward on 13-4-22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//
// object c 类目
// http://blog.csdn.net/wuleihenbang/article/details/9076853

#import "UINavigationBar+customBar.h"

@implementation UINavigationBar (customBar)

- (void)customNavigationBar{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *image = [UIImage imageNamed:@"navi_bg.png"];
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        // 去除黑线
        NSArray *list=self.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                imageView.hidden=YES;
            }
        }
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 420, 64)];
        imageView.image=[UIImage imageNamed:@"top_bg"];
        [self addSubview:imageView];
        [self sendSubviewToBack:imageView];
    } else {
        [self drawRect:self.bounds];
    }
}


- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"Title"] drawInRect:rect];
}
@end
