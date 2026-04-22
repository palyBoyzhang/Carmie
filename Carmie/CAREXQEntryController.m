//
//  CAREXQEntryController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQEntryController.h"
#import "CAREXQImage.h"
#import "CMRAgreementController.h"
#import "CMRPrivacyController.h"

static NSString * const CAREXQEntryLoginStateKey = @"CAREXQEntryLoginStateKey";
static NSString * const CAREXQEntryNicknameKey = @"CAREXQIdentityNicknameKey";
static NSString * const CAREXQEntryEmailKey = @"CAREXQEntryEmailKey";

@interface CAREXQEntryController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *crxHeaderView;
@property (nonatomic, strong) UIButton *crxBackButton;
@property (nonatomic, strong) UIView *crxPanelView;
@property (nonatomic, strong) UIImageView *crxHeaderImageView;
@property (nonatomic, strong) UITextField *crxEmailField;
@property (nonatomic, strong) UITextField *crxPasswordField;
@property (nonatomic, strong) UIButton *crxLoginButton;
@property (nonatomic, strong) UIButton *crxAgreementButton;
@property (nonatomic, strong) UITextView *crxAgreementTextView;
@property (nonatomic, assign) BOOL crxAgreementAccepted;
@property (nonatomic, strong) CAGradientLayer *crxHeaderGradientLayer;
@property (nonatomic, strong) CAGradientLayer *crxLoginGradientLayer;
@property (nonatomic, strong) CAGradientLayer *crxPanelGradientLayer;

@end

@implementation CAREXQEntryController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x05/255.0 green:0x06/255.0 blue:0x1A/255.0 alpha:1];
    [self crx_setupEntryViews];
    [self crx_updateLoginButtonState];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.crxHeaderGradientLayer.frame = self.crxHeaderView.bounds;
    self.crxPanelGradientLayer.frame = self.crxPanelView.bounds;
    self.crxLoginGradientLayer.frame = self.crxLoginButton.bounds;
    self.crxLoginGradientLayer.cornerRadius = CGRectGetHeight(self.crxLoginButton.bounds) * 0.5;
}

- (void)crx_setupEntryViews {
    UITapGestureRecognizer *crxTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crxDismissKeyboard)];
    [self.view addGestureRecognizer:crxTapGesture];
    
    self.crxHeaderImageView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_entry_bg"]];
    self.crxHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxHeaderImageView.backgroundColor = self.crxHeaderView.backgroundColor;
    [self.view addSubview:self.crxHeaderImageView];
    self.crxHeaderImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxHeaderImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.crxHeaderImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxHeaderImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxHeaderImageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.crxHeaderView = [[UIView alloc] init];
    self.crxHeaderView.backgroundColor = [UIColor clearColor];
    self.crxHeaderView.clipsToBounds = YES;
    [self.view addSubview:self.crxHeaderView];
    self.crxHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxHeaderView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.crxHeaderView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxHeaderView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxHeaderView.heightAnchor constraintEqualToConstant:308]
    ]];
    
    self.crxHeaderGradientLayer = [CAGradientLayer layer];
    self.crxHeaderGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0x1E/255.0 green:0x0D/255.0 blue:0x2B/255.0 alpha:0.26].CGColor,
        (__bridge id)[UIColor colorWithRed:0x37/255.0 green:0x16/255.0 blue:0x48/255.0 alpha:0.18].CGColor,
        (__bridge id)[UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x1D/255.0 alpha:0.05].CGColor
    ];
    self.crxHeaderGradientLayer.startPoint = CGPointMake(0, 0);
    self.crxHeaderGradientLayer.endPoint = CGPointMake(0.9, 1);
    
    UIView *crxHeaderMaskView = [[UIView alloc] init];
    crxHeaderMaskView.backgroundColor = [UIColor colorWithRed:0x05/255.0 green:0x06/255.0 blue:0x1A/255.0 alpha:0.12];
    [self.crxHeaderView addSubview:crxHeaderMaskView];
    crxHeaderMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxHeaderMaskView.topAnchor constraintEqualToAnchor:self.crxHeaderView.topAnchor],
        [crxHeaderMaskView.leadingAnchor constraintEqualToAnchor:self.crxHeaderView.leadingAnchor],
        [crxHeaderMaskView.trailingAnchor constraintEqualToAnchor:self.crxHeaderView.trailingAnchor],
        [crxHeaderMaskView.bottomAnchor constraintEqualToAnchor:self.crxHeaderView.bottomAnchor]
    ]];
    
    self.crxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxBackButton setImage:[CAREXQImage imageNamed:@"crx_harbor_back@3x"] forState:UIControlStateNormal];
    self.crxBackButton.backgroundColor = [UIColor colorWithRed:0x2B/255.0 green:0x0B/255.0 blue:0x47/255.0 alpha:0.92];
    self.crxBackButton.layer.cornerRadius = 18.f;
    [self.crxBackButton addTarget:self action:@selector(crxBackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.crxHeaderView addSubview:self.crxBackButton];
    self.crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [self.crxBackButton.widthAnchor constraintEqualToConstant:36],
        [self.crxBackButton.heightAnchor constraintEqualToConstant:36]
    ]];
    
    self.crxPanelView = [[UIView alloc] init];
    self.crxPanelView.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x07/255.0 blue:0x23/255.0 alpha:0.98];
    self.crxPanelView.layer.cornerRadius = 26.f;
    self.crxPanelView.layer.masksToBounds = YES;
    [self.view addSubview:self.crxPanelView];
    self.crxPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxPanelView.topAnchor constraintEqualToAnchor:self.crxHeaderView.bottomAnchor constant:-34],
        [self.crxPanelView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxPanelView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxPanelView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.crxPanelGradientLayer = [CAGradientLayer layer];
    self.crxPanelGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0x1B/255.0 green:0x08/255.0 blue:0x37/255.0 alpha:0.82].CGColor,
        (__bridge id)[UIColor colorWithRed:0x0A/255.0 green:0x0A/255.0 blue:0x29/255.0 alpha:0.98].CGColor,
        (__bridge id)[UIColor colorWithRed:0x05/255.0 green:0x0B/255.0 blue:0x21/255.0 alpha:1].CGColor
    ];
    self.crxPanelGradientLayer.startPoint = CGPointMake(0.5, 0);
    self.crxPanelGradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.crxPanelView.layer insertSublayer:self.crxPanelGradientLayer atIndex:0];
    
    UILabel *crxWelcomeLabel = [[UILabel alloc] init];
    crxWelcomeLabel.text = @"Welcome login";
    crxWelcomeLabel.textColor = UIColor.whiteColor;
    crxWelcomeLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBlack];
    [self.crxPanelView addSubview:crxWelcomeLabel];
    crxWelcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxWelcomeLabel.topAnchor constraintEqualToAnchor:self.crxPanelView.topAnchor constant:34],
        [crxWelcomeLabel.centerXAnchor constraintEqualToAnchor:self.crxPanelView.centerXAnchor]
    ]];
    
    UILabel *crxEmailLabel = [self crx_buildSectionLabelWithTitle:@"Email"];
    [self.crxPanelView addSubview:crxEmailLabel];
    crxEmailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxEmailLabel.topAnchor constraintEqualToAnchor:crxWelcomeLabel.bottomAnchor constant:36],
        [crxEmailLabel.leadingAnchor constraintEqualToAnchor:self.crxPanelView.leadingAnchor constant:16]
    ]];
    
    UIView *crxEmailContainer = [self crx_buildInputContainer];
    [self.crxPanelView addSubview:crxEmailContainer];
    crxEmailContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxEmailContainer.topAnchor constraintEqualToAnchor:crxEmailLabel.bottomAnchor constant:12],
        [crxEmailContainer.leadingAnchor constraintEqualToAnchor:self.crxPanelView.leadingAnchor constant:16],
        [crxEmailContainer.trailingAnchor constraintEqualToAnchor:self.crxPanelView.trailingAnchor constant:-16],
        [crxEmailContainer.heightAnchor constraintEqualToConstant:48]
    ]];
    
    self.crxEmailField = [self crx_buildTextFieldWithPlaceholder:@"Please enter your email address."];
    self.crxEmailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.crxEmailField.textContentType = UITextContentTypeUsername;
    self.crxEmailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.crxEmailField.returnKeyType = UIReturnKeyNext;
    [self.crxEmailField addTarget:self action:@selector(crxTextDidChange) forControlEvents:UIControlEventEditingChanged];
    [crxEmailContainer addSubview:self.crxEmailField];
    self.crxEmailField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxEmailField.leadingAnchor constraintEqualToAnchor:crxEmailContainer.leadingAnchor constant:18],
        [self.crxEmailField.trailingAnchor constraintEqualToAnchor:crxEmailContainer.trailingAnchor constant:-18],
        [self.crxEmailField.topAnchor constraintEqualToAnchor:crxEmailContainer.topAnchor],
        [self.crxEmailField.bottomAnchor constraintEqualToAnchor:crxEmailContainer.bottomAnchor]
    ]];
    
    UILabel *crxPasswordLabel = [self crx_buildSectionLabelWithTitle:@"Password"];
    [self.crxPanelView addSubview:crxPasswordLabel];
    crxPasswordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxPasswordLabel.topAnchor constraintEqualToAnchor:crxEmailContainer.bottomAnchor constant:26],
        [crxPasswordLabel.leadingAnchor constraintEqualToAnchor:self.crxPanelView.leadingAnchor constant:16]
    ]];
    
    UIView *crxPasswordContainer = [self crx_buildInputContainer];
    [self.crxPanelView addSubview:crxPasswordContainer];
    crxPasswordContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxPasswordContainer.topAnchor constraintEqualToAnchor:crxPasswordLabel.bottomAnchor constant:12],
        [crxPasswordContainer.leadingAnchor constraintEqualToAnchor:self.crxPanelView.leadingAnchor constant:16],
        [crxPasswordContainer.trailingAnchor constraintEqualToAnchor:self.crxPanelView.trailingAnchor constant:-16],
        [crxPasswordContainer.heightAnchor constraintEqualToConstant:48]
    ]];
    
    self.crxPasswordField = [self crx_buildTextFieldWithPlaceholder:@"Please enter your password."];
    self.crxPasswordField.secureTextEntry = YES;
    self.crxPasswordField.textContentType = UITextContentTypePassword;
    self.crxPasswordField.returnKeyType = UIReturnKeyDone;
    [self.crxPasswordField addTarget:self action:@selector(crxTextDidChange) forControlEvents:UIControlEventEditingChanged];
    [crxPasswordContainer addSubview:self.crxPasswordField];
    self.crxPasswordField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxPasswordField.leadingAnchor constraintEqualToAnchor:crxPasswordContainer.leadingAnchor constant:18],
        [self.crxPasswordField.trailingAnchor constraintEqualToAnchor:crxPasswordContainer.trailingAnchor constant:-18],
        [self.crxPasswordField.topAnchor constraintEqualToAnchor:crxPasswordContainer.topAnchor],
        [self.crxPasswordField.bottomAnchor constraintEqualToAnchor:crxPasswordContainer.bottomAnchor]
    ]];
    
    self.crxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxLoginButton setTitle:@"Log in" forState:UIControlStateNormal];
    [self.crxLoginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.crxLoginButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.62] forState:UIControlStateDisabled];
    self.crxLoginButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    self.crxLoginButton.layer.cornerRadius = 24.f;
    self.crxLoginButton.clipsToBounds = YES;
    [self.crxLoginButton addTarget:self action:@selector(crxLoginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.crxPanelView addSubview:self.crxLoginButton];
    self.crxLoginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxLoginButton.topAnchor constraintEqualToAnchor:crxPasswordContainer.bottomAnchor constant:54],
        [self.crxLoginButton.leadingAnchor constraintEqualToAnchor:self.crxPanelView.leadingAnchor constant:16],
        [self.crxLoginButton.trailingAnchor constraintEqualToAnchor:self.crxPanelView.trailingAnchor constant:-16],
        [self.crxLoginButton.heightAnchor constraintEqualToConstant:52]
    ]];
    
    self.crxLoginGradientLayer = [CAGradientLayer layer];
    self.crxLoginGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0xFF/255.0 green:0xB4/255.0 blue:0x4D/255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0xFF/255.0 green:0x5C/255.0 blue:0x9E/255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x89/255.0 green:0x42/255.0 blue:0xFF/255.0 alpha:1].CGColor
    ];
    self.crxLoginGradientLayer.startPoint = CGPointMake(0, 0.5);
    self.crxLoginGradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.crxLoginButton.layer insertSublayer:self.crxLoginGradientLayer atIndex:0];
    
    UIView *crxAgreementRowView = [[UIView alloc] init];
    [self.crxPanelView addSubview:crxAgreementRowView];
    crxAgreementRowView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxAgreementRowView.topAnchor constraintEqualToAnchor:self.crxLoginButton.bottomAnchor constant:24],
        [crxAgreementRowView.centerXAnchor constraintEqualToAnchor:self.crxPanelView.centerXAnchor],
        [crxAgreementRowView.widthAnchor constraintEqualToConstant:286],
        [crxAgreementRowView.heightAnchor constraintEqualToConstant:44]
    ]];
    
    self.crxAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxAgreementButton setImage:[CAREXQImage imageNamed:@"crx_entry_nor"] forState:UIControlStateNormal];
    [self.crxAgreementButton addTarget:self action:@selector(crxAgreementButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [crxAgreementRowView addSubview:self.crxAgreementButton];
    self.crxAgreementButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxAgreementButton.leadingAnchor constraintEqualToAnchor:crxAgreementRowView.leadingAnchor],
        [self.crxAgreementButton.centerYAnchor constraintEqualToAnchor:crxAgreementRowView.centerYAnchor constant:-6],
        [self.crxAgreementButton.widthAnchor constraintEqualToConstant:18],
        [self.crxAgreementButton.heightAnchor constraintEqualToConstant:18]
    ]];
    
    self.crxAgreementTextView = [[UITextView alloc] init];
    self.crxAgreementTextView.backgroundColor = UIColor.clearColor;
    self.crxAgreementTextView.scrollEnabled = NO;
    self.crxAgreementTextView.editable = NO;
    self.crxAgreementTextView.selectable = YES;
    self.crxAgreementTextView.delegate = self;
    self.crxAgreementTextView.textAlignment = NSTextAlignmentCenter;
    self.crxAgreementTextView.textContainerInset = UIEdgeInsetsZero;
    self.crxAgreementTextView.textContainer.lineFragmentPadding = 0;
    self.crxAgreementTextView.linkTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0x2C/255.0 blue:0xAD/255.0 alpha:1],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
    };
    self.crxAgreementTextView.attributedText = [self crx_buildAgreementAttributedText];
    [crxAgreementRowView addSubview:self.crxAgreementTextView];
    self.crxAgreementTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxAgreementTextView.leadingAnchor constraintEqualToAnchor:self.crxAgreementButton.trailingAnchor constant:8],
        [self.crxAgreementTextView.trailingAnchor constraintEqualToAnchor:crxAgreementRowView.trailingAnchor],
        [self.crxAgreementTextView.topAnchor constraintEqualToAnchor:crxAgreementRowView.topAnchor],
        [self.crxAgreementTextView.bottomAnchor constraintEqualToAnchor:crxAgreementRowView.bottomAnchor]
    ]];
    
    self.crxEmailField.delegate = self;
    self.crxPasswordField.delegate = self;
}

- (UILabel *)crx_buildSectionLabelWithTitle:(NSString *)crxTitle {
    UILabel *crxLabel = [[UILabel alloc] init];
    crxLabel.text = crxTitle;
    crxLabel.textColor = UIColor.whiteColor;
    crxLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    return crxLabel;
}

- (UIView *)crx_buildInputContainer {
    UIView *crxView = [[UIView alloc] init];
    crxView.backgroundColor = [UIColor colorWithRed:0x33/255.0 green:0x02/255.0 blue:0x41/255.0 alpha:0.92];
    crxView.layer.cornerRadius = 16.f;
    crxView.layer.borderWidth = 1.f;
    crxView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.28].CGColor;
    return crxView;
}

- (UITextField *)crx_buildTextFieldWithPlaceholder:(NSString *)crxPlaceholder {
    UITextField *crxTextField = [[UITextField alloc] init];
    crxTextField.textColor = UIColor.whiteColor;
    crxTextField.tintColor = [UIColor colorWithRed:1 green:0x5A/255.0 blue:0xAB/255.0 alpha:1];
    crxTextField.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    crxTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:crxPlaceholder
                                                                          attributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.46],
        NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightRegular]
    }];
    crxTextField.textAlignment = NSTextAlignmentCenter;
    return crxTextField;
}

- (NSAttributedString *)crx_buildAgreementAttributedText {
    NSMutableParagraphStyle *crxParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    crxParagraphStyle.lineSpacing = 1.f;
    crxParagraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *crxNormalAttributes = @{
        NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.76],
        NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightRegular],
        NSParagraphStyleAttributeName: crxParagraphStyle
    };
    NSDictionary *crxLinkAttributes = @{
        NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0x2C/255.0 blue:0xAD/255.0 alpha:1],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightRegular],
        NSParagraphStyleAttributeName: crxParagraphStyle
    };
    
    NSMutableAttributedString *crxAttributedText = [[NSMutableAttributedString alloc] initWithString:@"Agree to the " attributes:crxNormalAttributes];
    NSAttributedString *crxAgreementText = [[NSAttributedString alloc] initWithString:@"User Agreement" attributes:crxLinkAttributes];
    [crxAttributedText appendAttributedString:crxAgreementText];
    [crxAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" and " attributes:crxNormalAttributes]];
    NSAttributedString *crxPrivacyText = [[NSAttributedString alloc] initWithString:@"Privacy Agreement" attributes:crxLinkAttributes];
    [crxAttributedText appendAttributedString:crxPrivacyText];
    
    [crxAttributedText addAttribute:NSLinkAttributeName value:@"crx://agreement" range:[[crxAttributedText string] rangeOfString:@"User Agreement"]];
    [crxAttributedText addAttribute:NSLinkAttributeName value:@"crx://privacy" range:[[crxAttributedText string] rangeOfString:@"Privacy Agreement"]];
    
    return crxAttributedText;
}

- (void)crxBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)crxAgreementButtonTapped {
    self.crxAgreementAccepted = !self.crxAgreementAccepted;
    NSString *crxImageName = self.crxAgreementAccepted ? @"crx_entry_sel" : @"crx_entry_nor";
    [self.crxAgreementButton setImage:[CAREXQImage imageNamed:crxImageName] forState:UIControlStateNormal];
    [self crx_updateLoginButtonState];
}

- (void)crxAgreementLinkTapped {
    CMRAgreementController *crxAgreementController = [[CMRAgreementController alloc] init];
    [self.navigationController pushViewController:crxAgreementController animated:YES];
}

- (void)crxPrivacyLinkTapped {
    CMRPrivacyController *crxPrivacyController = [[CMRPrivacyController alloc] init];
    [self.navigationController pushViewController:crxPrivacyController animated:YES];
}

- (void)crxTextDidChange {
    [self crx_updateLoginButtonState];
}

- (void)crxUpdateLoginTextAlpha:(CGFloat)crxAlpha {
    self.crxLoginButton.alpha = crxAlpha;
    self.crxLoginGradientLayer.opacity = crxAlpha;
}

- (void)crx_updateLoginButtonState {
    BOOL crxHasEmail = self.crxEmailField.text.length > 0;
    BOOL crxHasPassword = self.crxPasswordField.text.length > 0;
    BOOL crxEnabled = crxHasEmail && crxHasPassword && self.crxAgreementAccepted;
    self.crxLoginButton.enabled = crxEnabled;
    [self crxUpdateLoginTextAlpha:(crxEnabled ? 1.0 : 0.55)];
}

- (void)crxLoginButtonTapped {
    [self crxDismissKeyboard];
    
    NSString *crxEmail = [self.crxEmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *crxPassword = self.crxPasswordField.text ?: @"";
    
    if (crxEmail.length == 0 || crxPassword.length == 0) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Please complete email and password first."];
        return;
    }
    
    if (!self.crxAgreementAccepted) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Please agree to the user agreement and privacy agreement."];
        return;
    }

    [self crx_storeLoginStateWithEmail:crxEmail];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)crx_storeLoginStateWithEmail:(NSString *)crxEmail {
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:CAREXQEntryLoginStateKey];
    [NSUserDefaults.standardUserDefaults setObject:crxEmail forKey:CAREXQEntryNicknameKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (BOOL)crx_isValidEmail:(NSString *)crxEmail {
    NSString *crxPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *crxPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", crxPattern];
    return [crxPredicate evaluateWithObject:crxEmail];
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

- (void)crxDismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.crxEmailField) {
        [self.crxPasswordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self crxLoginButtonTapped];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL absoluteString] isEqualToString:@"crx://agreement"]) {
        [self crxAgreementLinkTapped];
        return NO;
    }
    
    if ([[URL absoluteString] isEqualToString:@"crx://privacy"]) {
        [self crxPrivacyLinkTapped];
        return NO;
    }
    
    return YES;
}

@end
