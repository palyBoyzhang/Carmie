//
//  CRXHarborController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXHarborController.h"
#import "CRXAccessCenterController.h"
#import "CRXSettingController.h"
#import "CRXEntryController.h"
#import "CRXIdentityEditorController.h"

@interface CRXHarborController ()

@end

@implementation CRXHarborController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCRXHarborViews];
}

- (void)setCRXHarborViews {
    UIImageView *crxImageView = [[UIImageView alloc] init];
    crxImageView.image = [UIImage imageNamed:@"crx_harbor_logo"];
    crxImageView.contentMode = UIViewContentModeScaleAspectFill;
    crxImageView.clipsToBounds = YES;
    crxImageView.layer.cornerRadius = 50.f;
    crxImageView.layer.borderWidth = 1.f;
    crxImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    [self.view addSubview:crxImageView];
    crxImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxImageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [crxImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [crxImageView.widthAnchor constraintEqualToConstant:100],
        [crxImageView.heightAnchor constraintEqualToConstant:100]
    ]];
    
    UIButton *crxNameButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [crxNameButton setTitle:@"Login now." forState:(UIControlStateNormal)];
    crxNameButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightBold)];
    [crxNameButton addTarget:self action:@selector(crxNameButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:crxNameButton];
    crxNameButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxNameButton.topAnchor constraintEqualToAnchor:crxImageView.bottomAnchor constant:12],
        [crxNameButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    UIView *crxView = [[UIView alloc] init];
    crxView.backgroundColor = [UIColor colorWithRed:0x33/255.0 green:0x02/255.0 blue:0x41/255.0 alpha:1];
    crxView.clipsToBounds = YES;
    crxView.layer.cornerRadius = 12.f;
    crxView.layer.borderWidth = 1.f;
    crxView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    [self.view addSubview:crxView];
    crxView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxView.topAnchor constraintEqualToAnchor:crxNameButton.bottomAnchor constant:20],
        [crxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [crxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [crxView.heightAnchor constraintEqualToConstant:72]
    ]];
    
    UILabel *crxlsLabel = [[UILabel alloc] init];
    crxlsLabel.text = @"Likes";
    crxlsLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    crxlsLabel.font = [UIFont systemFontOfSize:12];
    crxlsLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *crxfsLabel = [[UILabel alloc] init];
    crxfsLabel.text = @"Followers";
    crxfsLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    crxfsLabel.font = [UIFont systemFontOfSize:12];
    crxfsLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *crxfgLabel = [[UILabel alloc] init];
    crxfgLabel.text = @"Following";
    crxfgLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    crxfgLabel.font = [UIFont systemFontOfSize:12];
    crxfgLabel.textAlignment = NSTextAlignmentCenter;

    UIStackView *crxStackView = [[UIStackView alloc] initWithArrangedSubviews:@[crxlsLabel,crxfsLabel,crxfgLabel]];
    crxStackView.spacing = 4;
    crxStackView.distribution = UIStackViewDistributionFillEqually;
    [crxView addSubview:crxStackView];
    crxStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxStackView.leadingAnchor constraintEqualToAnchor:crxView.leadingAnchor],
        [crxStackView.trailingAnchor constraintEqualToAnchor:crxView.trailingAnchor],
        [crxStackView.bottomAnchor constraintEqualToAnchor:crxView.bottomAnchor constant:-15]
    ]];
    
    UILabel *crxlsNumLabel = [[UILabel alloc] init];
    crxlsNumLabel.text = @"0";
    crxlsNumLabel.textColor = [UIColor whiteColor];
    crxlsNumLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];
    crxlsNumLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *crxfsNumLabel = [[UILabel alloc] init];
    crxfsNumLabel.text = @"0";
    crxfsNumLabel.textColor = [UIColor whiteColor];
    crxfsNumLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];
    crxfsNumLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *crxfgNumLabel = [[UILabel alloc] init];
    crxfgNumLabel.text = @"0";
    crxfgNumLabel.textColor = [UIColor whiteColor];
    crxfgNumLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];
    crxfgNumLabel.textAlignment = NSTextAlignmentCenter;

    UIStackView *crxNumStackView = [[UIStackView alloc] initWithArrangedSubviews:@[crxlsNumLabel,crxfsNumLabel,crxfgNumLabel]];
    crxNumStackView.spacing = 4;
    crxNumStackView.distribution = UIStackViewDistributionFillEqually;
    [crxView addSubview:crxNumStackView];
    crxNumStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxNumStackView.leadingAnchor constraintEqualToAnchor:crxView.leadingAnchor],
        [crxNumStackView.trailingAnchor constraintEqualToAnchor:crxView.trailingAnchor],
        [crxNumStackView.bottomAnchor constraintEqualToAnchor:crxStackView.topAnchor constant:-5]
    ]];
    
    UIButton *crxedtButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [crxedtButton setImage:[UIImage imageNamed:@"crx_harbor_edt"] forState:(UIControlStateNormal)];
    [crxedtButton addTarget:self action:@selector(crxedtButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *crxharbosepButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [crxharbosepButton setImage:[UIImage imageNamed:@"crx_harbor_sep"] forState:(UIControlStateNormal)];
    [crxharbosepButton addTarget:self action:@selector(crxharbosepButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIStackView *crxButtonStackView = [[UIStackView alloc] initWithArrangedSubviews:@[crxedtButton,crxharbosepButton]];
    crxButtonStackView.spacing = 10;
    [self.view addSubview:crxButtonStackView];
    crxButtonStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxButtonStackView.topAnchor constraintEqualToAnchor:crxView.bottomAnchor constant:40],
        [crxButtonStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    UIImageView *crxpatImageView = [[UIImageView alloc] init];
    crxpatImageView.image = [UIImage imageNamed:@"crx_harbor_pat"];
    [self.view addSubview:crxpatImageView];
    crxpatImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxpatImageView.topAnchor constraintEqualToAnchor:crxButtonStackView.bottomAnchor constant:30],
        [crxpatImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30]
    ]];
    
    UILabel *crxcotLabel = [[UILabel alloc] init];
    crxcotLabel.text = @"No content.";
    crxcotLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    crxcotLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:crxcotLabel];
    crxcotLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxcotLabel.topAnchor constraintEqualToAnchor:crxpatImageView.bottomAnchor constant:55],
        [crxcotLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    UIView *crxzhsView = [[UIView alloc] init];
    crxzhsView.backgroundColor = [UIColor colorWithRed:0x2E/255.0 green:0x03/255.0 blue:0x44/255.0 alpha:1];
    crxzhsView.clipsToBounds = YES;
    crxzhsView.layer.cornerRadius = 14.f;
    crxzhsView.layer.borderWidth = 1.f;
    crxzhsView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    crxzhsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapcrxzhsView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crxzhsViewTapped)];
    [crxzhsView addGestureRecognizer:tapcrxzhsView];
    [self.view addSubview:crxzhsView];
    crxzhsView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxzhsView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [crxzhsView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
        [crxzhsView.widthAnchor constraintEqualToConstant:92],
        [crxzhsView.heightAnchor constraintEqualToConstant:28]
    ]];
    
    UIImageView *crxzhsImageView = [[UIImageView alloc] init];
    crxzhsImageView.image = [UIImage imageNamed:@"crx_harbor_zhs"];
    
    UILabel *crxzhsLabel = [[UILabel alloc] init];
    crxzhsLabel.text = @"0>";
    crxzhsLabel.textColor = UIColor.whiteColor;
    crxzhsLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    
    UIStackView *crxzhsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[crxzhsImageView,crxzhsLabel]];
    crxzhsStackView.spacing = 2;
    [crxzhsView addSubview:crxzhsStackView];
    crxzhsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxzhsStackView.centerXAnchor constraintEqualToAnchor:crxzhsView.centerXAnchor],
        [crxzhsStackView.centerYAnchor constraintEqualToAnchor:crxzhsView.centerYAnchor]
    ]];
}

- (void)crxNameButtonTapped {
    CRXEntryController *crxVC = [[CRXEntryController alloc] init];
    [self.navigationController pushViewController:crxVC animated:YES];
}

- (void)crxedtButtonTapped {
    CRXIdentityEditorController *crxVC = [[CRXIdentityEditorController alloc] init];
    [self.navigationController pushViewController:crxVC animated:YES];
}

- (void)crxharbosepButtonTapped {
    CRXSettingController *crxVC = [[CRXSettingController alloc] init];
    [self.navigationController pushViewController:crxVC animated:YES];
}

- (void)crxzhsViewTapped {
    CRXAccessCenterController *crxVC = [[CRXAccessCenterController alloc] init];
    [self.navigationController pushViewController:crxVC animated:YES];
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
