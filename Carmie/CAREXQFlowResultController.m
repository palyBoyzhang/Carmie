//
//  CAREXQFlowResultController.m
//  CAREXQ
//
//  Created by OpenAI on 2026/4/9.
//

#import "CAREXQFlowResultController.h"
#import "CAREXQImage.h"

@interface CAREXQFlowResultController ()

@property (nonatomic, strong) UITextView *crxResultTextView;

@end

@implementation CAREXQFlowResultController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x09/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1.0];
    [self crx_buildViews];
}

- (void)crx_buildViews {
    UIImageView *crxHeroImageView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_flow_bg"]];
    crxHeroImageView.contentMode = UIViewContentModeScaleAspectFill;
    crxHeroImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxHeroImageView];

    UIButton *crxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxBackButton.backgroundColor = [UIColor colorWithRed:0x1B/255.0 green:0x0E/255.0 blue:0x2F/255.0 alpha:0.92];
    crxBackButton.layer.cornerRadius = 11.f;
    UIImageSymbolConfiguration *crxBackConfig = [UIImageSymbolConfiguration configurationWithPointSize:16 weight:UIFontWeightBold];
    [crxBackButton setImage:[UIImage systemImageNamed:@"chevron.left" withConfiguration:crxBackConfig] forState:UIControlStateNormal];
    crxBackButton.tintColor = UIColor.whiteColor;
    [crxBackButton addTarget:self action:@selector(crx_backTapped) forControlEvents:UIControlEventTouchUpInside];
    crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxBackButton];

    UIView *crxPanelView = [[UIView alloc] init];
    crxPanelView.backgroundColor = [UIColor colorWithRed:0x1A/255.0 green:0x15/255.0 blue:0x34/255.0 alpha:0.97];
    crxPanelView.layer.cornerRadius = 20.f;
    crxPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxPanelView];

    self.crxResultTextView = [[UITextView alloc] init];
    self.crxResultTextView.backgroundColor = UIColor.clearColor;
    self.crxResultTextView.textColor = UIColor.whiteColor;
    self.crxResultTextView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.crxResultTextView.editable = NO;
    self.crxResultTextView.selectable = YES;
    self.crxResultTextView.showsVerticalScrollIndicator = NO;
    self.crxResultTextView.textContainerInset = UIEdgeInsetsMake(16, 14, 16, 14);
    self.crxResultTextView.textContainer.lineFragmentPadding = 0;
    self.crxResultTextView.text = self.crxResultText.length > 0 ? self.crxResultText : @"No result available.";
    self.crxResultTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [crxPanelView addSubview:self.crxResultTextView];

    [NSLayoutConstraint activateConstraints:@[
        [crxHeroImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxHeroImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxHeroImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxHeroImageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [crxBackButton.widthAnchor constraintEqualToConstant:36],
        [crxBackButton.heightAnchor constraintEqualToConstant:36],

        [crxPanelView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:305],
        [crxPanelView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [crxPanelView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [crxPanelView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-18],

        [self.crxResultTextView.topAnchor constraintEqualToAnchor:crxPanelView.topAnchor],
        [self.crxResultTextView.leadingAnchor constraintEqualToAnchor:crxPanelView.leadingAnchor],
        [self.crxResultTextView.trailingAnchor constraintEqualToAnchor:crxPanelView.trailingAnchor],
        [self.crxResultTextView.bottomAnchor constraintEqualToAnchor:crxPanelView.bottomAnchor]
    ]];
}

- (void)crx_backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
