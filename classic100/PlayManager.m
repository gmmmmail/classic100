//
//  PlayManager.m
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "PlayManager.h"

@implementation PlayManager

+(NSMutableArray *)list
{
    @synchronized(self)
    {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            if (musics==nil) {
                musics = [NSMutableArray new];
            }
        });
    }
    return musics;
}

+(NSMutableArray *)images
{
    @synchronized(self)
    {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            if (images==nil) {
                images = [NSMutableArray new];
                [images addObject:@"http://p1.img.cctvpic.com/fmspic/cc/image/29364/29364.jpg"];
                [images addObject:@"http://p3.img.cctvpic.com/fmspic/cc/image/27460/27460.jpg"];
                [images addObject:@"http://p3.img.cctvpic.com/fmspic/cc/image/29819.03/29819.03.jpg"];
                [images addObject:@"http://p1.img.cctvpic.com/fmspic/cc/image/24131/24131.jpg"];
                [images addObject:@"http://p4.img.cctvpic.com/fmspic/cc/image/28912/28912.jpg"];
                [images addObject:@"http://p1.img.cctvpic.com/fmspic/cc/image/32552/32552.jpg"];
                [images addObject:@"http://p4.img.cctvpic.com/fmspic/cc/image/29370/29370.jpg"];
                [images addObject:@"http://p5.img.cctvpic.com/fmspic/cc/image/16743/16743.jpg"];
                [images addObject:@"http://p2.img.cctvpic.com/fmspic/cc/image/29652/29652.jpg"];
                [images addObject:@"http://p3.img.cctvpic.com/fmspic/vms/image/2013/09/25/VSET_1380086424197515.jpg"];
                [images addObject:@"http://p3.img.cctvpic.com/fmspic/vms/image/2012/05/18/VSET_1337304101115879.jpg"];
                [images addObject:@"http://p1.img.cctvpic.com/fmspic/vms/image/2013/08/08/VSET_1375939580863560.jpg"];
            }
        });
    }
    return images;
}

@end
