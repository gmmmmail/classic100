//
//  MusicViewController.m
//  classic100
//
//  Created by lai on 15/4/7.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MusicViewController.h"
#import "EEHUDView.h"
#import "MusicHelper.h"
#import "DownloadManager.h"

@interface MusicViewController ()
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@end

static GADBannerView *gAdBannerView;
static BOOL IADCanLoad = true;
@implementation MusicViewController{
    NSMutableArray *data;
    int currentPlayedIndex;
    BOOL flag;
}


- (void)initIAdBanner
{
    if (IADCanLoad && !self.iAdBannerView ) {
        CGRect rect = CGRectMake(0, self.view.frame.size.height-50, 0, 50);
        self.iAdBannerView = [[ADBannerView alloc] initWithFrame:rect];
        self.iAdBannerView.delegate = self;
        [self.view addSubview:self.iAdBannerView];
    }else{
        [self initAdMob];
    }
}


-(void)initAdMob
{
    if (!gAdBannerView) {
        gAdBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, self.view.frame.size.height-50)];
        gAdBannerView.adUnitID = @"ca-app-pub-2857102944322752/6811981022";
        gAdBannerView.tag = 11;
        gAdBannerView.rootViewController = self;
        [self.view addSubview:gAdBannerView];
        [gAdBannerView loadRequest:[GADRequest request]];
    }
    if (![self.view viewWithTag:11]) {
        [self.view addSubview:gAdBannerView];
        
    }
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
}

// http://stackoverflow.com/questions/16908758/iad-didfailtoreceiveadwitherror-always-called
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (IADCanLoad) {
        IADCanLoad = false;
    }
    if (self.iAdBannerView) {
        self.iAdBannerView.hidden = YES;
    }
    [self initAdMob];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initIAdBanner];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleView.text = NSLocalizedString(@"100 songs", @"");
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleView;
    
    if ([[DownloadManager readAppController] isEqualToString:@"1"]) {
        flag=true;
    }else{
        flag=false;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGSize appSize = [[UIScreen mainScreen] applicationFrame].size;
    CGSize navSize = self.navigationController.navigationBar.frame.size;
    CGSize statusSize = [[UIApplication sharedApplication] statusBarFrame].size;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, statusSize.height+navSize.height, appSize.width, appSize.height-navSize.height-50) style:UITableViewStylePlain];
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"theme.plist"];
    NSMutableDictionary *theme = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    int value = [[theme objectForKey:@"theme"] intValue];
    if (value==0) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    }else if(value==1){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    }else if(value==2){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
    }else if(value==3){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg4.png"]];
    }else if(value==4){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg5.png"]];
    }else if(value==5){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg6.png"]];
    }else if(value==6){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg7.png"]];
    }else if(value==7){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg8.png"]];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 23)];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu.png"]];
    [button addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 23)];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listen.png"]];
    [button addTarget:self action:@selector(showMain) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    data = [[DBHelper new] selectMusics];
    [_table reloadData];
    
    if ([MainViewController shared].currentPlayerID) {
        for (int i=0; i<data.count; i++) {
            Music *m = [data objectAtIndex:i];
            if ([m.musicID isEqualToString:[MainViewController shared].currentPlayerID]) {
                currentPlayedIndex = i;
                float max = _table.contentSize.height-_table.frame.size.height;
                if (60*i>max) {
                    [_table setContentOffset:CGPointMake(0, max) animated:NO];
                }else{
                    [_table setContentOffset:CGPointMake(0, 60*i) animated:NO];
                }
                
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([PlayManager list].count!=100) {
        [[PlayManager list] removeAllObjects];
        for (NSString *musicID in [[DBHelper new] selectAllMusicIDs]) {
            [[PlayManager list] addObject:musicID];
        }
    }
    
    Music *music = [data objectAtIndex:indexPath.row];
    
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[MainViewController shared]];
    [nav.navigationBar customNavigationBar];
    [[MainViewController shared] play:music.musicID];
    
    self.frostedViewController.contentViewController = nav;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MusicTableViewCell" owner:self options:nil] lastObject];
        cell.musicidLB.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (flag) {
            cell.downloadBT.hidden = NO;
            [cell.downloadBT setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
        }else{
            cell.downloadBT.hidden = YES;
        }
    }
    if (indexPath.row == currentPlayedIndex) {
        [cell.musicNameLB setTextColor:[UIColor redColor]];
    }else{
        [cell.musicNameLB setTextColor:[UIColor whiteColor]];
    }
    Music *music = [data objectAtIndex:indexPath.row];
    cell.musicNameLB.text = music.musicName;
    cell.musicidLB.text = music.musicID;
    if ([music.isDownload isEqualToString:@"1"]) {
        cell.downloadBT.hidden = YES;
    }else{
        cell.downloadBT.hidden = NO;
    }
    
    if (flag) {
        for (DownloadObj *obj in [DownloadManager downloadList]) {
            if ([obj.musicID isEqualToString:music.musicID]) {
                cell.downloadBT.hidden = YES;
            }else{
                cell.downloadBT.hidden = NO;
            }
        }
    }else{
        cell.downloadBT.hidden = YES;
    }
    
    if (cell.downloadBT.hidden==YES) {
        cell.musicNameLB.frame = CGRectMake(9, 16, cell.frame.size.width-15, 32);
    }else{
//        cell.musicNameLB.frame = CGRectMake(9, 16, cell.frame.size.width-70, 32);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)showLeftMenu
{
    [self.frostedViewController presentMenuViewController];
}

-(void)showMain
{
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[MainViewController shared]];
    [nav.navigationBar customNavigationBar];
    self.frostedViewController.contentViewController = nav;
    [self.frostedViewController hideMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
