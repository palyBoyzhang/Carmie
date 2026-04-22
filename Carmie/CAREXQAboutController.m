//
//  CAREXQAboutController.m
//  CAREXQ
//
//  Created by OpenAI on 2026/4/2.
//

#import "CAREXQAboutController.h"
#import "CAREXQImage.h"

@implementation CAREXQAboutController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildViews];
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
    crxTitleLabel.text = @"About Us";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont italicSystemFontOfSize:18];
    [self.view addSubview:crxTitleLabel];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxTitleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [crxTitleLabel.centerYAnchor constraintEqualToAnchor:crxBackButton.centerYAnchor]
    ]];
    
    UIView *crxIconCardView = [[UIView alloc] init];
    crxIconCardView.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x0D/255.0 blue:0x3C/255.0 alpha:0.52];
    crxIconCardView.layer.cornerRadius = 14.f;
    crxIconCardView.layer.borderWidth = 1.f;
    crxIconCardView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    [self.view addSubview:crxIconCardView];
    crxIconCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *crxIconView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_harbor_logo"]];
    crxIconView.contentMode = UIViewContentModeScaleAspectFit;
    [crxIconCardView addSubview:crxIconView];
    crxIconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *crxNameLabel = [[UILabel alloc] init];
    crxNameLabel.text = @"Carmie";
    crxNameLabel.textColor = UIColor.whiteColor;
    crxNameLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    [self.view addSubview:crxNameLabel];
    crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *crxVersionLabel = [[UILabel alloc] init];
    crxVersionLabel.textColor = [UIColor colorWithWhite:1 alpha:0.68];
    crxVersionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    crxVersionLabel.text = [NSString stringWithFormat:@"Version %@", [self crx_currentVersionText]];
    [self.view addSubview:crxVersionLabel];
    crxVersionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [crxIconCardView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:188],
        [crxIconCardView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [crxIconCardView.widthAnchor constraintEqualToConstant:86],
        [crxIconCardView.heightAnchor constraintEqualToConstant:86],
        
        [crxIconView.centerXAnchor constraintEqualToAnchor:crxIconCardView.centerXAnchor],
        [crxIconView.centerYAnchor constraintEqualToAnchor:crxIconCardView.centerYAnchor],
        [crxIconView.widthAnchor constraintEqualToConstant:64],
        [crxIconView.heightAnchor constraintEqualToConstant:64],
        
        [crxNameLabel.topAnchor constraintEqualToAnchor:crxIconCardView.bottomAnchor constant:18],
        [crxNameLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [crxVersionLabel.topAnchor constraintEqualToAnchor:crxNameLabel.bottomAnchor constant:6],
        [crxVersionLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (NSString *)crx_currentVersionText {
    NSString *crxShortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *crxBuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    if (crxShortVersion.length > 0) {
        return crxShortVersion;
    }
    
    if (crxBuildVersion.length > 0) {
        return crxBuildVersion;
    }
    
    return @"1.0.0";
}

- (void)crxBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
