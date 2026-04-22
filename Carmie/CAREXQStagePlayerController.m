//
//  CAREXQStagePlayerController.m
//  CAREXQ
//
//  Created by OpenAI on 2026/4/8.
//

#import "CAREXQStagePlayerController.h"
#import "CAREXQImage.h"
#import <AVFoundation/AVFoundation.h>

@interface CAREXQStagePlayerCommentCell : UITableViewCell

- (void)crx_configureWithComment:(NSDictionary *)crxComment;

@end

@interface CAREXQStagePlayerCommentCell ()

@property (nonatomic, strong) UIImageView *crxAvatarView;
@property (nonatomic, strong) UILabel *crxNameLabel;
@property (nonatomic, strong) UILabel *crxContentLabel;
@property (nonatomic, strong) UILabel *crxTimeLabel;
@property (nonatomic, strong) UILabel *crxLikeLabel;

@end

@implementation CAREXQStagePlayerCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self crx_setupViews];
    }
    return self;
}

- (void)crx_setupViews {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.crxAvatarView = [[UIImageView alloc] init];
    self.crxAvatarView.layer.cornerRadius = 18.0;
    self.crxAvatarView.clipsToBounds = YES;
    self.crxAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.crxAvatarView];

    self.crxNameLabel = [[UILabel alloc] init];
    self.crxNameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.crxNameLabel.textColor = UIColor.whiteColor;
    self.crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.crxNameLabel];

    self.crxContentLabel = [[UILabel alloc] init];
    self.crxContentLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.crxContentLabel.textColor = [UIColor colorWithWhite:1 alpha:0.88];
    self.crxContentLabel.numberOfLines = 0;
    self.crxContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.crxContentLabel];

    self.crxTimeLabel = [[UILabel alloc] init];
    self.crxTimeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.crxTimeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.55];
    self.crxTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.crxTimeLabel];

    UIImageView *crxHeartView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"heart"]];
    crxHeartView.tintColor = UIColor.whiteColor;
    crxHeartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:crxHeartView];

    self.crxLikeLabel = [[UILabel alloc] init];
    self.crxLikeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.crxLikeLabel.textColor = UIColor.whiteColor;
    self.crxLikeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.crxLikeLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.crxAvatarView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
        [self.crxAvatarView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.crxAvatarView.widthAnchor constraintEqualToConstant:36],
        [self.crxAvatarView.heightAnchor constraintEqualToConstant:36],

        [self.crxNameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4],
        [self.crxNameLabel.leadingAnchor constraintEqualToAnchor:self.crxAvatarView.trailingAnchor constant:12],
        [self.crxNameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:crxHeartView.leadingAnchor constant:-12],

        [self.crxContentLabel.topAnchor constraintEqualToAnchor:self.crxNameLabel.bottomAnchor constant:4],
        [self.crxContentLabel.leadingAnchor constraintEqualToAnchor:self.crxNameLabel.leadingAnchor],
        [self.crxContentLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-56],

        [self.crxTimeLabel.topAnchor constraintEqualToAnchor:self.crxContentLabel.bottomAnchor constant:8],
        [self.crxTimeLabel.leadingAnchor constraintEqualToAnchor:self.crxContentLabel.leadingAnchor],
        [self.crxTimeLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10],

        [crxHeartView.centerYAnchor constraintEqualToAnchor:self.crxTimeLabel.centerYAnchor],
        [crxHeartView.trailingAnchor constraintEqualToAnchor:self.crxLikeLabel.leadingAnchor constant:-5],
        [crxHeartView.widthAnchor constraintEqualToConstant:15],
        [crxHeartView.heightAnchor constraintEqualToConstant:15],

        [self.crxLikeLabel.centerYAnchor constraintEqualToAnchor:self.crxTimeLabel.centerYAnchor],
        [self.crxLikeLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
    ]];
}

- (void)crx_configureWithComment:(NSDictionary *)crxComment {
    self.crxAvatarView.image = [CAREXQImage imageNamed:crxComment[@"crxAvatarName"]] ?: [CAREXQImage imageNamed:@"crx_head_1"];
    self.crxNameLabel.text = crxComment[@"crxName"] ?: @"Carmie User";
    self.crxContentLabel.text = crxComment[@"crxText"] ?: @"";
    self.crxTimeLabel.text = crxComment[@"crxTimeText"] ?: @"Just now";
    self.crxLikeLabel.text = crxComment[@"crxLikeText"] ?: @"12.5";
}

@end

@interface CAREXQStagePlayerController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *crxPosterView;
@property (nonatomic, strong) UIButton *crxPlayButton;
@property (nonatomic, strong) UIView *crxBottomOverlayView;
@property (nonatomic, strong) UILabel *crxNameLabel;
@property (nonatomic, strong) UILabel *crxDescLabel;
@property (nonatomic, strong) UIImageView *crxAvatarView;
@property (nonatomic, strong) UIButton *crxFollowButton;
@property (nonatomic, strong) UIButton *crxCommentTriggerButton;
@property (nonatomic, strong) UIView *crxCommentDimView;
@property (nonatomic, strong) UIView *crxCommentSheetView;
@property (nonatomic, strong) UILabel *crxCommentTitleLabel;
@property (nonatomic, strong) UITableView *crxCommentTableView;
@property (nonatomic, strong) UITextField *crxCommentField;
@property (nonatomic, strong) UIButton *crxSendButton;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *crxComments;
@property (nonatomic, strong) AVPlayer *crxPlayer;
@property (nonatomic, strong) AVPlayerLayer *crxPlayerLayer;
@property (nonatomic, strong) NSLayoutConstraint *crxCommentSheetBottomConstraint;

@end

@implementation CAREXQStagePlayerController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self crx_prepareData];
    [self crx_setupViews];
    [self crx_reloadCommentTitle];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.crxPlayerLayer.frame = self.view.bounds;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)crx_prepareData {
    if (self.crxStageItem.count == 0) {
        self.crxStageItem = @{
            @"crxAvatarName": @"crx_head_1",
            @"crxVideoName": @"crx_stage_1",
            @"crxName": @"Hayden",
            @"crxDescription": @"Show your smoothest hand dance moves and let your gestures flow naturally with the music."
        };
    }

    NSArray<NSDictionary *> *crxCachedComments = [[NSUserDefaults standardUserDefaults] objectForKey:[self crx_commentCacheKey]];
    if (crxCachedComments.count > 0) {
        self.crxComments = crxCachedComments.mutableCopy;
        return;
    }

    NSString *crxAuthorName = self.crxStageItem[@"crxName"] ?: @"Kallisto";
    NSString *crxAvatarName = self.crxStageItem[@"crxAvatarName"] ?: @"crx_head_1";
    self.crxComments = [@[
        @{
            @"crxAvatarName": crxAvatarName,
            @"crxName": crxAuthorName,
            @"crxText": @"I miss seeing these dances. Can't wait to attend the next ceremony.",
            @"crxTimeText": @"2 minutes ago",
            @"crxLikeText": @"12.5"
        },
        @{
            @"crxAvatarName": @"crx_head_8",
            @"crxName": @"Alyssa",
            @"crxText": @"This hand dance looks so smooth, I want to try it tonight.",
            @"crxTimeText": @"5 minutes ago",
            @"crxLikeText": @"10.8"
        }
    ] mutableCopy];
}

- (void)crx_setupViews {
    self.view.backgroundColor = UIColor.blackColor;

    self.crxPosterView = [[UIImageView alloc] initWithImage:self.crxStageItem[@"crxCoverImage"]];
    self.crxPosterView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxPosterView.clipsToBounds = YES;
    self.crxPosterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxPosterView];

    UIView *crxShadeView = [[UIView alloc] init];
    crxShadeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.18];
    crxShadeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxShadeView];

    CAGradientLayer *crxBottomGradient = [CAGradientLayer layer];
    crxBottomGradient.colors = @[
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.82].CGColor
    ];
    crxBottomGradient.startPoint = CGPointMake(0.5, 0.0);
    crxBottomGradient.endPoint = CGPointMake(0.5, 1.0);

    UIView *crxGradientHolder = [[UIView alloc] init];
    crxGradientHolder.userInteractionEnabled = NO;
    crxGradientHolder.translatesAutoresizingMaskIntoConstraints = NO;
    [crxGradientHolder.layer addSublayer:crxBottomGradient];
    [self.view addSubview:crxGradientHolder];

    UIButton *crxBackButton = [self crx_buildTopButtonWithSystemImage:@"chevron.left"];
    [crxBackButton addTarget:self action:@selector(crx_backTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxBackButton];

    UIButton *crxMoreButton = [self crx_buildTopButtonWithSystemImage:@"ellipsis"];
    [crxMoreButton addTarget:self action:@selector(crx_moreTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxMoreButton];

    self.crxPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crxPlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.28];
    self.crxPlayButton.layer.cornerRadius = 34.0;
    UIImageSymbolConfiguration *crxConfig = [UIImageSymbolConfiguration configurationWithPointSize:34 weight:UIImageSymbolWeightBold];
    [self.crxPlayButton setImage:[UIImage systemImageNamed:@"play.fill" withConfiguration:crxConfig] forState:UIControlStateNormal];
    self.crxPlayButton.tintColor = UIColor.whiteColor;
    [self.crxPlayButton addTarget:self action:@selector(crx_playTapped) forControlEvents:UIControlEventTouchUpInside];
    self.crxPlayButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxPlayButton];

    self.crxBottomOverlayView = [[UIView alloc] init];
    self.crxBottomOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxBottomOverlayView];

    self.crxAvatarView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:self.crxStageItem[@"crxAvatarName"]] ?: self.crxStageItem[@"crxAvatarImage"]];
    self.crxAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxAvatarView.layer.cornerRadius = 18.0;
    self.crxAvatarView.clipsToBounds = YES;
    self.crxAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxBottomOverlayView addSubview:self.crxAvatarView];

    self.crxNameLabel = [[UILabel alloc] init];
    self.crxNameLabel.text = [NSString stringWithFormat:@"@%@", self.crxStageItem[@"crxName"] ?: @"creator"];
    self.crxNameLabel.textColor = UIColor.whiteColor;
    self.crxNameLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightSemibold];
    self.crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxBottomOverlayView addSubview:self.crxNameLabel];

    self.crxFollowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxFollowButton setTitle:@"Follow" forState:UIControlStateNormal];
    self.crxFollowButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [self.crxFollowButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxFollowButton.layer.cornerRadius = 15.0;
    self.crxFollowButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.09 blue:0.74 alpha:1.0];
    self.crxFollowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxBottomOverlayView addSubview:self.crxFollowButton];

    self.crxDescLabel = [[UILabel alloc] init];
    self.crxDescLabel.text = self.crxStageItem[@"crxDescription"] ?: @"";
    self.crxDescLabel.textColor = UIColor.whiteColor;
    self.crxDescLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.crxDescLabel.numberOfLines = 3;
    self.crxDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxBottomOverlayView addSubview:self.crxDescLabel];

    self.crxCommentTriggerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crxCommentTriggerButton.backgroundColor = [UIColor colorWithRed:0.20 green:0.07 blue:0.28 alpha:0.94];
    self.crxCommentTriggerButton.layer.cornerRadius = 18.0;
    self.crxCommentTriggerButton.layer.borderWidth = 1.0;
    self.crxCommentTriggerButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
    self.crxCommentTriggerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.crxCommentTriggerButton setTitle:@"Add comments..." forState:UIControlStateNormal];
    [self.crxCommentTriggerButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateNormal];
    [self.crxCommentTriggerButton setImage:[UIImage systemImageNamed:@"message"] forState:UIControlStateNormal];
    self.crxCommentTriggerButton.tintColor = [UIColor colorWithWhite:1 alpha:0.7];
    self.crxCommentTriggerButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [self.crxCommentTriggerButton addTarget:self action:@selector(crx_showComments) forControlEvents:UIControlEventTouchUpInside];
    self.crxCommentTriggerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxBottomOverlayView addSubview:self.crxCommentTriggerButton];

    UIButton *crxLikeButton = [self crx_buildCircleActionButtonWithSystemImage:@"heart"];
    [self.crxBottomOverlayView addSubview:crxLikeButton];

    UIButton *crxChatButton = [self crx_buildCircleActionButtonWithSystemImage:@"ellipsis.message.fill"];
    [crxChatButton addTarget:self action:@selector(crx_showComments) forControlEvents:UIControlEventTouchUpInside];
    [self.crxBottomOverlayView addSubview:crxChatButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.crxPosterView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.crxPosterView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxPosterView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxPosterView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [crxShadeView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxShadeView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxShadeView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxShadeView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [crxGradientHolder.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxGradientHolder.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxGradientHolder.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [crxGradientHolder.heightAnchor constraintEqualToConstant:340],

        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [crxBackButton.widthAnchor constraintEqualToConstant:34],
        [crxBackButton.heightAnchor constraintEqualToConstant:34],

        [crxMoreButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [crxMoreButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [crxMoreButton.widthAnchor constraintEqualToConstant:34],
        [crxMoreButton.heightAnchor constraintEqualToConstant:34],

        [self.crxPlayButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.crxPlayButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:30],
        [self.crxPlayButton.widthAnchor constraintEqualToConstant:68],
        [self.crxPlayButton.heightAnchor constraintEqualToConstant:68],

        [self.crxBottomOverlayView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [self.crxBottomOverlayView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-18],
        [self.crxBottomOverlayView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-12],

        [self.crxAvatarView.topAnchor constraintEqualToAnchor:self.crxBottomOverlayView.topAnchor],
        [self.crxAvatarView.leadingAnchor constraintEqualToAnchor:self.crxBottomOverlayView.leadingAnchor],
        [self.crxAvatarView.widthAnchor constraintEqualToConstant:36],
        [self.crxAvatarView.heightAnchor constraintEqualToConstant:36],

        [self.crxNameLabel.centerYAnchor constraintEqualToAnchor:self.crxAvatarView.centerYAnchor],
        [self.crxNameLabel.leadingAnchor constraintEqualToAnchor:self.crxAvatarView.trailingAnchor constant:10],

        [self.crxFollowButton.centerYAnchor constraintEqualToAnchor:self.crxAvatarView.centerYAnchor],
        [self.crxFollowButton.trailingAnchor constraintEqualToAnchor:self.crxBottomOverlayView.trailingAnchor],
        [self.crxFollowButton.widthAnchor constraintGreaterThanOrEqualToConstant:82],
        [self.crxFollowButton.heightAnchor constraintEqualToConstant:30],

        [self.crxDescLabel.topAnchor constraintEqualToAnchor:self.crxAvatarView.bottomAnchor constant:12],
        [self.crxDescLabel.leadingAnchor constraintEqualToAnchor:self.crxBottomOverlayView.leadingAnchor],
        [self.crxDescLabel.trailingAnchor constraintEqualToAnchor:self.crxBottomOverlayView.trailingAnchor],

        [self.crxCommentTriggerButton.topAnchor constraintEqualToAnchor:self.crxDescLabel.bottomAnchor constant:16],
        [self.crxCommentTriggerButton.leadingAnchor constraintEqualToAnchor:self.crxBottomOverlayView.leadingAnchor],
        [self.crxCommentTriggerButton.heightAnchor constraintEqualToConstant:44],
        [self.crxCommentTriggerButton.bottomAnchor constraintEqualToAnchor:self.crxBottomOverlayView.bottomAnchor],

        [crxChatButton.centerYAnchor constraintEqualToAnchor:self.crxCommentTriggerButton.centerYAnchor],
        [crxChatButton.trailingAnchor constraintEqualToAnchor:self.crxBottomOverlayView.trailingAnchor],
        [crxChatButton.widthAnchor constraintEqualToConstant:44],
        [crxChatButton.heightAnchor constraintEqualToConstant:44],

        [crxLikeButton.centerYAnchor constraintEqualToAnchor:self.crxCommentTriggerButton.centerYAnchor],
        [crxLikeButton.trailingAnchor constraintEqualToAnchor:crxChatButton.leadingAnchor constant:-10],
        [crxLikeButton.widthAnchor constraintEqualToConstant:44],
        [crxLikeButton.heightAnchor constraintEqualToConstant:44],

        [self.crxCommentTriggerButton.trailingAnchor constraintEqualToAnchor:crxLikeButton.leadingAnchor constant:-12]
    ]];

    [self crx_setupCommentSheet];

    dispatch_async(dispatch_get_main_queue(), ^{
        crxBottomGradient.frame = crxGradientHolder.bounds;
    });
}

- (void)crx_setupCommentSheet {
    self.crxCommentDimView = [[UIView alloc] init];
    self.crxCommentDimView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.48];
    self.crxCommentDimView.alpha = 0.0;
    self.crxCommentDimView.hidden = YES;
    self.crxCommentDimView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxCommentDimView];

    UITapGestureRecognizer *crxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crx_hideComments)];
    [self.crxCommentDimView addGestureRecognizer:crxTap];

    self.crxCommentSheetView = [[UIView alloc] init];
    self.crxCommentSheetView.backgroundColor = [UIColor colorWithRed:0x16/255.0 green:0x0E/255.0 blue:0x2F/255.0 alpha:0.98];
    self.crxCommentSheetView.layer.cornerRadius = 28.0;
    self.crxCommentSheetView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.crxCommentSheetView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxCommentSheetView];

    self.crxCommentTitleLabel = [[UILabel alloc] init];
    self.crxCommentTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.crxCommentTitleLabel.textColor = UIColor.whiteColor;
    self.crxCommentTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.crxCommentTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxCommentSheetView addSubview:self.crxCommentTitleLabel];

    self.crxCommentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.crxCommentTableView.backgroundColor = UIColor.clearColor;
    self.crxCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.crxCommentTableView.delegate = self;
    self.crxCommentTableView.dataSource = self;
    [self.crxCommentTableView registerClass:CAREXQStagePlayerCommentCell.class forCellReuseIdentifier:@"CAREXQStagePlayerCommentCell"];
    self.crxCommentTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxCommentSheetView addSubview:self.crxCommentTableView];

    UIView *crxInputWrapView = [[UIView alloc] init];
    crxInputWrapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxCommentSheetView addSubview:crxInputWrapView];

    UIView *crxFieldBackground = [[UIView alloc] init];
    crxFieldBackground.backgroundColor = [UIColor colorWithRed:0x2D/255.0 green:0x0B/255.0 blue:0x4D/255.0 alpha:1.0];
    crxFieldBackground.layer.cornerRadius = 20.0;
    crxFieldBackground.layer.borderWidth = 1.0;
    crxFieldBackground.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
    crxFieldBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [crxInputWrapView addSubview:crxFieldBackground];

    UIImageView *crxInputIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"message"]];
    crxInputIcon.tintColor = [UIColor colorWithWhite:1 alpha:0.65];
    crxInputIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [crxFieldBackground addSubview:crxInputIcon];

    self.crxCommentField = [[UITextField alloc] init];
    self.crxCommentField.delegate = self;
    self.crxCommentField.textColor = UIColor.whiteColor;
    self.crxCommentField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add comments..." attributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.56]
    }];
    self.crxCommentField.returnKeyType = UIReturnKeySend;
    self.crxCommentField.translatesAutoresizingMaskIntoConstraints = NO;
    [crxFieldBackground addSubview:self.crxCommentField];

    self.crxSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crxSendButton.layer.cornerRadius = 22.0;
    self.crxSendButton.clipsToBounds = YES;
    [self.crxSendButton setImage:[UIImage systemImageNamed:@"paperplane.fill"] forState:UIControlStateNormal];
    self.crxSendButton.tintColor = UIColor.whiteColor;
    [self.crxSendButton addTarget:self action:@selector(crx_sendComment) forControlEvents:UIControlEventTouchUpInside];
    self.crxSendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [crxInputWrapView addSubview:self.crxSendButton];

    CAGradientLayer *crxSendGradient = [CAGradientLayer layer];
    crxSendGradient.colors = @[
        (__bridge id)[UIColor colorWithRed:1.0 green:0.39 blue:0.42 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.93 green:0.18 blue:0.97 alpha:1.0].CGColor
    ];
    crxSendGradient.startPoint = CGPointMake(0.0, 0.5);
    crxSendGradient.endPoint = CGPointMake(1.0, 0.5);
    [self.crxSendButton.layer insertSublayer:crxSendGradient atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
        [self.crxCommentDimView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.crxCommentDimView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxCommentDimView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxCommentDimView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.crxCommentSheetView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxCommentSheetView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxCommentSheetView.heightAnchor constraintEqualToConstant:372],

        [self.crxCommentTitleLabel.topAnchor constraintEqualToAnchor:self.crxCommentSheetView.topAnchor constant:18],
        [self.crxCommentTitleLabel.leadingAnchor constraintEqualToAnchor:self.crxCommentSheetView.leadingAnchor constant:24],
        [self.crxCommentTitleLabel.trailingAnchor constraintEqualToAnchor:self.crxCommentSheetView.trailingAnchor constant:-24],

        [self.crxCommentTableView.topAnchor constraintEqualToAnchor:self.crxCommentTitleLabel.bottomAnchor constant:16],
        [self.crxCommentTableView.leadingAnchor constraintEqualToAnchor:self.crxCommentSheetView.leadingAnchor constant:22],
        [self.crxCommentTableView.trailingAnchor constraintEqualToAnchor:self.crxCommentSheetView.trailingAnchor constant:-22],

        [crxInputWrapView.topAnchor constraintEqualToAnchor:self.crxCommentTableView.bottomAnchor constant:12],
        [crxInputWrapView.leadingAnchor constraintEqualToAnchor:self.crxCommentSheetView.leadingAnchor constant:22],
        [crxInputWrapView.trailingAnchor constraintEqualToAnchor:self.crxCommentSheetView.trailingAnchor constant:-22],
        [crxInputWrapView.bottomAnchor constraintEqualToAnchor:self.crxCommentSheetView.safeAreaLayoutGuide.bottomAnchor constant:-12],
        [crxInputWrapView.heightAnchor constraintEqualToConstant:48],

        [crxFieldBackground.topAnchor constraintEqualToAnchor:crxInputWrapView.topAnchor],
        [crxFieldBackground.leadingAnchor constraintEqualToAnchor:crxInputWrapView.leadingAnchor],
        [crxFieldBackground.bottomAnchor constraintEqualToAnchor:crxInputWrapView.bottomAnchor],
        [crxFieldBackground.trailingAnchor constraintEqualToAnchor:self.crxSendButton.leadingAnchor constant:-12],

        [crxInputIcon.centerYAnchor constraintEqualToAnchor:crxFieldBackground.centerYAnchor],
        [crxInputIcon.leadingAnchor constraintEqualToAnchor:crxFieldBackground.leadingAnchor constant:12],
        [crxInputIcon.widthAnchor constraintEqualToConstant:16],
        [crxInputIcon.heightAnchor constraintEqualToConstant:16],

        [self.crxCommentField.topAnchor constraintEqualToAnchor:crxFieldBackground.topAnchor],
        [self.crxCommentField.leadingAnchor constraintEqualToAnchor:crxInputIcon.trailingAnchor constant:8],
        [self.crxCommentField.trailingAnchor constraintEqualToAnchor:crxFieldBackground.trailingAnchor constant:-12],
        [self.crxCommentField.bottomAnchor constraintEqualToAnchor:crxFieldBackground.bottomAnchor],

        [self.crxSendButton.topAnchor constraintEqualToAnchor:crxInputWrapView.topAnchor],
        [self.crxSendButton.trailingAnchor constraintEqualToAnchor:crxInputWrapView.trailingAnchor],
        [self.crxSendButton.bottomAnchor constraintEqualToAnchor:crxInputWrapView.bottomAnchor],
        [self.crxSendButton.widthAnchor constraintEqualToConstant:44]
    ]];
    self.crxCommentSheetBottomConstraint = [self.crxCommentSheetView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    self.crxCommentSheetBottomConstraint.active = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        crxSendGradient.frame = self.crxSendButton.bounds;
    });
}

- (UIButton *)crx_buildTopButtonWithSystemImage:(NSString *)crxImageName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.58];
    crxButton.layer.cornerRadius = 10.0;
    [crxButton setImage:[UIImage systemImageNamed:crxImageName] forState:UIControlStateNormal];
    crxButton.tintColor = UIColor.whiteColor;
    crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    return crxButton;
}

- (UIButton *)crx_buildCircleActionButtonWithSystemImage:(NSString *)crxImageName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    crxButton.layer.cornerRadius = 22.0;
    crxButton.layer.borderWidth = 1.0;
    crxButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    [crxButton setImage:[UIImage systemImageNamed:crxImageName] forState:UIControlStateNormal];
    crxButton.tintColor = UIColor.whiteColor;
    crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    return crxButton;
}

- (void)crx_playTapped {
    if (self.crxPlayer == nil) {
        NSString *crxVideoName = self.crxStageItem[@"crxVideoName"];
        NSString *crxVideoPath = [[NSBundle mainBundle] pathForResource:crxVideoName ofType:@"mp4"];
        if (crxVideoPath.length == 0) {
            return;
        }

        NSURL *crxURL = [NSURL fileURLWithPath:crxVideoPath];
        self.crxPlayer = [AVPlayer playerWithURL:crxURL];
        self.crxPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.crxPlayer];
        self.crxPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer insertSublayer:self.crxPlayerLayer above:self.crxPosterView.layer];
        self.crxPlayerLayer.frame = self.view.bounds;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crx_playerDidFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.crxPlayer.currentItem];
    }

    self.crxPosterView.hidden = YES;
    self.crxPlayButton.hidden = YES;
    [self.crxPlayer play];
}

- (void)crx_playerDidFinish:(NSNotification *)notification {
    [self.crxPlayer seekToTime:kCMTimeZero];
    [self.crxPlayer play];
}

- (void)crx_backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)crx_moreTapped {
    NSString *crxName = self.crxStageItem[@"crxName"] ?: @"";
    __weak typeof(self) weakSelf = self;
    [self crx_presentModerationForUserName:crxName blockHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)crx_showComments {
    [self crx_reloadCommentTitle];
    [self.crxCommentTableView reloadData];
    self.crxCommentDimView.hidden = NO;
    [self.view layoutIfNeeded];
    self.crxCommentSheetBottomConstraint.active = NO;
    self.crxCommentSheetBottomConstraint = [self.crxCommentSheetView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    self.crxCommentSheetBottomConstraint.active = YES;
    [UIView animateWithDuration:0.22 animations:^{
        self.crxCommentDimView.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
}

- (void)crx_hideComments {
    [self.view endEditing:YES];
    self.crxCommentSheetBottomConstraint.active = NO;
    self.crxCommentSheetBottomConstraint = [self.crxCommentSheetView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    self.crxCommentSheetBottomConstraint.active = YES;
    [UIView animateWithDuration:0.22 animations:^{
        self.crxCommentDimView.alpha = 0.0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.crxCommentDimView.hidden = YES;
    }];
}

- (void)crx_sendComment {
    NSString *crxText = [self.crxCommentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (crxText.length == 0) {
        return;
    }

    NSDictionary *crxComment = @{
        @"crxAvatarName": @"crx_head_8",
        @"crxName": @"Alyssa",
        @"crxText": crxText,
        @"crxTimeText": @"Just now",
        @"crxLikeText": @"0.0"
    };
    [self.crxComments addObject:crxComment];
    [[NSUserDefaults standardUserDefaults] setObject:self.crxComments.copy forKey:[self crx_commentCacheKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.crxCommentField.text = @"";
    [self crx_reloadCommentTitle];
    [self.crxCommentTableView reloadData];

    if (self.crxComments.count > 0) {
        NSIndexPath *crxIndexPath = [NSIndexPath indexPathForRow:self.crxComments.count - 1 inSection:0];
        [self.crxCommentTableView scrollToRowAtIndexPath:crxIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSString *)crx_commentCacheKey {
    NSString *crxVideoName = self.crxStageItem[@"crxVideoName"];
    if (crxVideoName.length == 0) {
        crxVideoName = @"default";
    }
    return [NSString stringWithFormat:@"crx.stage.player.comments.%@", crxVideoName];
}

- (void)crx_reloadCommentTitle {
    self.crxCommentTitleLabel.text = [NSString stringWithFormat:@"%lu Comments", (unsigned long)self.crxComments.count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crxComments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CAREXQStagePlayerCommentCell *crxCell = [tableView dequeueReusableCellWithIdentifier:@"CAREXQStagePlayerCommentCell" forIndexPath:indexPath];
    [crxCell crx_configureWithComment:self.crxComments[indexPath.row]];
    return crxCell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self crx_sendComment];
    return NO;
}

@end
