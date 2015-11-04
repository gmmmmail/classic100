/*
    2 sections:本地已下载、正在下载
*/
#import "DownloadViewController.h"
#import "MainViewController.h"
#import "Music.h"
#import "EEHUDView.h"

static DownloadViewController *controller;
@interface DownloadViewController ()

@end

@implementation DownloadViewController{
    NSMutableArray *downloads;
}

-(void)showMain
{
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[MainViewController shared]];
    [nav.navigationBar customNavigationBar];
    self.frostedViewController.contentViewController = nav;
    [self.frostedViewController hideMenuViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
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
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleView.text = NSLocalizedString(@"download", @"");
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadChanged) name:@"DownloadChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OneFinished) name:@"OneFinished" object:nil];
    downloads = [[DBHelper new] selectDownloads];
    [_table reloadData];
}

-(void)downloadChanged
{
    [_table reloadData];
}

-(void)OneFinished
{
    downloads = [[DBHelper new] selectDownloads];
    [_table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [DownloadManager downloadList].count;
    }else{
        return downloads.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [v setBackgroundColor:[UIColor clearColor]];;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:v.frame];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setTextColor:[UIColor whiteColor]];
    if (section == 0) {
        if ([DownloadManager downloadList].count==0) {
            labelTitle.text = @"";
        }else{
            labelTitle.text = NSLocalizedString(@"downloading", @"");
        }
    }else{
        if (downloads.count==0) {
            labelTitle.text = NSLocalizedString(@"no dowloaded song", @"");
        }else{
            labelTitle.text = NSLocalizedString(@"downloaded", @"");
        }
    }
    [v addSubview:labelTitle];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        [[PlayManager list] removeAllObjects];
        downloads = [[DBHelper new] selectDownloads];
        for (Music *music in downloads) {
            [[PlayManager list] addObject:music.musicID];
        }
        
        Music *music = [downloads objectAtIndex:indexPath.row];
        
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[MainViewController shared]];
        [nav.navigationBar customNavigationBar];
        [[MainViewController shared] play:music.musicID];
        self.frostedViewController.contentViewController = nav;
    }
}

-(void)mp3Url:(NSString *)mp3Url musicID:(NSString *)musicID
{
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:[MainViewController shared]];
    [nav.navigationBar customNavigationBar];
    [[MainViewController shared] play:musicID];
    self.frostedViewController.contentViewController = nav;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DownloadTableViewCell" owner:self options:nil] lastObject];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLB.frame = CGRectMake(19, 16, cell.frame.size.width-90, 32);
        }
        DownloadObj *obj = [[DownloadManager downloadList] objectAtIndex:indexPath.row];
        cell.nameLB.text = obj.musicName;
        if (!obj.progress||[obj.progress rangeOfString:@"%"].location==NSNotFound) {
            cell.percentLB.text = NSLocalizedString(@"waiting", @"");
        }else{
            cell.percentLB.text = obj.progress;
        }
        return cell;
    }else{
        DownloadTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadTableViewCell2"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DownloadTableViewCell2" owner:self options:nil] lastObject];
            cell.backgroundColor = [UIColor clearColor];
            cell.musicidLB.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLB.frame = CGRectMake(19, 16, cell.frame.size.width-20, 32);
        }
        Music *music = [downloads objectAtIndex:indexPath.row];
        cell.nameLB.text = music.musicName;
        cell.musicidLB.text = music.musicID;
        
        UIView *crossView = [self viewWithImageName:@"cross"];
        crossView.backgroundColor = [UIColor clearColor];
        [cell setSwipeGestureWithView:crossView color:[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.8] mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            DownloadTableViewCell2 *c = (DownloadTableViewCell2*)cell;
            
            if ([DownloadManager downloadList].count>0) {
                return ;
            }
            
            // delete from download record
            DBHelper *dbHelper = [DBHelper new];
            [dbHelper deleteFilePathbyID:c.musicidLB.text];
            
            downloads = [dbHelper selectDownloads];
            [_table deleteRowsAtIndexPaths:@[[_table indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            
            // delete file
            NSString *filePath = [NSString stringWithFormat:@"%@/music/%@.mp3",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],c.musicidLB.text];
            NSError *err;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&err];
            if (!err) {
                [EEHUDView growlWithMessage:NSLocalizedString(@"delete success", @"")
                                  showStyle:EEHUDViewShowStyleFadeIn
                                  hideStyle:EEHUDViewHideStyleFadeOut
                            resultViewStyle:EEHUDResultViewStyleNG
                                   showTime:0.5];
                
            }else{
                [EEHUDView growlWithMessage:NSLocalizedString(@"delete fail", @"")
                                  showStyle:EEHUDViewShowStyleFadeIn
                                  hideStyle:EEHUDViewHideStyleFadeOut
                            resultViewStyle:EEHUDResultViewStyleNG
                                   showTime:0.5];
            }
        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

+(DownloadViewController *)shared
{
    if (!controller) {
        controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DownloadViewController"];
    }
    return controller;
}

-(void)showLeftMenu
{
    [self.frostedViewController presentMenuViewController];
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
