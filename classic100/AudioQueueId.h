//
//  AudioQueueId.h
//  ClassicalMusic
//
//  Created by lai on 14-9-24.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioQueueId : NSObject

@property (readwrite) int count;
@property (readwrite) NSURL* url;

// 根据url生成id
-(id) initWithUrl:(NSURL*)url andCount:(int)count;

@end
