//
//  CRXSignalBoardController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXSignalBoardController.h"
#import "CRXSignalHeaderView.h"
#import "CRXSignalMessageCell.h"
#import "CRXChannelController.h"
#import "CRXPersonaController.h"

static NSString * const CRXSignalMessageCellID = @"CRXSignalMessageCellID";

@interface CRXSignalBoardController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *crxTableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxUsers;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxMessages;

@end

@implementation CRXSignalBoardController

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
    
    self.crxUsers = [CRXController crx_filterItems:@[
        @{@"crxName": @"Hayden", @"crxImage": crxAvatarOne ?: UIImage.new},
        @{@"crxName": @"Carson", @"crxImage": crxAvatarTwo ?: UIImage.new},
        @{@"crxName": @"Bennett", @"crxImage": crxAvatarThree ?: UIImage.new},
        @{@"crxName": @"Holden", @"crxImage": crxAvatarFour ?: UIImage.new},
        @{@"crxName": @"Tanner", @"crxImage": crxAvatarFive ?: UIImage.new},
        @{@"crxName": @"Garrett", @"crxImage": crxAvatarSix ?: UIImage.new},
        @{@"crxName": @"Malcolm", @"crxImage": crxAvatarSeven ?: UIImage.new},
        @{@"crxName": @"Alyssa", @"crxImage": crxAvatarEight ?: UIImage.new}
    ] nameKey:@"crxName"];
    
    self.crxMessages = [CRXController crx_filterItems:@[
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
    
    UIImageView *crxTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_signal_title"]];
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
    [self.crxTableView registerClass:CRXSignalMessageCell.class forCellReuseIdentifier:CRXSignalMessageCellID];
    [self.view addSubview:self.crxTableView];
    self.crxTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        
        [crxTitleView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:12],
        [crxTitleView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        
        [self.crxTableView.topAnchor constraintEqualToAnchor:crxTitleView.bottomAnchor constant:16],
        [self.crxTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    [self crx_reloadHeaderAndList];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.crxMessages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRXSignalMessageCell *crxCell = [tableView dequeueReusableCellWithIdentifier:CRXSignalMessageCellID forIndexPath:indexPath];
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
    CRXChannelController *crxController = [[CRXChannelController alloc] init];
    crxController.crxMessageItem = self.crxMessages[indexPath.section];
    [self.navigationController pushViewController:crxController animated:YES];
}

- (void)crx_reloadHeaderAndList {
    if (!self.crxTableView) {
        return;
    }
    CRXSignalHeaderView *crxHeaderView = [[CRXSignalHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 138)];
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
