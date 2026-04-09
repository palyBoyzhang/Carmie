//
//  CRXBlueprintController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXBlueprintController.h"
#import "CRXStagePlayerController.h"
#import "CRXChannelController.h"

@interface CRXBlueprintParticipantCard : UIControl

- (void)crx_configureWithItem:(NSDictionary *)crxItem;

@end

@interface CRXBlueprintParticipantCard ()

@property (nonatomic, strong) UIImageView *crxCoverView;
@property (nonatomic, strong) UIButton *crxPlayButton;
@property (nonatomic, strong) UIImageView *crxAvatarView;
@property (nonatomic, strong) UILabel *crxNameLabel;
@property (nonatomic, strong) UILabel *crxMetaLabel;
@property (nonatomic, strong) UIButton *crxHeartButton;

@end

@implementation CRXBlueprintParticipantCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self crx_setupViews];
    }
    return self;
}

- (void)crx_setupViews {
    self.layer.cornerRadius = 16.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:0.85 green:0.45 blue:1 alpha:0.75].CGColor;
    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.07 blue:0.23 alpha:0.95];
    self.clipsToBounds = YES;

    self.crxCoverView = [[UIImageView alloc] init];
    self.crxCoverView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxCoverView.clipsToBounds = YES;
    self.crxCoverView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.crxCoverView];

    self.crxPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crxPlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.32];
    self.crxPlayButton.layer.cornerRadius = 16.0;
    UIImageSymbolConfiguration *crxConfig = [UIImageSymbolConfiguration configurationWithPointSize:16 weight:UIImageSymbolWeightBold];
    [self.crxPlayButton setImage:[UIImage systemImageNamed:@"play.fill" withConfiguration:crxConfig] forState:UIControlStateNormal];
    self.crxPlayButton.tintColor = UIColor.whiteColor;
    self.crxPlayButton.userInteractionEnabled = NO;
    self.crxPlayButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxCoverView addSubview:self.crxPlayButton];

    UIView *crxBottomShade = [[UIView alloc] init];
    crxBottomShade.backgroundColor = [UIColor colorWithWhite:0 alpha:0.18];
    crxBottomShade.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:crxBottomShade];

    self.crxAvatarView = [[UIImageView alloc] init];
    self.crxAvatarView.layer.cornerRadius = 10.0;
    self.crxAvatarView.clipsToBounds = YES;
    self.crxAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.crxAvatarView];

    self.crxNameLabel = [[UILabel alloc] init];
    self.crxNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.crxNameLabel.textColor = UIColor.whiteColor;
    self.crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.crxNameLabel];

    self.crxMetaLabel = [[UILabel alloc] init];
    self.crxMetaLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    self.crxMetaLabel.textColor = [UIColor colorWithWhite:1 alpha:0.72];
    self.crxMetaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.crxMetaLabel];

    self.crxHeartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxHeartButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    self.crxHeartButton.tintColor = UIColor.whiteColor;
    self.crxHeartButton.userInteractionEnabled = NO;
    self.crxHeartButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.crxHeartButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.crxCoverView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.crxCoverView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.crxCoverView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.crxCoverView.heightAnchor constraintEqualToConstant:122],

        [self.crxPlayButton.centerXAnchor constraintEqualToAnchor:self.crxCoverView.centerXAnchor],
        [self.crxPlayButton.centerYAnchor constraintEqualToAnchor:self.crxCoverView.centerYAnchor],
        [self.crxPlayButton.widthAnchor constraintEqualToConstant:32],
        [self.crxPlayButton.heightAnchor constraintEqualToConstant:32],

        [crxBottomShade.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [crxBottomShade.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [crxBottomShade.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [crxBottomShade.heightAnchor constraintEqualToConstant:44],

        [self.crxAvatarView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8],
        [self.crxAvatarView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8],
        [self.crxAvatarView.widthAnchor constraintEqualToConstant:20],
        [self.crxAvatarView.heightAnchor constraintEqualToConstant:20],

        [self.crxNameLabel.leadingAnchor constraintEqualToAnchor:self.crxAvatarView.trailingAnchor constant:5],
        [self.crxNameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],
        [self.crxNameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.crxHeartButton.leadingAnchor constant:-4],

        [self.crxMetaLabel.leadingAnchor constraintEqualToAnchor:self.crxNameLabel.leadingAnchor],
        [self.crxMetaLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4],

        [self.crxHeartButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8],
        [self.crxHeartButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],
        [self.crxHeartButton.widthAnchor constraintEqualToConstant:16],
        [self.crxHeartButton.heightAnchor constraintEqualToConstant:16]
    ]];
}

- (void)crx_configureWithItem:(NSDictionary *)crxItem {
    self.crxCoverView.image = crxItem[@"crxCoverImage"] ?: [UIImage imageNamed:@"crx_stage_aig"];
    self.crxAvatarView.image = [UIImage imageNamed:crxItem[@"crxAvatarName"]] ?: [UIImage imageNamed:@"crx_head_1"];
    self.crxNameLabel.text = crxItem[@"crxName"] ?: @"User";
    self.crxMetaLabel.text = crxItem[@"crxLikeText"] ?: @"12.5";
}

@end

@interface CRXBlueprintController ()

@property (nonatomic, strong) UIImageView *crxPosterView;
@property (nonatomic, strong) UILabel *crxTitleLabel;
@property (nonatomic, strong) UIButton *crxLikeButton;
@property (nonatomic, strong) UILabel *crxInterestLabel;
@property (nonatomic, strong) UIView *crxInfoCardView;
@property (nonatomic, strong) UIButton *crxJoinButton;
@property (nonatomic, strong) UIButton *crxSendButton;
@property (nonatomic, strong) UIScrollView *crxParticipantScrollView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxParticipantItems;
@property (nonatomic, assign) BOOL crxJoined;
@property (nonatomic, assign) BOOL crxLiked;
@property (nonatomic, strong) UILabel *crxCountLabel;

@end

@implementation CRXBlueprintController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self crx_prepareData];
    [self crx_loadState];
    [self crx_setupViews];
    [self crx_reloadActionState];
}

- (void)crx_prepareData {
    if (self.crxStageItem.count == 0) {
        self.crxStageItem = @{
            @"crxAvatarName": @"crx_head_1",
            @"crxVideoName": @"crx_stage_1",
            @"crxName": @"Hayden",
            @"crxHeadline": @"Gesture Flow",
            @"crxDescription": @"Show your smoothest hand dance moves and let your gestures flow naturally with the music.",
            @"crxCoverImage": [UIImage imageNamed:@"crx_stage_aig"] ?: UIImage.new
        };
    }

    NSArray<NSString *> *crxNames = @[@"Hayden", @"Carson", @"Bennett", @"Holden", @"Tanner", @"Garrett", @"Malcolm", @"Alyssa"];
    NSMutableArray<NSDictionary *> *crxCards = [NSMutableArray array];
    NSInteger crxBaseIndex = [self crx_videoIndex] * 2;
    for (NSInteger idx = 0; idx < 4; idx++) {
        NSInteger crxImageIndex = ((crxBaseIndex + idx) % 16) + 1;
        NSInteger crxHeadIndex = (([self crx_videoIndex] + idx) % 8) + 1;
        [crxCards addObject:@{
            @"crxCoverImage": [UIImage imageNamed:[NSString stringWithFormat:@"crx_dy_%ld", (long)crxImageIndex]] ?: self.crxStageItem[@"crxCoverImage"] ?: UIImage.new,
            @"crxAvatarName": [NSString stringWithFormat:@"crx_head_%ld", (long)crxHeadIndex],
            @"crxName": crxNames[crxHeadIndex - 1],
            @"crxLikeText": @"12.5"
        }];
    }
    self.crxParticipantItems = [CRXController crx_filterItems:crxCards.copy nameKey:@"crxName"];
}

- (NSInteger)crx_videoIndex {
    NSString *crxVideoName = self.crxStageItem[@"crxVideoName"];
    NSArray<NSString *> *crxParts = [crxVideoName componentsSeparatedByString:@"_"];
    return MAX(crxParts.lastObject.integerValue - 1, 0);
}

- (void)crx_loadState {
    NSString *crxVideoName = self.crxStageItem[@"crxVideoName"] ?: @"default";
    NSUserDefaults *crxDefaults = [NSUserDefaults standardUserDefaults];
    self.crxJoined = [crxDefaults boolForKey:[NSString stringWithFormat:@"crx.blueprint.joined.%@", crxVideoName]];
    self.crxLiked = [crxDefaults boolForKey:[NSString stringWithFormat:@"crx.blueprint.liked.%@", crxVideoName]];
}

- (void)crx_saveState {
    NSString *crxVideoName = self.crxStageItem[@"crxVideoName"] ?: @"default";
    NSUserDefaults *crxDefaults = [NSUserDefaults standardUserDefaults];
    [crxDefaults setBool:self.crxJoined forKey:[NSString stringWithFormat:@"crx.blueprint.joined.%@", crxVideoName]];
    [crxDefaults setBool:self.crxLiked forKey:[NSString stringWithFormat:@"crx.blueprint.liked.%@", crxVideoName]];
    [crxDefaults synchronize];
}

- (void)crx_setupViews {
    self.view.backgroundColor = [UIColor colorWithRed:0x05/255.0 green:0x08/255.0 blue:0x24/255.0 alpha:1.0];

    self.crxPosterView = [[UIImageView alloc] initWithImage:self.crxStageItem[@"crxCoverImage"]];
    self.crxPosterView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxPosterView.clipsToBounds = YES;
    self.crxPosterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxPosterView];

    UIView *crxPosterShade = [[UIView alloc] init];
    crxPosterShade.backgroundColor = [UIColor colorWithWhite:0 alpha:0.12];
    crxPosterShade.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxPosterShade];

    UIButton *crxBackButton = [self crx_buildTopButtonWithSystemImage:@"chevron.left"];
    [crxBackButton addTarget:self action:@selector(crx_backTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxBackButton];

    UIButton *crxMoreButton = [self crx_buildTopButtonWithSystemImage:@"ellipsis"];
    [crxMoreButton addTarget:self action:@selector(crx_moreTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxMoreButton];

    UIButton *crxPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxPlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.28];
    crxPlayButton.layer.cornerRadius = 34.0;
    UIImageSymbolConfiguration *crxPlayConfig = [UIImageSymbolConfiguration configurationWithPointSize:34 weight:UIFontWeightBold];
    [crxPlayButton setImage:[UIImage systemImageNamed:@"play.fill" withConfiguration:crxPlayConfig] forState:UIControlStateNormal];
    crxPlayButton.tintColor = UIColor.whiteColor;
    [crxPlayButton addTarget:self action:@selector(crx_openPlayer) forControlEvents:UIControlEventTouchUpInside];
    crxPlayButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxPlayButton];

    self.crxInfoCardView = [[UIView alloc] init];
    self.crxInfoCardView.backgroundColor = [UIColor colorWithRed:0x1A/255.0 green:0x0B/255.0 blue:0x33/255.0 alpha:0.96];
    self.crxInfoCardView.layer.cornerRadius = 22.0;
    self.crxInfoCardView.layer.borderWidth = 1.0;
    self.crxInfoCardView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.12].CGColor;
    self.crxInfoCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxInfoCardView];

    self.crxTitleLabel = [[UILabel alloc] init];
    self.crxTitleLabel.text = self.crxStageItem[@"crxHeadline"] ?: @"Gesture Dance Title";
    self.crxTitleLabel.textColor = UIColor.whiteColor;
    self.crxTitleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxInfoCardView addSubview:self.crxTitleLabel];

    self.crxLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crxLikeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
    self.crxLikeButton.layer.cornerRadius = 18.0;
    self.crxLikeButton.layer.borderWidth = 1.0;
    self.crxLikeButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    [self.crxLikeButton addTarget:self action:@selector(crx_likeTapped) forControlEvents:UIControlEventTouchUpInside];
    self.crxLikeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxInfoCardView addSubview:self.crxLikeButton];

    UIView *crxInterestRow = [[UIView alloc] init];
    crxInterestRow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxInfoCardView addSubview:crxInterestRow];

    [self crx_addInterestAvatarsToView:crxInterestRow];

    UIImageView *crxFireView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"flame.fill"]];
    crxFireView.tintColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.25 alpha:1.0];
    crxFireView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxInterestRow addSubview:crxFireView];

    self.crxInterestLabel = [[UILabel alloc] init];
    self.crxInterestLabel.text = [NSString stringWithFormat:@"%lu people are interested", (unsigned long)MAX(self.crxParticipantItems.count * 8 + 1, 1)];
    self.crxInterestLabel.textColor = UIColor.whiteColor;
    self.crxInterestLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    self.crxInterestLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxInterestRow addSubview:self.crxInterestLabel];

    self.crxCountLabel = [[UILabel alloc] init];
    self.crxCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)MAX(self.crxParticipantItems.count * 8 + 1, 1)];
    self.crxCountLabel.textColor = UIColor.whiteColor;
    self.crxCountLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
    self.crxCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxInterestRow addSubview:self.crxCountLabel];

    UIView *crxDescBox = [[UIView alloc] init];
    crxDescBox.backgroundColor = [UIColor colorWithRed:0x2B/255.0 green:0x0E/255.0 blue:0x4C/255.0 alpha:1.0];
    crxDescBox.layer.cornerRadius = 14.0;
    crxDescBox.layer.borderWidth = 1.0;
    crxDescBox.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    crxDescBox.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxInfoCardView addSubview:crxDescBox];

    UILabel *crxDepictLabel = [[UILabel alloc] init];
    crxDepictLabel.text = @"Depict:";
    crxDepictLabel.textColor = UIColor.whiteColor;
    crxDepictLabel.font = [UIFont italicSystemFontOfSize:13];
    crxDepictLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxDescBox addSubview:crxDepictLabel];

    UILabel *crxDescLabel = [[UILabel alloc] init];
    crxDescLabel.text = self.crxStageItem[@"crxDescription"] ?: @"";
    crxDescLabel.textColor = UIColor.whiteColor;
    crxDescLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    crxDescLabel.numberOfLines = 3;
    crxDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxDescBox addSubview:crxDescLabel];

    UILabel *crxParticipantTitle = [[UILabel alloc] init];
    crxParticipantTitle.text = @"Participating users";
    crxParticipantTitle.font = [UIFont italicSystemFontOfSize:15];
    crxParticipantTitle.textColor = UIColor.whiteColor;
    crxParticipantTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxParticipantTitle];

    self.crxParticipantScrollView = [[UIScrollView alloc] init];
    self.crxParticipantScrollView.showsHorizontalScrollIndicator = NO;
    self.crxParticipantScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxParticipantScrollView];

    UIView *crxCardContentView = [[UIView alloc] init];
    crxCardContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxParticipantScrollView addSubview:crxCardContentView];

    UIButton *crxJoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxJoinButton.layer.cornerRadius = 24.0;
    crxJoinButton.clipsToBounds = YES;
    [crxJoinButton addTarget:self action:@selector(crx_joinTapped) forControlEvents:UIControlEventTouchUpInside];
    crxJoinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxJoinButton];
    self.crxJoinButton = crxJoinButton;

    self.crxSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxSendButton setImage:[UIImage imageNamed:@"crx_send_btn@3x"] forState:(UIControlStateNormal)];
    [self.crxSendButton addTarget:self action:@selector(crxSendButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    self.crxSendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxSendButton];

    CAGradientLayer *crxJoinGradient = [CAGradientLayer layer];
    crxJoinGradient.startPoint = CGPointMake(0.0, 0.5);
    crxJoinGradient.endPoint = CGPointMake(1.0, 0.5);
    [self.crxJoinButton.layer insertSublayer:crxJoinGradient atIndex:0];

    NSMutableArray<NSLayoutConstraint *> *crxCardConstraints = [NSMutableArray array];
    UIView *crxPreviousCard = nil;
    for (NSDictionary *crxCardItem in self.crxParticipantItems) {
        CRXBlueprintParticipantCard *crxCard = [[CRXBlueprintParticipantCard alloc] initWithFrame:CGRectZero];
        [crxCard crx_configureWithItem:crxCardItem];
        [crxCard addTarget:self action:@selector(crx_openPlayer) forControlEvents:UIControlEventTouchUpInside];
        crxCard.translatesAutoresizingMaskIntoConstraints = NO;
        [crxCardContentView addSubview:crxCard];

        [crxCardConstraints addObject:[crxCard.topAnchor constraintEqualToAnchor:crxCardContentView.topAnchor]];
        [crxCardConstraints addObject:[crxCard.bottomAnchor constraintEqualToAnchor:crxCardContentView.bottomAnchor]];
        [crxCardConstraints addObject:[crxCard.widthAnchor constraintEqualToConstant:108]];
        if (crxPreviousCard) {
            [crxCardConstraints addObject:[crxCard.leadingAnchor constraintEqualToAnchor:crxPreviousCard.trailingAnchor constant:10]];
        } else {
            [crxCardConstraints addObject:[crxCard.leadingAnchor constraintEqualToAnchor:crxCardContentView.leadingAnchor]];
        }
        crxPreviousCard = crxCard;
    }
    if (crxPreviousCard) {
        [crxCardConstraints addObject:[crxPreviousCard.trailingAnchor constraintEqualToAnchor:crxCardContentView.trailingAnchor]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [self.crxPosterView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.crxPosterView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxPosterView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxPosterView.heightAnchor constraintEqualToConstant:310],

        [crxPosterShade.topAnchor constraintEqualToAnchor:self.crxPosterView.topAnchor],
        [crxPosterShade.leadingAnchor constraintEqualToAnchor:self.crxPosterView.leadingAnchor],
        [crxPosterShade.trailingAnchor constraintEqualToAnchor:self.crxPosterView.trailingAnchor],
        [crxPosterShade.bottomAnchor constraintEqualToAnchor:self.crxPosterView.bottomAnchor],

        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:12],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [crxBackButton.widthAnchor constraintEqualToConstant:34],
        [crxBackButton.heightAnchor constraintEqualToConstant:34],

        [crxMoreButton.topAnchor constraintEqualToAnchor:crxBackButton.topAnchor],
        [crxMoreButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [crxMoreButton.widthAnchor constraintEqualToConstant:34],
        [crxMoreButton.heightAnchor constraintEqualToConstant:34],

        [crxPlayButton.centerXAnchor constraintEqualToAnchor:self.crxPosterView.centerXAnchor],
        [crxPlayButton.centerYAnchor constraintEqualToAnchor:self.crxPosterView.centerYAnchor constant:14],
        [crxPlayButton.widthAnchor constraintEqualToConstant:68],
        [crxPlayButton.heightAnchor constraintEqualToConstant:68],

        [self.crxInfoCardView.topAnchor constraintEqualToAnchor:self.crxPosterView.bottomAnchor constant:-30],
        [self.crxInfoCardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.crxInfoCardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],

        [self.crxTitleLabel.topAnchor constraintEqualToAnchor:self.crxInfoCardView.topAnchor constant:18],
        [self.crxTitleLabel.leadingAnchor constraintEqualToAnchor:self.crxInfoCardView.leadingAnchor constant:16],
        [self.crxTitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.crxLikeButton.leadingAnchor constant:-12],

        [self.crxLikeButton.centerYAnchor constraintEqualToAnchor:self.crxTitleLabel.centerYAnchor],
        [self.crxLikeButton.trailingAnchor constraintEqualToAnchor:self.crxInfoCardView.trailingAnchor constant:-14],
        [self.crxLikeButton.widthAnchor constraintEqualToConstant:36],
        [self.crxLikeButton.heightAnchor constraintEqualToConstant:36],

        [crxInterestRow.topAnchor constraintEqualToAnchor:self.crxTitleLabel.bottomAnchor constant:12],
        [crxInterestRow.leadingAnchor constraintEqualToAnchor:self.crxInfoCardView.leadingAnchor constant:16],
        [crxInterestRow.trailingAnchor constraintEqualToAnchor:self.crxInfoCardView.trailingAnchor constant:-16],
        [crxInterestRow.heightAnchor constraintEqualToConstant:20],

        [crxFireView.leadingAnchor constraintEqualToAnchor:crxInterestRow.leadingAnchor constant:60],
        [crxFireView.centerYAnchor constraintEqualToAnchor:crxInterestRow.centerYAnchor],
        [crxFireView.widthAnchor constraintEqualToConstant:12],
        [crxFireView.heightAnchor constraintEqualToConstant:12],

        [self.crxCountLabel.leadingAnchor constraintEqualToAnchor:crxFireView.trailingAnchor constant:4],
        [self.crxCountLabel.centerYAnchor constraintEqualToAnchor:crxInterestRow.centerYAnchor],

        [self.crxInterestLabel.leadingAnchor constraintEqualToAnchor:self.crxCountLabel.trailingAnchor constant:3],
        [self.crxInterestLabel.centerYAnchor constraintEqualToAnchor:crxInterestRow.centerYAnchor],

        [crxDescBox.topAnchor constraintEqualToAnchor:crxInterestRow.bottomAnchor constant:14],
        [crxDescBox.leadingAnchor constraintEqualToAnchor:self.crxInfoCardView.leadingAnchor constant:14],
        [crxDescBox.trailingAnchor constraintEqualToAnchor:self.crxInfoCardView.trailingAnchor constant:-14],

        [crxDepictLabel.topAnchor constraintEqualToAnchor:crxDescBox.topAnchor constant:12],
        [crxDepictLabel.leadingAnchor constraintEqualToAnchor:crxDescBox.leadingAnchor constant:12],

        [crxDescLabel.topAnchor constraintEqualToAnchor:crxDescBox.topAnchor constant:12],
        [crxDescLabel.leadingAnchor constraintEqualToAnchor:crxDepictLabel.trailingAnchor constant:8],
        [crxDescLabel.trailingAnchor constraintEqualToAnchor:crxDescBox.trailingAnchor constant:-12],
        [crxDescLabel.bottomAnchor constraintEqualToAnchor:crxDescBox.bottomAnchor constant:-12],

        [self.crxInfoCardView.bottomAnchor constraintEqualToAnchor:crxDescBox.bottomAnchor constant:14],

        [crxParticipantTitle.topAnchor constraintEqualToAnchor:self.crxInfoCardView.bottomAnchor constant:14],
        [crxParticipantTitle.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],

        [self.crxParticipantScrollView.topAnchor constraintEqualToAnchor:crxParticipantTitle.bottomAnchor constant:10],
        [self.crxParticipantScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.crxParticipantScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxParticipantScrollView.heightAnchor constraintEqualToConstant:168],

        [crxCardContentView.topAnchor constraintEqualToAnchor:self.crxParticipantScrollView.contentLayoutGuide.topAnchor],
        [crxCardContentView.leadingAnchor constraintEqualToAnchor:self.crxParticipantScrollView.contentLayoutGuide.leadingAnchor],
        [crxCardContentView.trailingAnchor constraintEqualToAnchor:self.crxParticipantScrollView.contentLayoutGuide.trailingAnchor],
        [crxCardContentView.bottomAnchor constraintEqualToAnchor:self.crxParticipantScrollView.contentLayoutGuide.bottomAnchor],
        [crxCardContentView.heightAnchor constraintEqualToAnchor:self.crxParticipantScrollView.frameLayoutGuide.heightAnchor],

        [self.crxJoinButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.crxJoinButton.trailingAnchor constraintEqualToAnchor:self.crxSendButton.leadingAnchor constant:-12],
        [self.crxJoinButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-12],
        [self.crxJoinButton.heightAnchor constraintEqualToConstant:48],

        [self.crxSendButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.crxSendButton.centerYAnchor constraintEqualToAnchor:self.crxJoinButton.centerYAnchor],
        [self.crxSendButton.widthAnchor constraintEqualToConstant:48],
        [self.crxSendButton.heightAnchor constraintEqualToConstant:48]
    ]];
    [NSLayoutConstraint activateConstraints:crxCardConstraints];

    dispatch_async(dispatch_get_main_queue(), ^{
        crxJoinGradient.frame = self.crxJoinButton.bounds;
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

- (void)crx_addInterestAvatarsToView:(UIView *)crxRowView {
    for (NSInteger idx = 0; idx < 5; idx++) {
        NSInteger crxHeadIndex = (([self crx_videoIndex] + idx) % 8) + 1;
        UIImageView *crxAvatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"crx_head_%ld", (long)crxHeadIndex]]];
        crxAvatarView.layer.cornerRadius = 8.0;
        crxAvatarView.layer.borderWidth = 1.0;
        crxAvatarView.layer.borderColor = [UIColor colorWithRed:0x1A/255.0 green:0x0B/255.0 blue:0x33/255.0 alpha:1.0].CGColor;
        crxAvatarView.clipsToBounds = YES;
        crxAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
        [crxRowView addSubview:crxAvatarView];

        [NSLayoutConstraint activateConstraints:@[
            [crxAvatarView.leadingAnchor constraintEqualToAnchor:crxRowView.leadingAnchor constant:idx * 11.0],
            [crxAvatarView.centerYAnchor constraintEqualToAnchor:crxRowView.centerYAnchor],
            [crxAvatarView.widthAnchor constraintEqualToConstant:16],
            [crxAvatarView.heightAnchor constraintEqualToConstant:16]
        ]];
    }
}

- (void)crx_reloadActionState {
    UIImage *crxHeartImage = [UIImage systemImageNamed:(self.crxLiked ? @"heart.fill" : @"heart")];
    UIColor *crxHeartColor = self.crxLiked ? [UIColor colorWithRed:1.0 green:0.14 blue:0.73 alpha:1.0] : UIColor.whiteColor;
    [self.crxLikeButton setImage:crxHeartImage forState:UIControlStateNormal];
    self.crxLikeButton.tintColor = crxHeartColor;

    [self.crxJoinButton setTitle:(self.crxJoined ? @"Cancel" : @"+ Join") forState:UIControlStateNormal];
    [self.crxJoinButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxJoinButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];

    CAGradientLayer *crxGradient = (CAGradientLayer *)self.crxJoinButton.layer.sublayers.firstObject;
    if ([crxGradient isKindOfClass:CAGradientLayer.class]) {
        if (self.crxJoined) {
            crxGradient.colors = @[
                (__bridge id)[UIColor colorWithRed:0.23 green:0.08 blue:0.35 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:0.34 green:0.11 blue:0.47 alpha:1.0].CGColor
            ];
        } else {
            crxGradient.colors = @[
                (__bridge id)[UIColor colorWithRed:1.0 green:0.56 blue:0.25 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:0.92 green:0.17 blue:0.96 alpha:1.0].CGColor
            ];
        }
    }
}

- (void)crx_likeTapped {
    self.crxLiked = !self.crxLiked;
    [self crx_saveState];
    [self crx_reloadActionState];
}

- (void)crx_joinTapped {
    self.crxJoined = !self.crxJoined;
    [self crx_saveState];
    [self crx_reloadActionState];
}

- (void)crx_openPlayer {
    CRXStagePlayerController *crxController = [[CRXStagePlayerController alloc] init];
    crxController.crxStageItem = self.crxStageItem;
    [self.navigationController pushViewController:crxController animated:YES];
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

- (void)crxSendButtonTapped {
    CRXChannelController *crxController = [[CRXChannelController alloc] init];
    UIImage *crxAvatar = self.crxStageItem[@"crxAvatarImage"] ?: [UIImage imageNamed:self.crxStageItem[@"crxAvatarName"]] ?: [UIImage imageNamed:@"crx_head_1"] ?: UIImage.new;
    NSString *crxName = self.crxStageItem[@"crxName"] ?: @"Hayden";
    NSString *crxPreview = [NSString stringWithFormat:@"Hi %@, I want to join this gesture dance challenge with you.", crxName];
    crxController.crxMessageItem = @{
        @"crxAvatar": crxAvatar,
        @"crxName": crxName,
        @"crxPreview": crxPreview,
        @"crxTime": @"Now"
    };
    [self.navigationController pushViewController:crxController animated:YES];
}

@end
