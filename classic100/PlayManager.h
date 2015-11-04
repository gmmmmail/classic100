//
//  PlayManager.h
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSMutableArray *musics;
static NSMutableArray *images;

@interface PlayManager : NSObject
+(NSMutableArray*) list;
+(NSMutableArray*) images;
@end
