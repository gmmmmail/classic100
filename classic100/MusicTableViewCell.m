//
//  MusicTableViewCell.m
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "DownloadManager.h"

@implementation MusicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)download:(id)sender {
    DownloadObj *obj = [DownloadObj new];
    obj.musicID = _musicidLB.text;
    obj.musicName = _musicNameLB.text;
    [DownloadManager addDownload:obj];
    _downloadBT.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
