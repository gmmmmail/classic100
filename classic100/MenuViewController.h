//
//  MenuViewController.h
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLFoldView.h"
#import <StoreKit/StoreKit.h>

@interface MenuViewController : UIViewController<UIActionSheetDelegate,LLFoldViewDelegate,SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *timeOffLB_ipad;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UISwitch *switchBT;

@property (weak, nonatomic) IBOutlet UILabel *timeLB_iphone;
@property (weak, nonatomic) IBOutlet UISwitch *switchBT_iphone;



@property (weak, nonatomic) IBOutlet UIButton *MusicFavor;
@property (weak, nonatomic) IBOutlet UIButton *PlayModeBT;
@property (weak, nonatomic) IBOutlet UIButton *MusicBT;
@property (weak, nonatomic) IBOutlet UIButton *ThemeBT;

@property (weak, nonatomic) IBOutlet UIButton *dBT;
@end
