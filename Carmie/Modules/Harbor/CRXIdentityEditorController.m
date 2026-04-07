//
//  CRXIdentityEditorController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXIdentityEditorController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

static NSString * const CRXIdentityNicknameKey = @"CRXIdentityNicknameKey";
static NSString * const CRXIdentityProfileKey = @"CRXIdentityProfileKey";
static NSString * const CRXIdentityAvatarDataKey = @"CRXIdentityAvatarDataKey";

@interface CRXIdentityEditorController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIImageView *crxAvatarImageView;
@property (nonatomic, strong) UILabel *crxNicknameValueLabel;
@property (nonatomic, strong) UITextView *crxProfileTextView;
@property (nonatomic, strong) UILabel *crxProfilePlaceholderLabel;
@property (nonatomic, strong) UIButton *crxSaveButton;
@property (nonatomic, strong) CAGradientLayer *crxSaveGradientLayer;

@end

@implementation CRXIdentityEditorController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildViews];
    [self crx_loadSavedProfile];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.crxSaveGradientLayer.frame = self.crxSaveButton.bounds;
    self.crxSaveGradientLayer.cornerRadius = CGRectGetHeight(self.crxSaveButton.bounds) * 0.5;
}

- (void)crx_buildViews {
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
    [crxBackButton setImage:[UIImage imageNamed:@"crx_harbor_back"] forState:UIControlStateNormal];
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
    crxTitleLabel.text = @"Edit";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont italicSystemFontOfSize:18];
    [self.view addSubview:crxTitleLabel];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxTitleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [crxTitleLabel.centerYAnchor constraintEqualToAnchor:crxBackButton.centerYAnchor]
    ]];
    
    UIView *crxAvatarRowView = [self crx_buildRowContainer];
    [self.view addSubview:crxAvatarRowView];
    crxAvatarRowView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *crxAvatarTitleLabel = [self crx_buildRowTitle:@"Avatar selection"];
    [crxAvatarRowView addSubview:crxAvatarTitleLabel];
    crxAvatarTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxAvatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_harbor_logo"]];
    self.crxAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxAvatarImageView.clipsToBounds = YES;
    self.crxAvatarImageView.layer.cornerRadius = 19.f;
    [crxAvatarRowView addSubview:self.crxAvatarImageView];
    self.crxAvatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *crxCameraBadgeView = [[UIView alloc] init];
    crxCameraBadgeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.38];
    crxCameraBadgeView.layer.cornerRadius = 11.f;
    [crxAvatarRowView addSubview:crxCameraBadgeView];
    crxCameraBadgeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *crxCameraLabel = [[UILabel alloc] init];
    crxCameraLabel.text = @"📷";
    crxCameraLabel.font = [UIFont systemFontOfSize:12];
    [crxCameraBadgeView addSubview:crxCameraLabel];
    crxCameraLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *crxAvatarButton = [self crx_buildArrowButtonWithAction:@selector(crxAvatarTapped)];
    [crxAvatarRowView addSubview:crxAvatarButton];
    crxAvatarButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *crxNicknameRowView = [self crx_buildRowContainer];
    [self.view addSubview:crxNicknameRowView];
    crxNicknameRowView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *crxNicknameTitleLabel = [self crx_buildRowTitle:@"Nick name"];
    [crxNicknameRowView addSubview:crxNicknameTitleLabel];
    crxNicknameTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxNicknameValueLabel = [[UILabel alloc] init];
    self.crxNicknameValueLabel.textColor = [UIColor colorWithWhite:1 alpha:0.62];
    self.crxNicknameValueLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.crxNicknameValueLabel.textAlignment = NSTextAlignmentRight;
    [crxNicknameRowView addSubview:self.crxNicknameValueLabel];
    self.crxNicknameValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *crxNicknameButton = [self crx_buildArrowButtonWithAction:@selector(crxNicknameTapped)];
    [crxNicknameRowView addSubview:crxNicknameButton];
    crxNicknameButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *crxProfileTitleLabel = [[UILabel alloc] init];
    crxProfileTitleLabel.text = @"PersonalProfile";
    crxProfileTitleLabel.textColor = UIColor.whiteColor;
    crxProfileTitleLabel.font = [UIFont italicSystemFontOfSize:16];
    [self.view addSubview:crxProfileTitleLabel];
    crxProfileTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *crxProfileCardView = [self crx_buildRowContainer];
    [self.view addSubview:crxProfileCardView];
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
    
    self.crxSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.crxSaveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxSaveButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    self.crxSaveButton.layer.cornerRadius = 24.f;
    self.crxSaveButton.layer.masksToBounds = YES;
    [self.crxSaveButton addTarget:self action:@selector(crxSaveTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxSaveButton];
    self.crxSaveButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxSaveGradientLayer = [CAGradientLayer layer];
    self.crxSaveGradientLayer.startPoint = CGPointMake(0, 0.5);
    self.crxSaveGradientLayer.endPoint = CGPointMake(1, 0.5);
    self.crxSaveGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
    ];
    [self.crxSaveButton.layer insertSublayer:self.crxSaveGradientLayer atIndex:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [crxAvatarRowView.topAnchor constraintEqualToAnchor:crxBackButton.bottomAnchor constant:28],
        [crxAvatarRowView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [crxAvatarRowView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [crxAvatarRowView.heightAnchor constraintEqualToConstant:68],
        
        [crxAvatarTitleLabel.leadingAnchor constraintEqualToAnchor:crxAvatarRowView.leadingAnchor constant:14],
        [crxAvatarTitleLabel.centerYAnchor constraintEqualToAnchor:crxAvatarRowView.centerYAnchor],
        
        [self.crxAvatarImageView.centerYAnchor constraintEqualToAnchor:crxAvatarRowView.centerYAnchor],
        [self.crxAvatarImageView.trailingAnchor constraintEqualToAnchor:crxAvatarRowView.trailingAnchor constant:-50],
        [self.crxAvatarImageView.widthAnchor constraintEqualToConstant:38],
        [self.crxAvatarImageView.heightAnchor constraintEqualToConstant:38],
        
        [crxCameraBadgeView.centerXAnchor constraintEqualToAnchor:self.crxAvatarImageView.centerXAnchor],
        [crxCameraBadgeView.centerYAnchor constraintEqualToAnchor:self.crxAvatarImageView.centerYAnchor],
        [crxCameraBadgeView.widthAnchor constraintEqualToConstant:22],
        [crxCameraBadgeView.heightAnchor constraintEqualToConstant:22],
        
        [crxCameraLabel.centerXAnchor constraintEqualToAnchor:crxCameraBadgeView.centerXAnchor],
        [crxCameraLabel.centerYAnchor constraintEqualToAnchor:crxCameraBadgeView.centerYAnchor],
        
        [crxAvatarButton.trailingAnchor constraintEqualToAnchor:crxAvatarRowView.trailingAnchor constant:-12],
        [crxAvatarButton.centerYAnchor constraintEqualToAnchor:crxAvatarRowView.centerYAnchor],
        
        [crxNicknameRowView.topAnchor constraintEqualToAnchor:crxAvatarRowView.bottomAnchor constant:16],
        [crxNicknameRowView.leadingAnchor constraintEqualToAnchor:crxAvatarRowView.leadingAnchor],
        [crxNicknameRowView.trailingAnchor constraintEqualToAnchor:crxAvatarRowView.trailingAnchor],
        [crxNicknameRowView.heightAnchor constraintEqualToConstant:68],
        
        [crxNicknameTitleLabel.leadingAnchor constraintEqualToAnchor:crxNicknameRowView.leadingAnchor constant:14],
        [crxNicknameTitleLabel.centerYAnchor constraintEqualToAnchor:crxNicknameRowView.centerYAnchor],
        
        [self.crxNicknameValueLabel.centerYAnchor constraintEqualToAnchor:crxNicknameRowView.centerYAnchor],
        [self.crxNicknameValueLabel.trailingAnchor constraintEqualToAnchor:crxNicknameButton.leadingAnchor constant:-12],
        [self.crxNicknameValueLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:crxNicknameTitleLabel.trailingAnchor constant:12],
        
        [crxNicknameButton.trailingAnchor constraintEqualToAnchor:crxNicknameRowView.trailingAnchor constant:-12],
        [crxNicknameButton.centerYAnchor constraintEqualToAnchor:crxNicknameRowView.centerYAnchor],
        
        [crxProfileTitleLabel.topAnchor constraintEqualToAnchor:crxNicknameRowView.bottomAnchor constant:18],
        [crxProfileTitleLabel.leadingAnchor constraintEqualToAnchor:crxAvatarRowView.leadingAnchor],
        
        [crxProfileCardView.topAnchor constraintEqualToAnchor:crxProfileTitleLabel.bottomAnchor constant:10],
        [crxProfileCardView.leadingAnchor constraintEqualToAnchor:crxAvatarRowView.leadingAnchor],
        [crxProfileCardView.trailingAnchor constraintEqualToAnchor:crxAvatarRowView.trailingAnchor],
        [crxProfileCardView.heightAnchor constraintEqualToConstant:96],
        
        [self.crxProfileTextView.topAnchor constraintEqualToAnchor:crxProfileCardView.topAnchor],
        [self.crxProfileTextView.leadingAnchor constraintEqualToAnchor:crxProfileCardView.leadingAnchor],
        [self.crxProfileTextView.trailingAnchor constraintEqualToAnchor:crxProfileCardView.trailingAnchor],
        [self.crxProfileTextView.bottomAnchor constraintEqualToAnchor:crxProfileCardView.bottomAnchor],
        
        [self.crxProfilePlaceholderLabel.topAnchor constraintEqualToAnchor:crxProfileCardView.topAnchor constant:16],
        [self.crxProfilePlaceholderLabel.leadingAnchor constraintEqualToAnchor:crxProfileCardView.leadingAnchor constant:16],
        [self.crxProfilePlaceholderLabel.trailingAnchor constraintLessThanOrEqualToAnchor:crxProfileCardView.trailingAnchor constant:-16],
        
        [self.crxSaveButton.leadingAnchor constraintEqualToAnchor:crxAvatarRowView.leadingAnchor],
        [self.crxSaveButton.trailingAnchor constraintEqualToAnchor:crxAvatarRowView.trailingAnchor],
        [self.crxSaveButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-22],
        [self.crxSaveButton.heightAnchor constraintEqualToConstant:52]
    ]];
}

- (UIView *)crx_buildRowContainer {
    UIView *crxRowView = [[UIView alloc] init];
    crxRowView.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x0D/255.0 blue:0x3C/255.0 alpha:0.86];
    crxRowView.layer.cornerRadius = 16.f;
    crxRowView.layer.borderWidth = 1.f;
    crxRowView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    return crxRowView;
}

- (UILabel *)crx_buildRowTitle:(NSString *)crxTitle {
    UILabel *crxLabel = [[UILabel alloc] init];
    crxLabel.text = crxTitle;
    crxLabel.textColor = UIColor.whiteColor;
    crxLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    return crxLabel;
}

- (UIButton *)crx_buildArrowButtonWithAction:(SEL)crxAction {
    UIButton *crxArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxArrowButton.layer.cornerRadius = 12.f;
    crxArrowButton.layer.masksToBounds = YES;
    [crxArrowButton setTitle:@"›" forState:UIControlStateNormal];
    [crxArrowButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    crxArrowButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    [crxArrowButton addTarget:self action:crxAction forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *crxArrowGradientLayer = [CAGradientLayer layer];
    crxArrowGradientLayer.startPoint = CGPointMake(0, 0.5);
    crxArrowGradientLayer.endPoint = CGPointMake(1, 0.5);
    crxArrowGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
    ];
    crxArrowGradientLayer.frame = CGRectMake(0, 0, 24, 24);
    crxArrowGradientLayer.cornerRadius = 12.f;
    [crxArrowButton.layer insertSublayer:crxArrowGradientLayer atIndex:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [crxArrowButton.widthAnchor constraintEqualToConstant:24],
        [crxArrowButton.heightAnchor constraintEqualToConstant:24]
    ]];
    
    return crxArrowButton;
}

- (void)crx_loadSavedProfile {
    NSString *crxSavedNickname = [[NSUserDefaults standardUserDefaults] stringForKey:CRXIdentityNicknameKey];
    NSString *crxSavedProfile = [[NSUserDefaults standardUserDefaults] stringForKey:CRXIdentityProfileKey];
    NSData *crxAvatarData = [[NSUserDefaults standardUserDefaults] objectForKey:CRXIdentityAvatarDataKey];
    
    self.crxNicknameValueLabel.text = crxSavedNickname.length > 0 ? crxSavedNickname : @"Kallisto";
    self.crxProfileTextView.text = crxSavedProfile ?: @"";
    self.crxProfilePlaceholderLabel.hidden = self.crxProfileTextView.text.length > 0;
    
    if (crxAvatarData.length > 0) {
        UIImage *crxSavedAvatar = [UIImage imageWithData:crxAvatarData];
        if (crxSavedAvatar != nil) {
            self.crxAvatarImageView.image = crxSavedAvatar;
        }
    }
}

- (void)crxAvatarTapped {
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:@"Avatar selection"
                                                                                message:@"Choose image source"
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *crxCameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(__unused UIAlertAction * _Nonnull action) {
            [self crx_presentImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        [crxAlertController addAction:crxCameraAction];
    }
    
    UIAlertAction *crxAlbumAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(__unused UIAlertAction * _Nonnull action) {
        [self crx_presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *crxCancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [crxAlertController addAction:crxAlbumAction];
    [crxAlertController addAction:crxCancelAction];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

- (void)crx_presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)crxSourceType {
    if (crxSourceType == UIImagePickerControllerSourceTypeCamera) {
        [self crx_requestCameraPermissionWithCompletion:^(BOOL crxGranted) {
            if (!crxGranted) {
                [self crx_showAlertWithTitle:@"Reminder" message:@"Please allow camera access in Settings."];
                return;
            }
            [self crx_openImagePickerWithSourceType:crxSourceType];
        }];
        return;
    }
    
    [self crx_requestPhotoLibraryPermissionWithCompletion:^(BOOL crxGranted) {
        if (!crxGranted) {
            [self crx_showAlertWithTitle:@"Reminder" message:@"Please allow photo library access in Settings."];
            return;
        }
        [self crx_openImagePickerWithSourceType:crxSourceType];
    }];
}

- (void)crx_requestCameraPermissionWithCompletion:(void (^)(BOOL crxGranted))crxCompletion {
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

- (void)crx_requestPhotoLibraryPermissionWithCompletion:(void (^)(BOOL crxGranted))crxCompletion {
    PHAuthorizationStatus crxStatus = [PHPhotoLibrary authorizationStatus];
    if (crxStatus == PHAuthorizationStatusAuthorized || crxStatus == PHAuthorizationStatusLimited) {
        crxCompletion(YES);
        return;
    }
    
    if (crxStatus == PHAuthorizationStatusDenied || crxStatus == PHAuthorizationStatusRestricted) {
        crxCompletion(NO);
        return;
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        BOOL crxGranted = (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited);
        dispatch_async(dispatch_get_main_queue(), ^{
            crxCompletion(crxGranted);
        });
    }];
}

- (void)crx_openImagePickerWithSourceType:(UIImagePickerControllerSourceType)crxSourceType {
    if (![UIImagePickerController isSourceTypeAvailable:crxSourceType]) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"This source is not available on the current device."];
        return;
    }
    
    UIImagePickerController *crxImagePickerController = [[UIImagePickerController alloc] init];
    crxImagePickerController.delegate = self;
    crxImagePickerController.sourceType = crxSourceType;
    crxImagePickerController.allowsEditing = YES;
    [self presentViewController:crxImagePickerController animated:YES completion:nil];
}

- (void)crxNicknameTapped {
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:@"Nick name"
                                                                                message:@"Please enter your nick name."
                                                                         preferredStyle:UIAlertControllerStyleAlert];
    [crxAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.crxNicknameValueLabel.text;
        textField.placeholder = @"Please enter your nick name.";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *crxCancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *crxSaveAction = [UIAlertAction actionWithTitle:@"Save"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(__unused UIAlertAction * _Nonnull action) {
        UITextField *crxTextField = crxAlertController.textFields.firstObject;
        NSString *crxNickname = [crxTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.crxNicknameValueLabel.text = crxNickname.length > 0 ? crxNickname : @"Kallisto";
    }];
    [crxAlertController addAction:crxCancelAction];
    [crxAlertController addAction:crxSaveAction];
    [self presentViewController:crxAlertController animated:YES completion:nil];
}

- (void)crxSaveTapped {
    NSString *crxNickname = self.crxNicknameValueLabel.text ?: @"Kallisto";
    NSString *crxProfile = self.crxProfileTextView.text ?: @"";
    NSData *crxAvatarData = UIImageJPEGRepresentation(self.crxAvatarImageView.image, 0.8);
    
    [[NSUserDefaults standardUserDefaults] setObject:crxNickname forKey:CRXIdentityNicknameKey];
    [[NSUserDefaults standardUserDefaults] setObject:crxProfile forKey:CRXIdentityProfileKey];
    if (crxAvatarData != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:crxAvatarData forKey:CRXIdentityAvatarDataKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self crx_showAlertWithTitle:@"Success" message:@"Profile information has been saved."];
}

- (void)crxBackButtonTapped {
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *crxEditedImage = info[UIImagePickerControllerEditedImage];
    UIImage *crxOriginalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *crxSelectedImage = crxEditedImage ?: crxOriginalImage;
    if (crxSelectedImage != nil) {
        self.crxAvatarImageView.image = crxSelectedImage;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.crxProfilePlaceholderLabel.hidden = textView.text.length > 0;
}

@end
