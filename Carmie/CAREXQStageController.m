//
//  CAREXQStageController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQStageController.h"
#import "CAREXQImage.h"
#import "CAREXQStageView.h"
#import "CAREXQStageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "CAREXQBlueprintController.h"

@interface CAREXQStageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CAREXQStageView *crxStageView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxStageItems;
@property (nonatomic, assign) BOOL crxLoadingStageData;

@end

@implementation CAREXQStageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self crx_reloadStageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCAREXQStageViews];
    [self crx_reloadStageData];
}

- (void)setCAREXQStageViews {
    UIImageView *crxCarmieImageView = [[UIImageView alloc] init];
    crxCarmieImageView.image = [CAREXQImage imageNamed:@"crx_stage_carmie"];
    crxCarmieImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxCarmieImageView];
    [NSLayoutConstraint activateConstraints:@[
        [crxCarmieImageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:5],
        [crxCarmieImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15]
    ]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.clearColor;
    [self.tableView registerClass:CAREXQStageCell.class forCellReuseIdentifier:@"CAREXQStageCell"];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:crxCarmieImageView.bottomAnchor constant:20],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.crxStageView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.crxStageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 365.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crxStageItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CAREXQStageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CAREXQStageCell"];
    NSDictionary *crxItem = self.crxStageItems[indexPath.row];
    [cell crx_configureWithItem:crxItem];
    __weak typeof(self) weakSelf = self;
    cell.crxMoreTappedBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf crx_presentModerationForUserName:crxItem[@"crxName"] blockHandler:^{
            [strongSelf crx_buildStageItems];
            [strongSelf.tableView reloadData];
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CAREXQBlueprintController *crxVC = [[CAREXQBlueprintController alloc] init];
    crxVC.crxStageItem = self.crxStageItems[indexPath.row];
    [self.navigationController pushViewController:crxVC animated:YES];
}

- (CAREXQStageView *)crxStageView {
    if (!_crxStageView) {
        _crxStageView = [[CAREXQStageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 174.f)];
    }
    return _crxStageView;
}

- (void)crx_reloadStageData {
    if (self.crxLoadingStageData) {
        return;
    }
    self.crxLoadingStageData = YES;
    [self crx_showLoadingWithText:@"Loading..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.crxLoadingStageData = NO;
        [self crx_buildStageItems];
        [self.tableView reloadData];
        [self crx_hideLoading];
    });
}

- (void)crx_buildStageItems {
    NSArray<NSDictionary *> *crxSourceItems = @[
        @{
            @"crxName": @"Hayden",
            @"crxTitle": @"Gesture Flow",
            @"crxDesc": @"Show your smoothest hand dance moves and let your gestures flow naturally with the music. Record a short clip and share how your hands move with the rhythm and style."
        },
        @{
            @"crxName": @"Carson",
            @"crxTitle": @"Hand Beat Challenge",
            @"crxDesc": @"Match your hand dance to the beat and keep the rhythm steady. Create a short video where your gestures follow the music and show how you interpret the sound."
        },
        @{
            @"crxName": @"Bennett",
            @"crxTitle": @"Move Your Hands",
            @"crxDesc": @"Design a short routine using your favorite hand gestures and movements. Keep it simple and creative so others can easily follow along and try it themselves."
        },
        @{
            @"crxName": @"Holden",
            @"crxTitle": @"Finger Rhythm",
            @"crxDesc": @"Let your fingers move with the rhythm and bring the music to life through hand gestures. Share a short clip showing your timing, flow, and personal style."
        },
        @{
            @"crxName": @"Tanner",
            @"crxTitle": @"Simple Hand Moves",
            @"crxDesc": @"Create a simple hand dance sequence that anyone can try. Focus on clear movements and smooth transitions so the routine is easy and fun to follow."
        },
        @{
            @"crxName": @"Garrett",
            @"crxTitle": @"Hand Motion Vibes",
            @"crxDesc": @"Create a short hand dance that matches the vibe of the music. Focus on smooth transitions and expressive movements to show your personal style and energy."
        },
        @{
            @"crxName": @"Malcolm",
            @"crxTitle": @"Gesture Groove",
            @"crxDesc": @"Bring your groove to life with creative hand gestures. Record a short clip where your hands follow the rhythm and showcase your unique interpretation of the beat."
        },
        @{
            @"crxName": @"Alyssa",
            @"crxTitle": @"Flowing Fingers",
            @"crxDesc": @"Let your fingers flow freely with the music and create a soft, continuous motion. Share a short video highlighting your control, timing, and fluid hand movements."
        }
    ];
    
    NSMutableArray<NSDictionary *> *crxItems = [NSMutableArray array];
    [crxSourceItems enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull crxSourceItem, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger crxIndex = idx + 1;
        NSString *crxHeadName = [NSString stringWithFormat:@"crx_head_%lu", (unsigned long)crxIndex];
        NSString *crxVideoName = [NSString stringWithFormat:@"crx_stage_%lu", (unsigned long)crxIndex];
        UIImage *crxAvatarImage = [CAREXQImage imageNamed:crxHeadName];
        UIImage *crxCoverImage = [self crx_coverImageForVideoName:crxVideoName];
        NSMutableArray<NSString *> *crxAvatarGroupNames = [NSMutableArray array];
        for (NSUInteger crxGroupIdx = 0; crxGroupIdx < 4; crxGroupIdx++) {
            NSUInteger crxGroupHeadIndex = ((idx + crxGroupIdx) % crxSourceItems.count) + 1;
            [crxAvatarGroupNames addObject:[NSString stringWithFormat:@"crx_head_%lu", (unsigned long)crxGroupHeadIndex]];
        }
        
        [crxItems addObject:@{
            @"crxAvatarImage": crxAvatarImage ?: UIImage.new,
            @"crxCoverImage": crxCoverImage ?: [CAREXQImage imageNamed:@"crx_stage_aig"] ?: UIImage.new,
            @"crxAvatarName": crxHeadName ?: @"",
            @"crxAvatarGroupNames": crxAvatarGroupNames.copy ?: @[],
            @"crxVideoName": crxVideoName ?: @"",
            @"crxName": crxSourceItem[@"crxName"] ?: [NSString stringWithFormat:@"Creator %02lu", (unsigned long)crxIndex],
            @"crxMeta": @"Hand dance",
            @"crxHeadline": crxSourceItem[@"crxTitle"] ?: @"",
            @"crxDescription": crxSourceItem[@"crxDesc"] ?: @"",
            @"crxTitle": [NSString stringWithFormat:@"%@\n%@", crxSourceItem[@"crxTitle"], crxSourceItem[@"crxDesc"]],
            @"crxClip": [NSString stringWithFormat:@"Clip %02lu", (unsigned long)crxIndex]
        }];
    }];
    self.crxStageItems = [CAREXQController crx_filterItems:crxItems.copy nameKey:@"crxName"];
}

- (UIImage *)crx_coverImageForVideoName:(NSString *)crxVideoName {
    NSString *crxVideoPath = [[NSBundle mainBundle] pathForResource:crxVideoName ofType:@"mp4"];
    if (crxVideoPath.length == 0) {
        return nil;
    }
    
    AVURLAsset *crxAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:crxVideoPath] options:nil];
    AVAssetImageGenerator *crxImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:crxAsset];
    crxImageGenerator.appliesPreferredTrackTransform = YES;
    crxImageGenerator.maximumSize = CGSizeMake(900, 900);
    
    NSError *crxError = nil;
    CGImageRef crxImageRef = [crxImageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(0.0, 600) actualTime:NULL error:&crxError];
    if (crxImageRef == NULL || crxError) {
        return nil;
    }
    
    UIImage *crxImage = [UIImage imageWithCGImage:crxImageRef];
    CGImageRelease(crxImageRef);
    return crxImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
