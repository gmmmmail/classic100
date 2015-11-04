//
//  MusicHelper.m
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MusicHelper.h"

@implementation MusicHelper

// isUrl2 default no
-(void)mp3UrlByMusicID:(NSString *)musicID Url2:(BOOL)isUrl2
{
    if (!musicID) {
        return;
    }
    DBHelper *dbHelper = [DBHelper new];
//    Music *music = [dbHelper musiclUrlByID:musicID];
//    if (![music.mp3Url isEqualToString:@""]) {
//        if (_delegate) {
//            [_delegate mp3Url:music.mp3Url musicID:musicID imageUrl:music.imageUrl];
//        }
//        return;
//    }
    
    NSString* url = [[@"/api/getIpadVideoInfo.do?pid=" stringByAppendingString:musicID] stringByAppendingString:@"&tai=dajuyuan"];
    MKNetworkEngine *engin = [[MKNetworkEngine alloc] initWithHostName:@"vdn.apps.cntv.cn" customHeaderFields:nil];
    MKNetworkOperation* op = [engin operationWithPath:url];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString* result = [completedOperation responseString];
        
        NSRange range = [result rangeOfString:@"{"];
        NSInteger start = range.location;
        
        range = [result rangeOfString:@";getHtml5VideoData(html5VideoData);"];
        NSInteger end = range.location;
        
        NSInteger length = end - start;
        range.location = start;
        range.length = length-1;
        
        result = [result substringWithRange:range];
        
        // json解析
        id obj = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSString* mp3URL;
        if (!isUrl2) {
            id tmp = [[[obj objectForKey:@"video"] objectForKey:@"chapters"] lastObject];
            mp3URL = [tmp objectForKey:@"url"];
        }else{
            id tmp = [[[obj objectForKey:@"video"] objectForKey:@"chapters2"] lastObject];
            mp3URL = [tmp objectForKey:@"url"];
        }
        NSString* imageUrl = [[[[obj objectForKey:@"video"] objectForKey:@"chapters"] lastObject] objectForKey:@"image"];
        // 更新数据库
        [dbHelper setMusiclUrl:mp3URL andImageUrl:imageUrl whereID:musicID];
        
        if (_delegate) {
            [_delegate mp3Url:mp3URL musicID:musicID imageUrl:imageUrl];
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        // to do
    }];
    [engin enqueueOperation:op];
}

@end
