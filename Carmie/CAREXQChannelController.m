//
//  CAREXQChannelController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQChannelController.h"
#import "CAREXQImage.h"
#import "CAREXQVideoCallController.h"

@interface CAREXQChannelController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *crxTableView;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *crxItems;
@property (nonatomic, strong) UITextField *crxInputField;

@end

@implementation CAREXQChannelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildData];
    [self crx_buildViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)crx_buildData {
    NSString *crxName = self.crxMessageItem[@"crxName"] ?: @"Hayden";
    NSArray<NSDictionary *> *crxStoredItems = [NSUserDefaults.standardUserDefaults objectForKey:[self crx_messageStorageKey]];
    if ([crxStoredItems isKindOfClass:NSArray.class] && crxStoredItems.count > 0) {
        self.crxItems = [crxStoredItems mutableCopy];
        return;
    }

    self.crxItems = [@[
        @{@"crxMine": @NO, @"crxText": [NSString stringWithFormat:@"Hey, %@ here. Want to try a new hand dance later?", crxName]},
        @{@"crxMine": @YES, @"crxText": @"Sure, I am practicing slow finger rhythm right now."},
        @{@"crxMine": @NO, @"crxText": @"Nice, send me the version with cleaner wrist turns."},
        @{@"crxMine": @YES, @"crxText": @"I will polish it tonight and share the clip with you."}
    ] mutableCopy];
}

- (void)crx_buildViews {
    UIButton *crxBackButton = [self crx_buildTopButtonWithSystemImage:@"chevron.left"];
    [crxBackButton addTarget:self action:@selector(crx_backTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxBackButton];
    crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *crxAvatarView = [[UIImageView alloc] initWithImage:self.crxMessageItem[@"crxAvatar"] ?: [CAREXQImage imageNamed:@"crx_head_1"]];
    crxAvatarView.layer.cornerRadius = 20;
    crxAvatarView.clipsToBounds = YES;
    crxAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxAvatarView];

    UILabel *crxNameLabel = [[UILabel alloc] init];
    crxNameLabel.text = self.crxMessageItem[@"crxName"] ?: @"Hayden";
    crxNameLabel.textColor = UIColor.whiteColor;
    crxNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxNameLabel];

    UILabel *crxStatusLabel = [[UILabel alloc] init];
    crxStatusLabel.text = @"online now";
    crxStatusLabel.textColor = [UIColor colorWithRed:0.42 green:1.0 blue:0.55 alpha:1.0];
    crxStatusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    crxStatusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxStatusLabel];

    UIButton *crxVideoButton = [self crx_buildTopButtonWithSystemImage:@"video.fill"];
    [crxVideoButton addTarget:self action:@selector(crx_videoTapped) forControlEvents:UIControlEventTouchUpInside];
    crxVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxVideoButton];

    UIButton *crxMoreButton = [self crx_buildTopButtonWithSystemImage:@"ellipsis"];
    [crxMoreButton addTarget:self action:@selector(crx_moreTapped) forControlEvents:UIControlEventTouchUpInside];
    crxMoreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxMoreButton];

    self.crxTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.crxTableView.backgroundColor = UIColor.clearColor;
    self.crxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.crxTableView.dataSource = self;
    self.crxTableView.delegate = self;
    self.crxTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxTableView];

    UIView *crxInputWrap = [[UIView alloc] init];
    crxInputWrap.backgroundColor = [UIColor colorWithRed:0x15/255.0 green:0x0C/255.0 blue:0x2D/255.0 alpha:1.0];
    crxInputWrap.layer.cornerRadius = 22;
    crxInputWrap.layer.borderWidth = 1;
    crxInputWrap.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.16].CGColor;
    crxInputWrap.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxInputWrap];

    self.crxInputField = [[UITextField alloc] init];
    self.crxInputField.delegate = self;
    self.crxInputField.textColor = UIColor.whiteColor;
    self.crxInputField.returnKeyType = UIReturnKeySend;
    self.crxInputField.enablesReturnKeyAutomatically = YES;
    self.crxInputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type a message..." attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.52]}];
    self.crxInputField.translatesAutoresizingMaskIntoConstraints = NO;
    [crxInputWrap addSubview:self.crxInputField];

    UIButton *crxSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxSendButton setImage:[CAREXQImage imageNamed:@"crx_send_btn"] forState:UIControlStateNormal];
    [crxSendButton addTarget:self action:@selector(crx_sendTapped) forControlEvents:UIControlEventTouchUpInside];
    crxSendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxSendButton];

    [NSLayoutConstraint activateConstraints:@[
        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:12],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [crxBackButton.widthAnchor constraintEqualToConstant:34],
        [crxBackButton.heightAnchor constraintEqualToConstant:34],

        [crxAvatarView.centerYAnchor constraintEqualToAnchor:crxBackButton.centerYAnchor],
        [crxAvatarView.leadingAnchor constraintEqualToAnchor:crxBackButton.trailingAnchor constant:14],
        [crxAvatarView.widthAnchor constraintEqualToConstant:40],
        [crxAvatarView.heightAnchor constraintEqualToConstant:40],

        [crxNameLabel.topAnchor constraintEqualToAnchor:crxAvatarView.topAnchor],
        [crxNameLabel.leadingAnchor constraintEqualToAnchor:crxAvatarView.trailingAnchor constant:10],

        [crxStatusLabel.topAnchor constraintEqualToAnchor:crxNameLabel.bottomAnchor constant:4],
        [crxStatusLabel.leadingAnchor constraintEqualToAnchor:crxNameLabel.leadingAnchor],

        [crxMoreButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-18],
        [crxMoreButton.centerYAnchor constraintEqualToAnchor:crxBackButton.centerYAnchor],
        [crxMoreButton.widthAnchor constraintEqualToConstant:34],
        [crxMoreButton.heightAnchor constraintEqualToConstant:34],

        [crxVideoButton.trailingAnchor constraintEqualToAnchor:crxMoreButton.leadingAnchor constant:-10],
        [crxVideoButton.centerYAnchor constraintEqualToAnchor:crxMoreButton.centerYAnchor],
        [crxVideoButton.widthAnchor constraintEqualToConstant:34],
        [crxVideoButton.heightAnchor constraintEqualToConstant:34],

        [self.crxTableView.topAnchor constraintEqualToAnchor:crxBackButton.bottomAnchor constant:20],
        [self.crxTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.crxTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.crxTableView.bottomAnchor constraintEqualToAnchor:crxInputWrap.topAnchor constant:-16],

        [crxInputWrap.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [crxInputWrap.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-12],
        [crxInputWrap.heightAnchor constraintEqualToConstant:48],
        [crxInputWrap.trailingAnchor constraintEqualToAnchor:crxSendButton.leadingAnchor constant:-12],

        [self.crxInputField.topAnchor constraintEqualToAnchor:crxInputWrap.topAnchor],
        [self.crxInputField.leadingAnchor constraintEqualToAnchor:crxInputWrap.leadingAnchor constant:14],
        [self.crxInputField.trailingAnchor constraintEqualToAnchor:crxInputWrap.trailingAnchor constant:-14],
        [self.crxInputField.bottomAnchor constraintEqualToAnchor:crxInputWrap.bottomAnchor],

        [crxSendButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [crxSendButton.centerYAnchor constraintEqualToAnchor:crxInputWrap.centerYAnchor],
        [crxSendButton.widthAnchor constraintEqualToConstant:44],
        [crxSendButton.heightAnchor constraintEqualToConstant:44]
    ]];
}

- (UIButton *)crx_buildTopButtonWithSystemImage:(NSString *)crxSystemName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.46];
    crxButton.layer.cornerRadius = 11;
    [crxButton setImage:[UIImage systemImageNamed:crxSystemName] forState:UIControlStateNormal];
    crxButton.tintColor = UIColor.whiteColor;
    return crxButton;
}

- (void)crx_backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)crx_messageStorageKey {
    NSString *crxName = self.crxMessageItem[@"crxName"] ?: @"default";
    return [NSString stringWithFormat:@"crx.channel.messages.%@", crxName];
}

- (void)crx_storeMessages {
    [NSUserDefaults.standardUserDefaults setObject:self.crxItems.copy forKey:[self crx_messageStorageKey]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crxItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *crxCell = [tableView dequeueReusableCellWithIdentifier:@"crxChatCell"];
    if (!crxCell) {
        crxCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"crxChatCell"];
    }
    crxCell.backgroundColor = UIColor.clearColor;
    crxCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [crxCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSDictionary *crxItem = self.crxItems[indexPath.row];
    BOOL crxMine = [crxItem[@"crxMine"] boolValue];

    UIView *crxBubble = [[UIView alloc] init];
    crxBubble.backgroundColor = crxMine ? [UIColor colorWithRed:0.72 green:0.15 blue:0.95 alpha:1.0] : [UIColor colorWithRed:0x19/255.0 green:0x0E/255.0 blue:0x31/255.0 alpha:1.0];
    crxBubble.layer.cornerRadius = 18;
    crxBubble.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCell.contentView addSubview:crxBubble];

    UILabel *crxLabel = [[UILabel alloc] init];
    crxLabel.text = crxItem[@"crxText"];
    crxLabel.numberOfLines = 0;
    crxLabel.textColor = UIColor.whiteColor;
    crxLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    crxLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxBubble addSubview:crxLabel];

    [NSLayoutConstraint activateConstraints:@[
        [crxBubble.topAnchor constraintEqualToAnchor:crxCell.contentView.topAnchor constant:8],
        [crxBubble.bottomAnchor constraintEqualToAnchor:crxCell.contentView.bottomAnchor constant:-8],
        [crxBubble.widthAnchor constraintLessThanOrEqualToConstant:250],
        crxMine ? [crxBubble.trailingAnchor constraintEqualToAnchor:crxCell.contentView.trailingAnchor] : [crxBubble.leadingAnchor constraintEqualToAnchor:crxCell.contentView.leadingAnchor],

        [crxLabel.topAnchor constraintEqualToAnchor:crxBubble.topAnchor constant:12],
        [crxLabel.leadingAnchor constraintEqualToAnchor:crxBubble.leadingAnchor constant:14],
        [crxLabel.trailingAnchor constraintEqualToAnchor:crxBubble.trailingAnchor constant:-14],
        [crxLabel.bottomAnchor constraintEqualToAnchor:crxBubble.bottomAnchor constant:-12]
    ]];
    return crxCell;
}

- (void)crx_sendTapped {
    [self.view endEditing:YES];
    NSString *crxText = [self.crxInputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (crxText.length == 0) {
        return;
    }
    [self.crxItems addObject:@{@"crxMine": @YES, @"crxText": crxText}];
    [self crx_storeMessages];
    self.crxInputField.text = @"";
    [self.crxTableView reloadData];
    NSIndexPath *crxLastIndexPath = [NSIndexPath indexPathForRow:self.crxItems.count - 1 inSection:0];
    [self.crxTableView scrollToRowAtIndexPath:crxLastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self crx_sendTapped];
    return NO;
}

- (void)crx_videoTapped {
    CAREXQVideoCallController *crxController = [[CAREXQVideoCallController alloc] init];
    crxController.modalPresentationStyle = UIModalPresentationFullScreen;
    crxController.crxMessageItem = self.crxMessageItem;
    __weak typeof(self) weakSelf = self;
    crxController.crxTimeoutHandler = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        UIAlertController *crxAlert = [UIAlertController alertControllerWithTitle:nil message:@"The other party did not respond." preferredStyle:UIAlertControllerStyleAlert];
        [crxAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [strongSelf presentViewController:crxAlert animated:YES completion:nil];
    };
    [self presentViewController:crxController animated:YES completion:nil];
}

- (void)crx_moreTapped {
    NSString *crxName = self.crxMessageItem[@"crxName"] ?: @"";
    __weak typeof(self) weakSelf = self;
    [self crx_presentModerationForUserName:crxName blockHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end
