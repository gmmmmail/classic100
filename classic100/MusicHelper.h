//
//  MusicHelper.h
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"
#import "DBHelper.h"

@protocol MusicDelegate<NSObject>
@optional
-(void) mp3Url:(NSString*)mp3Url musicID:(NSString*)musicID imageUrl:(NSString*)imageURl;
@end

@interface MusicHelper : NSObject

@property (readwrite, retain) id<MusicDelegate> delegate;
-(void)mp3UrlByMusicID:(NSString *)musicID Url2:(BOOL)isUrl2;
@end
