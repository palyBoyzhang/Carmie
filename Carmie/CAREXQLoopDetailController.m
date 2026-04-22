//
//  CAREXQLoopDetailController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQLoopDetailController.h"
#import "CAREXQImage.h"

@interface CAREXQLoopDetailController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *crxMediaScrollView;
@property (nonatomic, strong) UIPageControl *crxPageControl;
@property (nonatomic, strong) UIButton *crxLikeButton;
@property (nonatomic, strong) UIButton *crxFollowButton;
@property (nonatomic, strong) UITextField *crxCommentField;
@property (nonatomic, strong) UIScrollView *crxCommentScrollView;
@property (nonatomic, strong) UIStackView *crxCommentStackView;
@property (nonatomic, strong) NSArray<UIImage *> *crxMediaImages;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *crxComments;
@property (nonatomic, assign) BOOL crxLiked;
@property (nonatomic, assign) BOOL crxFollowed;

@end

@implementation CAREXQLoopDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1.0];
    [self crx_restoreState];
    [self crx_loadComments];
    [self crx_buildViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)crx_buildViews {
    NSDictionary *crxPayload = [self crx_payload];
    self.crxMediaImages = crxPayload[@"crxMediaImages"];

    UIButton *crxBackButton = [self crx_circleButtonWithSystemName:@"chevron.left"];
    [crxBackButton addTarget:self action:@selector(crx_backTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxBackButton];

    UIButton *crxMoreButton = [self crx_circleButtonWithSystemName:@"ellipsis"];
    [crxMoreButton addTarget:self action:@selector(crx_moreTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxMoreButton];

    UIImageView *crxTopAvatarView = [[UIImageView alloc] initWithImage:crxPayload[@"crxAvatar"]];
    crxTopAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    crxTopAvatarView.layer.cornerRadius = 16;
    crxTopAvatarView.clipsToBounds = YES;
    crxTopAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxTopAvatarView];

    UILabel *crxTopNameLabel = [[UILabel alloc] init];
    crxTopNameLabel.text = crxPayload[@"crxTopName"];
    crxTopNameLabel.textColor = UIColor.whiteColor;
    crxTopNameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    crxTopNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxTopNameLabel];

    UIView *crxMediaCardView = [[UIView alloc] init];
    crxMediaCardView.backgroundColor = [UIColor colorWithRed:0x1A/255.0 green:0x0B/255.0 blue:0x2F/255.0 alpha:1.0];
    crxMediaCardView.layer.cornerRadius = 18;
    crxMediaCardView.clipsToBounds = YES;
    crxMediaCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxMediaCardView];

    self.crxMediaScrollView = [[UIScrollView alloc] init];
    self.crxMediaScrollView.pagingEnabled = YES;
    self.crxMediaScrollView.showsHorizontalScrollIndicator = NO;
    self.crxMediaScrollView.delegate = self;
    self.crxMediaScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxMediaCardView addSubview:self.crxMediaScrollView];

    UIView *crxMediaContentView = [[UIView alloc] init];
    crxMediaContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxMediaScrollView addSubview:crxMediaContentView];

    UIView *crxLastImageView = nil;
    for (UIImage *crxImage in self.crxMediaImages) {
        UIImageView *crxImageView = [[UIImageView alloc] initWithImage:crxImage];
        crxImageView.contentMode = UIViewContentModeScaleAspectFill;
        crxImageView.clipsToBounds = YES;
        crxImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [crxMediaContentView addSubview:crxImageView];

        [NSLayoutConstraint activateConstraints:@[
            [crxImageView.topAnchor constraintEqualToAnchor:crxMediaContentView.topAnchor],
            [crxImageView.bottomAnchor constraintEqualToAnchor:crxMediaContentView.bottomAnchor],
            [crxImageView.widthAnchor constraintEqualToAnchor:crxMediaCardView.widthAnchor]
        ]];
        if (crxLastImageView) {
            [crxImageView.leadingAnchor constraintEqualToAnchor:crxLastImageView.trailingAnchor].active = YES;
        } else {
            [crxImageView.leadingAnchor constraintEqualToAnchor:crxMediaContentView.leadingAnchor].active = YES;
        }
        crxLastImageView = crxImageView;
    }
    [crxLastImageView.trailingAnchor constraintEqualToAnchor:crxMediaContentView.trailingAnchor].active = YES;

    UIView *crxMediaGradientMask = [[UIView alloc] init];
    crxMediaGradientMask.translatesAutoresizingMaskIntoConstraints = NO;
    [crxMediaCardView addSubview:crxMediaGradientMask];

    CAGradientLayer *crxMaskGradient = [CAGradientLayer layer];
    crxMaskGradient.colors = @[
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.10].CGColor,
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.58].CGColor
    ];
    crxMaskGradient.startPoint = CGPointMake(0.5, 0.0);
    crxMaskGradient.endPoint = CGPointMake(0.5, 1.0);
    [crxMediaGradientMask.layer addSublayer:crxMaskGradient];

    UILabel *crxOverlayTextLabel = [[UILabel alloc] init];
    crxOverlayTextLabel.text = crxPayload[@"crxOverlayText"];
    crxOverlayTextLabel.textColor = [UIColor colorWithWhite:1 alpha:0.88];
    crxOverlayTextLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    crxOverlayTextLabel.numberOfLines = 2;
    crxOverlayTextLabel.textAlignment = NSTextAlignmentCenter;
    crxOverlayTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxMediaCardView addSubview:crxOverlayTextLabel];

    self.crxPageControl = [[UIPageControl alloc] init];
    self.crxPageControl.numberOfPages = self.crxMediaImages.count;
    self.crxPageControl.currentPage = 0;
    self.crxPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.35];
    self.crxPageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
    self.crxPageControl.userInteractionEnabled = NO;
    self.crxPageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [crxMediaCardView addSubview:self.crxPageControl];

    self.crxCommentScrollView = [[UIScrollView alloc] init];
    self.crxCommentScrollView.showsVerticalScrollIndicator = NO;
    self.crxCommentScrollView.alwaysBounceVertical = YES;
    self.crxCommentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxCommentScrollView];

    UIView *crxCommentContentView = [[UIView alloc] init];
    crxCommentContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxCommentScrollView addSubview:crxCommentContentView];

    self.crxCommentStackView = [[UIStackView alloc] init];
    self.crxCommentStackView.axis = UILayoutConstraintAxisVertical;
    self.crxCommentStackView.spacing = 14;
    self.crxCommentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCommentContentView addSubview:self.crxCommentStackView];

    UIView *crxToolBar = [[UIView alloc] init];
    crxToolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxToolBar];

    UIView *crxInputView = [[UIView alloc] init];
    crxInputView.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x10/255.0 blue:0x45/255.0 alpha:0.98];
    crxInputView.layer.cornerRadius = 18;
    crxInputView.layer.borderWidth = 1;
    crxInputView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    crxInputView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxToolBar addSubview:crxInputView];

    UIImageView *crxInputIcon = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_board_add"]];
    crxInputIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [crxInputView addSubview:crxInputIcon];

    self.crxCommentField = [[UITextField alloc] init];
    self.crxCommentField.delegate = self;
    self.crxCommentField.placeholder = @"Add comments...";
    self.crxCommentField.textColor = UIColor.whiteColor;
    self.crxCommentField.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.crxCommentField.returnKeyType = UIReturnKeySend;
    self.crxCommentField.enablesReturnKeyAutomatically = YES;
    self.crxCommentField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add comments..." attributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.45]
    }];
    self.crxCommentField.translatesAutoresizingMaskIntoConstraints = NO;
    [crxInputView addSubview:self.crxCommentField];

    self.crxLikeButton = [self crx_toolbarCircleButtonWithImageName:@"crx_board_aixin"];
    [self.crxLikeButton addTarget:self action:@selector(crx_toggleLike) forControlEvents:UIControlEventTouchUpInside];
    [crxToolBar addSubview:self.crxLikeButton];

    self.crxFollowButton = [self crx_toolbarCircleButtonWithImageName:@"crx_board_flo"];
    [self.crxFollowButton addTarget:self action:@selector(crx_toggleFollow) forControlEvents:UIControlEventTouchUpInside];
    [crxToolBar addSubview:self.crxFollowButton];

    UIButton *crxCallButton = [self crx_toolbarCircleButtonWithImageName:@"crx_board_more"];
    [crxCallButton addTarget:self action:@selector(crx_moreTapped) forControlEvents:UIControlEventTouchUpInside];
    [crxToolBar addSubview:crxCallButton];

    [NSLayoutConstraint activateConstraints:@[
        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [crxBackButton.widthAnchor constraintEqualToConstant:36],
        [crxBackButton.heightAnchor constraintEqualToConstant:36],

        [crxMoreButton.topAnchor constraintEqualToAnchor:crxBackButton.topAnchor],
        [crxMoreButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [crxMoreButton.widthAnchor constraintEqualToConstant:36],
        [crxMoreButton.heightAnchor constraintEqualToConstant:36],

        [crxTopAvatarView.centerYAnchor constraintEqualToAnchor:crxBackButton.centerYAnchor],
        [crxTopAvatarView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-40],
        [crxTopAvatarView.widthAnchor constraintEqualToConstant:32],
        [crxTopAvatarView.heightAnchor constraintEqualToConstant:32],

        [crxTopNameLabel.leadingAnchor constraintEqualToAnchor:crxTopAvatarView.trailingAnchor constant:8],
        [crxTopNameLabel.centerYAnchor constraintEqualToAnchor:crxTopAvatarView.centerYAnchor],

        [crxMediaCardView.topAnchor constraintEqualToAnchor:crxBackButton.bottomAnchor constant:22],
        [crxMediaCardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [crxMediaCardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [crxMediaCardView.heightAnchor constraintEqualToConstant:408],

        [self.crxMediaScrollView.topAnchor constraintEqualToAnchor:crxMediaCardView.topAnchor],
        [self.crxMediaScrollView.leadingAnchor constraintEqualToAnchor:crxMediaCardView.leadingAnchor],
        [self.crxMediaScrollView.trailingAnchor constraintEqualToAnchor:crxMediaCardView.trailingAnchor],
        [self.crxMediaScrollView.bottomAnchor constraintEqualToAnchor:crxMediaCardView.bottomAnchor],

        [crxMediaContentView.topAnchor constraintEqualToAnchor:self.crxMediaScrollView.contentLayoutGuide.topAnchor],
        [crxMediaContentView.leadingAnchor constraintEqualToAnchor:self.crxMediaScrollView.contentLayoutGuide.leadingAnchor],
        [crxMediaContentView.trailingAnchor constraintEqualToAnchor:self.crxMediaScrollView.contentLayoutGuide.trailingAnchor],
        [crxMediaContentView.bottomAnchor constraintEqualToAnchor:self.crxMediaScrollView.contentLayoutGuide.bottomAnchor],
        [crxMediaContentView.heightAnchor constraintEqualToAnchor:self.crxMediaScrollView.frameLayoutGuide.heightAnchor],

        [crxMediaGradientMask.leadingAnchor constraintEqualToAnchor:crxMediaCardView.leadingAnchor],
        [crxMediaGradientMask.trailingAnchor constraintEqualToAnchor:crxMediaCardView.trailingAnchor],
        [crxMediaGradientMask.bottomAnchor constraintEqualToAnchor:crxMediaCardView.bottomAnchor],
        [crxMediaGradientMask.heightAnchor constraintEqualToConstant:150],

        [crxOverlayTextLabel.leadingAnchor constraintEqualToAnchor:crxMediaCardView.leadingAnchor constant:36],
        [crxOverlayTextLabel.trailingAnchor constraintEqualToAnchor:crxMediaCardView.trailingAnchor constant:-36],
        [crxOverlayTextLabel.bottomAnchor constraintEqualToAnchor:self.crxPageControl.topAnchor constant:-10],

        [self.crxPageControl.centerXAnchor constraintEqualToAnchor:crxMediaCardView.centerXAnchor],
        [self.crxPageControl.bottomAnchor constraintEqualToAnchor:crxMediaCardView.bottomAnchor constant:-14],

        [self.crxCommentScrollView.topAnchor constraintEqualToAnchor:crxMediaCardView.bottomAnchor constant:18],
        [self.crxCommentScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.crxCommentScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.crxCommentScrollView.bottomAnchor constraintEqualToAnchor:crxToolBar.topAnchor constant:-16],

        [crxCommentContentView.topAnchor constraintEqualToAnchor:self.crxCommentScrollView.contentLayoutGuide.topAnchor],
        [crxCommentContentView.leadingAnchor constraintEqualToAnchor:self.crxCommentScrollView.contentLayoutGuide.leadingAnchor],
        [crxCommentContentView.trailingAnchor constraintEqualToAnchor:self.crxCommentScrollView.contentLayoutGuide.trailingAnchor],
        [crxCommentContentView.bottomAnchor constraintEqualToAnchor:self.crxCommentScrollView.contentLayoutGuide.bottomAnchor],
        [crxCommentContentView.widthAnchor constraintEqualToAnchor:self.crxCommentScrollView.frameLayoutGuide.widthAnchor],

        [self.crxCommentStackView.topAnchor constraintEqualToAnchor:crxCommentContentView.topAnchor],
        [self.crxCommentStackView.leadingAnchor constraintEqualToAnchor:crxCommentContentView.leadingAnchor],
        [self.crxCommentStackView.trailingAnchor constraintEqualToAnchor:crxCommentContentView.trailingAnchor],
        [self.crxCommentStackView.bottomAnchor constraintEqualToAnchor:crxCommentContentView.bottomAnchor],

        [crxToolBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [crxToolBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [crxToolBar.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-8],
        [crxToolBar.heightAnchor constraintEqualToConstant:44],

        [crxInputView.leadingAnchor constraintEqualToAnchor:crxToolBar.leadingAnchor],
        [crxInputView.centerYAnchor constraintEqualToAnchor:crxToolBar.centerYAnchor],
        [crxInputView.heightAnchor constraintEqualToConstant:36],
        [crxInputView.widthAnchor constraintEqualToConstant:160],

        [crxInputIcon.leadingAnchor constraintEqualToAnchor:crxInputView.leadingAnchor constant:12],
        [crxInputIcon.centerYAnchor constraintEqualToAnchor:crxInputView.centerYAnchor],
        [crxInputIcon.widthAnchor constraintEqualToConstant:16],
        [crxInputIcon.heightAnchor constraintEqualToConstant:16],

        [self.crxCommentField.leadingAnchor constraintEqualToAnchor:crxInputIcon.trailingAnchor constant:8],
        [self.crxCommentField.trailingAnchor constraintEqualToAnchor:crxInputView.trailingAnchor constant:-12],
        [self.crxCommentField.topAnchor constraintEqualToAnchor:crxInputView.topAnchor],
        [self.crxCommentField.bottomAnchor constraintEqualToAnchor:crxInputView.bottomAnchor],

        [crxCallButton.trailingAnchor constraintEqualToAnchor:crxToolBar.trailingAnchor],
        [crxCallButton.centerYAnchor constraintEqualToAnchor:crxToolBar.centerYAnchor],
        [crxCallButton.widthAnchor constraintEqualToConstant:36],
        [crxCallButton.heightAnchor constraintEqualToConstant:36],

        [self.crxFollowButton.trailingAnchor constraintEqualToAnchor:crxCallButton.leadingAnchor constant:-10],
        [self.crxFollowButton.centerYAnchor constraintEqualToAnchor:crxToolBar.centerYAnchor],
        [self.crxFollowButton.widthAnchor constraintEqualToConstant:36],
        [self.crxFollowButton.heightAnchor constraintEqualToConstant:36],

        [self.crxLikeButton.trailingAnchor constraintEqualToAnchor:self.crxFollowButton.leadingAnchor constant:-10],
        [self.crxLikeButton.centerYAnchor constraintEqualToAnchor:crxToolBar.centerYAnchor],
        [self.crxLikeButton.widthAnchor constraintEqualToConstant:36],
        [self.crxLikeButton.heightAnchor constraintEqualToConstant:36]
    ]];

    [self crx_refreshToolbarStates];
    [self crx_reloadComments];

    dispatch_async(dispatch_get_main_queue(), ^{
        crxMaskGradient.frame = crxMediaGradientMask.bounds;
    });
}

- (UIButton *)crx_circleButtonWithSystemName:(NSString *)crxSystemName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.40];
    crxButton.layer.cornerRadius = 18;
    [crxButton setImage:[UIImage systemImageNamed:crxSystemName] forState:UIControlStateNormal];
    crxButton.tintColor = UIColor.whiteColor;
    crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    return crxButton;
}

- (UIButton *)crx_toolbarCircleButtonWithImageName:(NSString *)crxImageName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = UIColor.clearColor;
    crxButton.layer.cornerRadius = 18;
    crxButton.layer.borderWidth = 1;
    crxButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.50].CGColor;
    [crxButton setImage:[CAREXQImage imageNamed:crxImageName] forState:UIControlStateNormal];
    crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    return crxButton;
}

- (NSDictionary *)crx_payload {
    UIImage *crxAvatar = self.crxMomentItem[@"crxAvatar"] ?: [CAREXQImage imageNamed:@"crx_head_1"] ?: UIImage.new;
    NSString *crxName = self.crxMomentItem[@"crxName"] ?: @"Hayden";
    NSString *crxAuthorName = [crxName isEqualToString:@"Alyssa"] ? @"Alyssa" : @"Kallisto";
    NSString *crxTopName = [crxName isEqualToString:@"Alyssa"] ? @"Alyssa" : @"Aelwen";
    NSString *crxText = self.crxMomentItem[@"crxContent"] ?: @"Went to the offline roleplay this weekend and really enjoyable.";
    UIImage *crxLeft = self.crxMomentItem[@"crxImageLeft"] ?: [CAREXQImage imageNamed:@"crx_dy_1"] ?: UIImage.new;
    UIImage *crxRight = self.crxMomentItem[@"crxImageRight"] ?: [CAREXQImage imageNamed:@"crx_dy_2"] ?: UIImage.new;
    NSArray<UIImage *> *crxImages = @[crxLeft, crxRight];

    return @{
        @"crxAvatar": crxAvatar,
        @"crxTopName": [NSString stringWithFormat:@"%@🎭🎟️❤️", crxTopName],
        @"crxAuthorName": crxAuthorName,
        @"crxAuthorContent": @"I miss seeing these dances. Can't wait to attend the next ceremony.",
        @"crxOverlayText": crxText,
        @"crxMediaImages": crxImages
    };
}

- (NSString *)crx_stateKeyForSuffix:(NSString *)crxSuffix {
    NSString *crxName = self.crxMomentItem[@"crxName"] ?: @"default";
    NSString *crxText = self.crxMomentItem[@"crxContent"] ?: @"";
    return [NSString stringWithFormat:@"crx.loop.detail.%@.%@.%lu", crxSuffix, crxName, (unsigned long)crxText.hash];
}

- (void)crx_restoreState {
    NSUserDefaults *crxDefaults = NSUserDefaults.standardUserDefaults;
    self.crxLiked = [crxDefaults boolForKey:[self crx_stateKeyForSuffix:@"liked"]];
    self.crxFollowed = [crxDefaults boolForKey:[self crx_stateKeyForSuffix:@"followed"]];
}

- (NSString *)crx_commentsStorageKey {
    return [self crx_stateKeyForSuffix:@"comments"];
}

- (void)crx_loadComments {
    NSArray *crxStoredComments = [NSUserDefaults.standardUserDefaults objectForKey:[self crx_commentsStorageKey]];
    if ([crxStoredComments isKindOfClass:NSArray.class] && crxStoredComments.count > 0) {
        self.crxComments = [crxStoredComments mutableCopy];
        return;
    }

    NSDictionary *crxPayload = [self crx_payload];
    self.crxComments = [NSMutableArray arrayWithObject:@{
        @"crxAvatarName": self.crxMomentItem[@"crxAvatarName"] ?: @"crx_head_1",
        @"crxName": crxPayload[@"crxAuthorName"] ?: @"Kallisto",
        @"crxContent": crxPayload[@"crxAuthorContent"] ?: @"I miss seeing these dances. Can't wait to attend the next ceremony.",
        @"crxTime": @"2 minutes ago",
        @"crxHeat": @"12.5",
        @"crxShowHeat": @YES
    }];
}

- (void)crx_storeComments {
    [NSUserDefaults.standardUserDefaults setObject:self.crxComments.copy forKey:[self crx_commentsStorageKey]];
}

- (void)crx_reloadComments {
    for (UIView *crxView in self.crxCommentStackView.arrangedSubviews) {
        [self.crxCommentStackView removeArrangedSubview:crxView];
        [crxView removeFromSuperview];
    }

    for (NSDictionary *crxComment in self.crxComments) {
        [self.crxCommentStackView addArrangedSubview:[self crx_commentViewForItem:crxComment]];
    }
}

- (UIView *)crx_commentViewForItem:(NSDictionary *)crxComment {
    UIView *crxRow = [[UIView alloc] init];
    crxRow.translatesAutoresizingMaskIntoConstraints = NO;

    NSString *crxAvatarName = crxComment[@"crxAvatarName"] ?: @"crx_head_1";
    UIImageView *crxAvatarView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:crxAvatarName] ?: [CAREXQImage imageNamed:@"crx_head_1"]];
    crxAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    crxAvatarView.layer.cornerRadius = 19;
    crxAvatarView.clipsToBounds = YES;
    crxAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxRow addSubview:crxAvatarView];

    UILabel *crxNameLabel = [[UILabel alloc] init];
    crxNameLabel.text = crxComment[@"crxName"] ?: @"You";
    crxNameLabel.textColor = UIColor.whiteColor;
    crxNameLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxRow addSubview:crxNameLabel];

    UILabel *crxContentLabel = [[UILabel alloc] init];
    crxContentLabel.text = crxComment[@"crxContent"] ?: @"";
    crxContentLabel.textColor = [UIColor colorWithWhite:1 alpha:0.78];
    crxContentLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    crxContentLabel.numberOfLines = 0;
    crxContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxRow addSubview:crxContentLabel];

    UILabel *crxTimeLabel = [[UILabel alloc] init];
    crxTimeLabel.text = crxComment[@"crxTime"] ?: @"Just now";
    crxTimeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.50];
    crxTimeLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    crxTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxRow addSubview:crxTimeLabel];

    UIButton *crxHeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxHeatButton setTitle:crxComment[@"crxHeat"] ?: @"12.5" forState:UIControlStateNormal];
    [crxHeatButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.82] forState:UIControlStateNormal];
    crxHeatButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [crxHeatButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    crxHeatButton.tintColor = UIColor.whiteColor;
    crxHeatButton.userInteractionEnabled = NO;
    crxHeatButton.hidden = ![crxComment[@"crxShowHeat"] boolValue];
    crxHeatButton.translatesAutoresizingMaskIntoConstraints = NO;
    [crxRow addSubview:crxHeatButton];

    [NSLayoutConstraint activateConstraints:@[
        [crxAvatarView.topAnchor constraintEqualToAnchor:crxRow.topAnchor],
        [crxAvatarView.leadingAnchor constraintEqualToAnchor:crxRow.leadingAnchor],
        [crxAvatarView.widthAnchor constraintEqualToConstant:38],
        [crxAvatarView.heightAnchor constraintEqualToConstant:38],

        [crxNameLabel.topAnchor constraintEqualToAnchor:crxRow.topAnchor],
        [crxNameLabel.leadingAnchor constraintEqualToAnchor:crxAvatarView.trailingAnchor constant:10],
        [crxNameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:crxHeatButton.leadingAnchor constant:-12],

        [crxContentLabel.topAnchor constraintEqualToAnchor:crxNameLabel.bottomAnchor constant:3],
        [crxContentLabel.leadingAnchor constraintEqualToAnchor:crxNameLabel.leadingAnchor],
        [crxContentLabel.trailingAnchor constraintEqualToAnchor:crxRow.trailingAnchor constant:-72],

        [crxTimeLabel.topAnchor constraintEqualToAnchor:crxContentLabel.bottomAnchor constant:8],
        [crxTimeLabel.leadingAnchor constraintEqualToAnchor:crxNameLabel.leadingAnchor],
        [crxTimeLabel.bottomAnchor constraintEqualToAnchor:crxRow.bottomAnchor],

        [crxHeatButton.trailingAnchor constraintEqualToAnchor:crxRow.trailingAnchor],
        [crxHeatButton.bottomAnchor constraintEqualToAnchor:crxTimeLabel.bottomAnchor constant:-2],
        [crxHeatButton.widthAnchor constraintGreaterThanOrEqualToConstant:50]
    ]];

    return crxRow;
}

- (void)crx_refreshToolbarStates {
    [self crx_applyState:self.crxLiked toButton:self.crxLikeButton];
    [self crx_applyState:self.crxFollowed toButton:self.crxFollowButton];
}

- (void)crx_applyState:(BOOL)crxEnabled toButton:(UIButton *)crxButton {
    crxButton.layer.borderColor = (crxEnabled ? [UIColor colorWithRed:0.96 green:0.12 blue:0.77 alpha:1.0] : [UIColor colorWithWhite:1 alpha:0.50]).CGColor;
    crxButton.backgroundColor = crxEnabled ? [UIColor colorWithRed:0.28 green:0.02 blue:0.35 alpha:1.0] : UIColor.clearColor;
}

- (void)crx_toggleLike {
    self.crxLiked = !self.crxLiked;
    [NSUserDefaults.standardUserDefaults setBool:self.crxLiked forKey:[self crx_stateKeyForSuffix:@"liked"]];
    [self crx_refreshToolbarStates];
}

- (void)crx_toggleFollow {
    self.crxFollowed = !self.crxFollowed;
    [NSUserDefaults.standardUserDefaults setBool:self.crxFollowed forKey:[self crx_stateKeyForSuffix:@"followed"]];
    [self crx_refreshToolbarStates];
}

- (void)crx_backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.crxMediaScrollView || scrollView.bounds.size.width <= 0.0) {
        return;
    }
    NSInteger crxPage = (NSInteger)lround(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.crxPageControl.currentPage = MAX(0, MIN(crxPage, self.crxMediaImages.count - 1));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self crx_submitComment];
    return YES;
}

- (void)crx_submitComment {
    NSString *crxText = [self.crxCommentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (crxText.length == 0) {
        [self.crxCommentField resignFirstResponder];
        return;
    }

    NSDictionary *crxComment = @{
        @"crxAvatarName": @"crx_head_8",
        @"crxName": @"You",
        @"crxContent": crxText,
        @"crxTime": @"Just now",
        @"crxHeat": @"",
        @"crxShowHeat": @NO
    };
    [self.crxComments addObject:crxComment];
    [self crx_storeComments];
    [self crx_reloadComments];
    self.crxCommentField.text = @"";
    [self.crxCommentField resignFirstResponder];

    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat crxOffsetY = MAX(-self.crxCommentScrollView.adjustedContentInset.top,
                                 self.crxCommentScrollView.contentSize.height - self.crxCommentScrollView.bounds.size.height + self.crxCommentScrollView.adjustedContentInset.bottom);
        [self.crxCommentScrollView setContentOffset:CGPointMake(0, crxOffsetY) animated:YES];
    });
}

- (void)crx_moreTapped {
    NSString *crxName = self.crxMomentItem[@"crxName"] ?: @"";
    __weak typeof(self) weakSelf = self;
    [self crx_presentModerationForUserName:crxName blockHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end
