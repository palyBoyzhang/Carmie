//
//  CRXLoopBoardController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXLoopBoardController.h"
#import "CRXLoopHeaderView.h"
#import "CRXLoopMomentCell.h"
#import "CRXLoopDetailController.h"
#import "CRXPersonaController.h"

static NSString * const CRXLoopMomentCellID = @"CRXLoopMomentCellID";

@interface CRXLoopBoardController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *crxTableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxUsers;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxMoments;

@end

@implementation CRXLoopBoardController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self crx_buildMockData];
    [self crx_reloadHeaderAndList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildMockData];
    [self crx_buildViews];
}

- (void)crx_buildMockData {
    UIImage *crxAvatarOne = [UIImage imageNamed:@"crx_head_1"];
    UIImage *crxAvatarTwo = [UIImage imageNamed:@"crx_head_2"];
    UIImage *crxAvatarThree = [UIImage imageNamed:@"crx_head_3"];
    UIImage *crxAvatarFour = [UIImage imageNamed:@"crx_head_4"];
    UIImage *crxAvatarFive = [UIImage imageNamed:@"crx_head_5"];
    UIImage *crxAvatarSix = [UIImage imageNamed:@"crx_head_6"];
    UIImage *crxAvatarSeven = [UIImage imageNamed:@"crx_head_7"];
    UIImage *crxAvatarEight = [UIImage imageNamed:@"crx_head_8"];
    
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
    self.crxUsers = [CRXController crx_filterItems:crxSourceUsers nameKey:@"crxName"];
    
    NSArray<UIImage *> *crxDynamicImages = @[
        [UIImage imageNamed:@"crx_dy_1"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_2"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_3"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_4"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_5"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_6"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_7"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_8"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_9"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_10"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_11"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_12"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_13"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_14"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_15"] ?: UIImage.new,
        [UIImage imageNamed:@"crx_dy_16"] ?: UIImage.new
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
    self.crxMoments = [CRXController crx_filterItems:crxMoments.copy nameKey:@"crxName"];
}

- (void)crx_buildViews {
    
    UIImageView *crxTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_board_mom"]];
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
    [self.crxTableView registerClass:CRXLoopMomentCell.class forCellReuseIdentifier:CRXLoopMomentCellID];
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
    CRXLoopMomentCell *crxCell = [tableView dequeueReusableCellWithIdentifier:CRXLoopMomentCellID forIndexPath:indexPath];
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
    CRXLoopDetailController *crxController = [[CRXLoopDetailController alloc] init];
    crxController.crxMomentItem = self.crxMoments[indexPath.row];
    [self.navigationController pushViewController:crxController animated:YES];
}

- (void)crx_reloadHeaderAndList {
    if (!self.crxTableView) {
        return;
    }
    CRXLoopHeaderView *crxHeaderView = [[CRXLoopHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 190)];
    [crxHeaderView crx_configureWithUsers:self.crxUsers];
    __weak typeof(self) weakSelf = self;
    crxHeaderView.crxUserTappedBlock = ^(NSDictionary *crxUserItem) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        CRXPersonaController *crxController = [[CRXPersonaController alloc] init];
        crxController.crxUserItem = crxUserItem;
        [strongSelf.navigationController pushViewController:crxController animated:YES];
    };
    self.crxTableView.tableHeaderView = crxHeaderView;
    [self.crxTableView reloadData];
}

@end
