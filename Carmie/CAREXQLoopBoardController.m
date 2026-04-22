//
//  CAREXQLoopBoardController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQLoopBoardController.h"
#import "CAREXQImage.h"
#import "CAREXQLoopHeaderView.h"
#import "CAREXQLoopMomentCell.h"
#import "CAREXQLoopDetailController.h"
#import "CAREXQPersonaController.h"

static NSString * const CAREXQLoopMomentCellID = @"CAREXQLoopMomentCellID";

@interface CAREXQLoopBoardController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *crxTableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxUsers;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxMoments;
@property (nonatomic, assign) BOOL crxLoadingLoopData;

@end

@implementation CAREXQLoopBoardController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self crx_reloadLoopData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildViews];
    [self crx_reloadLoopData];
}

- (void)crx_buildMockData {
    UIImage *crxAvatarOne = [CAREXQImage imageNamed:@"crx_head_1"];
    UIImage *crxAvatarTwo = [CAREXQImage imageNamed:@"crx_head_2"];
    UIImage *crxAvatarThree = [CAREXQImage imageNamed:@"crx_head_3"];
    UIImage *crxAvatarFour = [CAREXQImage imageNamed:@"crx_head_4"];
    UIImage *crxAvatarFive = [CAREXQImage imageNamed:@"crx_head_5"];
    UIImage *crxAvatarSix = [CAREXQImage imageNamed:@"crx_head_6"];
    UIImage *crxAvatarSeven = [CAREXQImage imageNamed:@"crx_head_7"];
    UIImage *crxAvatarEight = [CAREXQImage imageNamed:@"crx_head_8"];
    
    NSArray<NSDictionary *> *crxSourceUsers = @[
        @{@"crxName": @"Hayden", @"crxImage": crxAvatarOne ?: UIImage.new},
        @{@"crxName": @"Carson", @"crxImage": crxAvatarTwo ?: UIImage.new},
        @{@"crxName": @"Bennett", @"crxImage": crxAvatarThree ?: UIImage.new},
        @{@"crxName": @"Holden", @"crxImage": crxAvatarFour ?: UIImage.new},
        @{@"crxName": @"Tanner", @"crxImage": crxAvatarFive ?: UIImage.new},
        @{@"crxName": @"Garrett", @"crxImage": crxAvatarSix ?: UIImage.new},
        @{@"crxName": @"Malcolm", @"crxImage": crxAvatarSeven ?: UIImage.new},
        @{@"crxName": @"Alyssa", @"crxImage": crxAvatarEight ?: UIImage.new}
    ];
    self.crxUsers = [CAREXQController crx_filterItems:crxSourceUsers nameKey:@"crxName"];
    
    NSArray<UIImage *> *crxDynamicImages = @[
        [CAREXQImage imageNamed:@"crx_dy_1"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_2"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_3"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_4"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_5"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_6"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_7"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_8"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_9"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_10"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_11"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_12"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_13"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_14"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_15"] ?: UIImage.new,
        [CAREXQImage imageNamed:@"crx_dy_16"] ?: UIImage.new
    ];
    
    NSArray<NSString *> *crxTexts = @[
        @"Tried a new hand dance today ✨🤲",
        @"Still practicing but having fun with it 💃",
        @"Just playing around with some moves 🎶🤲",
        @"A quick hand dance before calling it a day 😄",
        @"Learning new gestures little by little 🌟",
        @"Just a short hand dance practice today",
        @"Trying to get these moves a little smoother",
        @"Sharing a quick hand dance clip"
    ];
    
    NSMutableArray<NSDictionary *> *crxMoments = [NSMutableArray array];
    for (NSInteger crxIndex = 0; crxIndex < 8; crxIndex++) {
        NSDictionary *crxUser = crxSourceUsers[crxIndex];
        NSInteger crxImageIndex = crxIndex * 2;
        [crxMoments addObject:@{
            @"crxAvatar": crxUser[@"crxImage"] ?: UIImage.new,
            @"crxName": crxUser[@"crxName"] ?: @"",
            @"crxDate": @"2026/12/22",
            @"crxContent": crxTexts[crxIndex] ?: @"",
            @"crxImageLeft": crxDynamicImages[crxImageIndex],
            @"crxImageRight": crxDynamicImages[crxImageIndex + 1]
        }];
    }
    self.crxMoments = [CAREXQController crx_filterItems:crxMoments.copy nameKey:@"crxName"];
}

- (void)crx_buildViews {
    
    UIImageView *crxTitleView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_board_mom"]];
    crxTitleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:crxTitleView];
    crxTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxTitleView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:5],
        [crxTitleView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
    ]];
    
    self.crxTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.crxTableView.backgroundColor = UIColor.clearColor;
    self.crxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.crxTableView.showsVerticalScrollIndicator = NO;
    self.crxTableView.dataSource = self;
    self.crxTableView.delegate = self;
    self.crxTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.crxTableView registerClass:CAREXQLoopMomentCell.class forCellReuseIdentifier:CAREXQLoopMomentCellID];
    [self.view addSubview:self.crxTableView];
    self.crxTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxTableView.topAnchor constraintEqualToAnchor:crxTitleView.bottomAnchor constant:10],
        [self.crxTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    [self crx_reloadHeaderAndList];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crxMoments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CAREXQLoopMomentCell *crxCell = [tableView dequeueReusableCellWithIdentifier:CAREXQLoopMomentCellID forIndexPath:indexPath];
    NSDictionary *crxMoment = self.crxMoments[indexPath.row];
    [crxCell crx_configureWithMoment:crxMoment];
    __weak typeof(self) weakSelf = self;
    crxCell.crxMoreTappedBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf crx_presentModerationForUserName:crxMoment[@"crxName"] blockHandler:^{
            [strongSelf crx_buildMockData];
            [strongSelf crx_reloadHeaderAndList];
        }];
    };
    return crxCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 330.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *crxView = [[UIView alloc] init];
    crxView.backgroundColor = UIColor.clearColor;
    return crxView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CAREXQLoopDetailController *crxController = [[CAREXQLoopDetailController alloc] init];
    crxController.crxMomentItem = self.crxMoments[indexPath.row];
    [self.navigationController pushViewController:crxController animated:YES];
}

- (void)crx_reloadHeaderAndList {
    if (!self.crxTableView) {
        return;
    }
    CAREXQLoopHeaderView *crxHeaderView = [[CAREXQLoopHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 190)];
    [crxHeaderView crx_configureWithUsers:self.crxUsers];
    __weak typeof(self) weakSelf = self;
    crxHeaderView.crxUserTappedBlock = ^(NSDictionary *crxUserItem) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        CAREXQPersonaController *crxController = [[CAREXQPersonaController alloc] init];
        crxController.crxUserItem = crxUserItem;
        [strongSelf.navigationController pushViewController:crxController animated:YES];
    };
    self.crxTableView.tableHeaderView = crxHeaderView;
    [self.crxTableView reloadData];
}

- (void)crx_reloadLoopData {
    if (self.crxLoadingLoopData) {
        return;
    }
    self.crxLoadingLoopData = YES;
    [self crx_showLoadingWithText:@"Loading..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.crxLoadingLoopData = NO;
        [self crx_buildMockData];
        [self crx_reloadHeaderAndList];
        [self crx_hideLoading];
    });
}

@end
