//
//  AudioQueueId.m
//  ClassicalMusic
//
//  Created by lai on 14-9-24.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "AudioQueueId.h"

@implementation AudioQueueId

-(id)initWithUrl:(NSURL *)url andCount:(int)count
{
    // 对父类初始化后，再对子类初始化
    if (self == [super init]) {
        self.url = url;
        self.count = count;
    }
    return self;
}

// 判断是否为相同对queueid
-(BOOL)isEqual:(id)object
{
    if (object == NULL) {
        return NO;
    }
    if ([object class] != [AudioQueueId class]) {
        return NO;
    }
    return [((AudioQueueId*)object).url isEqual:self.url]&&((AudioQueueId*)object).count == self.count;
}

// 重写NSObject方法
-(NSString *)description
{
    return [self.url description];
}

@end
