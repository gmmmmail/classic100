//
//  MusicViewController.h
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicTableViewCell.h"
#import "REFrostedViewController.h"
#import "CustomNavigationController.h"
#import "MainViewController.h"
#import "UINavigationBar+customBar.h"
#import <iAd/iAd.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MusicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate>
@property (strong, nonatomic) UITableView *table;



//+(MusicViewController*)shared;


@end
