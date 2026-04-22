//
//  CAREXQVideoCallController.m
//  CAREXQ
//
//  Created by OpenAI on 2026/4/10.
//

#import "CAREXQVideoCallController.h"
#import "CAREXQImage.h"

@interface CAREXQVideoCallController ()

@property (nonatomic, strong) dispatch_source_t crxTimeoutSource;

@end

@implementation CAREXQVideoCallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self crx_buildViews];
    [self crx_startTimeout];
}

- (void)dealloc {
    [self crx_cancelTimeout];
}

- (void)crx_buildViews {
    self.view.backgroundColor = UIColor.blackColor;

    UIImage *crxBackgroundImage = self.crxMessageItem[@"crxBackground"];
    if (!crxBackgroundImage) {
        NSString *crxName = self.crxMessageItem[@"crxName"] ?: @"Hayden";
        NSArray<NSString *> *crxNames = @[@"Hayden", @"Carson", @"Bennett", @"Holden", @"Tanner", @"Garrett", @"Malcolm", @"Alyssa"];
        NSUInteger crxIndex = [crxNames indexOfObject:crxName];
        NSInteger crxImageIndex = crxIndex == NSNotFound ? 1 : (((NSInteger)crxIndex * 2) % 16) + 1;
        crxBackgroundImage = [CAREXQImage imageNamed:[NSString stringWithFormat:@"crx_dy_%ld", (long)crxImageIndex]];
    }

    UIImageView *crxBackgroundView = [[UIImageView alloc] initWithImage:crxBackgroundImage ?: [CAREXQImage imageNamed:@"crx_dy_1"]];
    crxBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    crxBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxBackgroundView];

    UIView *crxMaskView = [[UIView alloc] init];
    crxMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.52];
    crxMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxMaskView];

    UIButton *crxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxBackButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.44];
    crxBackButton.layer.cornerRadius = 11;
    [crxBackButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    crxBackButton.tintColor = UIColor.whiteColor;
    [crxBackButton addTarget:self action:@selector(crx_endCallTapped) forControlEvents:UIControlEventTouchUpInside];
    crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxBackButton];

    UIButton *crxMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxMoreButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.44];
    crxMoreButton.layer.cornerRadius = 11;
    [crxMoreButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    crxMoreButton.tintColor = UIColor.whiteColor;
    crxMoreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxMoreButton];

    UIImageView *crxAvatarView = [[UIImageView alloc] initWithImage:self.crxMessageItem[@"crxAvatar"] ?: [CAREXQImage imageNamed:@"crx_head_1"]];
    crxAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    crxAvatarView.layer.cornerRadius = 56;
    crxAvatarView.layer.borderWidth = 3;
    crxAvatarView.layer.borderColor = [UIColor colorWithRed:0.94 green:0.08 blue:0.82 alpha:1.0].CGColor;
    crxAvatarView.clipsToBounds = YES;
    crxAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxAvatarView];

    UILabel *crxNameLabel = [[UILabel alloc] init];
    crxNameLabel.text = [NSString stringWithFormat:@"%@ Call", self.crxMessageItem[@"crxName"] ?: @"Hayden"];
    crxNameLabel.textColor = UIColor.whiteColor;
    crxNameLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBold];
    crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxNameLabel];

    UILabel *crxStatusLabel = [[UILabel alloc] init];
    crxStatusLabel.text = @"Call...";
    crxStatusLabel.textColor = [UIColor colorWithWhite:1 alpha:0.78];
    crxStatusLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    crxStatusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxStatusLabel];

    UIButton *crxAcceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxAcceptButton.backgroundColor = [UIColor colorWithRed:0.22 green:0.88 blue:0.24 alpha:1.0];
    crxAcceptButton.layer.cornerRadius = 34;
    [crxAcceptButton setImage:[UIImage systemImageNamed:@"phone.fill"] forState:UIControlStateNormal];
    crxAcceptButton.tintColor = UIColor.whiteColor;
    crxAcceptButton.userInteractionEnabled = NO;
    crxAcceptButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxAcceptButton];

    UIButton *crxDeclineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxDeclineButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.33 blue:0.33 alpha:1.0];
    crxDeclineButton.layer.cornerRadius = 34;
    [crxDeclineButton setImage:[UIImage systemImageNamed:@"phone.down.fill"] forState:UIControlStateNormal];
    crxDeclineButton.tintColor = UIColor.whiteColor;
    [crxDeclineButton addTarget:self action:@selector(crx_endCallTapped) forControlEvents:UIControlEventTouchUpInside];
    crxDeclineButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxDeclineButton];

    [NSLayoutConstraint activateConstraints:@[
        [crxBackgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxBackgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxBackgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxBackgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [crxMaskView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxMaskView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxMaskView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxMaskView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:12],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [crxBackButton.widthAnchor constraintEqualToConstant:34],
        [crxBackButton.heightAnchor constraintEqualToConstant:34],

        [crxMoreButton.topAnchor constraintEqualToAnchor:crxBackButton.topAnchor],
        [crxMoreButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-18],
        [crxMoreButton.widthAnchor constraintEqualToConstant:34],
        [crxMoreButton.heightAnchor constraintEqualToConstant:34],

        [crxAvatarView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [crxAvatarView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:110],
        [crxAvatarView.widthAnchor constraintEqualToConstant:112],
        [crxAvatarView.heightAnchor constraintEqualToConstant:112],

        [crxNameLabel.topAnchor constraintEqualToAnchor:crxAvatarView.bottomAnchor constant:18],
        [crxNameLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],

        [crxStatusLabel.topAnchor constraintEqualToAnchor:crxNameLabel.bottomAnchor constant:8],
        [crxStatusLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],

        [crxAcceptButton.leadingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-92],
        [crxAcceptButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-56],
        [crxAcceptButton.widthAnchor constraintEqualToConstant:68],
        [crxAcceptButton.heightAnchor constraintEqualToConstant:68],

        [crxDeclineButton.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:92],
        [crxDeclineButton.centerYAnchor constraintEqualToAnchor:crxAcceptButton.centerYAnchor],
        [crxDeclineButton.widthAnchor constraintEqualToConstant:68],
        [crxDeclineButton.heightAnchor constraintEqualToConstant:68]
    ]];
}

- (void)crx_startTimeout {
    [self crx_cancelTimeout];
    dispatch_queue_t crxQueue = dispatch_get_main_queue();
    self.crxTimeoutSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, crxQueue);
    dispatch_source_set_timer(self.crxTimeoutSource, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), DISPATCH_TIME_FOREVER, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.crxTimeoutSource, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf crx_cancelTimeout];
        [strongSelf dismissViewControllerAnimated:YES completion:^{
            if (strongSelf.crxTimeoutHandler) {
                strongSelf.crxTimeoutHandler();
            }
        }];
    });
    dispatch_resume(self.crxTimeoutSource);
}

- (void)crx_cancelTimeout {
    if (self.crxTimeoutSource) {
        dispatch_source_cancel(self.crxTimeoutSource);
        self.crxTimeoutSource = nil;
    }
}

- (void)crx_endCallTapped {
    [self crx_cancelTimeout];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
