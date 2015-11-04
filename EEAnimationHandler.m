//
// EEAnimationHandler.m
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

#import "EEAnimationHandler.h"

#pragma mark - CAAnimation Category
@implementation CAAnimation (handle)

@dynamic startHandlerBlock, stopHandlerBlock;
@dynamic animationKey;
@dynamic addedLayer;

@end

@interface CAAnimation (identifier)

@property (nonatomic, strong) NSString *identifier;

@end

@implementation CAAnimation (identifier)

@dynamic identifier;

@end

#pragma mark - NSMutableArray Categoty
@interface NSMutableArray (handleAnimes)
- (void)addAnimation:(CAAnimation *)animation;
- (void)removeAnimation:(CAAnimation *)animation;

@end

@implementation NSMutableArray (handleAnimes)

- (void)addAnimation:(CAAnimation *)animation
{
    CALayer *layer = animation.addedLayer;
    if (!layer) {
        return;
    }
    
    if ([layer.animationKeys count] == 0) {
        [layer addAnimation:animation forKey:animation.animationKey];
    }else {
        [self addObject:animation];
    }
}

- (void)removeAnimation:(CAAnimation *)animation
{
    for (CAAnimation *anim in self) {
        // animは違うのでidで比較
        if ([anim.identifier isEqualToString:animation.identifier]) {
            [self removeObject:anim];
            break;
        }
    }
    
    if (self.count != 0) {
        CAAnimation *nextAnim = [self objectAtIndex:0];
        CALayer *layer = nextAnim.addedLayer;
        if (layer) {
            [layer addAnimation:nextAnim forKey:nextAnim.animationKey];
        }
    }
}

@end


#pragma mark - Private Category
@interface EEAnimationHandler()
{
    NSMutableSet *_layers;
}
@property (nonatomic, strong) NSMutableSet *layers;

- (NSString *)identifier;
- (void)registrateAnimation:(CAAnimation *)animation;
@end

@implementation EEAnimationHandler

@synthesize layers = _layers;

static EEAnimationHandler *sharedHandler;

+ (EEAnimationHandler *)sharedHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedHandler) {
            sharedHandler = [[self alloc] init];
        }
    });
    
    return sharedHandler;
}

- (id)init
{
    self = [super init];
    if (self) {
        _layers = [NSMutableSet set];
    }
    
    return self;
}

#pragma mark - Public
- (NSString *)registerAnimation:(CAAnimation *)animation toLayer:(CALayer *)layer forKey:(NSString *)aKey
{
    // registration
    NSString *key;
    if (aKey) {
        key = aKey;
    }else {
        key = @"";
    }
    
    if (!layer) {return nil;}
    if (!animation) {return nil;}
    
    // 
    animation.animationKey = key;
    animation.addedLayer = layer;
    
    NSString *identifier = [self identifier];
    animation.identifier = identifier;
    
    // delegate
    animation.delegate = self;
    
    // animation start
    [self registrateAnimation:animation];
    
    return identifier;
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - Animation Delegate
- (void)animationDidStart:(CAAnimation *)anim
{
    if (anim.startHandlerBlock) anim.startHandlerBlock(anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim.stopHandlerBlock) anim.stopHandlerBlock(anim, flag);
    
    
    // remove animation
    CALayer *layer = anim.addedLayer;
    
    if (!layer) {
        return;
    }
    
    NSMutableDictionary *layerInfo;
    
    for (NSMutableDictionary *dict in self.layers) {
        CALayer *aLayer = (CALayer *)[dict objectForKey:@"layer"];
        if ([aLayer isEqual:layer]) {
            layerInfo = dict;
            break;
        }
    }
    
    if (layerInfo) {
        NSMutableArray *animes = [layerInfo objectForKey:@"animes"];
        [animes removeAnimation:anim];
    }
}

#pragma mark - Private
- (NSString *)identifier
{
    CFUUIDRef   uuid;
    NSString*   identifier;
    uuid = CFUUIDCreate(NULL);
    identifier = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    return identifier;
}

- (void)registrateAnimation:(CAAnimation *)animation
{
    CALayer *layer = animation.addedLayer;
    
    if (!layer) {
        return;
    }
    
    NSMutableDictionary *layerInfo;
    for (NSMutableDictionary *dict in self.layers) {
        CALayer *aLayer = (CALayer *)[dict objectForKey:@"layer"];
        if ([aLayer isEqual:layer]) {
            layerInfo = dict;
            break;
        }
    }
    
    if (layerInfo) {
        
        NSMutableArray *animes = [layerInfo objectForKey:@"animes"];
        [animes addAnimation:animation];
        
    }else {
        
        NSMutableArray *animes = [NSMutableArray array];
        NSArray *objects = [NSArray arrayWithObjects:layer, animes, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"layer", @"animes", nil];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        
        [self.layers addObject:dict];
        
        [animes addAnimation:animation];
    }
}

@end
