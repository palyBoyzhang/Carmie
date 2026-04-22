//
//  CAREXQSignalBoardController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQSignalBoardController.h"
#import "CAREXQImage.h"
#import "CAREXQSignalHeaderView.h"
#import "CAREXQSignalMessageCell.h"
#import "CAREXQChannelController.h"
#import "CAREXQPersonaController.h"
#import "CAREXQEntryController.h"

static NSString * const CAREXQSignalMessageCellID = @"CAREXQSignalMessageCellID";
static NSString * const CAREXQHarborLoginStateKey = @"CAREXQEntryLoginStateKey";

@interface CAREXQSignalBoardController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *crxTableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxUsers;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxMessages;
@property (nonatomic, strong) UIView *crxEmptyStateView;
@property (nonatomic, assign) BOOL crxLoadingSignalData;

@end

@implementation CAREXQSignalBoardController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self crx_reloadSignalData];
}

- (BOOL)crx_isLoggedIn {
    return [NSUserDefaults.standardUserDefaults boolForKey:CAREXQHarborLoginStateKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildViews];
    [self crx_reloadSignalData];
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
    
    self.crxUsers = [CAREXQController crx_filterItems:@[
        @{@"crxName": @"Hayden", @"crxImage": crxAvatarOne ?: UIImage.new},
        @{@"crxName": @"Carson", @"crxImage": crxAvatarTwo ?: UIImage.new},
        @{@"crxName": @"Bennett", @"crxImage": crxAvatarThree ?: UIImage.new},
        @{@"crxName": @"Holden", @"crxImage": crxAvatarFour ?: UIImage.new},
        @{@"crxName": @"Tanner", @"crxImage": crxAvatarFive ?: UIImage.new},
        @{@"crxName": @"Garrett", @"crxImage": crxAvatarSix ?: UIImage.new},
        @{@"crxName": @"Malcolm", @"crxImage": crxAvatarSeven ?: UIImage.new},
        @{@"crxName": @"Alyssa", @"crxImage": crxAvatarEight ?: UIImage.new}
    ] nameKey:@"crxName"];
    
    self.crxMessages = [CAREXQController crx_filterItems:@[
        @{
            @"crxAvatar": crxAvatarOne ?: UIImage.new,
            @"crxName": @"Hayden",
            @"crxPreview": @"Hey, did you try that new hand dance move today?",
            @"crxTime": @"09:18"
        },
        @{
            @"crxAvatar": crxAvatarFour ?: UIImage.new,
            @"crxName": @"Holden",
            @"crxPreview": @"Your gesture flow looked smooth, teach me that part later.",
            @"crxTime": @"11:42"
        },
        @{
            @"crxAvatar": crxAvatarEight ?: UIImage.new,
            @"crxName": @"Alyssa",
            @"crxPreview": @"Hi, I am still practicing the finger rhythm challenge today.",
            @"crxTime": @"14:06"
        }
    ] nameKey:@"crxName"];
}

- (void)crx_buildViews {
    
    UIImageView *crxTitleView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_signal_title"]];
    crxTitleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:crxTitleView];
    crxTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.crxTableView.backgroundColor = UIColor.clearColor;
    self.crxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.crxTableView.showsVerticalScrollIndicator = NO;
    self.crxTableView.dataSource = self;
    self.crxTableView.delegate = self;
    self.crxTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.crxTableView registerClass:CAREXQSignalMessageCell.class forCellReuseIdentifier:CAREXQSignalMessageCellID];
    [self.view addSubview:self.crxTableView];
    self.crxTableView.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxEmptyStateView = [[UIView alloc] init];
    self.crxEmptyStateView.hidden = YES;
    [self.view addSubview:self.crxEmptyStateView];
    self.crxEmptyStateView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *crxEmptyLabel = [[UILabel alloc] init];
    crxEmptyLabel.text = @"Please log in to view your messages.";
    crxEmptyLabel.textColor = [UIColor colorWithWhite:1 alpha:0.74];
    crxEmptyLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    crxEmptyLabel.textAlignment = NSTextAlignmentCenter;
    crxEmptyLabel.numberOfLines = 0;
    [self.crxEmptyStateView addSubview:crxEmptyLabel];
    crxEmptyLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIButton *crxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxLoginButton setTitle:@"Log in" forState:UIControlStateNormal];
    [crxLoginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    crxLoginButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    crxLoginButton.layer.cornerRadius = 24.f;
    crxLoginButton.layer.masksToBounds = YES;
    [crxLoginButton addTarget:self action:@selector(crxLoginTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.crxEmptyStateView addSubview:crxLoginButton];
    crxLoginButton.translatesAutoresizingMaskIntoConstraints = NO;

    CAGradientLayer *crxLoginGradientLayer = [CAGradientLayer layer];
    crxLoginGradientLayer.startPoint = CGPointMake(0, 0.5);
    crxLoginGradientLayer.endPoint = CGPointMake(1, 0.5);
    crxLoginGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
    ];
    crxLoginGradientLayer.frame = CGRectMake(0, 0, 188, 52);
    crxLoginGradientLayer.cornerRadius = 26.f;
    [crxLoginButton.layer insertSublayer:crxLoginGradientLayer atIndex:0];
    
    [NSLayoutConstraint activateConstraints:@[
        
        [crxTitleView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:12],
        [crxTitleView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        
        [self.crxTableView.topAnchor constraintEqualToAnchor:crxTitleView.bottomAnchor constant:16],
        [self.crxTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],

        [self.crxEmptyStateView.topAnchor constraintEqualToAnchor:crxTitleView.bottomAnchor constant:16],
        [self.crxEmptyStateView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [self.crxEmptyStateView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],
        [self.crxEmptyStateView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],

        [crxEmptyLabel.centerXAnchor constraintEqualToAnchor:self.crxEmptyStateView.centerXAnchor],
        [crxEmptyLabel.centerYAnchor constraintEqualToAnchor:self.crxEmptyStateView.centerYAnchor constant:-24],
        [crxEmptyLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.crxEmptyStateView.leadingAnchor],
        [crxEmptyLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.crxEmptyStateView.trailingAnchor],

        [crxLoginButton.topAnchor constraintEqualToAnchor:crxEmptyLabel.bottomAnchor constant:20],
        [crxLoginButton.centerXAnchor constraintEqualToAnchor:self.crxEmptyStateView.centerXAnchor],
        [crxLoginButton.widthAnchor constraintEqualToConstant:188],
        [crxLoginButton.heightAnchor constraintEqualToConstant:52]
    ]];
    
    [self crx_refreshLoginState];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![self crx_isLoggedIn]) {
        return 0;
    }
    return self.crxMessages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CAREXQSignalMessageCell *crxCell = [tableView dequeueReusableCellWithIdentifier:CAREXQSignalMessageCellID forIndexPath:indexPath];
    [crxCell crx_configureWithMessage:self.crxMessages[indexPath.section]];
    return crxCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.crxMessages.count - 1 ? 0.f : 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *crxView = [[UIView alloc] init];
    crxView.backgroundColor = UIColor.clearColor;
    return crxView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CAREXQChannelController *crxController = [[CAREXQChannelController alloc] init];
    crxController.crxMessageItem = self.crxMessages[indexPath.section];
    [self.navigationController pushViewController:crxController animated:YES];
}

- (void)crx_reloadHeaderAndList {
    if (!self.crxTableView) {
        return;
    }
    CAREXQSignalHeaderView *crxHeaderView = [[CAREXQSignalHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 138)];
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

- (void)crx_refreshLoginState {
    BOOL crxLoggedIn = [self crx_isLoggedIn];
    self.crxEmptyStateView.hidden = YES;
    self.crxTableView.tableFooterView = crxLoggedIn ? [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 1)] : [self crx_buildEmptyFooterView];
    [self crx_reloadHeaderAndList];
}

- (void)crxLoginTapped {
    CAREXQEntryController *crxController = [[CAREXQEntryController alloc] init];
    [self.navigationController pushViewController:crxController animated:YES];
}

- (UIView *)crx_buildEmptyFooterView {
    CGFloat crxFooterHeight = 400.0;
    UIView *crxFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, crxFooterHeight)];
    crxFooterView.backgroundColor = UIColor.clearColor;

    UILabel *crxEmptyLabel = [[UILabel alloc] init];
    crxEmptyLabel.text = @"Please log in to view your messages.";
    crxEmptyLabel.textColor = [UIColor colorWithWhite:1 alpha:0.74];
    crxEmptyLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    crxEmptyLabel.textAlignment = NSTextAlignmentCenter;
    crxEmptyLabel.numberOfLines = 0;
    [crxFooterView addSubview:crxEmptyLabel];
    crxEmptyLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIButton *crxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxLoginButton setTitle:@"Log in" forState:UIControlStateNormal];
    [crxLoginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    crxLoginButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    crxLoginButton.layer.cornerRadius = 24.f;
    crxLoginButton.layer.masksToBounds = YES;
    [crxLoginButton addTarget:self action:@selector(crxLoginTapped) forControlEvents:UIControlEventTouchUpInside];
    [crxFooterView addSubview:crxLoginButton];
    crxLoginButton.translatesAutoresizingMaskIntoConstraints = NO;

    CAGradientLayer *crxLoginGradientLayer = [CAGradientLayer layer];
    crxLoginGradientLayer.startPoint = CGPointMake(0, 0.5);
    crxLoginGradientLayer.endPoint = CGPointMake(1, 0.5);
    crxLoginGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
    ];
    crxLoginGradientLayer.frame = CGRectMake(0, 0, 188, 52);
    crxLoginGradientLayer.cornerRadius = 26.f;
    [crxLoginButton.layer insertSublayer:crxLoginGradientLayer atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
        [crxEmptyLabel.centerXAnchor constraintEqualToAnchor:crxFooterView.centerXAnchor],
        [crxEmptyLabel.centerYAnchor constraintEqualToAnchor:crxFooterView.centerYAnchor constant:-42],
        [crxEmptyLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:crxFooterView.leadingAnchor constant:24],
        [crxEmptyLabel.trailingAnchor constraintLessThanOrEqualToAnchor:crxFooterView.trailingAnchor constant:-24],

        [crxLoginButton.topAnchor constraintEqualToAnchor:crxEmptyLabel.bottomAnchor constant:16],
        [crxLoginButton.centerXAnchor constraintEqualToAnchor:crxFooterView.centerXAnchor],
        [crxLoginButton.widthAnchor constraintEqualToConstant:188],
        [crxLoginButton.heightAnchor constraintEqualToConstant:52]
    ]];

    return crxFooterView;
}

- (void)crx_reloadSignalData {
    if (self.crxLoadingSignalData) {
        return;
    }
    self.crxLoadingSignalData = YES;
    [self crx_showLoadingWithText:@"Loading..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.crxLoadingSignalData = NO;
        [self crx_buildMockData];
        [self crx_refreshLoginState];
        [self crx_hideLoading];
    });
}

@end
