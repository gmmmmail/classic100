//
//  LLFoldView.m
//  AnimStudy
//
//  Created by lai on 15/4/8.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "LLFoldView.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
@implementation LLFoldView{
    UIImageView *v1;
    UIImageView *v2;
    UIImageView *v3;
    UIImageView *v4;
    
    
    UIImageView *v5;
    UIImageView *v6;
    UIImageView *v7;
    UIImageView *v8;
    
    UIImageView *blank;
    
    float width;
    float height;
    float padding;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        padding = 5;
        width = (self.frame.size.width-3*padding)/4;
        height = self.frame.size.height/3-50;
    }
    return self;
}

-(void)initView
{
    blank = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-height)];
    v1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-height, width,height)];
    v2 = [[UIImageView alloc] initWithFrame:CGRectMake(width+padding,  self.frame.size.height-height, width, height)];
    v3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*width+2*padding, self.frame.size.height-height, width, height)];
    v4 = [[UIImageView alloc] initWithFrame:CGRectMake(3*width+3*padding,  self.frame.size.height-height, width, height)];
    
    v5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2*height-padding, width,height)];
    v6 = [[UIImageView alloc] initWithFrame:CGRectMake(width+padding,  self.frame.size.height-2*height-padding, width, height)];
    v7 = [[UIImageView alloc] initWithFrame:CGRectMake(2*width+2*padding, self.frame.size.height-2*height-padding, width, height)];
    v8 = [[UIImageView alloc] initWithFrame:CGRectMake(3*width+3*padding,  self.frame.size.height-2*height-padding, width, height)];
    
    v1.image = [_images objectAtIndex:0];
    v2.image = [_images objectAtIndex:1];
    v3.image = [_images objectAtIndex:2];
    v4.image = [_images objectAtIndex:3];
    
    v5.image = [_images objectAtIndex:4];
    v6.image = [_images objectAtIndex:5];
    v7.image = [_images objectAtIndex:6];
    v8.image = [_images objectAtIndex:7];
    
    
    [self addSubview:blank];
    [self addSubview:v1];
    [self addSubview:v2];
    [self addSubview:v3];
    [self addSubview:v4];
    
    [self addSubview:v5];
    [self addSubview:v6];
    [self addSubview:v7];
    [self addSubview:v8];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [blank addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    [v1 addGestureRecognizer:gesture1];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
    [v2 addGestureRecognizer:gesture2];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3)];
    [v3 addGestureRecognizer:gesture3];
    UITapGestureRecognizer *gesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap4)];
    [v4 addGestureRecognizer:gesture4];
    
    UITapGestureRecognizer *gesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap5)];
    [v5 addGestureRecognizer:gesture5];
    UITapGestureRecognizer *gesture6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap6)];
    [v6 addGestureRecognizer:gesture6];
    UITapGestureRecognizer *gesture7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap7)];
    [v7 addGestureRecognizer:gesture7];
    UITapGestureRecognizer *gesture8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap8)];
    [v8 addGestureRecognizer:gesture8];
    
    [self startBefore];
}

-(void)tap
{
    [self close:-2];
}

-(void)tap1
{
    [self close:0];
}

-(void)tap2
{
    [self close:1];
}

-(void)tap3
{
    [self close:2];
}

-(void)tap4
{
    [self close:3];
}

-(void)tap5
{
    [self close:4];
}

-(void)tap6
{
    [self close:5];
}

-(void)tap7
{
    [self close:6];
}

-(void)tap8
{
    [self close:7];
}
-(void)close
{
    [self close:-1];
}

// to do :
// -1 do nothing
// -2 cancel theme
// >=0 change theme
-(void)close:(int)index
{
    blank.userInteractionEnabled = NO;
    v1.userInteractionEnabled = NO;
    v2.userInteractionEnabled = NO;
    v3.userInteractionEnabled = NO;
    v4.userInteractionEnabled = NO;
    
    
    [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v4];
    CATransform3D transform4 = CATransform3DIdentity;
    transform4.m34 = 1.0 / 200.0;
    transform4 = CATransform3DRotate(transform4, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
    
    [UIView animateWithDuration:0.15 animations:^{
        v4.layer.transform = transform4;
    } completion:^(BOOL finished) {
        //3
        [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v3];
        CATransform3D transform3 = CATransform3DIdentity;
        transform3.m34 = 1.0 / 200.0;
        transform3 = CATransform3DRotate(transform3, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
        
        [UIView animateWithDuration:0.15 animations:^{
            v3.layer.transform = transform3;
        } completion:^(BOOL finished) {
            //2
            [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v2];
            CATransform3D transform2 = CATransform3DIdentity;
            transform2.m34 = 1.0 / 200.0;
            transform2 = CATransform3DRotate(transform2, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
            
            [UIView animateWithDuration:0.15 animations:^{
                v2.layer.transform = transform2;
            } completion:^(BOOL finished) {
                //1
                [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v1];
                CATransform3D transform1 = CATransform3DIdentity;
                transform1.m34 = 1.0 / 200.0;
                transform1 = CATransform3DRotate(transform1, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
                
                [UIView animateWithDuration:0.15 animations:^{
                    v1.layer.transform = transform1;
                } completion:^(BOOL finished) {
                    if (_delegate) {
                        if (index>=0) {
                            [_delegate tap:index];
                        }else if (index==-2) {
                            [_delegate cancelTheme];
                        }
                        
                    }
                }];
            }];
        }];
    }];
    
    v5.userInteractionEnabled = NO;
    v6.userInteractionEnabled = NO;
    v7.userInteractionEnabled = NO;
    v8.userInteractionEnabled = NO;
    
    [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v8];
    CATransform3D transform8 = CATransform3DIdentity;
    transform8.m34 = 1.0 / 200.0;
    transform8 = CATransform3DRotate(transform8, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
    
    [UIView animateWithDuration:0.15 animations:^{
        v8.layer.transform = transform8;
    } completion:^(BOOL finished) {
        //3
        [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v7];
        CATransform3D transform7 = CATransform3DIdentity;
        transform7.m34 = 1.0 / 200.0;
        transform7 = CATransform3DRotate(transform7, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
        
        [UIView animateWithDuration:0.15 animations:^{
            v7.layer.transform = transform7;
        } completion:^(BOOL finished) {
            //2
            [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v6];
            CATransform3D transform6 = CATransform3DIdentity;
            transform6.m34 = 1.0 / 200.0;
            transform6 = CATransform3DRotate(transform6, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
            
            [UIView animateWithDuration:0.15 animations:^{
                v6.layer.transform = transform6;
            } completion:^(BOOL finished) {
                [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v5];
                CATransform3D transform4 = CATransform3DIdentity;
                transform4.m34 = 1.0 / 200.0;
                transform4 = CATransform3DRotate(transform4, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
                
                [UIView animateWithDuration:0.15 animations:^{
                    v5.layer.transform = transform4;
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

-(void)open
{
    [self startBefore];
    
    [self setAnchorPoint:CGPointMake(1.0, 0.0) forView:v8];
    CATransform3D transform8 = CATransform3DIdentity;
    transform8.m34 = 1.0 / 200.0;
    transform8 = CATransform3DRotate(transform8, DEGREES_TO_RADIANS(0), 0.0f, 1.0f, 0.0f);
    
    [UIView animateWithDuration:0.2 animations:^{
        v8.layer.transform = transform8;
    } completion:^(BOOL finished) {
        
        // 2
        [self setAnchorPoint:CGPointMake(1.0, 0.0) forView:v6];
        CATransform3D transform7 = CATransform3DIdentity;
        transform7.m34 = 1.0 / 200.0;
        transform7 = CATransform3DRotate(transform7, DEGREES_TO_RADIANS(0), 0.0f, 1.0f, 0.0f);
        
        [UIView animateWithDuration:0.2 animations:^{
            v7.layer.transform = transform7;
        } completion:^(BOOL finished) {
            // 3
            [self setAnchorPoint:CGPointMake(1.0, 0.0) forView:v3];
            CATransform3D transform6 = CATransform3DIdentity;
            transform6.m34 = 1.0 / 200.0;
            transform6 = CATransform3DRotate(transform6, DEGREES_TO_RADIANS(0), 0.0f, 1.0f, 0.0f);
            
            [UIView animateWithDuration:0.2 animations:^{
                v6.layer.transform = transform6;
            } completion:^(BOOL finished) {
                // 4
                [self setAnchorPoint:CGPointMake(1.0, 0.0) forView:v8];
                CATransform3D transform5 = CATransform3DIdentity;
                transform5.m34 = 1.0 / 200.0;
                transform5 = CATransform3DRotate(transform5, DEGREES_TO_RADIANS(0), 0.0f, 1.0f, 0.0f);
                
                [UIView animateWithDuration:0.2 animations:^{
                    v5.layer.transform = transform5;
                } completion:^(BOOL finished) {
                    v5.userInteractionEnabled = YES;
                    v6.userInteractionEnabled = YES;
                    v7.userInteractionEnabled = YES;
                    v8.userInteractionEnabled = YES;
                    blank.userInteractionEnabled = YES;
                }];
            }];
        }];
        
    }];
    
    [self setAnchorPoint:CGPointMake(0, 0.0) forView:v1];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / 200.0;
    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(0), 0.0f, 1.0f, 0.0f);
    
    [UIView animateWithDuration:0.2 animations:^{
        v1.layer.transform = transform;
    } completion:^(BOOL finished) {
        // 2
        [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v2];
        CATransform3D transform2 = CATransform3DIdentity;
        transform2.m34 = 1.0 / 200.0;
        transform2 = CATransform3DRotate(transform2, DEGREES_TO_RADIANS(0), 0.0f, 1.0f, 0.0f);
        
        [UIView animateWithDuration:0.2 animations:^{
            v2.layer.transform = transform2;
        } completion:^(BOOL finished) {
            // 3
            [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v3];
            CATransform3D transform3 = CATransform3DIdentity;
            transform3.m34 = 1.0 / 200.0;
            transform3 = CATransform3DRotate(transform3, DEGREES_TO_RADIANS(0), 0.0f, 1.0f, 0.0f);
            
            [UIView animateWithDuration:0.2 animations:^{
                v3.layer.transform = transform3;
            } completion:^(BOOL finished) {
                // 4
                [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v4];
                CATransform3D transform4 = CATransform3DIdentity;
                transform4.m34 = 1.0 / 200.0;
                transform4 = CATransform3DRotate(transform4, DEGREES_TO_RADIANS(0), 0.0f, 1.0f, 0.0f);
                
                [UIView animateWithDuration:0.2 animations:^{
                    v4.layer.transform = transform4;
                } completion:^(BOOL finished) {
                    v1.userInteractionEnabled = YES;
                    v2.userInteractionEnabled = YES;
                    v3.userInteractionEnabled = YES;
                    v4.userInteractionEnabled = YES;
                    blank.userInteractionEnabled = YES;
                }];
            }];
        }];
        
    }];
    
    
    
}

-(void)startBefore
{
    [self setAnchorPoint:CGPointMake(0, 0.0) forView:v1];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / 200.0;
    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
    v1.layer.transform = transform;
    
    [self setAnchorPoint:CGPointMake(0.0, 0.0) forView:v2];
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = 1.0 / 200.0;
    transform2 = CATransform3DRotate(transform2, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
    v2.layer.transform = transform2;
    
    [self setAnchorPoint:CGPointMake(0.5, 0.0) forView:v3];
    CATransform3D transform3 = CATransform3DIdentity;
    transform3.m34 = 1.0 / 200.0;
    transform3 = CATransform3DRotate(transform3, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
    v3.layer.transform = transform3;
    
    [self setAnchorPoint:CGPointMake(0.5, 0.0) forView:v4];
    CATransform3D transform4 = CATransform3DIdentity;
    transform4.m34 = 1.0 / 200.0;
    transform4 = CATransform3DRotate(transform4, DEGREES_TO_RADIANS(-90), 0.0f, 1.0f, 0.0f);
    v4.layer.transform = transform4;
    
    //
    [self setAnchorPoint:CGPointMake(1, 0.0) forView:v5];
    CATransform3D transform5 = CATransform3DIdentity;
    transform5.m34 = 1.0 / 200.0;
    transform5 = CATransform3DRotate(transform5, DEGREES_TO_RADIANS(90), 0.0f, 1.0f, 0.0f);
    v5.layer.transform = transform5;
    
    [self setAnchorPoint:CGPointMake(1.0, 0.0) forView:v6];
    CATransform3D transform6 = CATransform3DIdentity;
    transform6.m34 = 1.0 / 200.0;
    transform6 = CATransform3DRotate(transform6, DEGREES_TO_RADIANS(90), 0.0f, 1.0f, 0.0f);
    v6.layer.transform = transform6;
    
    [self setAnchorPoint:CGPointMake(1.0, 0.0) forView:v7];
    CATransform3D transform7 = CATransform3DIdentity;
    transform7.m34 = 1.0 / 200.0;
    transform7 = CATransform3DRotate(transform7, DEGREES_TO_RADIANS(90), 0.0f, 1.0f, 0.0f);
    v7.layer.transform = transform7;
    
    [self setAnchorPoint:CGPointMake(1.0, 0.0) forView:v8];
    CATransform3D transform8 = CATransform3DIdentity;
    transform8.m34 = 1.0 / 200.0;
    transform8 = CATransform3DRotate(transform8, DEGREES_TO_RADIANS(90), 0.0f, 1.0f, 0.0f);
    v8.layer.transform = transform8;

    
    v1.userInteractionEnabled = NO;
    v2.userInteractionEnabled = NO;
    v3.userInteractionEnabled = NO;
    v4.userInteractionEnabled = NO;
 
    v5.userInteractionEnabled = NO;
    v6.userInteractionEnabled = NO;
    v7.userInteractionEnabled = NO;
    v8.userInteractionEnabled = NO;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

@end
