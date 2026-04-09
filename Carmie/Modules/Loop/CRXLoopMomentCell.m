//
//  CRXLoopMomentCell.m
//  Carmie
//
//  Created by OpenAI on 2026/4/7.
//

#import "CRXLoopMomentCell.h"

@interface CRXLoopMomentCell ()

@property (nonatomic, strong) UIView *crxCardView;
@property (nonatomic, strong) UIImageView *crxAvatarImageView;
@property (nonatomic, strong) UILabel *crxNameLabel;
@property (nonatomic, strong) UILabel *crxDateLabel;
@property (nonatomic, strong) UIImageView *crxPhoneImageView;
@property (nonatomic, strong) UILabel *crxContentLabel;
@property (nonatomic, strong) UIImageView *crxLeftImageView;
@property (nonatomic, strong) UIImageView *crxRightImageView;
@property (nonatomic, strong) UIView *crxCommentView;
@property (nonatomic, strong) UILabel *crxCommentLabel;
@property (nonatomic, strong) UIButton *crxLikeButton;
@property (nonatomic, strong) UIButton *crxFollowButton;
@property (nonatomic, strong) UIButton *crxWarnButton;

@end

@implementation CRXLoopMomentCell

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
    self.crxCardView.backgroundColor = [UIColor colorWithRed:0x1D/255.0 green:0x0C/255.0 blue:0x34/255.0 alpha:0.92];
    self.crxCardView.layer.cornerRadius = 20.f;
    self.crxCardView.layer.borderWidth = 1.f;
    self.crxCardView.layer.borderColor = [UIColor colorWithRed:0.20 green:0.72 blue:0.94 alpha:0.56].CGColor;
    [self.contentView addSubview:self.crxCardView];
    self.crxCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxAvatarImageView = [[UIImageView alloc] init];
    self.crxAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxAvatarImageView.clipsToBounds = YES;
    self.crxAvatarImageView.layer.cornerRadius = 16.f;
    [self.crxCardView addSubview:self.crxAvatarImageView];
    self.crxAvatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxNameLabel = [[UILabel alloc] init];
    self.crxNameLabel.textColor = UIColor.whiteColor;
    self.crxNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.crxCardView addSubview:self.crxNameLabel];
    self.crxNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxDateLabel = [[UILabel alloc] init];
    self.crxDateLabel.textColor = [UIColor colorWithWhite:1 alpha:0.52];
    self.crxDateLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    [self.crxCardView addSubview:self.crxDateLabel];
    self.crxDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxPhoneImageView = [[UIImageView alloc] init];
    self.crxPhoneImageView.image = [UIImage imageNamed:@"crx_board_pho"];
    [self.crxCardView addSubview:self.crxPhoneImageView];
    self.crxPhoneImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxContentLabel = [[UILabel alloc] init];
    self.crxContentLabel.textColor = [UIColor colorWithWhite:1 alpha:0.74];
    self.crxContentLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.crxContentLabel.numberOfLines = 0;
    [self.crxCardView addSubview:self.crxContentLabel];
    self.crxContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxLeftImageView = [self crx_buildPostImageView];
    self.crxRightImageView = [self crx_buildPostImageView];
    
    self.crxCommentView = [[UIView alloc] init];
    self.crxCommentView.backgroundColor = [UIColor colorWithRed:0x2B/255.0 green:0x1A/255.0 blue:0x41/255.0 alpha:0.98];
    self.crxCommentView.layer.cornerRadius = 18.f;
    [self.crxCardView addSubview:self.crxCommentView];
    self.crxCommentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *crxCommentIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_board_add"]];
    crxCommentIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.crxCommentView addSubview:crxCommentIconView];
    crxCommentIconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxCommentLabel = [[UILabel alloc] init];
    self.crxCommentLabel.text = @"Add comments...";
    self.crxCommentLabel.textColor = [UIColor colorWithWhite:1 alpha:0.58];
    self.crxCommentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.crxCommentView addSubview:self.crxCommentLabel];
    self.crxCommentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxLikeButton = [self crx_buildCircleButtonWithImageName:@"crx_board_aixin"];
    self.crxFollowButton = [self crx_buildCircleButtonWithImageName:@"crx_board_flo"];
    self.crxWarnButton = [self crx_buildCircleButtonWithImageName:@"crx_board_more"];
    [self.crxWarnButton addTarget:self action:@selector(crx_moreTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.crxCardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.crxCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.crxCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.crxCardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-12],
        
        [self.crxAvatarImageView.topAnchor constraintEqualToAnchor:self.crxCardView.topAnchor constant:14],
        [self.crxAvatarImageView.leadingAnchor constraintEqualToAnchor:self.crxCardView.leadingAnchor constant:14],
        [self.crxAvatarImageView.widthAnchor constraintEqualToConstant:32],
        [self.crxAvatarImageView.heightAnchor constraintEqualToConstant:32],
        
        [self.crxNameLabel.topAnchor constraintEqualToAnchor:self.crxAvatarImageView.topAnchor],
        [self.crxNameLabel.leadingAnchor constraintEqualToAnchor:self.crxAvatarImageView.trailingAnchor constant:10],
        [self.crxNameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.crxPhoneImageView.leadingAnchor constant:-10],
        
        [self.crxDateLabel.leadingAnchor constraintEqualToAnchor:self.crxNameLabel.leadingAnchor],
        [self.crxDateLabel.topAnchor constraintEqualToAnchor:self.crxNameLabel.bottomAnchor constant:3],
        
        [self.crxPhoneImageView.trailingAnchor constraintEqualToAnchor:self.crxCardView.trailingAnchor constant:-14],
        [self.crxPhoneImageView.centerYAnchor constraintEqualToAnchor:self.crxAvatarImageView.centerYAnchor],
        
        [self.crxContentLabel.topAnchor constraintEqualToAnchor:self.crxAvatarImageView.bottomAnchor constant:12],
        [self.crxContentLabel.leadingAnchor constraintEqualToAnchor:self.crxAvatarImageView.leadingAnchor],
        [self.crxContentLabel.trailingAnchor constraintEqualToAnchor:self.crxPhoneImageView.trailingAnchor],
        
        [self.crxLeftImageView.topAnchor constraintEqualToAnchor:self.crxContentLabel.bottomAnchor constant:12],
        [self.crxLeftImageView.leadingAnchor constraintEqualToAnchor:self.crxContentLabel.leadingAnchor],
        [self.crxLeftImageView.widthAnchor constraintEqualToConstant:140],
        [self.crxLeftImageView.heightAnchor constraintEqualToConstant:168],
        
        [self.crxRightImageView.topAnchor constraintEqualToAnchor:self.crxLeftImageView.topAnchor],
        [self.crxRightImageView.leadingAnchor constraintEqualToAnchor:self.crxLeftImageView.trailingAnchor constant:10],
        [self.crxRightImageView.trailingAnchor constraintEqualToAnchor:self.crxContentLabel.trailingAnchor],
        [self.crxRightImageView.widthAnchor constraintEqualToAnchor:self.crxLeftImageView.widthAnchor],
        [self.crxRightImageView.heightAnchor constraintEqualToAnchor:self.crxLeftImageView.heightAnchor],
        
        [self.crxCommentView.topAnchor constraintEqualToAnchor:self.crxLeftImageView.bottomAnchor constant:12],
        [self.crxCommentView.leadingAnchor constraintEqualToAnchor:self.crxLeftImageView.leadingAnchor],
        [self.crxCommentView.widthAnchor constraintEqualToConstant:144],
        [self.crxCommentView.heightAnchor constraintEqualToConstant:36],
        [self.crxCommentView.bottomAnchor constraintEqualToAnchor:self.crxCardView.bottomAnchor constant:-12],
        
        [crxCommentIconView.leadingAnchor constraintEqualToAnchor:self.crxCommentView.leadingAnchor constant:12],
        [crxCommentIconView.centerYAnchor constraintEqualToAnchor:self.crxCommentView.centerYAnchor],
        [crxCommentIconView.widthAnchor constraintEqualToConstant:16],
        [crxCommentIconView.heightAnchor constraintEqualToConstant:16],
        
        [self.crxCommentLabel.leadingAnchor constraintEqualToAnchor:crxCommentIconView.trailingAnchor constant:6],
        [self.crxCommentLabel.centerYAnchor constraintEqualToAnchor:self.crxCommentView.centerYAnchor],
        
        [self.crxWarnButton.trailingAnchor constraintEqualToAnchor:self.crxContentLabel.trailingAnchor],
        [self.crxWarnButton.centerYAnchor constraintEqualToAnchor:self.crxCommentView.centerYAnchor],
        [self.crxFollowButton.trailingAnchor constraintEqualToAnchor:self.crxWarnButton.leadingAnchor constant:-10],
        [self.crxFollowButton.centerYAnchor constraintEqualToAnchor:self.crxWarnButton.centerYAnchor],
        [self.crxLikeButton.trailingAnchor constraintEqualToAnchor:self.crxFollowButton.leadingAnchor constant:-10],
        [self.crxLikeButton.centerYAnchor constraintEqualToAnchor:self.crxWarnButton.centerYAnchor]
    ]];
}

- (UIImageView *)crx_buildPostImageView {
    UIImageView *crxImageView = [[UIImageView alloc] init];
    crxImageView.contentMode = UIViewContentModeScaleAspectFill;
    crxImageView.clipsToBounds = YES;
    crxImageView.layer.cornerRadius = 14.f;
    [self.crxCardView addSubview:crxImageView];
    crxImageView.translatesAutoresizingMaskIntoConstraints = NO;
    return crxImageView;
}

- (UIButton *)crx_buildCircleButtonWithImageName:(NSString *)crxImageName {
    UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crxButton.backgroundColor = UIColor.clearColor;
    crxButton.layer.cornerRadius = 18.f;
    crxButton.layer.borderWidth = 1.f;
    crxButton.layer.borderColor = [UIColor colorWithRed:0.91 green:0.08 blue:0.82 alpha:1].CGColor;
    [crxButton setImage:[UIImage imageNamed:crxImageName] forState:UIControlStateNormal];
    [self.crxCardView addSubview:crxButton];
    crxButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxButton.widthAnchor constraintEqualToConstant:36],
        [crxButton.heightAnchor constraintEqualToConstant:36]
    ]];
    return crxButton;
}

- (void)crx_configureWithMoment:(NSDictionary *)crxMoment {
    self.crxAvatarImageView.image = crxMoment[@"crxAvatar"];
    self.crxNameLabel.text = crxMoment[@"crxName"];
    self.crxDateLabel.text = crxMoment[@"crxDate"];
    self.crxContentLabel.text = crxMoment[@"crxContent"];
    self.crxLeftImageView.image = crxMoment[@"crxImageLeft"];
    self.crxRightImageView.image = crxMoment[@"crxImageRight"];
}

- (void)crx_moreTapped {
    if (self.crxMoreTappedBlock) {
        self.crxMoreTappedBlock();
    }
}

@end
