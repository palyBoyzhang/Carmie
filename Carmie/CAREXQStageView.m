//
//  CAREXQStageView.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/17.
//

#import "CAREXQStageView.h"
#import "CAREXQImage.h"
#import "CAREXQFlowController.h"
#import "CAREXQStudioController.h"

@implementation CAREXQStageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self setCAREXQStageViews];
    }
    return self;
}

- (void)setCAREXQStageViews {
    UIImageView *crxAiImageView = [[UIImageView alloc] init];
    crxAiImageView.image = [CAREXQImage imageNamed:@"crx_stage_aig"];
    crxAiImageView.contentMode = UIViewContentModeScaleAspectFill;
    crxAiImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapcrxAiImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crxAiImageTapped)];
    [crxAiImageView addGestureRecognizer:tapcrxAiImage];
    [self addSubview:crxAiImageView];
    crxAiImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxAiImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [crxAiImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
        [crxAiImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-53]
    ]];
    
    UIImageView *crxEmImageView = [[UIImageView alloc] init];
    crxEmImageView.image = [CAREXQImage imageNamed:@"crx_stage_em"];
    crxEmImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapcrxEmImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crxEmImageTapped)];
    [crxEmImageView addGestureRecognizer:tapcrxEmImage];
    [self addSubview:crxEmImageView];
    crxEmImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxEmImageView.bottomAnchor constraintEqualToAnchor:crxAiImageView.bottomAnchor],
        [crxEmImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-15],
        [crxEmImageView.leadingAnchor constraintEqualToAnchor:crxAiImageView.trailingAnchor constant:10]
    ]];
    
    UIImageView *crxLcImageView = [[UIImageView alloc] init];
    crxLcImageView.image = [CAREXQImage imageNamed:@"crx_stage_lc"];
    [self addSubview:crxLcImageView];
    crxLcImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxLcImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
        [crxLcImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-12]
    ]];
}

- (void)crxAiImageTapped {
    CAREXQFlowController *crxVC = [[CAREXQFlowController alloc] init];
    [[self crx_parentNavigationController] pushViewController:crxVC animated:YES];
}

- (void)crxEmImageTapped {
    CAREXQStudioController *crxVC = [[CAREXQStudioController alloc] init];
    [[self crx_parentNavigationController] pushViewController:crxVC animated:YES];
}

- (UINavigationController *)crx_parentNavigationController {
    UIResponder *crxResponder = self;
    while (crxResponder) {
        crxResponder = crxResponder.nextResponder;
        if ([crxResponder isKindOfClass:UIViewController.class]) {
            return ((UIViewController *)crxResponder).navigationController;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
