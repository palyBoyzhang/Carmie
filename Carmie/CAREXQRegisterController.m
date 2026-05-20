//
//  CAREXQRegisterController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/5/11.
//

#import "CAREXQRegisterController.h"

#import "CAREXQImage.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

static NSString * const CAREXQRegisterLoginStateKey = @"CAREXQEntryLoginStateKey";
static NSString * const CAREXQRegisterNicknameKey = @"CAREXQIdentityNicknameKey";
static NSString * const CAREXQRegisterEmailKey = @"CAREXQEntryEmailKey";
static NSString * const CAREXQRegisterProfileKey = @"CAREXQIdentityProfileKey";
static NSString * const CAREXQRegisterAvatarDataKey = @"CAREXQIdentityAvatarDataKey";
static NSString * const CAREXQRegisterGenderKey = @"CAREXQRegisterGenderKey";
static NSString * const CAREXQRegisterBirthdayKey = @"CAREXQRegisterBirthdayKey";
static NSString * const CAREXQRegisterAddressKey = @"CAREXQRegisterAddressKey";

@interface CAREXQRegisterController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIButton *crxBackButton;
@property (nonatomic, strong) UIScrollView *crxScrollView;
@property (nonatomic, strong) UIView *crxContentView;

@property (nonatomic, strong) UIView *crxStepOneView;
@property (nonatomic, strong) UIButton *crxAvatarButton;
@property (nonatomic, strong) UIImageView *crxAvatarImageView;
@property (nonatomic, strong) UITextField *crxNameField;
@property (nonatomic, strong) UITextField *crxEmailField;
@property (nonatomic, strong) UITextField *crxPasswordField;
@property (nonatomic, strong) UIButton *crxNextButton;
@property (nonatomic, strong) CAGradientLayer *crxNextGradientLayer;

@property (nonatomic, strong) UIView *crxStepTwoView;
@property (nonatomic, strong) UILabel *crxGenderValueLabel;
@property (nonatomic, strong) UILabel *crxBirthdayValueLabel;
@property (nonatomic, strong) UILabel *crxAddressValueLabel;
@property (nonatomic, strong) UITextView *crxProfileTextView;
@property (nonatomic, strong) UILabel *crxProfilePlaceholderLabel;
@property (nonatomic, strong) UIButton *crxEnterButton;
@property (nonatomic, strong) CAGradientLayer *crxEnterGradientLayer;

@property (nonatomic, copy) NSString *crxSelectedGender;
@property (nonatomic, copy) NSString *crxSelectedBirthday;
@property (nonatomic, copy) NSString *crxSelectedAddress;
@property (nonatomic, assign) BOOL crxShowingSecondStep;

@end

@implementation CAREXQRegisterController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1.0];
    self.crxSelectedGender = @"Female";
    self.crxSelectedBirthday = @"2001-07-19";
    self.crxSelectedAddress = @"Los Angeles, CA, USA";
    UITapGestureRecognizer *crxTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crxDismissKeyboard)];
    [self.view addGestureRecognizer:crxTapGesture];
    [self crx_buildViews];
    [self crx_refreshStepTwoValues];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.crxNextGradientLayer.frame = self.crxNextButton.bounds;
    self.crxNextGradientLayer.cornerRadius = CGRectGetHeight(self.crxNextButton.bounds) * 0.5;
    self.crxEnterGradientLayer.frame = self.crxEnterButton.bounds;
    self.crxEnterGradientLayer.cornerRadius = CGRectGetHeight(self.crxEnterButton.bounds) * 0.5;
}

- (void)crx_buildViews {
    UIView *crxOverlayView = [[UIView alloc] init];
    crxOverlayView.backgroundColor = [UIColor colorWithRed:0x14/255.0 green:0x04/255.0 blue:0x28/255.0 alpha:0.30];
    [self.view addSubview:crxOverlayView];
    crxOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxOverlayView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxOverlayView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxOverlayView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxOverlayView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];

    self.crxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxBackButton setImage:[CAREXQImage imageNamed:@"crx_harbor_back"] forState:UIControlStateNormal];
    self.crxBackButton.backgroundColor = [UIColor colorWithRed:0x2B/255.0 green:0x0B/255.0 blue:0x47/255.0 alpha:0.92];
    self.crxBackButton.layer.cornerRadius = 18.0;
    [self.crxBackButton addTarget:self action:@selector(crxBackTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxBackButton];
    self.crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxScrollView = [[UIScrollView alloc] init];
    self.crxScrollView.showsVerticalScrollIndicator = NO;
    self.crxScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.crxScrollView];
    self.crxScrollView.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxContentView = [[UIView alloc] init];
    [self.crxScrollView addSubview:self.crxContentView];
    self.crxContentView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [self.crxBackButton.widthAnchor constraintEqualToConstant:36],
        [self.crxBackButton.heightAnchor constraintEqualToConstant:36],

        [self.crxScrollView.topAnchor constraintEqualToAnchor:self.crxBackButton.bottomAnchor constant:18],
        [self.crxScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxScrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.crxContentView.topAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.topAnchor],
        [self.crxContentView.leadingAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.leadingAnchor],
        [self.crxContentView.trailingAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.trailingAnchor],
        [self.crxContentView.bottomAnchor constraintEqualToAnchor:self.crxScrollView.contentLayoutGuide.bottomAnchor],
        [self.crxContentView.widthAnchor constraintEqualToAnchor:self.crxScrollView.frameLayoutGuide.widthAnchor]
    ]];

    [self crx_buildStepOne];
    [self crx_buildStepTwo];
    [self crx_showSecondStep:NO];
}

- (void)crx_buildStepOne {
    self.crxStepOneView = [[UIView alloc] init];
    [self.crxContentView addSubview:self.crxStepOneView];
    self.crxStepOneView.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxAvatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crxAvatarButton.layer.cornerRadius = 36.0;
    self.crxAvatarButton.layer.borderWidth = 1.0;
    self.crxAvatarButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.28].CGColor;
    self.crxAvatarButton.backgroundColor = [UIColor colorWithRed:0x1A/255.0 green:0x0D/255.0 blue:0x33/255.0 alpha:0.52];
    [self.crxAvatarButton addTarget:self action:@selector(crxAvatarTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.crxStepOneView addSubview:self.crxAvatarButton];
    self.crxAvatarButton.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *crxPlusLabel = [[UILabel alloc] init];
    crxPlusLabel.text = @"+";
    crxPlusLabel.textColor = UIColor.whiteColor;
    crxPlusLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightLight];
    crxPlusLabel.textAlignment = NSTextAlignmentCenter;
    [self.crxAvatarButton addSubview:crxPlusLabel];
    crxPlusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxPlusLabel.centerXAnchor constraintEqualToAnchor:self.crxAvatarButton.centerXAnchor],
        [crxPlusLabel.centerYAnchor constraintEqualToAnchor:self.crxAvatarButton.centerYAnchor constant:-1]
    ]];

    self.crxAvatarImageView = [[UIImageView alloc] init];
    self.crxAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxAvatarImageView.layer.cornerRadius = 36.0;
    self.crxAvatarImageView.clipsToBounds = YES;
    self.crxAvatarImageView.hidden = YES;
    [self.crxAvatarButton addSubview:self.crxAvatarImageView];
    self.crxAvatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxAvatarImageView.topAnchor constraintEqualToAnchor:self.crxAvatarButton.topAnchor],
        [self.crxAvatarImageView.leadingAnchor constraintEqualToAnchor:self.crxAvatarButton.leadingAnchor],
        [self.crxAvatarImageView.trailingAnchor constraintEqualToAnchor:self.crxAvatarButton.trailingAnchor],
        [self.crxAvatarImageView.bottomAnchor constraintEqualToAnchor:self.crxAvatarButton.bottomAnchor]
    ]];

    UILabel *crxNameLabel = [self crx_buildSectionLabel:@"Name"];
    UILabel *crxEmailLabel = [self crx_buildSectionLabel:@"Email"];
    UILabel *crxPasswordLabel = [self crx_buildSectionLabel:@"Password"];
    [self.crxStepOneView addSubview:crxNameLabel];
    [self.crxStepOneView addSubview:crxEmailLabel];
    [self.crxStepOneView addSubview:crxPasswordLabel];
    crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    crxEmailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    crxPasswordLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *crxNameContainer = [self crx_buildInputContainer];
    UIView *crxEmailContainer = [self crx_buildInputContainer];
    UIView *crxPasswordContainer = [self crx_buildInputContainer];
    [self.crxStepOneView addSubview:crxNameContainer];
    [self.crxStepOneView addSubview:crxEmailContainer];
    [self.crxStepOneView addSubview:crxPasswordContainer];
    crxNameContainer.translatesAutoresizingMaskIntoConstraints = NO;
    crxEmailContainer.translatesAutoresizingMaskIntoConstraints = NO;
    crxPasswordContainer.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxNameField = [self crx_buildTextField:@"Please enter your nickname."];
    self.crxNameField.returnKeyType = UIReturnKeyNext;
    self.crxEmailField = [self crx_buildTextField:@"Please enter your email address."];
    self.crxEmailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.crxEmailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.crxEmailField.returnKeyType = UIReturnKeyNext;
    self.crxPasswordField = [self crx_buildTextField:@"Please enter your password."];
    self.crxPasswordField.secureTextEntry = YES;
    self.crxPasswordField.returnKeyType = UIReturnKeyDone;
    [crxNameContainer addSubview:self.crxNameField];
    [crxEmailContainer addSubview:self.crxEmailField];
    [crxPasswordContainer addSubview:self.crxPasswordField];
    self.crxNameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.crxEmailField.translatesAutoresizingMaskIntoConstraints = NO;
    self.crxPasswordField.translatesAutoresizingMaskIntoConstraints = NO;

    [self crx_pinTextField:self.crxNameField toContainer:crxNameContainer];
    [self crx_pinTextField:self.crxEmailField toContainer:crxEmailContainer];
    [self crx_pinTextField:self.crxPasswordField toContainer:crxPasswordContainer];

    self.crxNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxNextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.crxNextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxNextButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    self.crxNextButton.layer.cornerRadius = 24.0;
    self.crxNextButton.clipsToBounds = YES;
    [self.crxNextButton addTarget:self action:@selector(crxNextTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.crxStepOneView addSubview:self.crxNextButton];
    self.crxNextButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.crxNextGradientLayer = [self crx_buildButtonGradient];
    [self.crxNextButton.layer insertSublayer:self.crxNextGradientLayer atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
        [self.crxStepOneView.topAnchor constraintEqualToAnchor:self.crxContentView.topAnchor],
        [self.crxStepOneView.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor],
        [self.crxStepOneView.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor],
        [self.crxStepOneView.bottomAnchor constraintEqualToAnchor:self.crxContentView.bottomAnchor],

        [self.crxAvatarButton.topAnchor constraintEqualToAnchor:self.crxStepOneView.topAnchor constant:28],
        [self.crxAvatarButton.centerXAnchor constraintEqualToAnchor:self.crxStepOneView.centerXAnchor],
        [self.crxAvatarButton.widthAnchor constraintEqualToConstant:72],
        [self.crxAvatarButton.heightAnchor constraintEqualToConstant:72],

        [crxNameLabel.topAnchor constraintEqualToAnchor:self.crxAvatarButton.bottomAnchor constant:34],
        [crxNameLabel.leadingAnchor constraintEqualToAnchor:self.crxStepOneView.leadingAnchor constant:22],
        [crxNameContainer.topAnchor constraintEqualToAnchor:crxNameLabel.bottomAnchor constant:10],
        [crxNameContainer.leadingAnchor constraintEqualToAnchor:self.crxStepOneView.leadingAnchor constant:22],
        [crxNameContainer.trailingAnchor constraintEqualToAnchor:self.crxStepOneView.trailingAnchor constant:-22],
        [crxNameContainer.heightAnchor constraintEqualToConstant:38],

        [crxEmailLabel.topAnchor constraintEqualToAnchor:crxNameContainer.bottomAnchor constant:18],
        [crxEmailLabel.leadingAnchor constraintEqualToAnchor:crxNameLabel.leadingAnchor],
        [crxEmailContainer.topAnchor constraintEqualToAnchor:crxEmailLabel.bottomAnchor constant:10],
        [crxEmailContainer.leadingAnchor constraintEqualToAnchor:crxNameContainer.leadingAnchor],
        [crxEmailContainer.trailingAnchor constraintEqualToAnchor:crxNameContainer.trailingAnchor],
        [crxEmailContainer.heightAnchor constraintEqualToConstant:38],

        [crxPasswordLabel.topAnchor constraintEqualToAnchor:crxEmailContainer.bottomAnchor constant:18],
        [crxPasswordLabel.leadingAnchor constraintEqualToAnchor:crxNameLabel.leadingAnchor],
        [crxPasswordContainer.topAnchor constraintEqualToAnchor:crxPasswordLabel.bottomAnchor constant:10],
        [crxPasswordContainer.leadingAnchor constraintEqualToAnchor:crxNameContainer.leadingAnchor],
        [crxPasswordContainer.trailingAnchor constraintEqualToAnchor:crxNameContainer.trailingAnchor],
        [crxPasswordContainer.heightAnchor constraintEqualToConstant:38],

        [self.crxNextButton.topAnchor constraintEqualToAnchor:crxPasswordContainer.bottomAnchor constant:34],
        [self.crxNextButton.leadingAnchor constraintEqualToAnchor:crxNameContainer.leadingAnchor],
        [self.crxNextButton.trailingAnchor constraintEqualToAnchor:crxNameContainer.trailingAnchor],
        [self.crxNextButton.heightAnchor constraintEqualToConstant:52],
        [self.crxNextButton.bottomAnchor constraintEqualToAnchor:self.crxStepOneView.safeAreaLayoutGuide.bottomAnchor constant:-34]
    ]];
}

- (void)crx_buildStepTwo {
    self.crxStepTwoView = [[UIView alloc] init];
    [self.crxContentView addSubview:self.crxStepTwoView];
    self.crxStepTwoView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.text = @"Complete information";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    [self.crxStepTwoView addSubview:crxTitleLabel];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *crxGenderRow = [self crx_buildInfoRowWithTitle:@"Gender" selector:@selector(crxGenderTapped)];
    UIView *crxBirthdayRow = [self crx_buildInfoRowWithTitle:@"Birthday" selector:@selector(crxBirthdayTapped)];
    UIView *crxAddressRow = [self crx_buildInfoRowWithTitle:@"Address" selector:@selector(crxAddressTapped)];
    [self.crxStepTwoView addSubview:crxGenderRow];
    [self.crxStepTwoView addSubview:crxBirthdayRow];
    [self.crxStepTwoView addSubview:crxAddressRow];
    crxGenderRow.translatesAutoresizingMaskIntoConstraints = NO;
    crxBirthdayRow.translatesAutoresizingMaskIntoConstraints = NO;
    crxAddressRow.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxGenderValueLabel = [self crx_buildRowValueLabel];
    self.crxBirthdayValueLabel = [self crx_buildRowValueLabel];
    self.crxAddressValueLabel = [self crx_buildRowValueLabel];
    [crxGenderRow addSubview:self.crxGenderValueLabel];
    [crxBirthdayRow addSubview:self.crxBirthdayValueLabel];
    [crxAddressRow addSubview:self.crxAddressValueLabel];
    self.crxGenderValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.crxBirthdayValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.crxAddressValueLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self crx_pinRowValue:self.crxGenderValueLabel toRow:crxGenderRow];
    [self crx_pinRowValue:self.crxBirthdayValueLabel toRow:crxBirthdayRow];
    [self crx_pinRowValue:self.crxAddressValueLabel toRow:crxAddressRow];

    UILabel *crxProfileTitleLabel = [[UILabel alloc] init];
    crxProfileTitleLabel.text = @"Personal Profile";
    crxProfileTitleLabel.textColor = UIColor.whiteColor;
    crxProfileTitleLabel.font = [UIFont italicSystemFontOfSize:16];
    [self.crxStepTwoView addSubview:crxProfileTitleLabel];
    crxProfileTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *crxProfileCardView = [self crx_buildInputContainer];
    [self.crxStepTwoView addSubview:crxProfileCardView];
    crxProfileCardView.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxProfileTextView = [[UITextView alloc] init];
    self.crxProfileTextView.backgroundColor = UIColor.clearColor;
    self.crxProfileTextView.textColor = UIColor.whiteColor;
    self.crxProfileTextView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.crxProfileTextView.delegate = self;
    self.crxProfileTextView.textContainerInset = UIEdgeInsetsMake(12, 10, 12, 10);
    [crxProfileCardView addSubview:self.crxProfileTextView];
    self.crxProfileTextView.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxProfilePlaceholderLabel = [[UILabel alloc] init];
    self.crxProfilePlaceholderLabel.text = @"Please enter your personal profile....";
    self.crxProfilePlaceholderLabel.textColor = [UIColor colorWithWhite:1 alpha:0.42];
    self.crxProfilePlaceholderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [crxProfileCardView addSubview:self.crxProfilePlaceholderLabel];
    self.crxProfilePlaceholderLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxEnterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxEnterButton setTitle:@"Enter" forState:UIControlStateNormal];
    [self.crxEnterButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxEnterButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    self.crxEnterButton.layer.cornerRadius = 24.0;
    self.crxEnterButton.clipsToBounds = YES;
    [self.crxEnterButton addTarget:self action:@selector(crxEnterTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.crxStepTwoView addSubview:self.crxEnterButton];
    self.crxEnterButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.crxEnterGradientLayer = [self crx_buildButtonGradient];
    [self.crxEnterButton.layer insertSublayer:self.crxEnterGradientLayer atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
        [self.crxStepTwoView.topAnchor constraintEqualToAnchor:self.crxContentView.topAnchor],
        [self.crxStepTwoView.leadingAnchor constraintEqualToAnchor:self.crxContentView.leadingAnchor],
        [self.crxStepTwoView.trailingAnchor constraintEqualToAnchor:self.crxContentView.trailingAnchor],
        [self.crxStepTwoView.bottomAnchor constraintEqualToAnchor:self.crxContentView.bottomAnchor],

        [crxTitleLabel.topAnchor constraintEqualToAnchor:self.crxStepTwoView.topAnchor constant:18],
        [crxTitleLabel.leadingAnchor constraintEqualToAnchor:self.crxStepTwoView.leadingAnchor constant:22],

        [crxGenderRow.topAnchor constraintEqualToAnchor:crxTitleLabel.bottomAnchor constant:20],
        [crxGenderRow.leadingAnchor constraintEqualToAnchor:self.crxStepTwoView.leadingAnchor constant:22],
        [crxGenderRow.trailingAnchor constraintEqualToAnchor:self.crxStepTwoView.trailingAnchor constant:-22],
        [crxGenderRow.heightAnchor constraintEqualToConstant:38],

        [crxBirthdayRow.topAnchor constraintEqualToAnchor:crxGenderRow.bottomAnchor constant:12],
        [crxBirthdayRow.leadingAnchor constraintEqualToAnchor:crxGenderRow.leadingAnchor],
        [crxBirthdayRow.trailingAnchor constraintEqualToAnchor:crxGenderRow.trailingAnchor],
        [crxBirthdayRow.heightAnchor constraintEqualToConstant:38],

        [crxAddressRow.topAnchor constraintEqualToAnchor:crxBirthdayRow.bottomAnchor constant:12],
        [crxAddressRow.leadingAnchor constraintEqualToAnchor:crxGenderRow.leadingAnchor],
        [crxAddressRow.trailingAnchor constraintEqualToAnchor:crxGenderRow.trailingAnchor],
        [crxAddressRow.heightAnchor constraintEqualToConstant:38],

        [crxProfileTitleLabel.topAnchor constraintEqualToAnchor:crxAddressRow.bottomAnchor constant:18],
        [crxProfileTitleLabel.leadingAnchor constraintEqualToAnchor:crxGenderRow.leadingAnchor],

        [crxProfileCardView.topAnchor constraintEqualToAnchor:crxProfileTitleLabel.bottomAnchor constant:10],
        [crxProfileCardView.leadingAnchor constraintEqualToAnchor:crxGenderRow.leadingAnchor],
        [crxProfileCardView.trailingAnchor constraintEqualToAnchor:crxGenderRow.trailingAnchor],
        [crxProfileCardView.heightAnchor constraintEqualToConstant:96],

        [self.crxProfileTextView.topAnchor constraintEqualToAnchor:crxProfileCardView.topAnchor],
        [self.crxProfileTextView.leadingAnchor constraintEqualToAnchor:crxProfileCardView.leadingAnchor],
        [self.crxProfileTextView.trailingAnchor constraintEqualToAnchor:crxProfileCardView.trailingAnchor],
        [self.crxProfileTextView.bottomAnchor constraintEqualToAnchor:crxProfileCardView.bottomAnchor],

        [self.crxProfilePlaceholderLabel.topAnchor constraintEqualToAnchor:crxProfileCardView.topAnchor constant:16],
        [self.crxProfilePlaceholderLabel.leadingAnchor constraintEqualToAnchor:crxProfileCardView.leadingAnchor constant:16],

        [self.crxEnterButton.topAnchor constraintEqualToAnchor:crxProfileCardView.bottomAnchor constant:32],
        [self.crxEnterButton.leadingAnchor constraintEqualToAnchor:crxGenderRow.leadingAnchor],
        [self.crxEnterButton.trailingAnchor constraintEqualToAnchor:crxGenderRow.trailingAnchor],
        [self.crxEnterButton.heightAnchor constraintEqualToConstant:52],
        [self.crxEnterButton.bottomAnchor constraintEqualToAnchor:self.crxStepTwoView.safeAreaLayoutGuide.bottomAnchor constant:-34]
    ]];
}

- (UILabel *)crx_buildSectionLabel:(NSString *)crxTitle {
    UILabel *crxLabel = [[UILabel alloc] init];
    crxLabel.text = crxTitle;
    crxLabel.textColor = UIColor.whiteColor;
    crxLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    return crxLabel;
}

- (UIView *)crx_buildInputContainer {
    UIView *crxContainerView = [[UIView alloc] init];
    crxContainerView.backgroundColor = [UIColor colorWithRed:0x3A/255.0 green:0x0E/255.0 blue:0x4D/255.0 alpha:0.82];
    crxContainerView.layer.cornerRadius = 14.0;
    crxContainerView.layer.borderWidth = 1.0;
    crxContainerView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    return crxContainerView;
}

- (UITextField *)crx_buildTextField:(NSString *)crxPlaceholder {
    UITextField *crxTextField = [[UITextField alloc] init];
    crxTextField.textColor = UIColor.whiteColor;
    crxTextField.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    crxTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:crxPlaceholder attributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.42]
    }];
    crxTextField.delegate = self;
    return crxTextField;
}

- (void)crx_pinTextField:(UITextField *)crxTextField toContainer:(UIView *)crxContainer {
    [NSLayoutConstraint activateConstraints:@[
        [crxTextField.leadingAnchor constraintEqualToAnchor:crxContainer.leadingAnchor constant:16],
        [crxTextField.trailingAnchor constraintEqualToAnchor:crxContainer.trailingAnchor constant:-16],
        [crxTextField.topAnchor constraintEqualToAnchor:crxContainer.topAnchor],
        [crxTextField.bottomAnchor constraintEqualToAnchor:crxContainer.bottomAnchor]
    ]];
}

- (UIView *)crx_buildInfoRowWithTitle:(NSString *)crxTitle selector:(SEL)crxSelector {
    UIView *crxRowView = [self crx_buildInputContainer];

    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.text = crxTitle;
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [crxRowView addSubview:crxTitleLabel];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIButton *crxArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxArrowButton setTitle:@"›" forState:UIControlStateNormal];
    [crxArrowButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    crxArrowButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    crxArrowButton.layer.cornerRadius = 11.0;
    crxArrowButton.layer.masksToBounds = YES;
    [crxArrowButton addTarget:self action:crxSelector forControlEvents:UIControlEventTouchUpInside];
    [crxRowView addSubview:crxArrowButton];
    crxArrowButton.translatesAutoresizingMaskIntoConstraints = NO;

    CAGradientLayer *crxArrowGradientLayer = [self crx_buildButtonGradient];
    crxArrowGradientLayer.frame = CGRectMake(0, 0, 22, 22);
    crxArrowGradientLayer.cornerRadius = 11.0;
    [crxArrowButton.layer insertSublayer:crxArrowGradientLayer atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
        [crxTitleLabel.leadingAnchor constraintEqualToAnchor:crxRowView.leadingAnchor constant:14],
        [crxTitleLabel.centerYAnchor constraintEqualToAnchor:crxRowView.centerYAnchor],

        [crxArrowButton.trailingAnchor constraintEqualToAnchor:crxRowView.trailingAnchor constant:-10],
        [crxArrowButton.centerYAnchor constraintEqualToAnchor:crxRowView.centerYAnchor],
        [crxArrowButton.widthAnchor constraintEqualToConstant:22],
        [crxArrowButton.heightAnchor constraintEqualToConstant:22]
    ]];
    return crxRowView;
}

- (UILabel *)crx_buildRowValueLabel {
    UILabel *crxLabel = [[UILabel alloc] init];
    crxLabel.textColor = [UIColor colorWithWhite:1 alpha:0.66];
    crxLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    crxLabel.textAlignment = NSTextAlignmentRight;
    return crxLabel;
}

- (void)crx_pinRowValue:(UILabel *)crxValueLabel toRow:(UIView *)crxRowView {
    [NSLayoutConstraint activateConstraints:@[
        [crxValueLabel.centerYAnchor constraintEqualToAnchor:crxRowView.centerYAnchor],
        [crxValueLabel.trailingAnchor constraintEqualToAnchor:crxRowView.trailingAnchor constant:-42],
        [crxValueLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:crxRowView.leadingAnchor constant:110]
    ]];
}

- (CAGradientLayer *)crx_buildButtonGradient {
    CAGradientLayer *crxGradientLayer = [CAGradientLayer layer];
    crxGradientLayer.startPoint = CGPointMake(0, 0.5);
    crxGradientLayer.endPoint = CGPointMake(1, 0.5);
    crxGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
    ];
    return crxGradientLayer;
}

- (void)crx_showSecondStep:(BOOL)crxShowSecondStep {
    self.crxShowingSecondStep = crxShowSecondStep;
    self.crxStepOneView.hidden = crxShowSecondStep;
    self.crxStepTwoView.hidden = !crxShowSecondStep;
    if (crxShowSecondStep) {
        [self.crxScrollView setContentOffset:CGPointZero animated:NO];
    }
}

- (void)crx_refreshStepTwoValues {
    self.crxGenderValueLabel.text = self.crxSelectedGender;
    self.crxBirthdayValueLabel.text = self.crxSelectedBirthday;
    self.crxAddressValueLabel.text = self.crxSelectedAddress;
    self.crxProfilePlaceholderLabel.hidden = self.crxProfileTextView.text.length > 0;
}

- (void)crxBackTapped {
    [self crxDismissKeyboard];
    if (self.crxShowingSecondStep) {
        [self crx_showSecondStep:NO];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)crxAvatarTapped {
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:@"Avatar selection"
                                                                                message:@"Choose image source"
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [crxAlertController addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction * _Nonnull action) {
            [self crx_requestCameraPermissionWithCompletion:^(BOOL crxGranted) {
                if (!crxGranted) {
                    [self crx_showAlertWithTitle:@"Reminder" message:@"Camera access is required to take a photo."];
                    return;
                }
                [self crx_openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }];
        }]];
    }
    [crxAlertController addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction * _Nonnull action) {
        [self crx_requestPhotoLibraryPermissionWithCompletion:^(BOOL crxGranted) {
            if (!crxGranted) {
                [self crx_showAlertWithTitle:@"Reminder" message:@"Photo library access is required to choose a photo."];
                return;
            }
            [self crx_openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
    }]];
    [crxAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

- (void)crxNextTapped {
    [self crxDismissKeyboard];
    NSString *crxName = [self.crxNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *crxEmail = [self.crxEmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *crxPassword = self.crxPasswordField.text ?: @"";

    if (self.crxAvatarImageView.image == nil) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Please upload an avatar first."];
        return;
    }
    if (crxName.length == 0 || crxEmail.length == 0 || crxPassword.length == 0) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Please complete your basic information first."];
        return;
    }
    if (![self crx_isValidEmail:crxEmail]) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Please enter a valid email address."];
        return;
    }
    if (crxPassword.length < 6) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Password must be at least 6 characters."];
        return;
    }
    [self crx_showSecondStep:YES];
}

- (void)crxGenderTapped {
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:@"Gender" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray<NSString *> *crxOptions = @[@"Female", @"Male", @"Other"];
    for (NSString *crxOption in crxOptions) {
        [crxAlertController addAction:[UIAlertAction actionWithTitle:crxOption style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction * _Nonnull action) {
            self.crxSelectedGender = crxOption;
            [self crx_refreshStepTwoValues];
        }]];
    }
    [crxAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

- (void)crxBirthdayTapped {
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:@"Birthday\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIDatePicker *crxDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 32, UIScreen.mainScreen.bounds.size.width - 32, 180)];
    crxDatePicker.datePickerMode = UIDatePickerModeDate;
    crxDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    NSDateFormatter *crxFormatter = [[NSDateFormatter alloc] init];
    crxFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *crxDate = [crxFormatter dateFromString:self.crxSelectedBirthday];
    if (crxDate != nil) {
        crxDatePicker.date = crxDate;
    }
    [crxAlertController.view addSubview:crxDatePicker];
    [crxAlertController addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction * _Nonnull action) {
        self.crxSelectedBirthday = [crxFormatter stringFromDate:crxDatePicker.date];
        [self crx_refreshStepTwoValues];
    }]];
    [crxAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

- (void)crxAddressTapped {
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:@"Address"
                                                                                message:@"Please enter your address."
                                                                         preferredStyle:UIAlertControllerStyleAlert];
    [crxAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.crxSelectedAddress;
        textField.placeholder = @"Los Angeles, CA, USA";
    }];
    [crxAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [crxAlertController addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction * _Nonnull action) {
        NSString *crxAddress = [crxAlertController.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (crxAddress.length > 0) {
            self.crxSelectedAddress = crxAddress;
            [self crx_refreshStepTwoValues];
        }
    }]];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

- (void)crxEnterTapped {
    [self crxDismissKeyboard];
    NSString *crxName = [self.crxNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *crxEmail = [self.crxEmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *crxProfile = [self.crxProfileTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (crxName.length == 0 || crxEmail.length == 0) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Please complete your account information first."];
        return;
    }
    if (self.crxSelectedAddress.length == 0) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Please complete your address."];
        return;
    }

    UIImage *crxAvatarImage = self.crxAvatarImageView.image;
    NSData *crxAvatarData = crxAvatarImage ? UIImageJPEGRepresentation(crxAvatarImage, 0.85) : nil;

    [NSUserDefaults.standardUserDefaults setBool:YES forKey:CAREXQRegisterLoginStateKey];
    [NSUserDefaults.standardUserDefaults setObject:crxEmail forKey:CAREXQRegisterEmailKey];
    [NSUserDefaults.standardUserDefaults setObject:crxName forKey:CAREXQRegisterNicknameKey];
    [NSUserDefaults.standardUserDefaults setObject:self.crxSelectedGender ?: @"" forKey:CAREXQRegisterGenderKey];
    [NSUserDefaults.standardUserDefaults setObject:self.crxSelectedBirthday ?: @"" forKey:CAREXQRegisterBirthdayKey];
    [NSUserDefaults.standardUserDefaults setObject:self.crxSelectedAddress ?: @"" forKey:CAREXQRegisterAddressKey];
    [NSUserDefaults.standardUserDefaults setObject:crxProfile ?: @"" forKey:CAREXQRegisterProfileKey];
    if (crxAvatarData.length > 0) {
        [NSUserDefaults.standardUserDefaults setObject:crxAvatarData forKey:CAREXQRegisterAvatarDataKey];
    }
    [NSUserDefaults.standardUserDefaults synchronize];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)crxDismissKeyboard {
    [self.view endEditing:YES];
}

- (void)crx_requestCameraPermissionWithCompletion:(void (^)(BOOL))crxCompletion {
    AVAuthorizationStatus crxStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (crxStatus == AVAuthorizationStatusAuthorized) {
        crxCompletion(YES);
        return;
    }
    if (crxStatus == AVAuthorizationStatusDenied || crxStatus == AVAuthorizationStatusRestricted) {
        crxCompletion(NO);
        return;
    }
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            crxCompletion(granted);
        });
    }];
}

- (void)crx_requestPhotoLibraryPermissionWithCompletion:(void (^)(BOOL))crxCompletion {
    PHAuthorizationStatus crxStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    if (crxStatus == PHAuthorizationStatusAuthorized || crxStatus == PHAuthorizationStatusLimited) {
        crxCompletion(YES);
        return;
    }
    if (crxStatus == PHAuthorizationStatusDenied || crxStatus == PHAuthorizationStatusRestricted) {
        crxCompletion(NO);
        return;
    }
    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            crxCompletion(status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited);
        });
    }];
}

- (void)crx_openImagePickerWithSourceType:(UIImagePickerControllerSourceType)crxSourceType {
    UIImagePickerController *crxPickerController = [[UIImagePickerController alloc] init];
    crxPickerController.sourceType = crxSourceType;
    crxPickerController.delegate = self;
    crxPickerController.allowsEditing = YES;
    [self presentViewController:crxPickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *crxImage = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    if (crxImage != nil) {
        self.crxAvatarImageView.image = crxImage;
        self.crxAvatarImageView.hidden = NO;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    [crxAlertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.crxProfilePlaceholderLabel.hidden = textView.text.length > 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.crxNameField) {
        [self.crxEmailField becomeFirstResponder];
    } else if (textField == self.crxEmailField) {
        [self.crxPasswordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self crxNextTapped];
    }
    return YES;
}

@end
