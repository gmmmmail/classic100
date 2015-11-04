//
//  MenuViewController.m
//  classic100
//
//  Created by lai on 15/4/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MenuViewController.h"
#import "MusicViewController.h"
#import "CustomNavigationController.h"
#import "REFrostedViewController.h"
#import "UINavigationBar+customBar.h"
#import "DownloadViewController.h"
#import "DownloadManager.h"

@interface MenuViewController ()

@end

@implementation MenuViewController{
    LLFoldView *view;
    UIWindow *window;
    UIActivityIndicatorView *indicator;
    
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _contentView.center = CGPointMake(_contentView.center.x, [UIScreen mainScreen].bounds.size.height/2);
    
    [_MusicFavor setTitle:NSLocalizedString(@"classical music collections", @"") forState:UIControlStateNormal];
    [_PlayModeBT setTitle:NSLocalizedString(@"play mode", @"") forState:UIControlStateNormal];
    [_MusicBT setTitle:NSLocalizedString(@"music library", @"") forState:UIControlStateNormal];
    [_ThemeBT setTitle:NSLocalizedString(@"theme", @"") forState:UIControlStateNormal];
    
    
    if ([[DownloadManager readAppController] isEqualToString:@"1"]) {
        _dBT.hidden=NO;
        [_dBT setTitle:NSLocalizedString(@"download", @"") forState:UIControlStateNormal];
    }else{
        _dBT.hidden=YES;
    }
    
    [_switchBT addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [_switchBT_iphone addTarget:self action:@selector(switchAction_iphone:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)switchAction_iphone:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    if ([switchButton isOn]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"time off", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:NSLocalizedString(@"10分钟", @"") otherButtonTitles:NSLocalizedString(@"20分钟", @""),NSLocalizedString(@"30分钟", @""), nil];
        sheet.tag = 22;
        [sheet showInView:self.view];
    }else {
        if (timer) {
            [timer invalidate];
            _timeLB_iphone.text = NSLocalizedString(@"time off", @"");
        }
    }
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    if ([switchButton isOn]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"time off", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:NSLocalizedString(@"10 minute", @"") otherButtonTitles:NSLocalizedString(@"20 minute", @""),NSLocalizedString(@"30 minute", @""), nil];
        sheet.tag = 22;
        [sheet showInView:self.view];
    }else {
        if (timer) {
            [timer invalidate];
            _timeLB.text = @"";
        }
    }
}

- (IBAction)playmode:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"play mode", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:NSLocalizedString(@"list loop", @"") otherButtonTitles:NSLocalizedString(@"single loop", @""),NSLocalizedString(@"Shuffle", @""), nil];
    [sheet showInView:self.view];
    [self.frostedViewController hideMenuViewController];
}
- (IBAction)theme:(id)sender {
    
    if (!window) {
        
        window = [UIWindow new];
        window.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.8];
        window.frame = [UIScreen mainScreen].bounds;
        view = [[LLFoldView alloc] initWithFrame:window.frame];
        view.delegate = self;
        view.images = @[[UIImage imageNamed:@"theme1.png"],
                        [UIImage imageNamed:@"theme2.png"],
                        [UIImage imageNamed:@"theme3.png"],
                        [UIImage imageNamed:@"theme4.png"],
                        [UIImage imageNamed:@"theme5.png"],
                        [UIImage imageNamed:@"theme6.png"],
                        [UIImage imageNamed:@"theme7.png"],
                        [UIImage imageNamed:@"theme8.png"]];
        [view initView];
        view.tag = 11;
        [window addSubview:view];
        
    }
    
    window.windowLevel = 3000;
    [window makeKeyAndVisible];
    [view open];
}

# pragma mark -FoldView Delegate
-(void)cancelTheme
{
    window.windowLevel = -3000;
    [self.frostedViewController hideMenuViewController];
}

-(void)tap:(NSInteger)index
{
    window.windowLevel = -3000;
    
    UIImage *image;
    
    if (index==0) {
        image = [UIImage imageNamed:@"bg.png"];
    }else if(index==1){
        image = [UIImage imageNamed:@"bg2.png"];
    }else if(index==2){
        image = [UIImage imageNamed:@"bg3.png"];
    }else if(index==3){
        image = [UIImage imageNamed:@"bg4.png"];
    }else if(index==4){
        image = [UIImage imageNamed:@"bg5.png"];
    }else if(index==5){
        image = [UIImage imageNamed:@"bg6.png"];
    }else if(index==6){
        image = [UIImage imageNamed:@"bg7.png"];
    }else if(index==7){
        image = [UIImage imageNamed:@"bg8.png"];
    }
    
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"theme.plist"];
    NSMutableDictionary *theme = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    [theme setObject:[NSNumber numberWithInteger:index] forKey:@"theme"];
    [theme writeToFile:fullPath atomically:NO];
    
    [MainViewController shared].view.backgroundColor=[UIColor colorWithPatternImage:image];
    
    UIViewController *tmp = [((CustomNavigationController*)self.frostedViewController.contentViewController).viewControllers objectAtIndex:0];
    if ([tmp isKindOfClass:[DownloadViewController class]]) {
       
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[DownloadViewController shared]];
        [DownloadViewController shared].view.backgroundColor = [UIColor colorWithPatternImage:image];
        [nav.navigationBar customNavigationBar];
        self.frostedViewController.contentViewController = nav;
        [self.frostedViewController hideMenuViewController];
        
    }else if([tmp isKindOfClass:[MusicViewController class]]){
       
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MusicViewController"]];
        [nav.navigationBar customNavigationBar];
        self.frostedViewController.contentViewController = nav;
        [self.frostedViewController hideMenuViewController];
        
    }else{
        
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[MainViewController shared]];
        [nav.navigationBar customNavigationBar];
        self.frostedViewController.contentViewController = nav;
        [self.frostedViewController hideMenuViewController];
        
    }
}


- (IBAction)classic:(id)sender {
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        indicator.center = self.view.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.view addSubview:indicator];
    }
    [indicator startAnimating];
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    storeProductViewController.delegate = self;
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"935576123"}
                                          completionBlock:^(BOOL result, NSError *error){
                                              if(!error){
                                                  [self presentViewController:storeProductViewController
                                                                     animated:YES
                                                                   completion:nil];
                                              }
                                              [indicator stopAnimating];
                                          }];
    
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        // do after animation
        UIViewController *tmp = [((CustomNavigationController*)self.frostedViewController.contentViewController).viewControllers objectAtIndex:0];
        if ([tmp isKindOfClass:[DownloadViewController class]]) {
            CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[DownloadViewController shared]];
            [nav.navigationBar customNavigationBar];
            self.frostedViewController.contentViewController = nav;
        }else if([tmp isKindOfClass:[MusicViewController class]]){
            
            CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MusicViewController"]];
            [nav.navigationBar customNavigationBar];
            self.frostedViewController.contentViewController = nav;
            
        }else{
            
            CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[MainViewController shared]];
            [nav.navigationBar customNavigationBar];
            self.frostedViewController.contentViewController = nav;
            
        }
        [self.frostedViewController hideMenuViewController];
    }];
}


- (IBAction)musics:(id)sender {
    MusicViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MusicViewController"];
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:controller];
    [nav.navigationBar customNavigationBar];
    self.frostedViewController.contentViewController = nav;
    [self.frostedViewController hideMenuViewController];
}

- (IBAction)download:(id)sender {
    DownloadViewController * controller = [DownloadViewController shared];
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:controller];
   // to do
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"theme.plist"];
    NSMutableDictionary *theme = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    int value = [[theme objectForKey:@"theme"] intValue];
    if (value==0) {
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    }else if(value==1){
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    }else if(value==2){
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
    }else if(value==3){
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg4.png"]];
    }else if(value==4){
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg5.png"]];
    }else if(value==5){
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg6.png"]];
    }else if(value==6){
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg7.png"]];
    }else if(value==7){
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg8.png"]];
    }
    
    [nav.navigationBar customNavigationBar];
    self.frostedViewController.contentViewController = nav;
    [self.frostedViewController hideMenuViewController];
}

NSInteger second = 0;
-(void)tick
{
    if (second==1) {
        [timer invalidate];
        _timeLB.text = @"";
        _switchBT.on = NO;
        // pause music
        [[MainViewController shared] pauseMusic];
        
    }else{
        second -= 1;
        _timeLB.text = [self secondToTime:second];
    }
}

-(void)tick_iphone
{
    if (second==1) {
        [timer invalidate];
        _timeLB_iphone.text = @"定时关闭";
        _switchBT_iphone.on = NO;
        // pause music
        [[MainViewController shared] pauseMusic];
        
    }else{
        second -= 1;
        _timeLB_iphone.text = [self secondToTime:second];
    }
}

-(NSString*)secondToTime:(NSInteger)second
{
    NSInteger min = second / 60;
    NSInteger sec = second % 60;
    return [NSString stringWithFormat:@"%02i:%02i",min,sec];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==22) {
        
        if (buttonIndex==0) {
            second = 10*60;
        }else if(buttonIndex==1){
            second = 20*60;
        }else if(buttonIndex==2){
            second = 30*60;
        }else{
            second = 0;
            if (_switchBT_iphone) {
                _switchBT_iphone.on = NO;
            }
            if (_switchBT) {
                _switchBT.on = NO;
            }
        }
        if (second!=0) {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
            }else{
                timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tick_iphone) userInfo:nil repeats:YES];
            }
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
        
    }else{
        if (buttonIndex==0) {
            [MainViewController shared].playMode = Circulation;
        }else if (buttonIndex==1) {
            [MainViewController shared].playMode = Single;
        }if (buttonIndex==2) {
            [MainViewController shared].playMode = Random;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
