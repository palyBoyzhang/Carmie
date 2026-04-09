//
//  CRXController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXController.h"
#import <objc/runtime.h>

static NSString * const CRXBlockedUserDefaultsKey = @"crx.moderation.blocked.users";
NSString * const CRXModerationDidUpdateNotification = @"CRXModerationDidUpdateNotification";
static void *CRXModerationOverlayKey = &CRXModerationOverlayKey;
static void *CRXModerationCompletionKey = &CRXModerationCompletionKey;
static void *CRXModerationUserNameKey = &CRXModerationUserNameKey;
static void *CRXModerationReportReasonKey = &CRXModerationReportReasonKey;
static void *CRXModerationTextViewKey = &CRXModerationTextViewKey;

@interface CRXController ()

@end

@implementation CRXController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *crxImageView = [[UIImageView alloc] init];
    crxImageView.image = [UIImage imageNamed:@"crx_bg_icon"];
    crxImageView.contentMode = UIViewContentModeScaleAspectFill;
    crxImageView.frame = UIScreen.mainScreen.bounds;
    [self.view addSubview:crxImageView];
}

+ (NSMutableSet<NSString *> *)crx_blockedUserSet {
    NSArray<NSString *> *crxNames = [NSUserDefaults.standardUserDefaults objectForKey:CRXBlockedUserDefaultsKey];
    return [NSMutableSet setWithArray:crxNames ?: @[]];
}

+ (void)crx_saveBlockedUserSet:(NSSet<NSString *> *)crxBlockedSet {
    NSArray<NSString *> *crxNames = crxBlockedSet.allObjects ?: @[];
    [NSUserDefaults.standardUserDefaults setObject:crxNames forKey:CRXBlockedUserDefaultsKey];
    [NSUserDefaults.standardUserDefaults synchronize];
    [NSNotificationCenter.defaultCenter postNotificationName:CRXModerationDidUpdateNotification object:nil];
}

+ (BOOL)crx_isBlockedUserName:(NSString *)crxUserName {
    if (crxUserName.length == 0) {
        return NO;
    }
    return [[self crx_blockedUserSet] containsObject:crxUserName];
}

+ (NSArray<NSDictionary *> *)crx_filterItems:(NSArray<NSDictionary *> *)crxItems nameKey:(NSString *)crxNameKey {
    if (crxItems.count == 0 || crxNameKey.length == 0) {
        return crxItems ?: @[];
    }
    NSIndexSet *crxIndexes = [crxItems indexesOfObjectsPassingTest:^BOOL(NSDictionary * _Nonnull crxItem, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *crxName = crxItem[crxNameKey];
        return ![self crx_isBlockedUserName:crxName];
    }];
    return [crxItems objectsAtIndexes:crxIndexes];
}

- (void)crx_presentModerationForUserName:(NSString *)crxUserName blockHandler:(dispatch_block_t)crxBlockHandler {
    if (crxUserName.length == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_block_t crxCompletion = ^{
        if (crxBlockHandler) {
            crxBlockHandler();
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf crx_dismissModerationOverlay];
    };
    objc_setAssociatedObject(self, CRXModerationCompletionKey, crxCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, CRXModerationUserNameKey, crxUserName, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self crx_showModerationChoiceOverlayForUserName:crxUserName];
}

- (void)crx_showModerationChoiceOverlayForUserName:(NSString *)crxUserName {
    UIView *crxOverlayView = [self crx_overlayContainer];
    UIView *crxCardView = [[UIView alloc] init];
    crxCardView.backgroundColor = [UIColor colorWithRed:0x11/255.0 green:0x08/255.0 blue:0x2A/255.0 alpha:0.98];
    crxCardView.layer.cornerRadius = 28;
    crxCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxOverlayView addSubview:crxCardView];

    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.text = @"Reporting user";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    crxTitleLabel.textAlignment = NSTextAlignmentCenter;
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCardView addSubview:crxTitleLabel];

    UILabel *crxDescLabel = [[UILabel alloc] init];
    crxDescLabel.text = @"If you find this user's behavior inappropriate or offensive, you can choose to report them to us for review or block them to prevent further interaction.";
    crxDescLabel.textColor = [UIColor colorWithWhite:1 alpha:0.80];
    crxDescLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    crxDescLabel.numberOfLines = 0;
    crxDescLabel.textAlignment = NSTextAlignmentCenter;
    crxDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCardView addSubview:crxDescLabel];

    UIButton *crxReportButton = [self crx_moderationActionButtonWithImageName:@"crx_more_report" title:@"Report" titleColor:[UIColor colorWithRed:1.0 green:0.11 blue:0.80 alpha:1.0]];
    [crxReportButton addTarget:self action:@selector(crx_showReportFormOverlay) forControlEvents:UIControlEventTouchUpInside];
    [crxCardView addSubview:crxReportButton];

    UIButton *crxBlockButton = [self crx_moderationActionButtonWithImageName:@"crx_more_block" title:@"Block" titleColor:[UIColor colorWithRed:0.14 green:0.73 blue:1.0 alpha:1.0]];
    [crxBlockButton addTarget:self action:@selector(crx_blockCurrentUser) forControlEvents:UIControlEventTouchUpInside];
    [crxCardView addSubview:crxBlockButton];

    UIButton *crxCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxCloseButton.backgroundColor = UIColor.whiteColor;
    crxCloseButton.layer.cornerRadius = 14;
    [crxCloseButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    crxCloseButton.tintColor = UIColor.blackColor;
    crxCloseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCloseButton addTarget:self action:@selector(crx_dismissModerationOverlay) forControlEvents:UIControlEventTouchUpInside];
    [crxOverlayView addSubview:crxCloseButton];

    [NSLayoutConstraint activateConstraints:@[
        [crxCardView.leadingAnchor constraintEqualToAnchor:crxOverlayView.leadingAnchor constant:20],
        [crxCardView.trailingAnchor constraintEqualToAnchor:crxOverlayView.trailingAnchor constant:-20],
        [crxCardView.bottomAnchor constraintEqualToAnchor:crxCloseButton.topAnchor constant:-18],

        [crxTitleLabel.topAnchor constraintEqualToAnchor:crxCardView.topAnchor constant:24],
        [crxTitleLabel.leadingAnchor constraintEqualToAnchor:crxCardView.leadingAnchor constant:20],
        [crxTitleLabel.trailingAnchor constraintEqualToAnchor:crxCardView.trailingAnchor constant:-20],

        [crxDescLabel.topAnchor constraintEqualToAnchor:crxTitleLabel.bottomAnchor constant:16],
        [crxDescLabel.leadingAnchor constraintEqualToAnchor:crxCardView.leadingAnchor constant:24],
        [crxDescLabel.trailingAnchor constraintEqualToAnchor:crxCardView.trailingAnchor constant:-24],

        [crxReportButton.topAnchor constraintEqualToAnchor:crxDescLabel.bottomAnchor constant:22],
        [crxReportButton.leadingAnchor constraintEqualToAnchor:crxCardView.leadingAnchor constant:18],
        [crxReportButton.heightAnchor constraintEqualToConstant:76],

        [crxBlockButton.topAnchor constraintEqualToAnchor:crxReportButton.topAnchor],
        [crxBlockButton.leadingAnchor constraintEqualToAnchor:crxReportButton.trailingAnchor constant:12],
        [crxBlockButton.trailingAnchor constraintEqualToAnchor:crxCardView.trailingAnchor constant:-18],
        [crxBlockButton.widthAnchor constraintEqualToAnchor:crxReportButton.widthAnchor],
        [crxBlockButton.heightAnchor constraintEqualToAnchor:crxReportButton.heightAnchor],
        [crxBlockButton.bottomAnchor constraintEqualToAnchor:crxCardView.bottomAnchor constant:-22],

        [crxCloseButton.centerXAnchor constraintEqualToAnchor:crxOverlayView.centerXAnchor],
        [crxCloseButton.bottomAnchor constraintEqualToAnchor:crxOverlayView.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [crxCloseButton.widthAnchor constraintEqualToConstant:28],
        [crxCloseButton.heightAnchor constraintEqualToConstant:28]
    ]];
}

- (void)crx_showReportFormOverlay {
    UIView *crxOverlayView = [self crx_overlayContainer];
    [crxOverlayView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIView *crxCardView = [[UIView alloc] init];
    crxCardView.backgroundColor = [UIColor colorWithRed:0x15/255.0 green:0x0A/255.0 blue:0x2E/255.0 alpha:0.98];
    crxCardView.layer.cornerRadius = 28;
    crxCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxOverlayView addSubview:crxCardView];

    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.text = @"Report";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    crxTitleLabel.textAlignment = NSTextAlignmentCenter;
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCardView addSubview:crxTitleLabel];

    UILabel *crxHintLabel = [[UILabel alloc] init];
    crxHintLabel.text = @"Please select the reason for reporting this user:";
    crxHintLabel.textColor = [UIColor colorWithWhite:1 alpha:0.78];
    crxHintLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    crxHintLabel.textAlignment = NSTextAlignmentCenter;
    crxHintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCardView addSubview:crxHintLabel];

    NSArray<NSString *> *crxReasons = @[@"Harassment", @"Malicious fraud", @"Malicious insults", @"Pornography", @"False Information", @"Other"];
    UIView *crxReasonWrapView = [[UIView alloc] init];
    crxReasonWrapView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCardView addSubview:crxReasonWrapView];

    CGFloat crxButtonWidth = (UIScreen.mainScreen.bounds.size.width - 40 - 40 - 12) / 2.0;
    UIButton *crxLastRowLeft = nil;
    UIButton *crxLastRowRight = nil;
    for (NSInteger crxIndex = 0; crxIndex < crxReasons.count; crxIndex++) {
        UIButton *crxReasonButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [crxReasonButton setTitle:crxReasons[crxIndex] forState:UIControlStateNormal];
        [crxReasonButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.80] forState:UIControlStateNormal];
        crxReasonButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        crxReasonButton.backgroundColor = [UIColor colorWithRed:0x24/255.0 green:0x19/255.0 blue:0x45/255.0 alpha:1.0];
        crxReasonButton.layer.cornerRadius = 18;
        crxReasonButton.layer.borderWidth = 1;
        crxReasonButton.layer.borderColor = UIColor.clearColor.CGColor;
        crxReasonButton.tag = crxIndex;
        crxReasonButton.translatesAutoresizingMaskIntoConstraints = NO;
        [crxReasonButton addTarget:self action:@selector(crx_reasonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [crxReasonWrapView addSubview:crxReasonButton];

        NSInteger crxRow = crxIndex / 2;
        NSInteger crxColumn = crxIndex % 2;
        [NSLayoutConstraint activateConstraints:@[
            [crxReasonButton.widthAnchor constraintEqualToConstant:crxButtonWidth],
            [crxReasonButton.heightAnchor constraintEqualToConstant:36]
        ]];
        if (crxColumn == 0) {
            [crxReasonButton.leadingAnchor constraintEqualToAnchor:crxReasonWrapView.leadingAnchor].active = YES;
            if (crxRow == 0) {
                [crxReasonButton.topAnchor constraintEqualToAnchor:crxReasonWrapView.topAnchor].active = YES;
            } else {
                [crxReasonButton.topAnchor constraintEqualToAnchor:crxLastRowLeft.bottomAnchor constant:12].active = YES;
            }
            crxLastRowLeft = crxReasonButton;
        } else {
            [crxReasonButton.trailingAnchor constraintEqualToAnchor:crxReasonWrapView.trailingAnchor].active = YES;
            [crxReasonButton.topAnchor constraintEqualToAnchor:crxLastRowLeft.topAnchor].active = YES;
            crxLastRowRight = crxReasonButton;
        }
    }
    [crxLastRowRight.bottomAnchor constraintEqualToAnchor:crxReasonWrapView.bottomAnchor].active = YES;

    UITextView *crxTextView = [[UITextView alloc] init];
    crxTextView.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x10/255.0 blue:0x45/255.0 alpha:0.92];
    crxTextView.layer.cornerRadius = 16;
    crxTextView.layer.borderWidth = 1;
    crxTextView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    crxTextView.textColor = [UIColor colorWithWhite:1 alpha:0.88];
    crxTextView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    crxTextView.text = @"Enter your reason here...";
    objc_setAssociatedObject(self, CRXModerationTextViewKey, crxTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    crxTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCardView addSubview:crxTextView];

    UIButton *crxSubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxSubmitButton setImage:[UIImage imageNamed:@"crx_more_submit"] forState:(UIControlStateNormal)];
    crxSubmitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [crxSubmitButton addTarget:self action:@selector(crx_submitReport) forControlEvents:UIControlEventTouchUpInside];
    [crxCardView addSubview:crxSubmitButton];

    UIButton *crxCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxCloseButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.96];
    crxCloseButton.layer.cornerRadius = 14;
    [crxCloseButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    crxCloseButton.tintColor = UIColor.blackColor;
    crxCloseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [crxCloseButton addTarget:self action:@selector(crx_dismissModerationOverlay) forControlEvents:UIControlEventTouchUpInside];
    [crxOverlayView addSubview:crxCloseButton];

    [NSLayoutConstraint activateConstraints:@[
        [crxCardView.leadingAnchor constraintEqualToAnchor:crxOverlayView.leadingAnchor constant:20],
        [crxCardView.trailingAnchor constraintEqualToAnchor:crxOverlayView.trailingAnchor constant:-20],
        [crxCardView.bottomAnchor constraintEqualToAnchor:crxCloseButton.topAnchor constant:-18],

        [crxTitleLabel.topAnchor constraintEqualToAnchor:crxCardView.topAnchor constant:20],
        [crxTitleLabel.leadingAnchor constraintEqualToAnchor:crxCardView.leadingAnchor constant:20],
        [crxTitleLabel.trailingAnchor constraintEqualToAnchor:crxCardView.trailingAnchor constant:-20],

        [crxHintLabel.topAnchor constraintEqualToAnchor:crxTitleLabel.bottomAnchor constant:14],
        [crxHintLabel.leadingAnchor constraintEqualToAnchor:crxCardView.leadingAnchor constant:20],
        [crxHintLabel.trailingAnchor constraintEqualToAnchor:crxCardView.trailingAnchor constant:-20],

        [crxReasonWrapView.topAnchor constraintEqualToAnchor:crxHintLabel.bottomAnchor constant:16],
        [crxReasonWrapView.leadingAnchor constraintEqualToAnchor:crxCardView.leadingAnchor constant:20],
        [crxReasonWrapView.trailingAnchor constraintEqualToAnchor:crxCardView.trailingAnchor constant:-20],

        [crxTextView.topAnchor constraintEqualToAnchor:crxReasonWrapView.bottomAnchor constant:16],
        [crxTextView.leadingAnchor constraintEqualToAnchor:crxReasonWrapView.leadingAnchor],
        [crxTextView.trailingAnchor constraintEqualToAnchor:crxReasonWrapView.trailingAnchor],
        [crxTextView.heightAnchor constraintEqualToConstant:104],

        [crxSubmitButton.topAnchor constraintEqualToAnchor:crxTextView.bottomAnchor constant:18],
        [crxSubmitButton.leadingAnchor constraintEqualToAnchor:crxReasonWrapView.leadingAnchor],
        [crxSubmitButton.trailingAnchor constraintEqualToAnchor:crxReasonWrapView.trailingAnchor],
        [crxSubmitButton.heightAnchor constraintEqualToConstant:48],
        [crxSubmitButton.bottomAnchor constraintEqualToAnchor:crxCardView.bottomAnchor constant:-20],

        [crxCloseButton.centerXAnchor constraintEqualToAnchor:crxOverlayView.centerXAnchor],
        [crxCloseButton.bottomAnchor constraintEqualToAnchor:crxOverlayView.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [crxCloseButton.widthAnchor constraintEqualToConstant:28],
        [crxCloseButton.heightAnchor constraintEqualToConstant:28]
    ]];
}

- (UIButton *)crx_moderationActionButtonWithImageName:(NSString *)crxImageName title:(NSString *)crxTitle titleColor:(UIColor *)crxTitleColor {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x10/255.0 blue:0x45/255.0 alpha:0.92];
    crxButton.layer.cornerRadius = 16;
    crxButton.layer.borderWidth = 1;
    crxButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    [crxButton setTitle:crxTitle forState:UIControlStateNormal];
    [crxButton setTitleColor:crxTitleColor forState:UIControlStateNormal];
    [crxButton setImage:[UIImage imageNamed:crxImageName] forState:UIControlStateNormal];
    crxButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    crxButton.tintColor = crxTitleColor;
    crxButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    return crxButton;
}

- (UIView *)crx_overlayContainer {
    UIView *crxOverlayView = objc_getAssociatedObject(self, CRXModerationOverlayKey);
    if (crxOverlayView) {
        [crxOverlayView removeFromSuperview];
    }
    crxOverlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    crxOverlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.48];
    crxOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxOverlayView];
    [NSLayoutConstraint activateConstraints:@[
        [crxOverlayView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxOverlayView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxOverlayView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxOverlayView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    objc_setAssociatedObject(self, CRXModerationOverlayKey, crxOverlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return crxOverlayView;
}

- (void)crx_dismissModerationOverlay {
    UIView *crxOverlayView = objc_getAssociatedObject(self, CRXModerationOverlayKey);
    [crxOverlayView removeFromSuperview];
    objc_setAssociatedObject(self, CRXModerationOverlayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, CRXModerationReportReasonKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, CRXModerationTextViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)crx_reasonTapped:(UIButton *)crxSender {
    UIView *crxContainer = crxSender.superview;
    for (UIButton *crxButton in crxContainer.subviews) {
        if (![crxButton isKindOfClass:UIButton.class]) {
            continue;
        }
        crxButton.layer.borderColor = UIColor.clearColor.CGColor;
        crxButton.backgroundColor = [UIColor colorWithRed:0x24/255.0 green:0x19/255.0 blue:0x45/255.0 alpha:1.0];
    }
    crxSender.layer.borderColor = [UIColor colorWithRed:1.0 green:0.58 blue:0.25 alpha:1.0].CGColor;
    crxSender.backgroundColor = [UIColor colorWithRed:0x37/255.0 green:0x0E/255.0 blue:0x4E/255.0 alpha:1.0];
    objc_setAssociatedObject(self, CRXModerationReportReasonKey, [crxSender titleForState:UIControlStateNormal], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)crx_submitReport {
    [self crx_dismissModerationOverlay];
}

- (void)crx_blockCurrentUser {
    NSString *crxUserName = objc_getAssociatedObject(self, CRXModerationUserNameKey);
    if (crxUserName.length == 0) {
        [self crx_dismissModerationOverlay];
        return;
    }
    NSMutableSet<NSString *> *crxBlockedSet = [CRXController crx_blockedUserSet];
    [crxBlockedSet addObject:crxUserName];
    [CRXController crx_saveBlockedUserSet:crxBlockedSet];

    dispatch_block_t crxCompletion = objc_getAssociatedObject(self, CRXModerationCompletionKey);
    if (crxCompletion) {
        crxCompletion();
    } else {
        [self crx_dismissModerationOverlay];
    }
}

@end
