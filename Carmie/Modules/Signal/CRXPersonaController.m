//
//  CRXPersonaController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXPersonaController.h"
#import "CRXChannelController.h"

@interface CRXPersonaController ()

@property (nonatomic, strong) UIScrollView *crxScrollView;
@property (nonatomic, strong) UIView *crxContentView;

@end

@implementation CRXPersonaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1.0];
    [self crx_buildViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)crx_buildViews {
    NSDictionary *crxProfile = [self crx_profilePayload];
    UIImage *crxAvatar = crxProfile[@"crxAvatar"];
    NSArray<UIImage *> *crxAlbum = crxProfile[@"crxAlbum"];

    self.crxScrollView = [[UIScrollView alloc] init];
    self.crxScrollView.showsVerticalScrollIndicator = NO;
    self.crxScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.crxScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxScrollView];

    self.crxContentView = [[UIView alloc] init];
    self.crxContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxScrollView addSubview:self.crxContentView];

    UIView *crxTopBar = [[UIView alloc] init];
    crxTopBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxTopBar];

    UIButton *crxBackButton = [self crx_circleButtonWithSystemName:@"chevron.left"];
    [crxBackButton addTarget:self action:@selector(crx_backTapped) forControlEvents:UIControlEventTouchUpInside];
    [crxTopBar addSubview:crxBackButton];

    UIImageView *crxMiniAvatarView = [[UIImageView alloc] initWithImage:crxAvatar];
    crxMiniAvatarView.layer.cornerRadius = 16;
    crxMiniAvatarView.clipsToBounds = YES;
    crxMiniAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    crxMiniAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxTopBar addSubview:crxMiniAvatarView];

    UILabel *crxNameLabel = [[UILabel alloc] init];
    crxNameLabel.text = crxProfile[@"crxDisplayName"];
    crxNameLabel.textColor = UIColor.whiteColor;
    crxNameLabel.font = [UIFont italicSystemFontOfSize:18];
    crxNameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxTopBar addSubview:crxNameLabel];

    UIButton *crxMoreButton = [self crx_circleButtonWithSystemName:@"ellipsis"];
    [crxMoreButton addTarget:self action:@selector(crx_moreTapped) forControlEvents:UIControlEventTouchUpInside];
    [crxTopBar addSubview:crxMoreButton];

    UIView *crxHeroCard = [[UIView alloc] init];
    crxHeroCard.backgroundColor = [UIColor colorWithRed:0x24/255.0 green:0x12/255.0 blue:0x3E/255.0 alpha:0.94];
    crxHeroCard.layer.cornerRadius = 18;
    crxHeroCard.layer.borderWidth = 1;
    crxHeroCard.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.08].CGColor;
    crxHeroCard.clipsToBounds = YES;
    crxHeroCard.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxHeroCard];

    UIImageView *crxHeroImageView = [[UIImageView alloc] initWithImage:crxProfile[@"crxHero"]];
    crxHeroImageView.contentMode = UIViewContentModeScaleAspectFill;
    crxHeroImageView.clipsToBounds = YES;
    crxHeroImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxHeroCard addSubview:crxHeroImageView];

    UIView *crxStatsBar = [[UIView alloc] init];
    crxStatsBar.backgroundColor = [UIColor colorWithRed:0x22/255.0 green:0x11/255.0 blue:0x39/255.0 alpha:0.96];
    crxStatsBar.translatesAutoresizingMaskIntoConstraints = NO;
    [crxHeroCard addSubview:crxStatsBar];

    NSArray<NSArray<NSString *> *> *crxStats = @[
        @[crxProfile[@"crxLikes"], @"Likes"],
        @[crxProfile[@"crxFollowers"], @"Followers"],
        @[crxProfile[@"crxFollowing"], @"Following"]
    ];
    UIView *crxPreviousColumn = nil;
    for (NSInteger crxIndex = 0; crxIndex < crxStats.count; crxIndex++) {
        UIView *crxColumn = [[UIView alloc] init];
        crxColumn.translatesAutoresizingMaskIntoConstraints = NO;
        [crxStatsBar addSubview:crxColumn];

        UILabel *crxValueLabel = [[UILabel alloc] init];
        crxValueLabel.text = crxStats[crxIndex][0];
        crxValueLabel.textColor = UIColor.whiteColor;
        crxValueLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        crxValueLabel.textAlignment = NSTextAlignmentCenter;
        crxValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [crxColumn addSubview:crxValueLabel];

        UILabel *crxTitleLabel = [[UILabel alloc] init];
        crxTitleLabel.text = crxStats[crxIndex][1];
        crxTitleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.55];
        crxTitleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        crxTitleLabel.textAlignment = NSTextAlignmentCenter;
        crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [crxColumn addSubview:crxTitleLabel];

        [NSLayoutConstraint activateConstraints:@[
            [crxValueLabel.topAnchor constraintEqualToAnchor:crxColumn.topAnchor constant:10],
            [crxValueLabel.leadingAnchor constraintEqualToAnchor:crxColumn.leadingAnchor],
            [crxValueLabel.trailingAnchor constraintEqualToAnchor:crxColumn.trailingAnchor],
            [crxTitleLabel.topAnchor constraintEqualToAnchor:crxValueLabel.bottomAnchor constant:4],
            [crxTitleLabel.leadingAnchor constraintEqualToAnchor:crxColumn.leadingAnchor],
            [crxTitleLabel.trailingAnchor constraintEqualToAnchor:crxColumn.trailingAnchor],
            [crxTitleLabel.bottomAnchor constraintEqualToAnchor:crxColumn.bottomAnchor constant:-10]
        ]];

        [NSLayoutConstraint activateConstraints:@[
            [crxColumn.topAnchor constraintEqualToAnchor:crxStatsBar.topAnchor],
            [crxColumn.bottomAnchor constraintEqualToAnchor:crxStatsBar.bottomAnchor],
            [crxColumn.widthAnchor constraintEqualToAnchor:crxStatsBar.widthAnchor multiplier:1.0 / 3.0]
        ]];

        if (crxPreviousColumn) {
            UIView *crxDivider = [[UIView alloc] init];
            crxDivider.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
            crxDivider.translatesAutoresizingMaskIntoConstraints = NO;
            [crxStatsBar addSubview:crxDivider];
            [NSLayoutConstraint activateConstraints:@[
                [crxDivider.widthAnchor constraintEqualToConstant:1],
                [crxDivider.topAnchor constraintEqualToAnchor:crxStatsBar.topAnchor constant:10],
                [crxDivider.bottomAnchor constraintEqualToAnchor:crxStatsBar.bottomAnchor constant:-10],
                [crxDivider.leadingAnchor constraintEqualToAnchor:crxPreviousColumn.trailingAnchor]
            ]];
            [crxColumn.leadingAnchor constraintEqualToAnchor:crxPreviousColumn.trailingAnchor].active = YES;
        } else {
            [crxColumn.leadingAnchor constraintEqualToAnchor:crxStatsBar.leadingAnchor].active = YES;
        }

        if (crxIndex == crxStats.count - 1) {
            [crxColumn.trailingAnchor constraintEqualToAnchor:crxStatsBar.trailingAnchor].active = YES;
        }
        crxPreviousColumn = crxColumn;
    }

    UILabel *crxBioLabel = [[UILabel alloc] init];
    crxBioLabel.text = crxProfile[@"crxBio"];
    crxBioLabel.textColor = [UIColor colorWithWhite:1 alpha:0.85];
    crxBioLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    crxBioLabel.numberOfLines = 0;
    crxBioLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxBioLabel];

    UIStackView *crxActionStack = [[UIStackView alloc] init];
    crxActionStack.axis = UILayoutConstraintAxisHorizontal;
    crxActionStack.spacing = 12;
    crxActionStack.alignment = UIStackViewAlignmentFill;
    crxActionStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxActionStack];

    UIButton *crxCallButton = [self crx_roundActionButtonWithSystemName:@"phone.fill"];
    [crxActionStack addArrangedSubview:crxCallButton];
    [crxCallButton.widthAnchor constraintEqualToConstant:48].active = YES;

    UIButton *crxPartnerButton = [self crx_roundActionButtonWithSystemName:@"person.2.fill"];
    [crxActionStack addArrangedSubview:crxPartnerButton];
    [crxPartnerButton.widthAnchor constraintEqualToConstant:48].active = YES;

    UIButton *crxMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxMessageButton.layer.cornerRadius = 24;
    crxMessageButton.clipsToBounds = YES;
    [crxMessageButton setTitle:@"Message" forState:UIControlStateNormal];
    [crxMessageButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    crxMessageButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [crxMessageButton setImage:[UIImage systemImageNamed:@"message.fill"] forState:UIControlStateNormal];
    crxMessageButton.tintColor = UIColor.whiteColor;
    crxMessageButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    [crxMessageButton addTarget:self action:@selector(crx_messageTapped) forControlEvents:UIControlEventTouchUpInside];
    crxMessageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [crxActionStack addArrangedSubview:crxMessageButton];
    [crxMessageButton.heightAnchor constraintEqualToConstant:48].active = YES;

    CAGradientLayer *crxMessageGradient = [CAGradientLayer layer];
    crxMessageGradient.colors = @[
        (__bridge id)[UIColor colorWithRed:0.15 green:0.70 blue:1.0 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.31 green:0.54 blue:1.0 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.60 green:0.17 blue:0.98 alpha:1.0].CGColor
    ];
    crxMessageGradient.startPoint = CGPointMake(0, 0.5);
    crxMessageGradient.endPoint = CGPointMake(1, 0.5);
    [crxMessageButton.layer insertSublayer:crxMessageGradient atIndex:0];

    UILabel *crxAlbumLabel = [[UILabel alloc] init];
    crxAlbumLabel.text = @"Photo Album";
    crxAlbumLabel.textColor = UIColor.whiteColor;
    crxAlbumLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    crxAlbumLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxAlbumLabel];

    UIView *crxAlbumGrid = [[UIView alloc] init];
    crxAlbumGrid.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxAlbumGrid];

    CGFloat crxSpacing = 12.0;
    NSMutableArray<NSLayoutConstraint *> *crxAlbumConstraints = [NSMutableArray array];
    UIView *crxLastBottomView = nil;
    for (NSInteger crxIndex = 0; crxIndex < crxAlbum.count; crxIndex++) {
        UIImageView *crxAlbumImageView = [[UIImageView alloc] initWithImage:crxAlbum[crxIndex]];
        crxAlbumImageView.contentMode = UIViewContentModeScaleAspectFill;
        crxAlbumImageView.clipsToBounds = YES;
        crxAlbumImageView.layer.cornerRadius = 12;
        crxAlbumImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [crxAlbumGrid addSubview:crxAlbumImageView];

        NSInteger crxColumn = crxIndex % 2;
        NSInteger crxRow = crxIndex / 2;
        [crxAlbumConstraints addObjectsFromArray:@[
            [crxAlbumImageView.widthAnchor constraintEqualToAnchor:crxAlbumGrid.widthAnchor multiplier:0.5 constant:-crxSpacing / 2.0],
            [crxAlbumImageView.heightAnchor constraintEqualToConstant:(crxRow == 0 ? 124 : 102)]
        ]];

        if (crxColumn == 0) {
            [crxAlbumImageView.leadingAnchor constraintEqualToAnchor:crxAlbumGrid.leadingAnchor].active = YES;
        } else {
            [crxAlbumImageView.trailingAnchor constraintEqualToAnchor:crxAlbumGrid.trailingAnchor].active = YES;
        }

        if (crxRow == 0) {
            [crxAlbumImageView.topAnchor constraintEqualToAnchor:crxAlbumGrid.topAnchor].active = YES;
        } else {
            UIView *crxUpperView = crxAlbumGrid.subviews[crxIndex - 2];
            [crxAlbumImageView.topAnchor constraintEqualToAnchor:crxUpperView.bottomAnchor constant:crxSpacing].active = YES;
        }

        if (crxColumn == 1) {
            UIView *crxLeftView = crxAlbumGrid.subviews[crxIndex - 1];
            [crxAlbumImageView.leadingAnchor constraintEqualToAnchor:crxLeftView.trailingAnchor constant:crxSpacing].active = YES;
        }

        if (crxIndex == crxAlbum.count - 1 || crxIndex == crxAlbum.count - 2) {
            crxLastBottomView = crxAlbumImageView;
        }

        if (crxIndex == 1) {
            UIButton *crxPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            crxPlayButton.userInteractionEnabled = NO;
            crxPlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.28];
            crxPlayButton.layer.cornerRadius = 24;
            [crxPlayButton setImage:[UIImage systemImageNamed:@"play.fill"] forState:UIControlStateNormal];
            crxPlayButton.tintColor = UIColor.whiteColor;
            crxPlayButton.translatesAutoresizingMaskIntoConstraints = NO;
            [crxAlbumImageView addSubview:crxPlayButton];
            [NSLayoutConstraint activateConstraints:@[
                [crxPlayButton.centerXAnchor constraintEqualToAnchor:crxAlbumImageView.centerXAnchor],
                [crxPlayButton.centerYAnchor constraintEqualToAnchor:crxAlbumImageView.centerYAnchor],
                [crxPlayButton.widthAnchor constraintEqualToConstant:48],
                [crxPlayButton.heightAnchor constraintEqualToConstant:48]
            ]];
        }
    }

    [NSLayoutConstraint activateConstraints:crxAlbumConstraints];
    [crxLastBottomView.bottomAnchor constraintEqualToAnchor:crxAlbumGrid.bottomAnchor].active = YES;

    [NSLayoutConstraint activateConstraints:@[
        [self.crxScrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.crxScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxScrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.crxContentView.topAnchor constraintEqualToAnchor:self.crxScrollView.topAnchor],
        [self.crxContentView.leadingAnchor constraintEqualToAnchor:self.crxScrollView.leadingAnchor],
        [self.crxContentView.trailingAnchor constraintEqualToAnchor:self.crxScrollView.trailingAnchor],
        [self.crxContentView.bottomAnchor constraintEqualToAnchor:self.crxScrollView.bottomAnchor],
        [self.crxContentView.widthAnchor constraintEqualToAnchor:self.crxScrollView.widthAnchor],

        [crxTopBar.topAnchor constraintEqualToAnchor:self.crxContentView.safeAreaLayoutGuide.topAnchor constant:6],
        [crxTopBar.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:16],
        [crxTopBar.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor constant:-16],
        [crxTopBar.heightAnchor constraintEqualToConstant:44],

        [crxBackButton.leadingAnchor constraintEqualToAnchor:crxTopBar.leadingAnchor],
        [crxBackButton.centerYAnchor constraintEqualToAnchor:crxTopBar.centerYAnchor],
        [crxBackButton.widthAnchor constraintEqualToConstant:36],
        [crxBackButton.heightAnchor constraintEqualToConstant:36],

        [crxMiniAvatarView.centerXAnchor constraintEqualToAnchor:crxTopBar.centerXAnchor constant:-40],
        [crxMiniAvatarView.centerYAnchor constraintEqualToAnchor:crxTopBar.centerYAnchor],
        [crxMiniAvatarView.widthAnchor constraintEqualToConstant:32],
        [crxMiniAvatarView.heightAnchor constraintEqualToConstant:32],

        [crxNameLabel.leadingAnchor constraintEqualToAnchor:crxMiniAvatarView.trailingAnchor constant:8],
        [crxNameLabel.centerYAnchor constraintEqualToAnchor:crxTopBar.centerYAnchor],

        [crxMoreButton.trailingAnchor constraintEqualToAnchor:crxTopBar.trailingAnchor],
        [crxMoreButton.centerYAnchor constraintEqualToAnchor:crxTopBar.centerYAnchor],
        [crxMoreButton.widthAnchor constraintEqualToConstant:36],
        [crxMoreButton.heightAnchor constraintEqualToConstant:36],

        [crxHeroCard.topAnchor constraintEqualToAnchor:crxTopBar.bottomAnchor constant:18],
        [crxHeroCard.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:18],
        [crxHeroCard.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor constant:-18],

        [crxHeroImageView.topAnchor constraintEqualToAnchor:crxHeroCard.topAnchor],
        [crxHeroImageView.leadingAnchor constraintEqualToAnchor:crxHeroCard.leadingAnchor],
        [crxHeroImageView.trailingAnchor constraintEqualToAnchor:crxHeroCard.trailingAnchor],
        [crxHeroImageView.heightAnchor constraintEqualToConstant:246],

        [crxStatsBar.topAnchor constraintEqualToAnchor:crxHeroImageView.bottomAnchor],
        [crxStatsBar.leadingAnchor constraintEqualToAnchor:crxHeroCard.leadingAnchor],
        [crxStatsBar.trailingAnchor constraintEqualToAnchor:crxHeroCard.trailingAnchor],
        [crxStatsBar.heightAnchor constraintEqualToConstant:70],
        [crxStatsBar.bottomAnchor constraintEqualToAnchor:crxHeroCard.bottomAnchor],

        [crxBioLabel.topAnchor constraintEqualToAnchor:crxHeroCard.bottomAnchor constant:16],
        [crxBioLabel.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:18],
        [crxBioLabel.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor constant:-18],

        [crxActionStack.topAnchor constraintEqualToAnchor:crxBioLabel.bottomAnchor constant:18],
        [crxActionStack.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:18],
        [crxActionStack.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor constant:-18],
        [crxActionStack.heightAnchor constraintEqualToConstant:48],

        [crxAlbumLabel.topAnchor constraintEqualToAnchor:crxActionStack.bottomAnchor constant:22],
        [crxAlbumLabel.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:18],

        [crxAlbumGrid.topAnchor constraintEqualToAnchor:crxAlbumLabel.bottomAnchor constant:12],
        [crxAlbumGrid.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:18],
        [crxAlbumGrid.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor constant:-18],
        [crxAlbumGrid.bottomAnchor constraintEqualToAnchor:self.crxContentView.bottomAnchor constant:-28]
    ]];

    dispatch_async(dispatch_get_main_queue(), ^{
        crxMessageGradient.frame = crxMessageButton.bounds;
    });
}

- (UIButton *)crx_circleButtonWithSystemName:(NSString *)crxSystemName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.42];
    crxButton.layer.cornerRadius = 18;
    [crxButton setImage:[UIImage systemImageNamed:crxSystemName] forState:UIControlStateNormal];
    crxButton.tintColor = UIColor.whiteColor;
    crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    return crxButton;
}

- (UIButton *)crx_roundActionButtonWithSystemName:(NSString *)crxSystemName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithRed:0x21/255.0 green:0x10/255.0 blue:0x38/255.0 alpha:1.0];
    crxButton.layer.cornerRadius = 24;
    crxButton.layer.borderWidth = 1;
    crxButton.layer.borderColor = [UIColor colorWithRed:0.89 green:0.22 blue:0.88 alpha:0.55].CGColor;
    [crxButton setImage:[UIImage systemImageNamed:crxSystemName] forState:UIControlStateNormal];
    crxButton.tintColor = [UIColor colorWithRed:1.0 green:0.35 blue:0.72 alpha:1.0];
    crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    return crxButton;
}

- (NSDictionary *)crx_profilePayload {
    UIImage *crxAvatar = self.crxUserItem[@"crxImage"] ?: self.crxUserItem[@"crxAvatar"] ?: [UIImage imageNamed:@"crx_head_1"] ?: UIImage.new;
    NSString *crxName = self.crxUserItem[@"crxName"] ?: @"Hayden";
    NSInteger crxIndex = [self crx_indexForUserName:crxName];

    NSArray<UIImage *> *crxHeroImages = @[
        [UIImage imageNamed:@"crx_dy_2"] ?: crxAvatar,
        [UIImage imageNamed:@"crx_dy_4"] ?: crxAvatar,
        [UIImage imageNamed:@"crx_dy_6"] ?: crxAvatar,
        [UIImage imageNamed:@"crx_dy_8"] ?: crxAvatar,
        [UIImage imageNamed:@"crx_dy_10"] ?: crxAvatar,
        [UIImage imageNamed:@"crx_dy_12"] ?: crxAvatar,
        [UIImage imageNamed:@"crx_dy_14"] ?: crxAvatar,
        [UIImage imageNamed:@"crx_dy_16"] ?: crxAvatar
    ];
    NSArray<NSString *> *crxDisplayNames = @[
        @"Hayden",
        @"Carson",
        @"Bennett",
        @"Holden",
        @"Tanner",
        @"Garrett",
        @"Malcolm",
        @"Alyssa"
    ];
    NSArray<NSString *> *crxBios = @[
        @"I love gesture dance and enjoy making new friends. Let's dance together and share happy moments. ✨🕺",
        @"Always exploring smooth hand moves and playful rhythm clips with friends.",
        @"Recording small gesture dance moments and collecting bright memories every day.",
        @"Into hand flow, soft timing, and sharing fun challenge clips with the circle.",
        @"Trying new dance gestures, saving cute clips, and meeting more creative people.",
        @"Enjoying music, motion, and quick hand dance ideas with an easygoing vibe.",
        @"Practicing clean rhythm and expressive moves while making new connections.",
        @"Sharing lighthearted gesture clips and meeting people who love the same beat."
    ];
    NSArray<NSString *> *crxLikes = @[@"60", @"74", @"83", @"68", @"91", @"55", @"79", @"88"];
    NSArray<NSString *> *crxFollowers = @[@"120", @"136", @"148", @"129", @"166", @"112", @"140", @"158"];
    NSArray<NSString *> *crxFollowing = @[@"33", @"41", @"28", @"36", @"45", @"31", @"39", @"42"];

    NSInteger crxStart = crxIndex * 2 + 1;
    NSMutableArray<UIImage *> *crxAlbum = [NSMutableArray array];
    for (NSInteger crxStep = 0; crxStep < 4; crxStep++) {
        NSInteger crxImageIndex = ((crxStart + crxStep - 1) % 16) + 1;
        UIImage *crxImage = [UIImage imageNamed:[NSString stringWithFormat:@"crx_dy_%ld", (long)crxImageIndex]] ?: crxAvatar;
        [crxAlbum addObject:crxImage];
    }

    return @{
        @"crxAvatar": crxAvatar,
        @"crxDisplayName": crxDisplayNames[crxIndex],
        @"crxHero": crxHeroImages[crxIndex],
        @"crxBio": crxBios[crxIndex],
        @"crxLikes": crxLikes[crxIndex],
        @"crxFollowers": crxFollowers[crxIndex],
        @"crxFollowing": crxFollowing[crxIndex],
        @"crxAlbum": crxAlbum.copy
    };
}

- (NSInteger)crx_indexForUserName:(NSString *)crxName {
    NSArray<NSString *> *crxNames = @[@"Hayden", @"Carson", @"Bennett", @"Holden", @"Tanner", @"Garrett", @"Malcolm", @"Alyssa"];
    NSUInteger crxIndex = [crxNames indexOfObject:crxName];
    return crxIndex == NSNotFound ? 0 : (NSInteger)crxIndex;
}

- (void)crx_backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)crx_messageTapped {
    CRXChannelController *crxController = [[CRXChannelController alloc] init];
    UIImage *crxAvatar = self.crxUserItem[@"crxImage"] ?: self.crxUserItem[@"crxAvatar"] ?: [UIImage imageNamed:@"crx_head_1"] ?: UIImage.new;
    NSString *crxName = self.crxUserItem[@"crxName"] ?: @"Hayden";
    crxController.crxMessageItem = @{
        @"crxAvatar": crxAvatar,
        @"crxName": crxName,
        @"crxPreview": @"Hey, want to practice the next gesture dance together?",
        @"crxTime": @"Now"
    };
    [self.navigationController pushViewController:crxController animated:YES];
}

- (void)crx_moreTapped {
    NSString *crxName = self.crxUserItem[@"crxName"] ?: @"";
    __weak typeof(self) weakSelf = self;
    [self crx_presentModerationForUserName:crxName blockHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end
