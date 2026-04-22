//
//  CMRPrivacyController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CMRPrivacyController.h"

@interface CMRPrivacyController ()

@end

@implementation CMRPrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Privacy Agreement";
    [self crx_setupPrivacyViews];
}

- (void)crx_setupPrivacyViews {
    UITextView *crxTextView = [[UITextView alloc] init];
    crxTextView.backgroundColor = UIColor.clearColor;
    crxTextView.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    crxTextView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    crxTextView.editable = NO;
    crxTextView.textContainerInset = UIEdgeInsetsMake(20, 16, 40, 16);
    crxTextView.text = @"This page is used to display the privacy agreement content.\n\nWe respect your privacy and explain here how the app may collect, store, and use information required for basic product functions. The exact data rules can be updated later according to the final business design.\n\n1. Basic information entered on the login page is only used for the current local interaction flow.\n2. The app should clearly inform users before requesting device permissions.\n3. If the privacy policy is updated, the latest displayed version will be the current reference.\n\nPlease read the content carefully before continuing to use related features.";
    [self.view addSubview:crxTextView];
    crxTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxTextView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [crxTextView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxTextView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxTextView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

@end
