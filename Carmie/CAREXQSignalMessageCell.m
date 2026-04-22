//
//  CAREXQSignalMessageCell.m
//  CAREXQ
//
//  Created by OpenAI on 2026/4/7.
//

#import "CAREXQSignalMessageCell.h"

@interface CAREXQSignalMessageCell ()

@property (nonatomic, strong) UIView *crxCardView;
@property (nonatomic, strong) UIImageView *crxAvatarImageView;
@property (nonatomic, strong) UILabel *crxNameLabel;
@property (nonatomic, strong) UILabel *crxPreviewLabel;
@property (nonatomic, strong) UILabel *crxTimeLabel;

@end

@implementation CAREXQSignalMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self crx_buildViews];
    }
    return self;
}

- (void)crx_buildViews {
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.crxCardView = [[UIView alloc] init];
    self.crxCardView.backgroundColor = [UIColor colorWithRed:0x24/255.0 green:0x10/255.0 blue:0x35/255.0 alpha:0.94];
    self.crxCardView.layer.cornerRadius = 18.f;
    self.crxCardView.layer.borderWidth = 1.f;
    self.crxCardView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.14].CGColor;
    [self.contentView addSubview:self.crxCardView];
    self.crxCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxAvatarImageView = [[UIImageView alloc] init];
    self.crxAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxAvatarImageView.clipsToBounds = YES;
    self.crxAvatarImageView.layer.cornerRadius = 20.f;
    [self.crxCardView addSubview:self.crxAvatarImageView];
    self.crxAvatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxNameLabel = [[UILabel alloc] init];
    self.crxNameLabel.textColor = UIColor.whiteColor;
    self.crxNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.crxCardView addSubview:self.crxNameLabel];
    self.crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxPreviewLabel = [[UILabel alloc] init];
    self.crxPreviewLabel.textColor = [UIColor colorWithWhite:1 alpha:0.42];
    self.crxPreviewLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self.crxCardView addSubview:self.crxPreviewLabel];
    self.crxPreviewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxTimeLabel = [[UILabel alloc] init];
    self.crxTimeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.34];
    self.crxTimeLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    self.crxTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.crxCardView addSubview:self.crxTimeLabel];
    self.crxTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.crxCardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.crxCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.crxCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.crxCardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        
        [self.crxAvatarImageView.leadingAnchor constraintEqualToAnchor:self.crxCardView.leadingAnchor constant:16],
        [self.crxAvatarImageView.centerYAnchor constraintEqualToAnchor:self.crxCardView.centerYAnchor],
        [self.crxAvatarImageView.widthAnchor constraintEqualToConstant:40],
        [self.crxAvatarImageView.heightAnchor constraintEqualToConstant:40],
        
        [self.crxNameLabel.topAnchor constraintEqualToAnchor:self.crxCardView.topAnchor constant:16],
        [self.crxNameLabel.leadingAnchor constraintEqualToAnchor:self.crxAvatarImageView.trailingAnchor constant:12],
        [self.crxNameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.crxCardView.trailingAnchor constant:-16],
        
        [self.crxPreviewLabel.topAnchor constraintEqualToAnchor:self.crxNameLabel.bottomAnchor constant:4],
        [self.crxPreviewLabel.leadingAnchor constraintEqualToAnchor:self.crxNameLabel.leadingAnchor],
        [self.crxPreviewLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.crxTimeLabel.leadingAnchor constant:-8],
        
        [self.crxTimeLabel.trailingAnchor constraintEqualToAnchor:self.crxCardView.trailingAnchor constant:-16],
        [self.crxTimeLabel.bottomAnchor constraintEqualToAnchor:self.crxCardView.bottomAnchor constant:-14],
        [self.crxTimeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:44]
    ]];
}

- (void)crx_configureWithMessage:(NSDictionary *)crxMessage {
    self.crxAvatarImageView.image = crxMessage[@"crxAvatar"];
    self.crxNameLabel.text = crxMessage[@"crxName"];
    self.crxPreviewLabel.text = crxMessage[@"crxPreview"];
    
    NSString *crxTime = crxMessage[@"crxTime"];
    self.crxTimeLabel.text = crxTime;
    self.crxTimeLabel.hidden = crxTime.length == 0;
}

@end
