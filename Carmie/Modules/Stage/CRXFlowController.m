//
//  CRXFlowController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXFlowController.h"

@interface CRXFlowController () <UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *crxScrollView;
@property (nonatomic, strong) UIView *crxContentView;
@property (nonatomic, strong) UITextView *crxMusicTextView;
@property (nonatomic, strong) UILabel *crxMusicPlaceholderLabel;
@property (nonatomic, strong) UITextView *crxStyleTextView;
@property (nonatomic, strong) UILabel *crxStylePlaceholderLabel;
@property (nonatomic, strong) NSArray<UIButton *> *crxSpeedButtons;
@property (nonatomic, strong) NSArray<UIButton *> *crxMoodButtons;
@property (nonatomic, strong) UIButton *crxSelectedSpeedButton;
@property (nonatomic, strong) UIButton *crxSelectedMoodButton;
@property (nonatomic, strong) UIButton *crxCreateButton;

@end

@implementation CRXFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x09/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildViews];
    [self crx_updateCreateButtonState];
}

- (void)crx_buildViews {
    UITapGestureRecognizer *crxTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crx_dismissKeyboard)];
    crxTapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:crxTapGesture];
    
    UIImageView *crxHeroImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_flow_bg"]];
    crxHeroImageView.contentMode = UIViewContentModeScaleToFill;
    crxHeroImageView.clipsToBounds = YES;
    [self.view addSubview:crxHeroImageView];
    crxHeroImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxScrollView = [[UIScrollView alloc] init];
    self.crxScrollView.showsVerticalScrollIndicator = NO;
    self.crxScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.crxScrollView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.crxScrollView];
    self.crxScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxContentView = [[UIView alloc] init];
    self.crxContentView.backgroundColor = [UIColor colorWithRed:0x0A/255.0 green:0x0B/255.0 blue:0x12/255.0 alpha:1];
    [self.crxScrollView addSubview:self.crxContentView];
    self.crxContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.crxScrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:110],
        [self.crxScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxScrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        
        [self.crxContentView.topAnchor constraintEqualToAnchor:self.crxScrollView.topAnchor],
        [self.crxContentView.leadingAnchor constraintEqualToAnchor:self.crxScrollView.leadingAnchor],
        [self.crxContentView.trailingAnchor constraintEqualToAnchor:self.crxScrollView.trailingAnchor],
        [self.crxContentView.bottomAnchor constraintEqualToAnchor:self.crxScrollView.bottomAnchor],
        [self.crxContentView.widthAnchor constraintEqualToAnchor:self.crxScrollView.widthAnchor]
    ]];
    
    UIView *crxPanelView = [[UIView alloc] init];
    crxPanelView.backgroundColor = UIColor.clearColor;
    [self.crxContentView addSubview:crxPanelView];
    crxPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *crxMusicTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_flow_music"]];
    crxMusicTitleView.contentMode = UIViewContentModeScaleAspectFit;
    [crxPanelView addSubview:crxMusicTitleView];
    crxMusicTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *crxMusicBoxView = [self crx_buildInputContainer];
    [crxPanelView addSubview:crxMusicBoxView];
    crxMusicBoxView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxMusicTextView = [self crx_buildTextView];
    self.crxMusicTextView.delegate = self;
    [crxMusicBoxView addSubview:self.crxMusicTextView];
    self.crxMusicTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxMusicPlaceholderLabel = [self crx_buildPlaceholderLabelWithText:@"Specify the type of music or a specific track\nname for the hand dance."];
    [crxMusicBoxView addSubview:self.crxMusicPlaceholderLabel];
    self.crxMusicPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *crxStyleTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_flow_style"]];
    crxStyleTitleView.contentMode = UIViewContentModeScaleAspectFit;
    [crxPanelView addSubview:crxStyleTitleView];
    crxStyleTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *crxStyleBoxView = [self crx_buildInputContainer];
    [crxPanelView addSubview:crxStyleBoxView];
    crxStyleBoxView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxStyleTextView = [self crx_buildTextView];
    self.crxStyleTextView.delegate = self;
    [crxStyleBoxView addSubview:self.crxStyleTextView];
    self.crxStyleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxStylePlaceholderLabel = [self crx_buildPlaceholderLabelWithText:@"Choose the style of the hand dance (e.g.,\nfluid, energetic, lyrical)."];
    [crxStyleBoxView addSubview:self.crxStylePlaceholderLabel];
    self.crxStylePlaceholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *crxSpeedTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_flow_spe"]];
    crxSpeedTitleView.contentMode = UIViewContentModeScaleAspectFit;
    [crxPanelView addSubview:crxSpeedTitleView];
    crxSpeedTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIStackView *crxSpeedStackView = [[UIStackView alloc] init];
    crxSpeedStackView.axis = UILayoutConstraintAxisHorizontal;
    crxSpeedStackView.distribution = UIStackViewDistributionFillEqually;
    crxSpeedStackView.spacing = 12.f;
    [crxPanelView addSubview:crxSpeedStackView];
    crxSpeedStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray<NSString *> *crxSpeedTitles = @[@"Fast", @"Medium", @"Slow"];
    NSMutableArray<UIButton *> *crxSpeedButtons = [NSMutableArray array];
    for (NSString *crxTitle in crxSpeedTitles) {
        UIButton *crxButton = [self crx_buildOptionButtonWithTitle:crxTitle];
        [crxButton addTarget:self action:@selector(crx_speedTapped:) forControlEvents:UIControlEventTouchUpInside];
        [crxSpeedStackView addArrangedSubview:crxButton];
        [crxSpeedButtons addObject:crxButton];
    }
    self.crxSpeedButtons = crxSpeedButtons.copy;
    
    UIImageView *crxMoodTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_flow_spe"]];
    crxMoodTitleView.contentMode = UIViewContentModeScaleAspectFit;
    [crxPanelView addSubview:crxMoodTitleView];
    crxMoodTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *crxMoodContainerView = [[UIView alloc] init];
    [crxPanelView addSubview:crxMoodContainerView];
    crxMoodContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray<NSString *> *crxMoodTitles = @[@"Happy", @"Sad", @"Romantic", @"Motivational"];
    NSMutableArray<UIButton *> *crxMoodButtons = [NSMutableArray array];
    UIButton *crxPreviousMoodButton = nil;
    UIButton *crxSecondRowLeadingButton = nil;
    for (NSInteger crxIndex = 0; crxIndex < crxMoodTitles.count; crxIndex++) {
        UIButton *crxButton = [self crx_buildOptionButtonWithTitle:crxMoodTitles[crxIndex]];
        [crxButton addTarget:self action:@selector(crx_moodTapped:) forControlEvents:UIControlEventTouchUpInside];
        [crxMoodContainerView addSubview:crxButton];
        crxButton.translatesAutoresizingMaskIntoConstraints = NO;
        [crxMoodButtons addObject:crxButton];
        
        if (crxIndex < 3) {
            [NSLayoutConstraint activateConstraints:@[
                [crxButton.topAnchor constraintEqualToAnchor:crxMoodContainerView.topAnchor],
                [crxButton.heightAnchor constraintEqualToConstant:46]
            ]];
            if (crxIndex == 0) {
                [crxButton.leadingAnchor constraintEqualToAnchor:crxMoodContainerView.leadingAnchor].active = YES;
            } else {
                [crxButton.leadingAnchor constraintEqualToAnchor:crxPreviousMoodButton.trailingAnchor constant:12].active = YES;
                [crxButton.widthAnchor constraintEqualToAnchor:crxPreviousMoodButton.widthAnchor].active = YES;
            }
            if (crxIndex == 2) {
                [crxButton.trailingAnchor constraintEqualToAnchor:crxMoodContainerView.trailingAnchor].active = YES;
            }
            if (crxIndex == 0) {
                crxSecondRowLeadingButton = crxButton;
            }
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [crxButton.topAnchor constraintEqualToAnchor:crxMoodContainerView.topAnchor constant:58],
                [crxButton.leadingAnchor constraintEqualToAnchor:crxMoodContainerView.leadingAnchor],
                [crxButton.widthAnchor constraintEqualToAnchor:crxSecondRowLeadingButton.widthAnchor],
                [crxButton.heightAnchor constraintEqualToConstant:46],
                [crxButton.bottomAnchor constraintEqualToAnchor:crxMoodContainerView.bottomAnchor]
            ]];
        }
        crxPreviousMoodButton = crxButton;
    }
    self.crxMoodButtons = crxMoodButtons.copy;
    
    self.crxCreateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxCreateButton setTitle:@"Create" forState:UIControlStateNormal];
    [self.crxCreateButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxCreateButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    self.crxCreateButton.layer.cornerRadius = 28.f;
    self.crxCreateButton.layer.masksToBounds = YES;
    [self.crxCreateButton addTarget:self action:@selector(crx_createTapped) forControlEvents:UIControlEventTouchUpInside];
    [crxPanelView addSubview:self.crxCreateButton];
    self.crxCreateButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    CAGradientLayer *crxCreateGradientLayer = [CAGradientLayer layer];
    crxCreateGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.62 blue:0.26 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.16 blue:0.60 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0.45 green:0.24 blue:1 alpha:1].CGColor
    ];
    crxCreateGradientLayer.startPoint = CGPointMake(0, 0.5);
    crxCreateGradientLayer.endPoint = CGPointMake(1, 0.5);
    crxCreateGradientLayer.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width - 30, 56);
    crxCreateGradientLayer.cornerRadius = 28.f;
    [self.crxCreateButton.layer insertSublayer:crxCreateGradientLayer atIndex:0];
    
    UIView *crxCostView = [[UIView alloc] init];
    crxCostView.backgroundColor = UIColor.whiteColor;
    crxCostView.layer.cornerRadius = 10.f;
    [self.crxCreateButton addSubview:crxCostView];
    crxCostView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *crxCostLabel = [[UILabel alloc] init];
    crxCostLabel.text = @"200";
    crxCostLabel.textColor = [UIColor colorWithRed:0x3F/255.0 green:0x36/255.0 blue:0x57/255.0 alpha:1];
    crxCostLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
    [crxCostView addSubview:crxCostLabel];
    crxCostLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *crxCostIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_harbor_zhs"]];
    crxCostIconView.contentMode = UIViewContentModeScaleAspectFit;
    [crxCostView addSubview:crxCostIconView];
    crxCostIconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [crxHeroImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxHeroImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxHeroImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        
        [crxPanelView.topAnchor constraintEqualToAnchor:self.crxContentView.topAnchor],
        [crxPanelView.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:15],
        [crxPanelView.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor constant:-15],
        [crxPanelView.bottomAnchor constraintEqualToAnchor:self.crxContentView.bottomAnchor constant:-24],
        
        [crxMusicTitleView.topAnchor constraintEqualToAnchor:crxPanelView.topAnchor constant:18],
        [crxMusicTitleView.centerXAnchor constraintEqualToAnchor:crxPanelView.centerXAnchor],
        [crxMusicTitleView.heightAnchor constraintEqualToConstant:28],
        
        [crxMusicBoxView.topAnchor constraintEqualToAnchor:crxMusicTitleView.bottomAnchor constant:12],
        [crxMusicBoxView.leadingAnchor constraintEqualToAnchor:crxPanelView.leadingAnchor],
        [crxMusicBoxView.trailingAnchor constraintEqualToAnchor:crxPanelView.trailingAnchor],
        [crxMusicBoxView.heightAnchor constraintEqualToConstant:98],
        
        [self.crxMusicTextView.topAnchor constraintEqualToAnchor:crxMusicBoxView.topAnchor constant:12],
        [self.crxMusicTextView.leadingAnchor constraintEqualToAnchor:crxMusicBoxView.leadingAnchor constant:10],
        [self.crxMusicTextView.trailingAnchor constraintEqualToAnchor:crxMusicBoxView.trailingAnchor constant:-10],
        [self.crxMusicTextView.bottomAnchor constraintEqualToAnchor:crxMusicBoxView.bottomAnchor constant:-10],
        
        [self.crxMusicPlaceholderLabel.topAnchor constraintEqualToAnchor:self.crxMusicTextView.topAnchor constant:3],
        [self.crxMusicPlaceholderLabel.leadingAnchor constraintEqualToAnchor:self.crxMusicTextView.leadingAnchor constant:4],
        [self.crxMusicPlaceholderLabel.trailingAnchor constraintEqualToAnchor:self.crxMusicTextView.trailingAnchor],
        
        [crxStyleTitleView.topAnchor constraintEqualToAnchor:crxMusicBoxView.bottomAnchor constant:22],
        [crxStyleTitleView.centerXAnchor constraintEqualToAnchor:crxPanelView.centerXAnchor],
        [crxStyleTitleView.heightAnchor constraintEqualToConstant:28],
        
        [crxStyleBoxView.topAnchor constraintEqualToAnchor:crxStyleTitleView.bottomAnchor constant:12],
        [crxStyleBoxView.leadingAnchor constraintEqualToAnchor:crxPanelView.leadingAnchor],
        [crxStyleBoxView.trailingAnchor constraintEqualToAnchor:crxPanelView.trailingAnchor],
        [crxStyleBoxView.heightAnchor constraintEqualToConstant:98],
        
        [self.crxStyleTextView.topAnchor constraintEqualToAnchor:crxStyleBoxView.topAnchor constant:12],
        [self.crxStyleTextView.leadingAnchor constraintEqualToAnchor:crxStyleBoxView.leadingAnchor constant:10],
        [self.crxStyleTextView.trailingAnchor constraintEqualToAnchor:crxStyleBoxView.trailingAnchor constant:-10],
        [self.crxStyleTextView.bottomAnchor constraintEqualToAnchor:crxStyleBoxView.bottomAnchor constant:-10],
        
        [self.crxStylePlaceholderLabel.topAnchor constraintEqualToAnchor:self.crxStyleTextView.topAnchor constant:3],
        [self.crxStylePlaceholderLabel.leadingAnchor constraintEqualToAnchor:self.crxStyleTextView.leadingAnchor constant:4],
        [self.crxStylePlaceholderLabel.trailingAnchor constraintEqualToAnchor:self.crxStyleTextView.trailingAnchor],
        
        [crxSpeedTitleView.topAnchor constraintEqualToAnchor:crxStyleBoxView.bottomAnchor constant:24],
        [crxSpeedTitleView.centerXAnchor constraintEqualToAnchor:crxPanelView.centerXAnchor],
        [crxSpeedTitleView.heightAnchor constraintEqualToConstant:28],
        
        [crxSpeedStackView.topAnchor constraintEqualToAnchor:crxSpeedTitleView.bottomAnchor constant:14],
        [crxSpeedStackView.leadingAnchor constraintEqualToAnchor:crxPanelView.leadingAnchor],
        [crxSpeedStackView.trailingAnchor constraintEqualToAnchor:crxPanelView.trailingAnchor],
        [crxSpeedStackView.heightAnchor constraintEqualToConstant:46],
        
        [crxMoodTitleView.topAnchor constraintEqualToAnchor:crxSpeedStackView.bottomAnchor constant:22],
        [crxMoodTitleView.centerXAnchor constraintEqualToAnchor:crxPanelView.centerXAnchor],
        [crxMoodTitleView.heightAnchor constraintEqualToConstant:28],
        
        [crxMoodContainerView.topAnchor constraintEqualToAnchor:crxMoodTitleView.bottomAnchor constant:14],
        [crxMoodContainerView.leadingAnchor constraintEqualToAnchor:crxPanelView.leadingAnchor],
        [crxMoodContainerView.trailingAnchor constraintEqualToAnchor:crxPanelView.trailingAnchor],
        
        [self.crxCreateButton.topAnchor constraintEqualToAnchor:crxMoodContainerView.bottomAnchor constant:24],
        [self.crxCreateButton.leadingAnchor constraintEqualToAnchor:crxPanelView.leadingAnchor],
        [self.crxCreateButton.trailingAnchor constraintEqualToAnchor:crxPanelView.trailingAnchor],
        [self.crxCreateButton.heightAnchor constraintEqualToConstant:56],
        [self.crxCreateButton.bottomAnchor constraintEqualToAnchor:crxPanelView.bottomAnchor],
        
        [crxCostView.centerYAnchor constraintEqualToAnchor:self.crxCreateButton.centerYAnchor constant:-3],
        [crxCostView.trailingAnchor constraintEqualToAnchor:self.crxCreateButton.trailingAnchor constant:-10],
        [crxCostView.widthAnchor constraintEqualToConstant:58],
        [crxCostView.heightAnchor constraintEqualToConstant:22],
        
        [crxCostLabel.leadingAnchor constraintEqualToAnchor:crxCostView.leadingAnchor constant:10],
        [crxCostLabel.centerYAnchor constraintEqualToAnchor:crxCostView.centerYAnchor],
        
        [crxCostIconView.leadingAnchor constraintEqualToAnchor:crxCostLabel.trailingAnchor constant:4],
        [crxCostIconView.centerYAnchor constraintEqualToAnchor:crxCostView.centerYAnchor],
        [crxCostIconView.widthAnchor constraintEqualToConstant:12],
        [crxCostIconView.heightAnchor constraintEqualToConstant:12]
    ]];
}

- (UIButton *)crx_buildTopButtonWithSystemImage:(NSString *)crxSystemName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithRed:0x1B/255.0 green:0x0E/255.0 blue:0x2F/255.0 alpha:0.92];
    crxButton.layer.cornerRadius = 11.f;
    UIImageSymbolConfiguration *crxConfig = [UIImageSymbolConfiguration configurationWithPointSize:16 weight:UIFontWeightBold];
    UIImage *crxImage = [UIImage systemImageNamed:crxSystemName withConfiguration:crxConfig];
    [crxButton setImage:crxImage forState:UIControlStateNormal];
    crxButton.tintColor = UIColor.whiteColor;
    return crxButton;
}

- (UIView *)crx_buildInputContainer {
    UIView *crxView = [[UIView alloc] init];
    crxView.backgroundColor = [UIColor colorWithRed:0x29/255.0 green:0x10/255.0 blue:0x37/255.0 alpha:0.92];
    crxView.layer.cornerRadius = 16.f;
    crxView.layer.borderWidth = 1.f;
    crxView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.22].CGColor;
    return crxView;
}

- (UITextView *)crx_buildTextView {
    UITextView *crxTextView = [[UITextView alloc] init];
    crxTextView.backgroundColor = UIColor.clearColor;
    crxTextView.textColor = UIColor.whiteColor;
    crxTextView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    crxTextView.tintColor = [UIColor colorWithRed:1 green:0.28 blue:0.72 alpha:1];
    crxTextView.textContainerInset = UIEdgeInsetsZero;
    crxTextView.textContainer.lineFragmentPadding = 0;
    return crxTextView;
}

- (UILabel *)crx_buildPlaceholderLabelWithText:(NSString *)crxText {
    UILabel *crxLabel = [[UILabel alloc] init];
    crxLabel.text = crxText;
    crxLabel.textColor = [UIColor colorWithWhite:1 alpha:0.62];
    crxLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    crxLabel.numberOfLines = 2;
    return crxLabel;
}

- (UIButton *)crx_buildOptionButtonWithTitle:(NSString *)crxTitle {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxButton setTitle:crxTitle forState:UIControlStateNormal];
    [crxButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.56] forState:UIControlStateNormal];
    crxButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    crxButton.backgroundColor = [UIColor colorWithRed:0x1D/255.0 green:0x20/255.0 blue:0x34/255.0 alpha:0.95];
    crxButton.layer.cornerRadius = 14.f;
    crxButton.layer.borderWidth = 1.f;
    crxButton.layer.borderColor = UIColor.clearColor.CGColor;
    return crxButton;
}

- (void)crx_speedTapped:(UIButton *)crxSender {
    self.crxSelectedSpeedButton = crxSender;
    [self crx_updateOptionButtons:self.crxSpeedButtons selectedButton:crxSender];
    [self crx_updateCreateButtonState];
}

- (void)crx_moodTapped:(UIButton *)crxSender {
    self.crxSelectedMoodButton = crxSender;
    [self crx_updateOptionButtons:self.crxMoodButtons selectedButton:crxSender];
    [self crx_updateCreateButtonState];
}

- (void)crx_updateOptionButtons:(NSArray<UIButton *> *)crxButtons selectedButton:(UIButton *)crxSelectedButton {
    for (UIButton *crxButton in crxButtons) {
        BOOL crxIsSelected = (crxButton == crxSelectedButton);
        [crxButton setTitleColor:(crxIsSelected ? UIColor.whiteColor : [UIColor colorWithWhite:1 alpha:0.56]) forState:UIControlStateNormal];
        crxButton.backgroundColor = crxIsSelected ? [UIColor colorWithRed:0x3B/255.0 green:0x1D/255.0 blue:0x40/255.0 alpha:1] : [UIColor colorWithRed:0x1D/255.0 green:0x20/255.0 blue:0x34/255.0 alpha:0.95];
        crxButton.layer.borderColor = (crxIsSelected ? [UIColor colorWithRed:1 green:0.37 blue:0.66 alpha:1].CGColor : UIColor.clearColor.CGColor);
    }
}

- (void)crx_updateCreateButtonState {
    BOOL crxHasMusic = self.crxMusicTextView.text.length > 0;
    BOOL crxHasStyle = self.crxStyleTextView.text.length > 0;
    BOOL crxHasSpeed = self.crxSelectedSpeedButton != nil;
    BOOL crxHasMood = self.crxSelectedMoodButton != nil;
    self.crxCreateButton.alpha = (crxHasMusic && crxHasStyle && crxHasSpeed && crxHasMood) ? 1.0 : 0.88;
}

- (void)crx_createTapped {
    [self.view endEditing:YES];
}

- (void)crx_dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.crxMusicPlaceholderLabel.hidden = self.crxMusicTextView.text.length > 0;
    self.crxStylePlaceholderLabel.hidden = self.crxStyleTextView.text.length > 0;
    [self crx_updateCreateButtonState];
}

@end
