//
//  DownloadManager.h
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadObj.h"
#import "MKNetworkKit.h"
#import "DBHelper.h"
#import "MusicHelper.h"

static NSMutableArray *downloadObjs;
@interface DownloadManager : NSObject

+(NSMutableArray*) downloadList;

+(void)addDownload:(DownloadObj*)obj;

+(void)writeAppController:(NSString*)v;
+(NSString*)readAppController;

@end
