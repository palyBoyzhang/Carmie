//
//  CRXEntryController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXEntryController.h"

@interface CRXEntryController ()

@end

@implementation CRXEntryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCRXEntryViews];
}

- (void)setCRXEntryViews {
    UILabel *crxwlLabel = [[UILabel alloc] init];
    crxwlLabel.text = @"Welcome login";
    crxwlLabel.textColor = UIColor.whiteColor;
    crxwlLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightBlack)];
    [self.view addSubview:crxwlLabel];
    crxwlLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxwlLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:90],
        [crxwlLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    UILabel *crxelLabel = [[UILabel alloc] init];
    crxelLabel.text = @"Email";
    crxelLabel.textColor = UIColor.whiteColor;
    crxelLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];
    [self.view addSubview:crxelLabel];
    crxelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxelLabel.topAnchor constraintEqualToAnchor:crxwlLabel.bottomAnchor constant:70],
        [crxelLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15]
    ]];
    
    UIView *crxelView = [[UIView alloc] init];
    crxelView.backgroundColor = [UIColor colorWithRed:0x33/255.0 green:0x02/255.0 blue:0x41/255.0 alpha:1];
    crxelView.clipsToBounds = YES;
    crxelView.layer.cornerRadius = 16.f;
    crxelView.layer.borderWidth = 1.f;
    crxelView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    [self.view addSubview:crxelView];
    crxelView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxelView.topAnchor constraintEqualToAnchor:crxelLabel.bottomAnchor constant:12],
        [crxelView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
        [crxelView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
        [crxelView.heightAnchor constraintEqualToConstant:52]
    ]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
