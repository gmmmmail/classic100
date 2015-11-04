//
//  DownloadManager.m
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "DownloadManager.h"
#import "EEHUDView.h"

static BOOL isRunning;
static MusicHelper *musicHelper;
@implementation DownloadManager

+(void)writeAppController:(NSString *)v
{
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"theme.plist"];
    NSMutableDictionary *theme = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    [theme setObject:v forKey:@"appControll"];
    [theme writeToFile:fullPath atomically:NO];
}

+(NSString *)readAppController
{
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"theme.plist"];
    NSMutableDictionary *theme = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    NSString *f = [theme objectForKey:@"appControll"];
    if (!f) {
        return @"0";
    }
    return f;
}

+(NSMutableArray *)downloadList
{
    @synchronized(self)
    {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            if (downloadObjs==nil) {
                downloadObjs = [NSMutableArray new];
                isRunning = false;
            }
        });
    }
    return downloadObjs;
}

+(void)addDownload:(DownloadObj *)obj
{
    BOOL flag = false;
    for (DownloadObj *temp in [DownloadManager downloadList]) {
        if ([temp.musicID isEqualToString:obj.musicID]) {
            flag = true;
            break;
        }
    }
    if (flag) {
        [EEHUDView growlWithMessage:NSLocalizedString(@"downloading", @"")
                          showStyle:EEHUDViewShowStyleFadeIn
                          hideStyle:EEHUDViewHideStyleFadeOut
                    resultViewStyle:EEHUDResultViewStyleOK
                           showTime:1.0];
        return;
    }else{
        [EEHUDView growlWithMessage:NSLocalizedString(@"add to download list", @"")
                          showStyle:EEHUDViewShowStyleFadeIn
                          hideStyle:EEHUDViewHideStyleFadeOut
                    resultViewStyle:EEHUDResultViewStyleOK
                           showTime:1.0];
        
    }
    [[DownloadManager downloadList] addObject:obj];
    if (!isRunning) {
        [self next];
    }
}

+(void)next
{
    if ([DownloadManager downloadList].count==0) {
        return;
    }
    DownloadObj *obj = [[DownloadManager downloadList] objectAtIndex:0];
    isRunning = true;
    
    NSString *filePath = [NSString stringWithFormat:@"%@/music/%@.mp3",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],obj.musicID];
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        [[DownloadManager downloadList] removeObject:obj];
//        [DownloadManager next];
//        isRunning = false;
//        return;
//    }
    DBHelper *dbHelper = [DBHelper new];
    NSString *mp3Url = [dbHelper musiclUrlByID:obj.musicID].mp3Url;
    if (![mp3Url isEqualToString:@""]) {
        MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"" customHeaderFields:nil];
        MKNetworkOperation *op = [engine operationWithURLString:mp3Url];
        [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath append:YES]];
        [op onDownloadProgressChanged:^(double progress) {
            obj.progress = [NSString stringWithFormat:@"%.0f%%",progress*100];
            int f = [[NSString stringWithFormat:@"%.0f",progress*100] intValue];
            if (f%5==0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadChange" object:nil];
            }
        }];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            isRunning = false;
            // 更新数据库:isDownload、filepath
            [[DBHelper new] updateFilePath:filePath whereID:obj.musicID];
            [[DownloadManager downloadList] removeObject:obj];
            [DownloadManager next];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OneFinished" object:nil];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            isRunning = false;
            [[DownloadManager downloadList] removeObject:obj];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadChange" object:nil];
            [EEHUDView growlWithMessage:NSLocalizedString(@"download error", @"")
                              showStyle:EEHUDViewShowStyleFadeIn
                              hideStyle:EEHUDViewHideStyleFadeOut
                        resultViewStyle:EEHUDResultViewStyleNG
                               showTime:1.0];
            [DownloadManager next];
        }];
        [engine enqueueOperation:op];
    }else{
        NSString* url = [[@"/api/getIpadVideoInfo.do?pid=" stringByAppendingString:obj.musicID] stringByAppendingString:@"&tai=dajuyuan"];
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
            id jsonObj = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSString *mp3Url = [[[[jsonObj objectForKey:@"video"] objectForKey:@"chapters"] lastObject] objectForKey:@"url"];
            NSString *imageUrl = [[[[jsonObj objectForKey:@"video"] objectForKey:@"chapters"] lastObject] objectForKey:@"image"];
            [dbHelper setMusiclUrl:mp3Url andImageUrl:imageUrl whereID:obj.musicID];
            
            MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"" customHeaderFields:nil];
            MKNetworkOperation *op = [engine operationWithURLString:mp3Url];
            [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath append:YES]];
            [op onDownloadProgressChanged:^(double progress) {
                obj.progress = [NSString stringWithFormat:@"%.0f%%",progress*100];
                int f = [[NSString stringWithFormat:@"%.0f",progress*100] intValue];
                if (f%5==0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadChange" object:nil];
                }
            }];
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                isRunning = false;
                // 更新数据库:isDownload、filepath
                [[DBHelper new] updateFilePath:filePath whereID:obj.musicID];
                [[DownloadManager downloadList] removeObject:obj];
                [DownloadManager next];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OneFinished" object:nil];
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                isRunning = false;
                [[DownloadManager downloadList] removeObject:obj];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadChange" object:nil];
                [EEHUDView growlWithMessage:NSLocalizedString(@"download error", @"")
                                  showStyle:EEHUDViewShowStyleFadeIn
                                  hideStyle:EEHUDViewHideStyleFadeOut
                            resultViewStyle:EEHUDResultViewStyleNG
                                   showTime:1.0];
                [DownloadManager next];
            }];
            [engine enqueueOperation:op];
            
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            isRunning = false;
            [[DownloadManager downloadList] removeObject:obj];
            [EEHUDView growlWithMessage:NSLocalizedString(@"download error", @"")
                              showStyle:EEHUDViewShowStyleFadeIn
                              hideStyle:EEHUDViewHideStyleFadeOut
                        resultViewStyle:EEHUDResultViewStyleNG
                               showTime:1.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadChange" object:nil];
            [DownloadManager next];
        }];
        [engin enqueueOperation:op];
    }
}

@end
