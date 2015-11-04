//
//  AppDelegate.m
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationBar+customBar.h"
#import "MainViewController.h"
#import "REFrostedViewController.h"
#import "MenuViewController.h"
#import "CustomNavigationController.h"
#import "MusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MobClick.h"
#import <iAd/iAd.h>
#import "DownloadManager.h"
#import "iRate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    REFrostedViewController *frostedViewController;
}


-(void)done
{
    NSString *f = [MobClick getConfigParams:@"appControll2"];
    if (f) {
        [DownloadManager writeAppController:f];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
     设置状态栏:View controller-based status bar appearance:NO
     http://blog.csdn.net/gaoyp/article/details/18406501
    */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    /************* umeng ***************/
    [MobClick startWithAppkey:@"5527e1b7fd98c5a419000686" reportPolicy:REALTIME   channelId:@"App Store"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(done)
                                                 name:UMOnlineConfigDidFinishedNotification
                                               object:nil];
    
    /************* rate ***************/
    [iRate sharedInstance].remindPeriod = 15;
    
    
    NSError* error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    MainViewController *mainController = [MainViewController shared];
    CustomNavigationController *navi = [[CustomNavigationController alloc] initWithRootViewController:mainController];
    [navi.navigationBar customNavigationBar];
    
    MenuViewController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navi menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = NO;
    frostedViewController.backgroundFadeAmount = 0.1;
    
    self.window.rootViewController = frostedViewController;
    
    [[DBHelper new] copyDBByLanguage];
//    [[DBHelper new] initDB];
    
    [self copyThemeFile];
    
    return YES;
}

-(void)copyThemeFile
{
    NSString *configPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"theme.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:configPath] == NO) {
        [[NSFileManager defaultManager] createFileAtPath:configPath contents:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"]] attributes:nil];
        NSError *error = nil;
        [[NSURL fileURLWithPath:configPath] setResourceValue: [NSNumber numberWithBool: YES]
                                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
    }
}



// 繁体、简体不同数据库
-(void)copyDBByLanguage
{
    //之前版本
    NSString *documentDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbFilePath = [documentDirectory stringByAppendingPathComponent:@"music.db"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbFilePath]) {
        NSString *resourceDBPath;
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hant"]) {
            resourceDBPath = [[NSBundle mainBundle] pathForResource:@"music_fan" ofType:@"db"];
        }else{
           resourceDBPath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"db"];
        }
        
        NSData *data = [NSData dataWithContentsOfFile:resourceDBPath];
        [[NSFileManager defaultManager] createFileAtPath:dbFilePath contents:data attributes:nil];
        NSError *error = nil;
        [[NSURL fileURLWithPath:dbFilePath] setResourceValue: [NSNumber numberWithBool: YES]
                                                                   forKey: NSURLIsExcludedFromBackupKey error: &error];
        if (error) {
            NSLog(@"error->%@",error);
        }
    };
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
