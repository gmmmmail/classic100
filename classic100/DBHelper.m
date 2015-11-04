//
//  DBHelper.m
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper{
    sqlite3* db;
}

// 繁体、简体不同数据库
/**
 关于之前在独立目录，现在要转移到共享目录的解决：
 
 如果之前目录存在db文件则将起拷贝到共享目录，否则将新db文件拷贝到共享目录
 
 */


-(void)copyDBByLanguage
{
    [self createMusicDir];
    
    NSString *documentDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbFilePath = [documentDirectory stringByAppendingPathComponent:@"music.db"];
    
    NSLog(@"db文件:%@",dbFilePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbFilePath]) {
        NSString *resourceDBPath;
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        /**
         en-US 英语
         zh-Hans / zh-Hans-US(ios9) 简体
         zh-Hant zh-HK / zh-Hant-US zh-HK zh-TW 繁体
         */
        
        
        if ([currentLanguage rangeOfString:@"zh-Hans"].location!=NSNotFound) {
            resourceDBPath = [[NSBundle mainBundle] pathForResource:@"music_jian" ofType:@"db"];
        }else if([currentLanguage rangeOfString:@"zh-Hant"].location!=NSNotFound ||     [currentLanguage rangeOfString:@"zh-HK"].location!=NSNotFound ||
                 [currentLanguage rangeOfString:@"zh-TW"].location!=NSNotFound){
            resourceDBPath = [[NSBundle mainBundle] pathForResource:@"music_fan" ofType:@"db"];
        }else{
            resourceDBPath = [[NSBundle mainBundle] pathForResource:@"music_en" ofType:@"db"];
        }
        
        NSData *data = [NSData dataWithContentsOfFile:resourceDBPath];
        [[NSFileManager defaultManager] createFileAtPath:dbFilePath contents:data attributes:nil];
        NSError *error = nil;
        [[NSURL fileURLWithPath:dbFilePath] setResourceValue: [NSNumber numberWithBool: YES]
                                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
    };
}

-(void)createMusicDir
{
    NSString *filePath = [NSString stringWithFormat:@"%@/music",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
        NSError *error = nil;
        [[NSURL fileURLWithPath:filePath] setResourceValue: [NSNumber numberWithBool: YES]
                                                    forKey: NSURLIsExcludedFromBackupKey error: &error];
    }
}

-(void)initDB
{
    int version = -1;
    if ([self openDB]) {
        // 创建版本信息表
        NSString* sql = @"create table if not exists DBVersionInfo(version_number int);";
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL)!=SQLITE_OK) {
            NSLog(@"version表创建失败");
        }else{
            NSString* esql = @"select version_number from dbversioninfo";
            sqlite3_stmt *statement;
            if(sqlite3_prepare_v2(db, [esql UTF8String], -1, &statement, NULL)==SQLITE_OK){
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    version = sqlite3_column_int(statement, 0);
                }else{
                    NSLog(@"version表无数据");
                    // 插入初始化数据
                    NSString* sql = @"insert into dbversioninfo(version_number) values(-1)";
                    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL)!=SQLITE_OK){
                        NSLog(@"version表插入数据失败");
                    }
                }
            }else{
                NSLog(@"预处理失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
        sqlite3_close(db);
    }
    
    if([self openDB]){
        NSString* sql;
        NSString* path = [[NSBundle mainBundle]pathForResource:@"table" ofType:@"sql"];
        sql = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        sqlite3_exec(db, [sql UTF8String], NULL, NULL, nil);
    }
    sqlite3_close(db);
}


-(void)setMusiclUrl:(NSString *)mp3Url andImageUrl:(NSString*)imgUrl whereID:(NSString *)musicID
{
    if ([self openDB]) {
        NSString* sql = @"update music set mp3URL = ?,imageURL=? where musicid = ?";
        sqlite3_stmt* statment;
        const char* err;
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment,&err)==SQLITE_OK){
            sqlite3_bind_text(statment, 1, [mp3Url UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statment, 2, [imgUrl UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statment, 3, [musicID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statment);
        }
        sqlite3_close(db);
    }
}

-(void)deleteFilePathbyID:(NSString *)musicID
{
    if ([self openDB]) {
        NSString* sql = @"update music set filepath = '', isdownload='0' where musicid = ?";
        sqlite3_stmt* statment;
        const char* err;
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment,&err)==SQLITE_OK){
            sqlite3_bind_text(statment, 1, [musicID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statment);
        }
        sqlite3_close(db);
    }
}

-(void)updateFilePath:(NSString *)filePath whereID:(NSString *)musicID
{
    if ([self openDB]) {
        NSString* sql = @"update music set filepath = ?, isdownload='1' where musicid = ?";
        sqlite3_stmt* statment;
        const char* err;
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment,&err)==SQLITE_OK){
            sqlite3_bind_text(statment, 1, [filePath UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statment, 2, [musicID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statment);
        }
        sqlite3_close(db);
    }
}

-(Music *)musiclByID:(NSString *)musicID
{
    Music *music = [Music new];
    music.mp3FilePath = @"";
    if ([self openDB]) {
        sqlite3_stmt *statement;
        NSString* sql = @"select filepath,musicname,imageUrl from music where musicid = ?";
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK){
            sqlite3_bind_text(statement, 1, [musicID UTF8String], -1, SQLITE_TRANSIENT);
            if (sqlite3_step(statement)==SQLITE_ROW) {
                char* url = (char*)sqlite3_column_text(statement, 0);
                char* musicname = (char*)sqlite3_column_text(statement, 1);
                char* imageUrl = (char*)sqlite3_column_text(statement, 2);
                if (musicname) {
                    music.musicName = [NSString stringWithUTF8String:musicname];
                }
                if (url) {
                    music.mp3FilePath = [NSString stringWithUTF8String:url];
                }
                if (imageUrl) {
                    music.imageUrl = [NSString stringWithUTF8String:imageUrl];
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return music;
}

-(Music *)musiclUrlByID:(NSString *)musicID
{
    Music *music = [Music new];
    music.mp3Url = @"";
    music.imageUrl = @"";
    if ([self openDB]) {
        sqlite3_stmt *statement;
        NSString* sql = @"select mp3url,imageUrl from music where musicid = ?";
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK){
            sqlite3_bind_text(statement, 1, [musicID UTF8String], -1, SQLITE_TRANSIENT);
            if (sqlite3_step(statement)==SQLITE_ROW) {
                char* url = (char*)sqlite3_column_text(statement, 0);
                char* imageUrl = (char*)sqlite3_column_text(statement, 1);
                if (url) {
                    music.mp3Url = [NSString stringWithUTF8String:url];
                }
                if (imageUrl) {
                    music.imageUrl = [NSString stringWithUTF8String:imageUrl];
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return music;
}

-(NSMutableArray *)selectDownloads
{
    NSMutableArray *array = [NSMutableArray new];
    if ([self openDB]) {
        sqlite3_stmt *statement;
        NSString* sql = @"select musicid,musicname from music where isdownload='1'";
        //        NSLog(@"%i",sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL));
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *musicid = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                NSString *musicname = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                
                Music *music = [Music new];
                music.musicID = musicid;
                music.musicName = musicname;
                [array addObject:music];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return array;
}

-(NSMutableArray *)selectMusics
{
    NSMutableArray *array = [NSMutableArray new];
    if ([self openDB]) {
        sqlite3_stmt *statement;
        NSString* sql = @"select musicid,musicname,isdownload from music";
        //        NSLog(@"%i",sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL));
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *musicid = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                NSString *musicname = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                char* tmp = (char*)sqlite3_column_text(statement, 2);
                NSString *isdownload = @"";
                if (tmp) {
                    isdownload = [NSString stringWithUTF8String:tmp];
                }
                
                Music *music = [Music new];
                music.musicID = musicid;
                music.musicName = musicname;
                music.isDownload = isdownload;
                [array addObject:music];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return array;
}

-(NSMutableArray*)selectAllMusicIDs
{
    NSMutableArray *array = [NSMutableArray new];
    if ([self openDB]) {
        sqlite3_stmt *statement;
        NSString* sql = @"select musicid,musicname from music";
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *musicid = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                [array addObject:musicid];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return array;
}

-(BOOL)openDB
{
    NSString *documentDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"music.db"];
    
//    NSLog(@"%@",dbPath);
    
    if (sqlite3_open([dbPath UTF8String], &db)!=SQLITE_OK) {
        NSLog(@"数据库打开失败");
        sqlite3_close(db);
        return false;
    }else{
        return  true;
    }
}

@end
