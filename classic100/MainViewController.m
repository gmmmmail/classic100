//
//  MainViewController.m
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MainViewController.h"
#import "EEHUDView.h"
#import "MarqueeLabel.h"
#import "UIImageView+WebCache.h"
#import "STKHTTPDataSource.h"
#import "STKLocalFileDataSource.h"


MainViewController * controller;
@interface MainViewController ()<GADBannerViewDelegate>
@property (strong, nonatomic) POPBasicAnimation *anim;

@property (nonatomic, strong) ADBannerView *iAdBannerView;
@end

static STKDataSource* dataSource;

static GADBannerView *gAdBannerView;
static BOOL IADCanLoad = true;

@implementation MainViewController
{
    float angle;
    STKAudioPlayer* audioPlayer;
    NSTimer *timer;
    BOOL flag;
    MusicHelper *musicHelper;
    MarqueeLabel *titleLabel;
    
    NSString *currentPlayUrl;
    
    UIImageView *circlrIV;
}

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
}

- (void)initiAdBanner
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
    
    //test
    gAdBannerView.delegate = self;
    
}

// Called before the add is shown, time to move the view
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
    
    musicHelper = [MusicHelper new];
    musicHelper.delegate = self;
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
    
    if ([PlayManager list].count!=100) {
        [[PlayManager list] removeAllObjects];
        for (NSString *musicID in [[DBHelper new] selectAllMusicIDs]) {
            [[PlayManager list] addObject:musicID];
        }
    }
    flag = true;
    _playMode = Circulation;
    _pauseBT.hidden = YES;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 23)];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu.png"]];
    [button addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 23)];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list.png"]];
    [button addTarget:self action:@selector(showMusic) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [_playBT setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [_pauseBT setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [_nextBT setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [_previousBT setBackgroundImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
    
    audioPlayer = [STKAudioPlayer new];
    audioPlayer.delegate = self;
    [_playBT addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [_pauseBT addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [_nextBT addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [_previousBT addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    
    _playSlider.minimumValue = 0;
    _playSlider.value = 0;
    _playSlider.continuous = YES;
    [_playSlider addTarget:self action:@selector(slideChanged) forControlEvents:UIControlEventValueChanged];
    
    if (!_anim) {
        _anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
        _anim.delegate = self;
        _anim.fromValue = @(0);
        _anim.duration = 0.03;
        _anim.toValue = @(angle*(M_PI/180.0f));
    }
    
    _currentPlayerID = [theme objectForKey:@"lastplay"];
    
    _albumImage = [UIImageView new];
    _albumImage.backgroundColor = [UIColor colorWithRed:83/255.0 green:84/255.0 blue:84/255.0 alpha:1];
    _albumImage.layer.masksToBounds = YES;
    
    
    circlrIV = [[UIImageView alloc] initWithFrame:CGRectZero];
    circlrIV.backgroundColor = [UIColor whiteColor];
    circlrIV.layer.shadowOffset = CGSizeMake(0, 1);
    circlrIV.layer.shadowRadius = 2.0;
    circlrIV.layer.shadowColor = [UIColor blackColor].CGColor;
    circlrIV.layer.shadowOpacity = 0.3;
    
    [self.view addSubview:circlrIV];
    [self.view addSubview:_albumImage];
    
    [self play:_currentPlayerID];
    [self initiAdBanner];
}

-(void)startRotate
{
    if (!flag) {
        _anim.fromValue = @(angle*(M_PI/180.0f));
        angle += 1;
        _anim.toValue = @(angle*(M_PI/180.0f));
        [_albumImage.layer pop_removeAnimationForKey:@"rotate"];
        [_albumImage.layer pop_addAnimation:_anim forKey:@"rotate"];
        flag = true;
    }
}

-(void)stopRotate
{
    if (flag) {
        flag = false;
        [_albumImage.layer pop_removeAllAnimations];
    }
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    if (flag) {
        _anim.fromValue = @(angle*(M_PI/180.0f));
        angle += 1;
        _anim.toValue = @(angle*(M_PI/180.0f));
        [_albumImage.layer pop_removeAnimationForKey:@"rotate"];
        [_albumImage.layer pop_addAnimation:_anim forKey:@"rotate"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (timer) {
        [timer invalidate];
    }
}

-(void)viewDidLayoutSubviews
{
    if (CGRectGetWidth(_albumImage.frame)==0) {
        
        UIView *container;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
            container = _container;
        }else{
            container = _container_Ipad;
        }
        
        [container layoutIfNeeded];
        
        float width = CGRectGetHeight(container.frame)*0.75;
        float height = width;
        _albumImage.frame = CGRectMake(0, 0, width, height);
        _albumImage.center = container.center;
        _albumImage.layer.cornerRadius = _albumImage.frame.size.width/2;
        
        circlrIV.frame = _albumImage.frame;
        circlrIV.layer.cornerRadius = circlrIV.frame.size.width/2;
        [self.view bringSubviewToFront:container];
    }
}

-(void)play:(NSString *)musicID
{
    _currentPlayerID = musicID;
    NSString *filePath = [[DBHelper new] musiclByID:musicID].mp3FilePath;
    if ([filePath isEqualToString:@""]) {
        [musicHelper mp3UrlByMusicID:musicID Url2:NO];
    }else{
        Music *music = [[DBHelper new] musiclByID:musicID];
        [self setMusicTitle:music.musicName];
        [_albumImage sd_setImageWithURL:[NSURL URLWithString:music.imageUrl]];
        [self setLastPlay];
        [self playUrl:filePath];
    }
}

// delegate
-(void) mp3Url:(NSString*)mp3Url musicID:(NSString*)musicID imageUrl:(NSString*)imageURl
{
    [self setMusicTitle:[[DBHelper new] musiclByID:musicID].musicName];
    imageURl = [[PlayManager images] objectAtIndex:arc4random() % ([PlayManager images].count)];
    [_albumImage sd_setImageWithURL:[NSURL URLWithString:imageURl] placeholderImage:nil];
    
    [self setLastPlay];
    [self playUrl:mp3Url];
}

-(void)setLastPlay
{
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"theme.plist"];
    NSMutableDictionary *theme = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    [theme setObject:_currentPlayerID forKey:@"lastplay"];
    [theme writeToFile:fullPath atomically:NO];
}

// 本地或在线播放
-(void)playUrl:(NSString*)mp3Url
{
    currentPlayUrl = mp3Url;
    if ([mp3Url rangeOfString:@"http://"].location==NSNotFound) {
        dataSource = [[STKLocalFileDataSource alloc] initWithFilePath:mp3Url];
    }else{
        dataSource = [[STKHTTPDataSource alloc] initWithURL:[NSURL URLWithString:mp3Url]];
    }
    dataSource.delegate = self;
    [audioPlayer playDataSource:dataSource];
}

-(void) dataSourceDataAvailable:(STKDataSource*)dataSource
{
    
}
-(void) dataSourceErrorOccured:(STKDataSource*)dataSource
{
    
}
-(void) dataSourceEof:(STKDataSource*)dataSource
{
    
}

-(void)play
{
    if (audioPlayer.state == STKAudioPlayerStatePaused) {
        [audioPlayer resume];
    }
}

-(void)pause
{
    if(audioPlayer.state == STKAudioPlayerStatePlaying){
        [audioPlayer pause];
    }
}

-(void)next
{
    NSUInteger index = [[PlayManager list] indexOfObject:_currentPlayerID];
    if (index==NSNotFound) {
        return;
    }
    switch (_playMode) {
        case Circulation:
            index += 1;
            if (index>=[PlayManager list].count) {
                index = 0;
            }
            break;
        case Single:
            break;
        case Random:
            index = arc4random() % (100);
            break;
    }
    NSString *nextID = [[PlayManager list] objectAtIndex:index];
    Music *music = [[DBHelper new] musiclByID:nextID];
    NSString *filePath = music.mp3FilePath;
    [self setMusicTitle:music.musicName];
    [self setLastPlay];
     _currentPlayerID = nextID;
    
    NSLog(@"播放第%li首",index+1);
    
    if ([filePath isEqualToString:@""]) {
        [musicHelper mp3UrlByMusicID:nextID Url2:NO];
    }else{
        [self playUrl:filePath];
    }
}

-(void)previous
{
    NSUInteger index = [[PlayManager list] indexOfObject:_currentPlayerID];
    if (index==NSNotFound) {
        return;
    }
    switch (_playMode) {
        case Circulation:
            index -= 1;
            if (index==-1) {
                index = [PlayManager list].count-1;
            }
            break;
        case Single:
            break;
        case Random:
            index = arc4random() % (100);
            break;
    }
    NSString *nextID = [[PlayManager list] objectAtIndex:index];
    Music *music = [[DBHelper new] musiclByID:nextID];
    NSString *filePath = music.mp3FilePath;
    [self setMusicTitle:music.musicName];
    [self setLastPlay];
    _currentPlayerID = nextID;

    NSLog(@"播放第%li首",index+1);
    
    if ([filePath isEqualToString:@""]) {
        [musicHelper mp3UrlByMusicID:nextID Url2:NO];
    }else{
        [self playUrl:filePath];
    }
}

- (void)tick
{
    if(audioPlayer.duration!=0){
        _playSlider.maximumValue = audioPlayer.duration;
        _playSlider.value = audioPlayer.progress;
        
        _startTimeLB.text = [self formatTimeFromSeconds:audioPlayer.progress];
        _endTimeLB.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:audioPlayer.duration]];
    }
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void)showMusic
{
    MusicViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MusicViewController"];
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:controller];
    [nav.navigationBar customNavigationBar];
    self.frostedViewController.contentViewController = nav;
    [self.frostedViewController hideMenuViewController];
}

-(void)showLeftMenu
{
    [self.frostedViewController presentMenuViewController];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    if (state==STKAudioPlayerStatePlaying) {
        [self startRotate];
        _playBT.hidden = YES;
        _pauseBT.hidden = NO;
    } else if (state==STKAudioPlayerStatePaused) {
        [self stopRotate];
        _playBT.hidden = NO;
        _pauseBT.hidden = YES;
    } else if (state==STKAudioPlayerStateBuffering) {
        [self stopRotate];
    } else if (state==STKAudioPlayerStateStopped) {
        [self stopRotate];
    }else if (state==STKAudioPlayerStateError) {
        [self stopRotate];
        _playBT.hidden = NO;
        _pauseBT.hidden = YES;
        [EEHUDView growlWithMessage:@"播放出错"
                          showStyle:EEHUDViewShowStyleFadeIn
                          hideStyle:EEHUDViewHideStyleFadeOut
                    resultViewStyle:EEHUDResultViewStyleNG
                           showTime:1.0];
    }
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    if (stopReason==STKAudioPlayerStopReasonEof) {
        [self next];
    }
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    if (currentPlayUrl) {
        if ([currentPlayUrl rangeOfString:@"MP3_128.mp3"].location!=NSNotFound) {
            [musicHelper mp3UrlByMusicID:_currentPlayerID Url2:YES];
        }else if ([currentPlayUrl rangeOfString:@"MP3_192.mp3"].location!=NSNotFound) {
            [musicHelper mp3UrlByMusicID:_currentPlayerID Url2:NO];
        }
    }
}

-(void)slideChanged
{
    [audioPlayer seekToTime:_playSlider.value];
}


-(void)setMusicTitle:(NSString*)name
{
    if (!titleLabel) {
        titleLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
        titleLabel.marqueeType = MLContinuous;
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.scrollDuration = 7.0;
        titleLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;
        titleLabel.fadeLength = 10.0f;
        titleLabel.leadingBuffer = 30.0f;
        titleLabel.trailingBuffer = 20.0f;
        self.navigationItem.titleView = titleLabel;
    }
    titleLabel.text = name;
}

-(void)pauseMusic
{
    [audioPlayer pause];
}

+(MainViewController *)shared
{
    if (!controller) {
        controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
    }
    return controller;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
