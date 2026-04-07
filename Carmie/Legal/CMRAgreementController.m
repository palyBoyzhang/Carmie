//
//  CMRAgreementController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CMRAgreementController.h"

@interface CMRAgreementController ()

@end

@implementation CMRAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"User Agreement";
    [self crx_setupAgreementViews];
}

- (void)crx_setupAgreementViews {
    UITextView *crxTextView = [[UITextView alloc] init];
    crxTextView.backgroundColor = UIColor.clearColor;
    crxTextView.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    crxTextView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    crxTextView.editable = NO;
    crxTextView.textContainerInset = UIEdgeInsetsMake(20, 16, 40, 16);
    crxTextView.text = @"Welcome to Carmie.\n\nThis page is used to display the user agreement content. Before you continue to use the login function, please read the agreement terms carefully and confirm that you understand the service description, account usage rules, and general conduct requirements.\n\n1. The content shown in the app is for product display and functional experience.\n2. Please keep your account information safe and avoid sharing your password with others.\n3. If the agreement content is updated later, the latest version displayed in the app will prevail.\n\nThank you for your support.";
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
