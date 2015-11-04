//
//  MusicTableViewCell.h
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *musicNameLB;
@property (weak, nonatomic) IBOutlet UILabel *musicidLB;

@property (weak, nonatomic) IBOutlet UIButton *downloadBT;
@end
