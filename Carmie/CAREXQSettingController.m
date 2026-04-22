//
//  CAREXQSettingController.m
//  CAREXQ
//
//  Created by OpenAI on 2026/4/2.
//

#import "CAREXQSettingController.h"
#import "CAREXQImage.h"
#import "CAREXQAboutController.h"
#import "CMRAgreementController.h"
#import "CMRPrivacyController.h"

static NSString * const CAREXQSettingLoginStateKey = @"CAREXQEntryLoginStateKey";
static NSString * const CAREXQSettingNicknameKey = @"CAREXQIdentityNicknameKey";

@interface CAREXQSettingController ()

@property (nonatomic, strong) UIScrollView *crxScrollView;
@property (nonatomic, strong) UIView *crxContentView;
@property (nonatomic, strong) UIButton *crxLogoutButton;
@property (nonatomic, strong) CAGradientLayer *crxLogoutGradientLayer;

@end

@implementation CAREXQSettingController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.crxLogoutGradientLayer.frame = self.crxLogoutButton.bounds;
    self.crxLogoutGradientLayer.cornerRadius = CGRectGetHeight(self.crxLogoutButton.bounds) * 0.5;
}

- (void)crx_buildViews {
    UIImageView *crxBackgroundView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_access_bg"]];
    crxBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    crxBackgroundView.clipsToBounds = YES;
    [self.view addSubview:crxBackgroundView];
    crxBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxBackgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxBackgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxBackgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxBackgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    UIView *crxOverlayView = [[UIView alloc] init];
    crxOverlayView.backgroundColor = [UIColor colorWithRed:0x14/255.0 green:0x04/255.0 blue:0x28/255.0 alpha:0.36];
    [self.view addSubview:crxOverlayView];
    crxOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxOverlayView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxOverlayView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxOverlayView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxOverlayView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    UIButton *crxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxBackButton setImage:[CAREXQImage imageNamed:@"crx_harbor_back"] forState:UIControlStateNormal];
    crxBackButton.backgroundColor = [UIColor colorWithRed:0x2B/255.0 green:0x0B/255.0 blue:0x47/255.0 alpha:0.92];
    crxBackButton.layer.cornerRadius = 18.f;
    [crxBackButton addTarget:self action:@selector(crxBackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crxBackButton];
    crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [crxBackButton.widthAnchor constraintEqualToConstant:36],
        [crxBackButton.heightAnchor constraintEqualToConstant:36]
    ]];
    
    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.text = @"Setting";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont italicSystemFontOfSize:18];
    [self.view addSubview:crxTitleLabel];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxTitleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [crxTitleLabel.centerYAnchor constraintEqualToAnchor:crxBackButton.centerYAnchor]
    ]];
    
    self.crxScrollView = [[UIScrollView alloc] init];
    self.crxScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.crxScrollView];
    self.crxScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxScrollView.topAnchor constraintEqualToAnchor:crxBackButton.bottomAnchor constant:28],
        [self.crxScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxScrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    self.crxContentView = [[UIView alloc] init];
    [self.crxScrollView addSubview:self.crxContentView];
    self.crxContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxContentView.topAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.topAnchor],
        [self.crxContentView.leadingAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.leadingAnchor],
        [self.crxContentView.trailingAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.trailingAnchor],
        [self.crxContentView.bottomAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.bottomAnchor],
        [self.crxContentView.widthAnchor constraintEqualToAnchor:self.crxScrollView.frameLayoutGuide.widthAnchor]
    ]];
    
    UIView *crxMenuCardView = [self crx_buildCardContainer];
    [self.crxContentView addSubview:crxMenuCardView];
    crxMenuCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIStackView *crxMenuStackView = [[UIStackView alloc] init];
    crxMenuStackView.axis = UILayoutConstraintAxisVertical;
    crxMenuStackView.spacing = 12.f;
    crxMenuStackView.distribution = UIStackViewDistributionFillEqually;
    [crxMenuCardView addSubview:crxMenuStackView];
    crxMenuStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxMenuStackView.topAnchor constraintEqualToAnchor:crxMenuCardView.topAnchor constant:12],
        [crxMenuStackView.leadingAnchor constraintEqualToAnchor:crxMenuCardView.leadingAnchor constant:14],
        [crxMenuStackView.trailingAnchor constraintEqualToAnchor:crxMenuCardView.trailingAnchor constant:-14],
        [crxMenuStackView.bottomAnchor constraintEqualToAnchor:crxMenuCardView.bottomAnchor constant:-12]
    ]];
    
    [crxMenuStackView addArrangedSubview:[self crx_buildMenuRowWithTitle:@"Privacy" action:@selector(crxPrivacyTapped)]];
    [crxMenuStackView addArrangedSubview:[self crx_buildMenuRowWithTitle:@"Match Preferences" action:@selector(crxPreferenceTapped)]];
    [crxMenuStackView addArrangedSubview:[self crx_buildMenuRowWithTitle:@"Privacy & User Agreement" action:@selector(crxAgreementCenterTapped)]];
    [crxMenuStackView addArrangedSubview:[self crx_buildMenuRowWithTitle:@"Clear the cache" action:@selector(crxClearCacheTapped)]];
    [crxMenuStackView addArrangedSubview:[self crx_buildMenuRowWithTitle:@"About us" action:@selector(crxAboutTapped)]];
    
    UIView *crxDeleteCardView = [self crx_buildCardContainer];
    [self.crxContentView addSubview:crxDeleteCardView];
    crxDeleteCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *crxDeleteButton = [self crx_buildMenuRowWithTitle:@"Delete Account" action:@selector(crxDeleteAccountTapped)];
    UILabel *crxDeleteTitleLabel = [crxDeleteButton viewWithTag:9001];
    crxDeleteTitleLabel.textColor = [UIColor colorWithRed:1 green:0.15 blue:0.55 alpha:1];
    [crxDeleteCardView addSubview:crxDeleteButton];
    crxDeleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxDeleteButton.topAnchor constraintEqualToAnchor:crxDeleteCardView.topAnchor constant:10],
        [crxDeleteButton.leadingAnchor constraintEqualToAnchor:crxDeleteCardView.leadingAnchor constant:12],
        [crxDeleteButton.trailingAnchor constraintEqualToAnchor:crxDeleteCardView.trailingAnchor constant:-12],
        [crxDeleteButton.bottomAnchor constraintEqualToAnchor:crxDeleteCardView.bottomAnchor constant:-10]
    ]];
    
    self.crxLogoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxLogoutButton setTitle:@"Log out" forState:UIControlStateNormal];
    [self.crxLogoutButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxLogoutButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    self.crxLogoutButton.layer.cornerRadius = 24.f;
    self.crxLogoutButton.layer.masksToBounds = YES;
    [self.crxLogoutButton addTarget:self action:@selector(crxLogoutTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.crxContentView addSubview:self.crxLogoutButton];
    self.crxLogoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxLogoutGradientLayer = [CAGradientLayer layer];
    self.crxLogoutGradientLayer.startPoint = CGPointMake(0, 0.5);
    self.crxLogoutGradientLayer.endPoint = CGPointMake(1, 0.5);
    self.crxLogoutGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
    ];
    [self.crxLogoutButton.layer insertSublayer:self.crxLogoutGradientLayer atIndex:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [crxMenuCardView.topAnchor constraintEqualToAnchor:self.crxContentView.topAnchor constant:2],
        [crxMenuCardView.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor constant:16],
        [crxMenuCardView.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor constant:-16],
        
        [crxDeleteCardView.topAnchor constraintEqualToAnchor:crxMenuCardView.bottomAnchor constant:16],
        [crxDeleteCardView.leadingAnchor constraintEqualToAnchor:crxMenuCardView.leadingAnchor],
        [crxDeleteCardView.trailingAnchor constraintEqualToAnchor:crxMenuCardView.trailingAnchor],
        
        [self.crxLogoutButton.topAnchor constraintEqualToAnchor:crxDeleteCardView.bottomAnchor constant:180],
        [self.crxLogoutButton.leadingAnchor constraintEqualToAnchor:crxMenuCardView.leadingAnchor],
        [self.crxLogoutButton.trailingAnchor constraintEqualToAnchor:crxMenuCardView.trailingAnchor],
        [self.crxLogoutButton.heightAnchor constraintEqualToConstant:52],
        [self.crxLogoutButton.bottomAnchor constraintEqualToAnchor:self.crxContentView.bottomAnchor constant:-24]
    ]];
}

- (UIView *)crx_buildCardContainer {
    UIView *crxCardView = [[UIView alloc] init];
    crxCardView.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x0D/255.0 blue:0x3C/255.0 alpha:0.86];
    crxCardView.layer.cornerRadius = 18.f;
    crxCardView.layer.borderWidth = 1.f;
    crxCardView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    return crxCardView;
}

- (UIButton *)crx_buildMenuRowWithTitle:(NSString *)crxTitle action:(SEL)crxAction {
    UIButton *crxRowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxRowButton.backgroundColor = UIColor.clearColor;
    crxRowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    [crxRowButton addTarget:self action:crxAction forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.tag = 9001;
    crxTitleLabel.text = crxTitle;
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [crxRowButton addSubview:crxTitleLabel];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *crxArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxArrowButton.userInteractionEnabled = NO;
    crxArrowButton.layer.cornerRadius = 12.f;
    crxArrowButton.layer.masksToBounds = YES;
    [crxArrowButton setTitle:@"›" forState:UIControlStateNormal];
    [crxArrowButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    crxArrowButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    [crxRowButton addSubview:crxArrowButton];
    crxArrowButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    CAGradientLayer *crxArrowGradientLayer = [CAGradientLayer layer];
    crxArrowGradientLayer.startPoint = CGPointMake(0, 0.5);
    crxArrowGradientLayer.endPoint = CGPointMake(1, 0.5);
    crxArrowGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
    ];
    crxArrowGradientLayer.cornerRadius = 12.f;
    crxArrowGradientLayer.frame = CGRectMake(0, 0, 24, 24);
    [crxArrowButton.layer insertSublayer:crxArrowGradientLayer atIndex:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [crxTitleLabel.leadingAnchor constraintEqualToAnchor:crxRowButton.leadingAnchor],
        [crxTitleLabel.centerYAnchor constraintEqualToAnchor:crxRowButton.centerYAnchor],
        
        [crxArrowButton.trailingAnchor constraintEqualToAnchor:crxRowButton.trailingAnchor],
        [crxArrowButton.centerYAnchor constraintEqualToAnchor:crxRowButton.centerYAnchor],
        [crxArrowButton.widthAnchor constraintEqualToConstant:24],
        [crxArrowButton.heightAnchor constraintEqualToConstant:24],
        
        [crxRowButton.heightAnchor constraintEqualToConstant:40]
    ]];
    
    return crxRowButton;
}

- (void)crxBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)crxPrivacyTapped {
    CMRPrivacyController *crxPrivacyController = [[CMRPrivacyController alloc] init];
    [self.navigationController pushViewController:crxPrivacyController animated:YES];
}

- (void)crxPreferenceTapped {
    [self crx_showAlertWithTitle:@"Match Preferences" message:@"Preference options will be available here soon."];
}

- (void)crxAgreementCenterTapped {
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:@"Agreement Center"
                                                                                message:@"Choose the document you want to review."
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *crxUserAgreementAction = [UIAlertAction actionWithTitle:@"User Agreement"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(__unused UIAlertAction * _Nonnull action) {
        CMRAgreementController *crxAgreementController = [[CMRAgreementController alloc] init];
        [self.navigationController pushViewController:crxAgreementController animated:YES];
    }];
    UIAlertAction *crxPrivacyAction = [UIAlertAction actionWithTitle:@"Privacy Agreement"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(__unused UIAlertAction * _Nonnull action) {
        CMRPrivacyController *crxPrivacyController = [[CMRPrivacyController alloc] init];
        [self.navigationController pushViewController:crxPrivacyController animated:YES];
    }];
    UIAlertAction *crxCancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [crxAlertController addAction:crxUserAgreementAction];
    [crxAlertController addAction:crxPrivacyAction];
    [crxAlertController addAction:crxCancelAction];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

- (void)crxClearCacheTapped {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self crx_showAlertWithTitle:@"Clear the cache" message:@"Cached data has been cleared."];
}

- (void)crxAboutTapped {
    CAREXQAboutController *crxAboutController = [[CAREXQAboutController alloc] init];
    [self.navigationController pushViewController:crxAboutController animated:YES];
}

- (void)crxDeleteAccountTapped {
    [self crx_showAlertWithTitle:@"Delete Account" message:@"Account removal flow has not been connected yet."];
}

- (void)crxLogoutTapped {
    [NSUserDefaults.standardUserDefaults setBool:NO forKey:CAREXQSettingLoginStateKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:CAREXQSettingNicknameKey];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)crx_showAlertWithTitle:(NSString *)crxTitle message:(NSString *)crxMessage {
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:crxTitle
                                                                                message:crxMessage
                                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *crxConfirmAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
    [crxAlertController addAction:crxConfirmAction];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

@end
