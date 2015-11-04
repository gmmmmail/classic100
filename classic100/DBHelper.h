//
//  DBHelper.h
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Music.h"

@interface DBHelper : NSObject

-(BOOL)openDB;
-(void)copyDBByLanguage;

// 更新网络播放地址
-(void)setMusiclUrl:(NSString *)mp3Url andImageUrl:(NSString*)imgUrl whereID:(NSString *)musicID;

-(void)updateFilePath:(NSString *)filePath whereID:(NSString *)musicID;

-(void)deleteFilePathbyID:(NSString *)musicID;

-(Music*)musiclUrlByID:(NSString *)musicID;

-(Music*)musiclByID:(NSString *)musicID;

-(NSMutableArray *)selectMusics;
-(NSMutableArray *)selectAllMusicIDs;
-(NSMutableArray *)selectDownloads;

-(void)initDB;

@end
