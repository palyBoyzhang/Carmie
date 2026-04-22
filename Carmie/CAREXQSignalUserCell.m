//
//  CAREXQSignalUserCell.m
//  CAREXQ
//
//  Created by OpenAI on 2026/4/7.
//

#import "CAREXQSignalUserCell.h"

@interface CAREXQSignalUserCell ()

@property (nonatomic, strong) UIImageView *crxAvatarImageView;
@property (nonatomic, strong) UIView *crxOnlineView;
@property (nonatomic, strong) UILabel *crxNameLabel;

@end

@implementation CAREXQSignalUserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self crx_buildViews];
    }
    return self;
}

- (void)crx_buildViews {
    self.backgroundColor = UIColor.clearColor;
    
    self.crxAvatarImageView = [[UIImageView alloc] init];
    self.crxAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxAvatarImageView.clipsToBounds = YES;
    self.crxAvatarImageView.layer.cornerRadius = 28.f;
    self.crxAvatarImageView.layer.borderWidth = 1.f;
    self.crxAvatarImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.16].CGColor;
    [self.contentView addSubview:self.crxAvatarImageView];
    self.crxAvatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxOnlineView = [[UIView alloc] init];
    self.crxOnlineView.backgroundColor = [UIColor colorWithRed:0.35 green:0.97 blue:0.34 alpha:1];
    self.crxOnlineView.layer.cornerRadius = 5.f;
    self.crxOnlineView.layer.borderWidth = 1.5f;
    self.crxOnlineView.layer.borderColor = [UIColor colorWithRed:0x1A/255.0 green:0x0D/255.0 blue:0x2F/255.0 alpha:1].CGColor;
    [self.contentView addSubview:self.crxOnlineView];
    self.crxOnlineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxNameLabel = [[UILabel alloc] init];
    self.crxNameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.78];
    self.crxNameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.crxNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.crxNameLabel];
    self.crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.crxAvatarImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.crxAvatarImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.crxAvatarImageView.widthAnchor constraintEqualToConstant:56],
        [self.crxAvatarImageView.heightAnchor constraintEqualToConstant:56],
        
        [self.crxOnlineView.topAnchor constraintEqualToAnchor:self.crxAvatarImageView.topAnchor constant:2],
        [self.crxOnlineView.leadingAnchor constraintEqualToAnchor:self.crxAvatarImageView.leadingAnchor constant:2],
        [self.crxOnlineView.widthAnchor constraintEqualToConstant:10],
        [self.crxOnlineView.heightAnchor constraintEqualToConstant:10],
        
        [self.crxNameLabel.topAnchor constraintEqualToAnchor:self.crxAvatarImageView.bottomAnchor constant:8],
        [self.crxNameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.crxNameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor]
    ]];
}

- (void)crx_configureWithName:(NSString *)crxName image:(UIImage *)crxImage {
    self.crxNameLabel.text = crxName;
    self.crxAvatarImageView.image = crxImage;
}

@end
