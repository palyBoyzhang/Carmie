//
//  CAREXQStudioController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQStudioController.h"
#import "CAREXQImage.h"
#import "CAREXQFlowResultController.h"
#import "CAREXQAccessCenterController.h"

static NSString * const CAREXQAccessCoinCountKey = @"CAREXQAccessCoinCountKey";
static NSInteger const CAREXQStudioCreateCost = 200;

@interface CAREXQStudioController () <UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *crxScrollView;
@property (nonatomic, strong) UIView *crxContentView;
@property (nonatomic, strong) UITextView *crxEmojiTextView;
@property (nonatomic, strong) UILabel *crxEmojiPlaceholderLabel;
@property (nonatomic, strong) UITextView *crxPromptTextView;
@property (nonatomic, strong) UILabel *crxPromptPlaceholderLabel;
@property (nonatomic, strong) NSArray<UIButton *> *crxTempoButtons;
@property (nonatomic, strong) NSArray<UIButton *> *crxEnergyButtons;
@property (nonatomic, strong) UIButton *crxSelectedTempoButton;
@property (nonatomic, strong) UIButton *crxSelectedEnergyButton;
@property (nonatomic, strong) UIButton *crxCreateButton;
@property (nonatomic, assign) BOOL crxCreating;

@end

@implementation CAREXQStudioController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x09/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildViews];
    [self crx_updateCreateButtonState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)crx_buildViews {
    UITapGestureRecognizer *crxTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crx_dismissKeyboard)];
    crxTapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:crxTapGesture];

    UIImageView *crxHeroImageView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_studio_bg"]];
    crxHeroImageView.contentMode = UIViewContentModeScaleAspectFill;
    crxHeroImageView.clipsToBounds = YES;
    crxHeroImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxHeroImageView];

    UIButton *crxBackButton = [self crx_buildTopButtonWithSystemImage:@"chevron.left"];
    [crxBackButton addTarget:self action:@selector(crx_backTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxBackButton];
    crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;

    UIButton *crxHistoryButton = [self crx_buildTopButtonWithSystemImage:@"sparkles"];
    [self.view addSubview:crxHistoryButton];
    crxHistoryButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxScrollView = [[UIScrollView alloc] init];
    self.crxScrollView.showsVerticalScrollIndicator = NO;
    self.crxScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.crxScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.crxScrollView];

    self.crxContentView = [[UIView alloc] init];
    self.crxContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxScrollView addSubview:self.crxContentView];

    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.text = @"Emoji Moves";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightHeavy];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxTitleLabel];

    UILabel *crxSubtitleLabel = [[UILabel alloc] init];
    crxSubtitleLabel.text = @"Turn your emoji ideas into a gesture dance prompt with a strong visual rhythm.";
    crxSubtitleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.82];
    crxSubtitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    crxSubtitleLabel.numberOfLines = 0;
    crxSubtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxSubtitleLabel];

    UILabel *crxEmojiSectionLabel = [self crx_buildSectionLabel:@"Emoji Prompt"];
    [self.crxContentView addSubview:crxEmojiSectionLabel];
    crxEmojiSectionLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *crxEmojiBoxView = [self crx_buildInputContainer];
    crxEmojiBoxView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxEmojiBoxView];

    self.crxEmojiTextView = [self crx_buildTextView];
    self.crxEmojiTextView.delegate = self;
    self.crxEmojiTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxEmojiBoxView addSubview:self.crxEmojiTextView];

    self.crxEmojiPlaceholderLabel = [self crx_buildPlaceholderLabelWithText:@"Type a few emojis that match the hand dance vibe.\nExample: 🤲✨🎶💜"];
    self.crxEmojiPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxEmojiBoxView addSubview:self.crxEmojiPlaceholderLabel];

    UILabel *crxPromptSectionLabel = [self crx_buildSectionLabel:@"Scene Notes"];
    [self.crxContentView addSubview:crxPromptSectionLabel];
    crxPromptSectionLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *crxPromptBoxView = [self crx_buildInputContainer];
    crxPromptBoxView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxPromptBoxView];

    self.crxPromptTextView = [self crx_buildTextView];
    self.crxPromptTextView.delegate = self;
    self.crxPromptTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxPromptBoxView addSubview:self.crxPromptTextView];

    self.crxPromptPlaceholderLabel = [self crx_buildPlaceholderLabelWithText:@"Add a short direction for pose, camera feeling, or hand motion detail."];
    self.crxPromptPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxPromptBoxView addSubview:self.crxPromptPlaceholderLabel];

    UILabel *crxTempoLabel = [self crx_buildSectionLabel:@"Tempo"];
    crxTempoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxTempoLabel];

    UIStackView *crxTempoStack = [[UIStackView alloc] init];
    crxTempoStack.axis = UILayoutConstraintAxisHorizontal;
    crxTempoStack.spacing = 12;
    crxTempoStack.distribution = UIStackViewDistributionFillEqually;
    crxTempoStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxTempoStack];

    NSMutableArray<UIButton *> *crxTempoButtons = [NSMutableArray array];
    for (NSString *crxTitle in @[@"Soft", @"Groovy", @"Sharp"]) {
        UIButton *crxButton = [self crx_buildOptionButtonWithTitle:crxTitle];
        [crxButton addTarget:self action:@selector(crx_tempoTapped:) forControlEvents:UIControlEventTouchUpInside];
        [crxTempoStack addArrangedSubview:crxButton];
        [crxTempoButtons addObject:crxButton];
    }
    self.crxTempoButtons = crxTempoButtons.copy;

    UILabel *crxEnergyLabel = [self crx_buildSectionLabel:@"Energy"];
    crxEnergyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxEnergyLabel];

    UIView *crxEnergyWrap = [[UIView alloc] init];
    crxEnergyWrap.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:crxEnergyWrap];

    NSMutableArray<UIButton *> *crxEnergyButtons = [NSMutableArray array];
    UIButton *crxPreviousButton = nil;
    for (NSInteger crxIndex = 0; crxIndex < 4; crxIndex++) {
        NSString *crxTitle = @[@"Cute", @"Dreamy", @"Confident", @"Playful"][crxIndex];
        UIButton *crxButton = [self crx_buildOptionButtonWithTitle:crxTitle];
        crxButton.translatesAutoresizingMaskIntoConstraints = NO;
        [crxButton addTarget:self action:@selector(crx_energyTapped:) forControlEvents:UIControlEventTouchUpInside];
        [crxEnergyWrap addSubview:crxButton];
        [crxEnergyButtons addObject:crxButton];

        if (crxIndex < 3) {
            [NSLayoutConstraint activateConstraints:@[
                [crxButton.topAnchor constraintEqualToAnchor:crxEnergyWrap.topAnchor],
                [crxButton.heightAnchor constraintEqualToConstant:46]
            ]];
            if (crxPreviousButton) {
                [crxButton.leadingAnchor constraintEqualToAnchor:crxPreviousButton.trailingAnchor constant:12].active = YES;
                [crxButton.widthAnchor constraintEqualToAnchor:crxPreviousButton.widthAnchor].active = YES;
            } else {
                [crxButton.leadingAnchor constraintEqualToAnchor:crxEnergyWrap.leadingAnchor].active = YES;
            }
            if (crxIndex == 2) {
                [crxButton.trailingAnchor constraintEqualToAnchor:crxEnergyWrap.trailingAnchor].active = YES;
            }
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [crxButton.topAnchor constraintEqualToAnchor:crxEnergyWrap.topAnchor constant:58],
                [crxButton.leadingAnchor constraintEqualToAnchor:crxEnergyWrap.leadingAnchor],
                [crxButton.widthAnchor constraintEqualToAnchor:self.crxEnergyButtons.firstObject.widthAnchor],
                [crxButton.heightAnchor constraintEqualToConstant:46],
                [crxButton.bottomAnchor constraintEqualToAnchor:crxEnergyWrap.bottomAnchor]
            ]];
        }
        crxPreviousButton = crxButton;
    }
    self.crxEnergyButtons = crxEnergyButtons.copy;

    self.crxCreateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxCreateButton setTitle:@"Interpret" forState:UIControlStateNormal];
    [self.crxCreateButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxCreateButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    self.crxCreateButton.layer.cornerRadius = 28;
    self.crxCreateButton.layer.masksToBounds = YES;
    [self.crxCreateButton addTarget:self action:@selector(crx_createTapped) forControlEvents:UIControlEventTouchUpInside];
    self.crxCreateButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.crxContentView addSubview:self.crxCreateButton];

    CAGradientLayer *crxGradient = [CAGradientLayer layer];
    crxGradient.colors = @[
        (__bridge id)[UIColor colorWithRed:1.0 green:0.62 blue:0.26 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:1.0 green:0.16 blue:0.60 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.45 green:0.24 blue:1.0 alpha:1.0].CGColor
    ];
    crxGradient.startPoint = CGPointMake(0.0, 0.5);
    crxGradient.endPoint = CGPointMake(1.0, 0.5);
    crxGradient.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width - 30, 56);
    crxGradient.cornerRadius = 28;
    [self.crxCreateButton.layer insertSublayer:crxGradient atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
        [crxHeroImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxHeroImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxHeroImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxHeroImageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [crxBackButton.widthAnchor constraintEqualToConstant:34],
        [crxBackButton.heightAnchor constraintEqualToConstant:34],

        [crxHistoryButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [crxHistoryButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-18],
        [crxHistoryButton.widthAnchor constraintEqualToConstant:34],
        [crxHistoryButton.heightAnchor constraintEqualToConstant:34],

        [self.crxScrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:300],
        [self.crxScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxScrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],

        [self.crxContentView.topAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.topAnchor],
        [self.crxContentView.leadingAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.leadingAnchor],
        [self.crxContentView.trailingAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.trailingAnchor],
        [self.crxContentView.bottomAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.bottomAnchor],
        [self.crxContentView.widthAnchor constraintEqualToAnchor:self.crxScrollView.frameLayoutGuide.widthAnchor],

        [crxTitleLabel.topAnchor constraintEqualToAnchor:self.crxContentView.topAnchor constant:18],
        [crxTitleLabel.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:16],
        [crxTitleLabel.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor constant:-16],

        [crxSubtitleLabel.topAnchor constraintEqualToAnchor:crxTitleLabel.bottomAnchor constant:8],
        [crxSubtitleLabel.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],
        [crxSubtitleLabel.trailingAnchor constraintEqualToAnchor:crxTitleLabel.trailingAnchor],

        [crxEmojiSectionLabel.topAnchor constraintEqualToAnchor:crxSubtitleLabel.bottomAnchor constant:24],
        [crxEmojiSectionLabel.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],

        [crxEmojiBoxView.topAnchor constraintEqualToAnchor:crxEmojiSectionLabel.bottomAnchor constant:10],
        [crxEmojiBoxView.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],
        [crxEmojiBoxView.trailingAnchor constraintEqualToAnchor:crxTitleLabel.trailingAnchor],
        [crxEmojiBoxView.heightAnchor constraintEqualToConstant:94],

        [self.crxEmojiTextView.topAnchor constraintEqualToAnchor:crxEmojiBoxView.topAnchor constant:10],
        [self.crxEmojiTextView.leadingAnchor constraintEqualToAnchor:crxEmojiBoxView.leadingAnchor constant:10],
        [self.crxEmojiTextView.trailingAnchor constraintEqualToAnchor:crxEmojiBoxView.trailingAnchor constant:-10],
        [self.crxEmojiTextView.bottomAnchor constraintEqualToAnchor:crxEmojiBoxView.bottomAnchor constant:-10],

        [self.crxEmojiPlaceholderLabel.topAnchor constraintEqualToAnchor:self.crxEmojiTextView.topAnchor constant:4],
        [self.crxEmojiPlaceholderLabel.leadingAnchor constraintEqualToAnchor:self.crxEmojiTextView.leadingAnchor constant:4],
        [self.crxEmojiPlaceholderLabel.trailingAnchor constraintEqualToAnchor:self.crxEmojiTextView.trailingAnchor],

        [crxPromptSectionLabel.topAnchor constraintEqualToAnchor:crxEmojiBoxView.bottomAnchor constant:22],
        [crxPromptSectionLabel.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],

        [crxPromptBoxView.topAnchor constraintEqualToAnchor:crxPromptSectionLabel.bottomAnchor constant:10],
        [crxPromptBoxView.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],
        [crxPromptBoxView.trailingAnchor constraintEqualToAnchor:crxTitleLabel.trailingAnchor],
        [crxPromptBoxView.heightAnchor constraintEqualToConstant:98],

        [self.crxPromptTextView.topAnchor constraintEqualToAnchor:crxPromptBoxView.topAnchor constant:10],
        [self.crxPromptTextView.leadingAnchor constraintEqualToAnchor:crxPromptBoxView.leadingAnchor constant:10],
        [self.crxPromptTextView.trailingAnchor constraintEqualToAnchor:crxPromptBoxView.trailingAnchor constant:-10],
        [self.crxPromptTextView.bottomAnchor constraintEqualToAnchor:crxPromptBoxView.bottomAnchor constant:-10],

        [self.crxPromptPlaceholderLabel.topAnchor constraintEqualToAnchor:self.crxPromptTextView.topAnchor constant:4],
        [self.crxPromptPlaceholderLabel.leadingAnchor constraintEqualToAnchor:self.crxPromptTextView.leadingAnchor constant:4],
        [self.crxPromptPlaceholderLabel.trailingAnchor constraintEqualToAnchor:self.crxPromptTextView.trailingAnchor],

        [crxTempoLabel.topAnchor constraintEqualToAnchor:crxPromptBoxView.bottomAnchor constant:24],
        [crxTempoLabel.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],

        [crxTempoStack.topAnchor constraintEqualToAnchor:crxTempoLabel.bottomAnchor constant:12],
        [crxTempoStack.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],
        [crxTempoStack.trailingAnchor constraintEqualToAnchor:crxTitleLabel.trailingAnchor],
        [crxTempoStack.heightAnchor constraintEqualToConstant:44],

        [crxEnergyLabel.topAnchor constraintEqualToAnchor:crxTempoStack.bottomAnchor constant:22],
        [crxEnergyLabel.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],

        [crxEnergyWrap.topAnchor constraintEqualToAnchor:crxEnergyLabel.bottomAnchor constant:12],
        [crxEnergyWrap.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],
        [crxEnergyWrap.trailingAnchor constraintEqualToAnchor:crxTitleLabel.trailingAnchor],

        [self.crxCreateButton.topAnchor constraintEqualToAnchor:crxEnergyWrap.bottomAnchor constant:28],
        [self.crxCreateButton.leadingAnchor constraintEqualToAnchor:crxTitleLabel.leadingAnchor],
        [self.crxCreateButton.trailingAnchor constraintEqualToAnchor:crxTitleLabel.trailingAnchor],
        [self.crxCreateButton.heightAnchor constraintEqualToConstant:54],
        [self.crxCreateButton.bottomAnchor constraintEqualToAnchor:self.crxContentView.bottomAnchor constant:-26]
    ]];
}

- (UIButton *)crx_buildTopButtonWithSystemImage:(NSString *)crxSystemName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithRed:0x1B/255.0 green:0x0E/255.0 blue:0x2F/255.0 alpha:0.92];
    crxButton.layer.cornerRadius = 11;
    UIImageSymbolConfiguration *crxConfig = [UIImageSymbolConfiguration configurationWithPointSize:16 weight:UIFontWeightBold];
    [crxButton setImage:[UIImage systemImageNamed:crxSystemName withConfiguration:crxConfig] forState:UIControlStateNormal];
    crxButton.tintColor = UIColor.whiteColor;
    return crxButton;
}

- (UILabel *)crx_buildSectionLabel:(NSString *)crxText {
    UILabel *crxLabel = [[UILabel alloc] init];
    crxLabel.text = crxText;
    crxLabel.textColor = UIColor.whiteColor;
    crxLabel.font = [UIFont italicSystemFontOfSize:17];
    return crxLabel;
}

- (UIView *)crx_buildInputContainer {
    UIView *crxView = [[UIView alloc] init];
    crxView.backgroundColor = [UIColor colorWithRed:0x2B/255.0 green:0x0E/255.0 blue:0x4C/255.0 alpha:1.0];
    crxView.layer.cornerRadius = 16;
    crxView.layer.borderWidth = 1;
    crxView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.22].CGColor;
    return crxView;
}

- (UITextView *)crx_buildTextView {
    UITextView *crxTextView = [[UITextView alloc] init];
    crxTextView.backgroundColor = UIColor.clearColor;
    crxTextView.textColor = UIColor.whiteColor;
    crxTextView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    crxTextView.textContainerInset = UIEdgeInsetsZero;
    return crxTextView;
}

- (UILabel *)crx_buildPlaceholderLabelWithText:(NSString *)crxText {
    UILabel *crxLabel = [[UILabel alloc] init];
    crxLabel.text = crxText;
    crxLabel.textColor = [UIColor colorWithWhite:1 alpha:0.48];
    crxLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    crxLabel.numberOfLines = 0;
    return crxLabel;
}

- (UIButton *)crx_buildOptionButtonWithTitle:(NSString *)crxTitle {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxButton setTitle:crxTitle forState:UIControlStateNormal];
    [crxButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.68] forState:UIControlStateNormal];
    crxButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    crxButton.backgroundColor = [UIColor colorWithRed:0x17/255.0 green:0x1D/255.0 blue:0x2E/255.0 alpha:1.0];
    crxButton.layer.cornerRadius = 12;
    crxButton.layer.borderWidth = 1;
    crxButton.layer.borderColor = UIColor.clearColor.CGColor;
    return crxButton;
}

- (void)crx_tempoTapped:(UIButton *)crxSender {
    self.crxSelectedTempoButton = crxSender;
    [self crx_updateOptionButtons:self.crxTempoButtons selectedButton:crxSender];
    [self crx_updateCreateButtonState];
}

- (void)crx_energyTapped:(UIButton *)crxSender {
    self.crxSelectedEnergyButton = crxSender;
    [self crx_updateOptionButtons:self.crxEnergyButtons selectedButton:crxSender];
    [self crx_updateCreateButtonState];
}

- (void)crx_updateOptionButtons:(NSArray<UIButton *> *)crxButtons selectedButton:(UIButton *)crxSelectedButton {
    for (UIButton *crxButton in crxButtons) {
        BOOL crxSelected = (crxButton == crxSelectedButton);
        [crxButton setTitleColor:(crxSelected ? UIColor.whiteColor : [UIColor colorWithWhite:1 alpha:0.72]) forState:UIControlStateNormal];
        crxButton.backgroundColor = crxSelected ? [UIColor colorWithRed:0x3C/255.0 green:0x16/255.0 blue:0x54/255.0 alpha:1.0] : [UIColor colorWithRed:0x17/255.0 green:0x1D/255.0 blue:0x2E/255.0 alpha:1.0];
        crxButton.layer.borderColor = (crxSelected ? [UIColor colorWithRed:0.88 green:0.36 blue:1 alpha:1].CGColor : UIColor.clearColor.CGColor);
    }
}

- (void)crx_updateCreateButtonState {
    BOOL crxEnabled = self.crxEmojiTextView.text.length > 0
    && self.crxPromptTextView.text.length > 0
    && self.crxSelectedTempoButton != nil
    && self.crxSelectedEnergyButton != nil
    && !self.crxCreating;
    self.crxCreateButton.enabled = crxEnabled;
    self.crxCreateButton.alpha = crxEnabled ? 1.0 : 0.55;
}

- (void)crx_backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)crx_createTapped {
    [self.view endEditing:YES];
    if (self.crxCreating) {
        return;
    }
    NSInteger crxCoinCount = [NSUserDefaults.standardUserDefaults integerForKey:CAREXQAccessCoinCountKey];
    if (crxCoinCount < CAREXQStudioCreateCost) {
        CAREXQAccessCenterController *crxController = [[CAREXQAccessCenterController alloc] init];
        [self.navigationController pushViewController:crxController animated:YES];
        return;
    }
    [self crx_requestAIResult];
}

- (void)crx_dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.crxEmojiPlaceholderLabel.hidden = self.crxEmojiTextView.text.length > 0;
    self.crxPromptPlaceholderLabel.hidden = self.crxPromptTextView.text.length > 0;
    [self crx_updateCreateButtonState];
}

- (NSString *)crx_questionText {
    NSString *crxEmoji = [self.crxEmojiTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *crxPrompt = [self.crxPromptTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *crxTempo = [self.crxSelectedTempoButton titleForState:UIControlStateNormal] ?: @"";
    NSString *crxEnergy = [self.crxSelectedEnergyButton titleForState:UIControlStateNormal] ?: @"";
    return [NSString stringWithFormat:@"Emoji Prompt: %@\nScene Notes: %@\nTempo: %@\nEnergy: %@", crxEmoji, crxPrompt, crxTempo, crxEnergy];
}

- (void)crx_requestAIResult {
    self.crxCreating = YES;
    [self.crxCreateButton setTitle:@"Interpreting..." forState:UIControlStateNormal];
    [self crx_updateCreateButtonState];
    [self crx_showLoadingWithText:@"Interpreting..."];

    NSURL *crxURL = [NSURL URLWithString:@"http://www.v8k2x7z9m4q1p.xyz/talk/aic/aiChat"];
    NSMutableURLRequest *crxRequest = [NSMutableURLRequest requestWithURL:crxURL];
    crxRequest.HTTPMethod = @"POST";
    [crxRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *crxParameters = @{@"question": [self crx_questionText]};
    crxRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:crxParameters options:0 error:nil];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *crxTask = [NSURLSession.sharedSession dataTaskWithRequest:crxRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.crxCreating = NO;
            [strongSelf.crxCreateButton setTitle:@"Interpret" forState:UIControlStateNormal];
            [strongSelf crx_updateCreateButtonState];
            [strongSelf crx_hideLoading];
        });

        if (error != nil || data.length == 0) {
            [strongSelf crx_showAlertWithTitle:@"Reminder" message:error.localizedDescription ?: @"Request failed."];
            return;
        }

        NSDictionary *crxJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (![crxJSON isKindOfClass:NSDictionary.class]) {
            [strongSelf crx_showAlertWithTitle:@"Reminder" message:@"Invalid response data."];
            return;
        }

        NSString *crxResultText = [strongSelf crx_resultTextFromObject:crxJSON[@"data"]];
        if ([crxJSON[@"code"] integerValue] != 200000 || crxResultText.length == 0) {
            NSString *crxMessage = crxJSON[@"message"];
            [strongSelf crx_showAlertWithTitle:@"Reminder" message:crxMessage.length > 0 ? crxMessage : @"Failed to generate result."];
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger crxCoinCount = [NSUserDefaults.standardUserDefaults integerForKey:CAREXQAccessCoinCountKey];
            NSInteger crxUpdatedCoinCount = MAX(crxCoinCount - CAREXQStudioCreateCost, 0);
            [NSUserDefaults.standardUserDefaults setInteger:crxUpdatedCoinCount forKey:CAREXQAccessCoinCountKey];
            [NSUserDefaults.standardUserDefaults synchronize];

            CAREXQFlowResultController *crxController = [[CAREXQFlowResultController alloc] init];
            crxController.crxResultText = crxResultText;
            [strongSelf.navigationController pushViewController:crxController animated:YES];
        });
    }];
    [crxTask resume];
}

- (NSString *)crx_resultTextFromObject:(id)crxObject {
    if ([crxObject isKindOfClass:NSString.class]) {
        return (NSString *)crxObject;
    }
    if ([crxObject isKindOfClass:NSDictionary.class] || [crxObject isKindOfClass:NSArray.class]) {
        NSData *crxData = [NSJSONSerialization dataWithJSONObject:crxObject options:NSJSONWritingPrettyPrinted error:nil];
        if (crxData != nil) {
            return [[NSString alloc] initWithData:crxData encoding:NSUTF8StringEncoding] ?: @"";
        }
    }
    return @"";
}

- (void)crx_showAlertWithTitle:(NSString *)crxTitle message:(NSString *)crxMessage {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:crxTitle message:crxMessage preferredStyle:UIAlertControllerStyleAlert];
        [crxAlertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:crxAlertController animated:YES completion:nil];
    });
}

@end
