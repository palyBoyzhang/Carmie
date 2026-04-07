//
//  CRXForgeController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXForgeController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface CRXForgeController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIButton *crxPrimaryImageButton;
@property (nonatomic, strong) NSArray<UIButton *> *crxSecondaryImageButtons;
@property (nonatomic, strong) UITextView *crxDescriptionTextView;
@property (nonatomic, strong) UILabel *crxPlaceholderLabel;
@property (nonatomic, strong) UIButton *crxPostButton;
@property (nonatomic, strong) CAGradientLayer *crxPostGradientLayer;
@property (nonatomic, weak) UIButton *crxCurrentImageButton;

@end

@implementation CRXForgeController

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
    self.crxPostGradientLayer.frame = self.crxPostButton.bounds;
    self.crxPostGradientLayer.cornerRadius = CGRectGetHeight(self.crxPostButton.bounds) * 0.5;
}

- (void)crx_buildViews {
    UIImageView *crxBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_access_bg"]];
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
    crxTitleLabel.text = @"Post";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont italicSystemFontOfSize:18];
    [self.view addSubview:crxTitleLabel];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxTitleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [crxTitleLabel.centerYAnchor constraintEqualToAnchor:crxBackButton.centerYAnchor]
    ]];
    
    self.crxPrimaryImageButton = [self crx_buildImageButtonWithImageName:@"crx_forge_add" action:@selector(crxImageButtonTapped:)];
    self.crxPrimaryImageButton.tag = 2000;
    [self.view addSubview:self.crxPrimaryImageButton];
    self.crxPrimaryImageButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *crxSecondButton = [self crx_buildImageButtonWithImageName:@"crx_forge_add1" action:@selector(crxImageButtonTapped:)];
    crxSecondButton.tag = 2001;
    UIButton *crxThirdButton = [self crx_buildImageButtonWithImageName:@"crx_forge_add1" action:@selector(crxImageButtonTapped:)];
    crxThirdButton.tag = 2002;
    UIButton *crxFourthButton = [self crx_buildImageButtonWithImageName:@"crx_forge_add1" action:@selector(crxImageButtonTapped:)];
    crxFourthButton.tag = 2003;
    self.crxSecondaryImageButtons = @[crxSecondButton, crxThirdButton, crxFourthButton];
    
    UIStackView *crxRightStackView = [[UIStackView alloc] initWithArrangedSubviews:self.crxSecondaryImageButtons];
    crxRightStackView.axis = UILayoutConstraintAxisVertical;
    crxRightStackView.spacing = 10.f;
    crxRightStackView.distribution = UIStackViewDistributionFillEqually;
    [self.view addSubview:crxRightStackView];
    crxRightStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    for (UIButton *crxButton in self.crxSecondaryImageButtons) {
        crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    UIImageView *crxSectionTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_forge_title"]];
    crxSectionTitleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:crxSectionTitleView];
    crxSectionTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *crxTextCardView = [[UIView alloc] init];
    crxTextCardView.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x0D/255.0 blue:0x3C/255.0 alpha:0.86];
    crxTextCardView.layer.cornerRadius = 16.f;
    crxTextCardView.layer.borderWidth = 1.f;
    crxTextCardView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    [self.view addSubview:crxTextCardView];
    crxTextCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxDescriptionTextView = [[UITextView alloc] init];
    self.crxDescriptionTextView.backgroundColor = UIColor.clearColor;
    self.crxDescriptionTextView.textColor = UIColor.whiteColor;
    self.crxDescriptionTextView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.crxDescriptionTextView.delegate = self;
    self.crxDescriptionTextView.textContainerInset = UIEdgeInsetsMake(12, 10, 12, 10);
    [crxTextCardView addSubview:self.crxDescriptionTextView];
    self.crxDescriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxPlaceholderLabel = [[UILabel alloc] init];
    self.crxPlaceholderLabel.text = @"Please enter your circle's description...";
    self.crxPlaceholderLabel.textColor = [UIColor colorWithWhite:1 alpha:0.42];
    self.crxPlaceholderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [crxTextCardView addSubview:self.crxPlaceholderLabel];
    self.crxPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxPostButton setTitle:@"Post" forState:UIControlStateNormal];
    [self.crxPostButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.crxPostButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    self.crxPostButton.layer.cornerRadius = 24.f;
    self.crxPostButton.layer.masksToBounds = YES;
    [self.crxPostButton addTarget:self action:@selector(crxPostTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxPostButton];
    self.crxPostButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxPostGradientLayer = [CAGradientLayer layer];
    self.crxPostGradientLayer.startPoint = CGPointMake(0, 0.5);
    self.crxPostGradientLayer.endPoint = CGPointMake(1, 0.5);
    self.crxPostGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
    ];
    [self.crxPostButton.layer insertSublayer:self.crxPostGradientLayer atIndex:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.crxPrimaryImageButton.topAnchor constraintEqualToAnchor:crxBackButton.bottomAnchor constant:28],
        [self.crxPrimaryImageButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.crxPrimaryImageButton.widthAnchor constraintEqualToConstant:208],
        [self.crxPrimaryImageButton.heightAnchor constraintEqualToConstant:302],
        
        [crxRightStackView.topAnchor constraintEqualToAnchor:self.crxPrimaryImageButton.topAnchor],
        [crxRightStackView.leadingAnchor constraintEqualToAnchor:self.crxPrimaryImageButton.trailingAnchor constant:10],
        [crxRightStackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [crxRightStackView.heightAnchor constraintEqualToConstant:302],
        
        [crxSectionTitleView.topAnchor constraintEqualToAnchor:self.crxPrimaryImageButton.bottomAnchor constant:18],
        [crxSectionTitleView.leadingAnchor constraintEqualToAnchor:self.crxPrimaryImageButton.leadingAnchor],
        [crxSectionTitleView.widthAnchor constraintLessThanOrEqualToConstant:190],
        [crxSectionTitleView.heightAnchor constraintEqualToConstant:28],
        
        [crxTextCardView.topAnchor constraintEqualToAnchor:crxSectionTitleView.bottomAnchor constant:10],
        [crxTextCardView.leadingAnchor constraintEqualToAnchor:self.crxPrimaryImageButton.leadingAnchor],
        [crxTextCardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [crxTextCardView.heightAnchor constraintEqualToConstant:124],
        
        [self.crxDescriptionTextView.topAnchor constraintEqualToAnchor:crxTextCardView.topAnchor],
        [self.crxDescriptionTextView.leadingAnchor constraintEqualToAnchor:crxTextCardView.leadingAnchor],
        [self.crxDescriptionTextView.trailingAnchor constraintEqualToAnchor:crxTextCardView.trailingAnchor],
        [self.crxDescriptionTextView.bottomAnchor constraintEqualToAnchor:crxTextCardView.bottomAnchor],
        
        [self.crxPlaceholderLabel.topAnchor constraintEqualToAnchor:crxTextCardView.topAnchor constant:16],
        [self.crxPlaceholderLabel.leadingAnchor constraintEqualToAnchor:crxTextCardView.leadingAnchor constant:16],
        [self.crxPlaceholderLabel.trailingAnchor constraintLessThanOrEqualToAnchor:crxTextCardView.trailingAnchor constant:-16],
        
        [self.crxPostButton.leadingAnchor constraintEqualToAnchor:self.crxPrimaryImageButton.leadingAnchor],
        [self.crxPostButton.trailingAnchor constraintEqualToAnchor:crxTextCardView.trailingAnchor],
        [self.crxPostButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-22],
        [self.crxPostButton.heightAnchor constraintEqualToConstant:52]
    ]];
}

- (UIButton *)crx_buildImageButtonWithImageName:(NSString *)crxImageName action:(SEL)crxAction {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x0D/255.0 blue:0x3C/255.0 alpha:0.68];
    crxButton.layer.cornerRadius = 16.f;
    crxButton.layer.masksToBounds = YES;
    crxButton.accessibilityIdentifier = @"crx_forge_empty";
    [crxButton setImage:[UIImage imageNamed:crxImageName] forState:UIControlStateNormal];
    crxButton.imageView.contentMode = UIViewContentModeCenter;
    [crxButton addTarget:self action:crxAction forControlEvents:UIControlEventTouchUpInside];
    return crxButton;
}

- (void)crxImageButtonTapped:(UIButton *)crxSender {
    self.crxCurrentImageButton = crxSender;
    
    UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:@"Select image"
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

- (void)crxPostTapped {
    BOOL crxHasImage = [self.crxPrimaryImageButton.accessibilityIdentifier isEqualToString:@"crx_forge_has_image"];
    if (!crxHasImage) {
        for (UIButton *crxButton in self.crxSecondaryImageButtons) {
            if ([crxButton.accessibilityIdentifier isEqualToString:@"crx_forge_has_image"]) {
                crxHasImage = YES;
                break;
            }
        }
    }
    
    NSString *crxDescription = [self.crxDescriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!crxHasImage && crxDescription.length == 0) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Please add an image or enter a description first."];
        return;
    }
    
    [self crx_showAlertWithTitle:@"Success" message:@"Post content is ready to submit."];
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
    if (crxSelectedImage != nil && self.crxCurrentImageButton != nil) {
        [self.crxCurrentImageButton setImage:crxSelectedImage forState:UIControlStateNormal];
        self.crxCurrentImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.crxCurrentImageButton.accessibilityIdentifier = @"crx_forge_has_image";
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.crxPlaceholderLabel.hidden = textView.text.length > 0;
}

@end
