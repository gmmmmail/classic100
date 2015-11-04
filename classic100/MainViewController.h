//
//  MainViewController.h
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "MusicViewController.h"
#import "CustomNavigationController.h"
#import "UINavigationBar+customBar.h"
#import "STKAudioPlayer.h"
#import "AudioQueueId.h"
#import "PlayManager.h"
#import "Pop.h"
#import "MusicHelper.h"
#import <iAd/iAd.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

typedef enum{
    Circulation,
    Single,
    Random
}PlayMode;

@interface MainViewController : UIViewController<STKAudioPlayerDelegate,POPAnimationDelegate,MusicDelegate,STKDataSourceDelegate,ADBannerViewDelegate, GADBannerViewDelegate>

@property (strong, nonatomic) UIImageView *albumImage;

@property (weak, nonatomic) IBOutlet UIView *container;
//todo:delete
@property (weak, nonatomic) IBOutlet UIView *container_Ipad;

@property (weak, nonatomic) IBOutlet UIButton *playBT;
@property (weak, nonatomic) IBOutlet UIButton *previousBT;
@property (weak, nonatomic) IBOutlet UIButton *nextBT;
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLB;
@property (weak, nonatomic) IBOutlet UIButton *pauseBT;

@property (strong, nonatomic)  NSString *currentPlayerID;
@property (strong, nonatomic)  NSString *currentImageUrl;

@property (assign, nonatomic)  NSInteger playMode;

-(void)play:(NSString *)musicID;
-(void)pauseMusic;

+(MainViewController*)shared;
@end
