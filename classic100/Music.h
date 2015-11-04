//
//  Music.h
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject

@property(nonatomic,strong) NSString *musicID;

@property(nonatomic,strong) NSString *musicName;

@property(nonatomic,strong) NSString *mp3Url;

@property(nonatomic,strong) NSString *imageUrl;

@property(nonatomic,strong) NSString *mp3FilePath;

@property(nonatomic,strong) NSString *isDownload;

@end
