//
//  CAREXQEntryGateController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/5/11.
//

#import "CAREXQEntryGateController.h"
#import "CAREXQEntryController.h"
#import "CAREXQRegisterController.h"
#import "CAREXQImage.h"
#import "CMRAgreementController.h"
#import "CMRPrivacyController.h"
#import <AuthenticationServices/AuthenticationServices.h>

static NSString * const CAREXQEntryLoginStateKey = @"CAREXQEntryLoginStateKey";
static NSString * const CAREXQEntryNicknameKey = @"CAREXQIdentityNicknameKey";
static NSString * const CAREXQEntryEmailKey = @"CAREXQEntryEmailKey";
static NSString * const CAREXQAppleUserIdentifierKey = @"CAREXQAppleUserIdentifierKey";
static NSString * const CAREXQAppleUserEmailMapKey = @"CAREXQAppleUserEmailMapKey";

@interface CAREXQEntryGateController () <UITextViewDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, strong) UIImageView *crxBackgroundImageView;
@property (nonatomic, strong) UIButton *crxBackButton;
@property (nonatomic, strong) UIButton *crxEulaButton;
@property (nonatomic, strong) UIButton *crxEmailButton;
@property (nonatomic, strong) UIButton *crxRegisterButton;
@property (nonatomic, strong) UIButton *crxAppleButton;
@property (nonatomic, strong) UIButton *crxAgreementButton;
@property (nonatomic, strong) UITextView *crxAgreementTextView;
@property (nonatomic, strong) UIView *crxIndicatorView;
@property (nonatomic, assign) BOOL crxAgreementAccepted;

@end

@implementation CAREXQEntryGateController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.crxAgreementAccepted = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0x0A/255.0 green:0x09/255.0 blue:0x1D/255.0 alpha:1.0];
    [self crx_setupViews];
    [self crx_updateAgreementButton];
}

- (void)crx_setupViews {
    self.crxBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CAREXQElue1"]];
    self.crxBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxBackgroundImageView.clipsToBounds = YES;
    [self.view addSubview:self.crxBackgroundImageView];
    self.crxBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *crxBottomMaskView = [[UIView alloc] init];
    crxBottomMaskView.backgroundColor = [UIColor colorWithRed:0x05/255.0 green:0x06/255.0 blue:0x1B/255.0 alpha:0.18];
    [self.view addSubview:crxBottomMaskView];
    crxBottomMaskView.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxBackButton setImage:[CAREXQImage imageNamed:@"crx_harbor_back"] forState:UIControlStateNormal];
    self.crxBackButton.backgroundColor = [UIColor colorWithRed:0x2C/255.0 green:0x0C/255.0 blue:0x46/255.0 alpha:0.96];
    self.crxBackButton.layer.cornerRadius = 18.0;
    [self.crxBackButton addTarget:self action:@selector(crxBackTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxBackButton];
    self.crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxEulaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxEulaButton setTitle:@"EULA" forState:UIControlStateNormal];
    [self.crxEulaButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxEulaButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    self.crxEulaButton.backgroundColor = [UIColor colorWithRed:0x2C/255.0 green:0x0C/255.0 blue:0x46/255.0 alpha:0.96];
    self.crxEulaButton.layer.cornerRadius = 18.0;
    self.crxEulaButton.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16);
    [self.crxEulaButton addTarget:self action:@selector(crxEulaTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxEulaButton];
    self.crxEulaButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxEmailButton setBackgroundImage:[UIImage imageNamed:@"CAREXQElue3"] forState:UIControlStateNormal];
    [self.crxEmailButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxEmailButton.adjustsImageWhenHighlighted = NO;
    [self.crxEmailButton addTarget:self action:@selector(crxEmailTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxEmailButton];
    self.crxEmailButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxRegisterButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.crxRegisterButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.96] forState:UIControlStateNormal];
    self.crxRegisterButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.crxRegisterButton.backgroundColor = [UIColor colorWithRed:0x1E/255.0 green:0x0D/255.0 blue:0x37/255.0 alpha:0.72];
    self.crxRegisterButton.layer.cornerRadius = 22.0;
    self.crxRegisterButton.layer.borderWidth = 1.0;
    self.crxRegisterButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    [self.crxRegisterButton addTarget:self action:@selector(crxRegisterTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxRegisterButton];
    self.crxRegisterButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxAppleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxAppleButton setImage:[UIImage imageNamed:@"CAREXQElue5"] forState:UIControlStateNormal];
    self.crxAppleButton.tintColor = UIColor.whiteColor;
    self.crxAppleButton.adjustsImageWhenHighlighted = NO;
    [self.crxAppleButton addTarget:self action:@selector(crxAppleTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxAppleButton];
    self.crxAppleButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxAgreementButton addTarget:self action:@selector(crxAgreementButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxAgreementButton];
    self.crxAgreementButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxAgreementTextView = [[UITextView alloc] init];
    self.crxAgreementTextView.backgroundColor = UIColor.clearColor;
    self.crxAgreementTextView.scrollEnabled = NO;
    self.crxAgreementTextView.editable = NO;
    self.crxAgreementTextView.selectable = YES;
    self.crxAgreementTextView.textAlignment = NSTextAlignmentCenter;
    self.crxAgreementTextView.delegate = self;
    self.crxAgreementTextView.textContainerInset = UIEdgeInsetsZero;
    self.crxAgreementTextView.textContainer.lineFragmentPadding = 0;
    self.crxAgreementTextView.linkTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor colorWithRed:0xF7/255.0 green:0x3F/255.0 blue:0xCF/255.0 alpha:1.0],
        NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
    };
    self.crxAgreementTextView.attributedText = [self crx_agreementAttributedText];
    [self.view addSubview:self.crxAgreementTextView];
    self.crxAgreementTextView.translatesAutoresizingMaskIntoConstraints = NO;

    self.crxIndicatorView = [[UIView alloc] init];
    self.crxIndicatorView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.24];
    self.crxIndicatorView.layer.cornerRadius = 2.0;
    [self.view addSubview:self.crxIndicatorView];
    self.crxIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;

    UILayoutGuide *crxSafeGuide = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxBackgroundImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.crxBackgroundImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxBackgroundImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxBackgroundImageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [crxBottomMaskView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxBottomMaskView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxBottomMaskView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [crxBottomMaskView.heightAnchor constraintEqualToConstant:220],

        [self.crxBackButton.topAnchor constraintEqualToAnchor:crxSafeGuide.topAnchor constant:10],
        [self.crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [self.crxBackButton.widthAnchor constraintEqualToConstant:36],
        [self.crxBackButton.heightAnchor constraintEqualToConstant:36],

        [self.crxEulaButton.topAnchor constraintEqualToAnchor:crxSafeGuide.topAnchor constant:10],
        [self.crxEulaButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-18],
        [self.crxEulaButton.heightAnchor constraintEqualToConstant:36],

        [self.crxEmailButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:26],
        [self.crxEmailButton.trailingAnchor constraintEqualToAnchor:self.crxAppleButton.leadingAnchor constant:-14],
        [self.crxEmailButton.heightAnchor constraintEqualToConstant:60],
        [self.crxEmailButton.bottomAnchor constraintEqualToAnchor:self.crxRegisterButton.topAnchor constant:-12],

        [self.crxRegisterButton.leadingAnchor constraintEqualToAnchor:self.crxEmailButton.leadingAnchor],
        [self.crxRegisterButton.trailingAnchor constraintEqualToAnchor:self.crxAppleButton.trailingAnchor],
        [self.crxRegisterButton.heightAnchor constraintEqualToConstant:60],
        [self.crxRegisterButton.bottomAnchor constraintEqualToAnchor:self.crxAgreementTextView.topAnchor constant:-16],

        [self.crxAppleButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-26],
        [self.crxAppleButton.centerYAnchor constraintEqualToAnchor:self.crxEmailButton.centerYAnchor],
        [self.crxAppleButton.widthAnchor constraintEqualToConstant:60],
        [self.crxAppleButton.heightAnchor constraintEqualToConstant:60],

        [self.crxAgreementButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:26],
        [self.crxAgreementButton.topAnchor constraintEqualToAnchor:self.crxAgreementTextView.topAnchor constant:2],
        [self.crxAgreementButton.widthAnchor constraintEqualToConstant:22],
        [self.crxAgreementButton.heightAnchor constraintEqualToConstant:22],

        [self.crxAgreementTextView.leadingAnchor constraintEqualToAnchor:self.crxAgreementButton.trailingAnchor constant:10],
        [self.crxAgreementTextView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-26],
        [self.crxAgreementTextView.heightAnchor constraintEqualToConstant:46],
        [self.crxAgreementTextView.bottomAnchor constraintEqualToAnchor:self.crxIndicatorView.topAnchor constant:-18],

        [self.crxIndicatorView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.crxIndicatorView.bottomAnchor constraintEqualToAnchor:crxSafeGuide.bottomAnchor constant:-8],
        [self.crxIndicatorView.widthAnchor constraintEqualToConstant:26],
        [self.crxIndicatorView.heightAnchor constraintEqualToConstant:4]
    ]];
}

- (NSAttributedString *)crx_agreementAttributedText {
    NSMutableParagraphStyle *crxParagraph = [[NSMutableParagraphStyle alloc] init];
    crxParagraph.alignment = NSTextAlignmentCenter;
    crxParagraph.lineSpacing = 1.0;
    NSDictionary *crxNormalAttributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.92],
        NSParagraphStyleAttributeName : crxParagraph
    };

    NSMutableAttributedString *crxText = [[NSMutableAttributedString alloc] initWithString:@"Agree to the " attributes:crxNormalAttributes];
    NSAttributedString *crxAgreement = [[NSAttributedString alloc] initWithString:@"User Agreement" attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName : [UIColor colorWithRed:0xF7/255.0 green:0x3F/255.0 blue:0xCF/255.0 alpha:1.0],
        NSLinkAttributeName : @"carexq://agreement",
        NSParagraphStyleAttributeName : crxParagraph
    }];
    NSAttributedString *crxAndText = [[NSAttributedString alloc] initWithString:@" and\n" attributes:crxNormalAttributes];
    NSAttributedString *crxPrivacy = [[NSAttributedString alloc] initWithString:@"Privacy Agreement" attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName : [UIColor colorWithRed:0xF7/255.0 green:0x3F/255.0 blue:0xCF/255.0 alpha:1.0],
        NSLinkAttributeName : @"carexq://privacy",
        NSParagraphStyleAttributeName : crxParagraph
    }];
    [crxText appendAttributedString:crxAgreement];
    [crxText appendAttributedString:crxAndText];
    [crxText appendAttributedString:crxPrivacy];
    return crxText;
}

- (void)crx_updateAgreementButton {
    NSString *crxImageName = self.crxAgreementAccepted ? @"crx_entry_sel" : @"crx_entry_nor";
    UIImage *crxImage = [CAREXQImage imageNamed:crxImageName];
    [self.crxAgreementButton setImage:crxImage forState:UIControlStateNormal];
}

- (void)crxAgreementButtonTapped {
    self.crxAgreementAccepted = !self.crxAgreementAccepted;
    [self crx_updateAgreementButton];
}

- (void)crxEulaTapped {
    CMRAgreementController *crxController = [[CMRAgreementController alloc] init];
    [self.navigationController pushViewController:crxController animated:YES];
}

- (void)crxEmailTapped {
    if (!self.crxAgreementAccepted) {
        [self crx_showAlertWithTitle:@"" message:@"Please agree to the terms first."];
        return;
    }
    CAREXQEntryController *crxController = [[CAREXQEntryController alloc] init];
    [self.navigationController pushViewController:crxController animated:YES];
}

- (void)crxAppleTapped {
    if (!self.crxAgreementAccepted) {
        [self crx_showAlertWithTitle:@"" message:@"Please agree to the terms first."];
        return;
    }
    ASAuthorizationAppleIDProvider *crxProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *crxRequest = [crxProvider createRequest];
    crxRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    ASAuthorizationController *crxAuthorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[crxRequest]];
    crxAuthorizationController.delegate = self;
    crxAuthorizationController.presentationContextProvider = self;
    [crxAuthorizationController performRequests];
}

- (void)crxRegisterTapped {
    if (!self.crxAgreementAccepted) {
        [self crx_showAlertWithTitle:@"" message:@"Please agree to the terms first."];
        return;
    }
    CAREXQRegisterController *crxController = [[CAREXQRegisterController alloc] init];
    [self.navigationController pushViewController:crxController animated:YES];
}

- (void)crxBackTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"carexq"]) {
        UIViewController *crxController = nil;
        if ([[URL host] isEqualToString:@"agreement"]) {
            crxController = [[CMRAgreementController alloc] init];
        } else if ([[URL host] isEqualToString:@"privacy"]) {
            crxController = [[CMRPrivacyController alloc] init];
        }
        if (crxController != nil) {
            [self.navigationController pushViewController:crxController animated:YES];
        }
        return NO;
    }
    return YES;
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

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if (![authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Apple login failed. Please try again."];
        return;
    }

    ASAuthorizationAppleIDCredential *crxCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
    NSString *crxEmail = [self crx_resolvedAppleEmailFromCredential:crxCredential];
    if (crxEmail.length == 0) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Apple did not return an email address. Please use email login once or try another Apple account."];
        return;
    }

    [self crx_storeAppleLoginStateWithEmail:crxEmail userIdentifier:crxCredential.user];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    if (error.code == ASAuthorizationErrorCanceled) {
        return;
    }
    NSString *crxMessage = error.localizedDescription.length > 0 ? error.localizedDescription : @"Apple login failed. Please try again.";
    [self crx_showAlertWithTitle:@"Reminder" message:crxMessage];
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return self.view.window ?: UIApplication.sharedApplication.windows.firstObject;
}

- (NSString *)crx_resolvedAppleEmailFromCredential:(ASAuthorizationAppleIDCredential *)crxCredential {
    NSString *crxEmail = [crxCredential.email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (crxEmail.length > 0) {
        return crxEmail;
    }

    NSDictionary<NSString *, NSString *> *crxEmailMap = [NSUserDefaults.standardUserDefaults dictionaryForKey:CAREXQAppleUserEmailMapKey];
    NSString *crxStoredEmail = [crxEmailMap[crxCredential.user] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (crxStoredEmail.length > 0) {
        return crxStoredEmail;
    }

    NSString *crxLastUserIdentifier = [NSUserDefaults.standardUserDefaults stringForKey:CAREXQAppleUserIdentifierKey];
    if ([crxLastUserIdentifier isEqualToString:crxCredential.user]) {
        NSString *crxLastEmail = [[NSUserDefaults.standardUserDefaults stringForKey:CAREXQEntryEmailKey] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (crxLastEmail.length > 0) {
            return crxLastEmail;
        }
        NSString *crxLastNickname = [[NSUserDefaults.standardUserDefaults stringForKey:CAREXQEntryNicknameKey] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (crxLastNickname.length > 0) {
            return crxLastNickname;
        }
    }
    return @"";
}

- (void)crx_storeAppleLoginStateWithEmail:(NSString *)crxEmail userIdentifier:(NSString *)crxUserIdentifier {
    NSString *crxTrimmedEmail = [crxEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (crxTrimmedEmail.length == 0) {
        return;
    }

    [NSUserDefaults.standardUserDefaults setBool:YES forKey:CAREXQEntryLoginStateKey];
    [NSUserDefaults.standardUserDefaults setObject:crxTrimmedEmail forKey:CAREXQEntryNicknameKey];
    [NSUserDefaults.standardUserDefaults setObject:crxTrimmedEmail forKey:CAREXQEntryEmailKey];
    if (crxUserIdentifier.length > 0) {
        [NSUserDefaults.standardUserDefaults setObject:crxUserIdentifier forKey:CAREXQAppleUserIdentifierKey];
        NSMutableDictionary<NSString *, NSString *> *crxEmailMap = [[NSUserDefaults.standardUserDefaults dictionaryForKey:CAREXQAppleUserEmailMapKey] mutableCopy];
        if (crxEmailMap == nil) {
            crxEmailMap = [NSMutableDictionary dictionary];
        }
        crxEmailMap[crxUserIdentifier] = crxTrimmedEmail;
        [NSUserDefaults.standardUserDefaults setObject:crxEmailMap forKey:CAREXQAppleUserEmailMapKey];
    }
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
