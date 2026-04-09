//
//  CRXControlController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXControlController.h"

@interface CRXControlController ()

@end

@implementation CRXControlController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x08/255.0 green:0x08/255.0 blue:0x23/255.0 alpha:1];
    [self crx_buildViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)crx_buildViews {
    UIButton *crxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxBackButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.46];
    crxBackButton.layer.cornerRadius = 11;
    [crxBackButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    crxBackButton.tintColor = UIColor.whiteColor;
    [crxBackButton addTarget:self action:@selector(crx_backTapped) forControlEvents:UIControlEventTouchUpInside];
    crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxBackButton];

    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.text = @"Control Center";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightHeavy];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxTitleLabel];

    UIView *crxCardView = [[UIView alloc] init];
    crxCardView.backgroundColor = [UIColor colorWithRed:0x18/255.0 green:0x0D/255.0 blue:0x31/255.0 alpha:1];
    crxCardView.layer.cornerRadius = 24;
    crxCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxCardView];

    NSArray<NSArray *> *crxItems = @[
        @[@"Account Status", @"Normal"],
        @[@"Content Mode", @"Gesture Only"],
        @[@"Notification Sync", @"Enabled"],
        @[@"Storage Snapshot", @"128 MB"]
    ];
    UIView *crxPreviousRow = nil;
    for (NSArray *crxItem in crxItems) {
        UIView *crxRow = [[UIView alloc] init];
        crxRow.translatesAutoresizingMaskIntoConstraints = NO;
        [crxCardView addSubview:crxRow];

        UILabel *crxLeftLabel = [[UILabel alloc] init];
        crxLeftLabel.text = crxItem[0];
        crxLeftLabel.textColor = UIColor.whiteColor;
        crxLeftLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        crxLeftLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [crxRow addSubview:crxLeftLabel];

        UILabel *crxRightLabel = [[UILabel alloc] init];
        crxRightLabel.text = crxItem[1];
        crxRightLabel.textColor = [UIColor colorWithWhite:1 alpha:0.62];
        crxRightLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        crxRightLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [crxRow addSubview:crxRightLabel];

        UIView *crxLine = [[UIView alloc] init];
        crxLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
        crxLine.translatesAutoresizingMaskIntoConstraints = NO;
        [crxRow addSubview:crxLine];

        [NSLayoutConstraint activateConstraints:@[
            [crxRow.leadingAnchor constraintEqualToAnchor:crxCardView.leadingAnchor constant:18],
            [crxRow.trailingAnchor constraintEqualToAnchor:crxCardView.trailingAnchor constant:-18],
            crxPreviousRow ? [crxRow.topAnchor constraintEqualToAnchor:crxPreviousRow.bottomAnchor constant:8] : [crxRow.topAnchor constraintEqualToAnchor:crxCardView.topAnchor constant:16],

            [crxLeftLabel.topAnchor constraintEqualToAnchor:crxRow.topAnchor constant:10],
            [crxLeftLabel.leadingAnchor constraintEqualToAnchor:crxRow.leadingAnchor],

            [crxRightLabel.centerYAnchor constraintEqualToAnchor:crxLeftLabel.centerYAnchor],
            [crxRightLabel.trailingAnchor constraintEqualToAnchor:crxRow.trailingAnchor],

            [crxLine.topAnchor constraintEqualToAnchor:crxLeftLabel.bottomAnchor constant:12],
            [crxLine.leadingAnchor constraintEqualToAnchor:crxRow.leadingAnchor],
            [crxLine.trailingAnchor constraintEqualToAnchor:crxRow.trailingAnchor],
            [crxLine.heightAnchor constraintEqualToConstant:1],
            [crxLine.bottomAnchor constraintEqualToAnchor:crxRow.bottomAnchor]
        ]];
        crxPreviousRow = crxRow;
    }

    UIButton *crxActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crxActionButton setTitle:@"Apply" forState:UIControlStateNormal];
    [crxActionButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    crxActionButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    crxActionButton.layer.cornerRadius = 24;
    crxActionButton.clipsToBounds = YES;
    crxActionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:crxActionButton];

    CAGradientLayer *crxGradient = [CAGradientLayer layer];
    crxGradient.colors = @[
        (__bridge id)[UIColor colorWithRed:1.0 green:0.62 blue:0.26 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:1.0 green:0.16 blue:0.60 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.45 green:0.24 blue:1.0 alpha:1.0].CGColor
    ];
    crxGradient.startPoint = CGPointMake(0, 0.5);
    crxGradient.endPoint = CGPointMake(1, 0.5);
    [crxActionButton.layer insertSublayer:crxGradient atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
        [crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:12],
        [crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [crxBackButton.widthAnchor constraintEqualToConstant:34],
        [crxBackButton.heightAnchor constraintEqualToConstant:34],

        [crxTitleLabel.topAnchor constraintEqualToAnchor:crxBackButton.bottomAnchor constant:20],
        [crxTitleLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],

        [crxCardView.topAnchor constraintEqualToAnchor:crxTitleLabel.bottomAnchor constant:24],
        [crxCardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [crxCardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],

        [crxCardView.bottomAnchor constraintEqualToAnchor:crxPreviousRow.bottomAnchor constant:16],

        [crxActionButton.leadingAnchor constraintEqualToAnchor:crxCardView.leadingAnchor],
        [crxActionButton.trailingAnchor constraintEqualToAnchor:crxCardView.trailingAnchor],
        [crxActionButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-18],
        [crxActionButton.heightAnchor constraintEqualToConstant:48]
    ]];

    dispatch_async(dispatch_get_main_queue(), ^{
        crxGradient.frame = crxActionButton.bounds;
    });
}

- (void)crx_backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
