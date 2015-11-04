//
//  DownloadViewController.h
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadTableViewCell.h"
#import "DownloadTableViewCell2.h"
#import "DownloadManager.h"
#import "PlayManager.h"
#import "DBHelper.h"
#import "MusicHelper.h"

@interface DownloadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MusicDelegate>
@property (strong, nonatomic) UITableView *table;


+(DownloadViewController *)shared;

@end
