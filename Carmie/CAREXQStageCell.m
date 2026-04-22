//
//  CAREXQStageCell.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/17.
//

#import "CAREXQStageCell.h"
#import "CAREXQImage.h"

@interface CAREXQStageCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *coverShadeView;
@property (nonatomic, strong) UIButton *crxPlayButton;
@property (nonatomic, strong) UIImageView *crxBadgeView;
@property (nonatomic, strong) UILabel *crxNameLabel;
@property (nonatomic, strong) UILabel *crxMetaLabel;
@property (nonatomic, strong) UIButton *crxMoreButton;
@property (nonatomic, strong) UILabel *crxTitleLabel;
@property (nonatomic, strong) UIView *crxGroupView;
@property (nonatomic, strong) UILabel *crxValueLabel;
@property (nonatomic, strong) UIButton *crxActionButton;
@property (nonatomic, strong) CAGradientLayer *cardGlowLayer;

@end

@implementation CAREXQStageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self crx_setupCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cardGlowLayer.frame = self.cardView.bounds;
    self.cardGlowLayer.cornerRadius = 20.f;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = [CAREXQImage imageNamed:@"crx_stage_aig"];
    self.crxBadgeView.image = [CAREXQImage imageNamed:@"crx_harbor_logo"];
    self.crxNameLabel.text = @"CAREXQ Showcase";
    self.crxMetaLabel.text = @"Preview card";
    self.crxTitleLabel.text = @"CAREXQ visual sample for layout preview and interface spacing.";
}

- (void)crx_setupCell {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor colorWithRed:0x0E/255.0 green:0x0A/255.0 blue:0x24/255.0 alpha:0.92];
    self.cardView.layer.cornerRadius = 20.f;
    self.cardView.layer.borderWidth = 1.f;
    self.cardView.layer.borderColor = [UIColor colorWithRed:0xA8/255.0 green:0x19/255.0 blue:0xF7/255.0 alpha:0.7].CGColor;
    self.cardView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.cardView];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]
    ]];
    
    self.cardGlowLayer = [CAGradientLayer layer];
    self.cardGlowLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0x7A/255.0 green:0x0E/255.0 blue:0xB8/255.0 alpha:0.35].CGColor,
        (__bridge id)[UIColor colorWithRed:0x08/255.0 green:0xC8/255.0 blue:0xFF/255.0 alpha:0.08].CGColor
    ];
    self.cardGlowLayer.startPoint = CGPointMake(0, 0);
    self.cardGlowLayer.endPoint = CGPointMake(1, 1);
    [self.cardView.layer insertSublayer:self.cardGlowLayer atIndex:0];
    
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.image = [CAREXQImage imageNamed:@"crx_stage_aig"];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.layer.cornerRadius = 16.f;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.userInteractionEnabled = YES;
    [self.cardView addSubview:self.coverImageView];
    self.coverImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.coverImageView.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:14],
        [self.coverImageView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:14],
        [self.coverImageView.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-14],
        [self.coverImageView.heightAnchor constraintEqualToConstant:214]
    ]];
    
    self.coverShadeView = [[UIView alloc] init];
    self.coverShadeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.14];
    self.coverShadeView.layer.cornerRadius = 16.f;
    self.coverShadeView.clipsToBounds = YES;
    [self.coverImageView addSubview:self.coverShadeView];
    self.coverShadeView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.coverShadeView.topAnchor constraintEqualToAnchor:self.coverImageView.topAnchor],
        [self.coverShadeView.leadingAnchor constraintEqualToAnchor:self.coverImageView.leadingAnchor],
        [self.coverShadeView.trailingAnchor constraintEqualToAnchor:self.coverImageView.trailingAnchor],
        [self.coverShadeView.bottomAnchor constraintEqualToAnchor:self.coverImageView.bottomAnchor]
    ]];
    
    self.crxPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crxPlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.38];
    self.crxPlayButton.layer.cornerRadius = 29.f;
    self.crxPlayButton.userInteractionEnabled = NO;
    UIImageSymbolConfiguration *playConfig = [UIImageSymbolConfiguration configurationWithPointSize:28 weight:UIImageSymbolWeightBold];
    UIImage *playImage = [UIImage systemImageNamed:@"play.fill" withConfiguration:playConfig];
    [self.crxPlayButton setImage:playImage forState:UIControlStateNormal];
    [self.crxPlayButton setTintColor:UIColor.whiteColor];
    [self.coverImageView addSubview:self.crxPlayButton];
    self.crxPlayButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxPlayButton.centerXAnchor constraintEqualToAnchor:self.coverImageView.centerXAnchor],
        [self.crxPlayButton.centerYAnchor constraintEqualToAnchor:self.coverImageView.centerYAnchor],
        [self.crxPlayButton.widthAnchor constraintEqualToConstant:58],
        [self.crxPlayButton.heightAnchor constraintEqualToConstant:58]
    ]];
    
    self.crxBadgeView = [[UIImageView alloc] init];
    self.crxBadgeView.image = [CAREXQImage imageNamed:@"crx_harbor_logo"];
    self.crxBadgeView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxBadgeView.layer.cornerRadius = 16;
    self.crxBadgeView.layer.borderWidth = 1.f;
    self.crxBadgeView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.65].CGColor;
    self.crxBadgeView.clipsToBounds = YES;
    [self.coverImageView addSubview:self.crxBadgeView];
    self.crxBadgeView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxBadgeView.topAnchor constraintEqualToAnchor:self.coverImageView.topAnchor constant:14],
        [self.crxBadgeView.leadingAnchor constraintEqualToAnchor:self.coverImageView.leadingAnchor constant:14],
        [self.crxBadgeView.widthAnchor constraintEqualToConstant:32],
        [self.crxBadgeView.heightAnchor constraintEqualToConstant:32]
    ]];
    
    self.crxNameLabel = [[UILabel alloc] init];
    self.crxNameLabel.text = @"CAREXQ Showcase";
    self.crxNameLabel.textColor = UIColor.whiteColor;
    self.crxNameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    
    self.crxMetaLabel = [[UILabel alloc] init];
    self.crxMetaLabel.text = @"Hand dance";
    self.crxMetaLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.crxMetaLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    
    UIStackView *crxNameStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.crxNameLabel, self.crxMetaLabel]];
    crxNameStackView.axis = UILayoutConstraintAxisVertical;
    crxNameStackView.alignment = UIStackViewAlignmentLeading;
    crxNameStackView.spacing = 1;
    [self.coverImageView addSubview:crxNameStackView];
    crxNameStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxNameStackView.centerYAnchor constraintEqualToAnchor:self.crxBadgeView.centerYAnchor],
        [crxNameStackView.leadingAnchor constraintEqualToAnchor:self.crxBadgeView.trailingAnchor constant:8]
    ]];
    
    self.crxMoreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *moreImage = [CAREXQImage imageNamed:@"crx_stage_ddd"];
    [self.crxMoreButton setImage:moreImage forState:UIControlStateNormal];
    self.crxMoreButton.tintColor = [UIColor colorWithWhite:1 alpha:0.88];
    [self.crxMoreButton addTarget:self action:@selector(crx_moreTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.coverImageView addSubview:self.crxMoreButton];
    self.crxMoreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxMoreButton.centerYAnchor constraintEqualToAnchor:self.crxBadgeView.centerYAnchor],
        [self.crxMoreButton.trailingAnchor constraintEqualToAnchor:self.coverImageView.trailingAnchor constant:-12],
        [self.crxMoreButton.widthAnchor constraintEqualToConstant:30],
        [self.crxMoreButton.heightAnchor constraintEqualToConstant:30]
    ]];
    
    self.crxTitleLabel = [[UILabel alloc] init];
    self.crxTitleLabel.text = @"CAREXQ visual sample for layout preview and interface spacing.";
    self.crxTitleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.92];
    self.crxTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.crxTitleLabel.numberOfLines = 2;
    [self.cardView addSubview:self.crxTitleLabel];
    self.crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxTitleLabel.topAnchor constraintEqualToAnchor:self.coverImageView.bottomAnchor constant:12],
        [self.crxTitleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:14],
        [self.crxTitleLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-14]
    ]];
    
    self.crxGroupView = [[UIView alloc] init];
    [self.cardView addSubview:self.crxGroupView];
    self.crxGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxGroupView.topAnchor constraintEqualToAnchor:self.crxTitleLabel.bottomAnchor constant:14],
        [self.crxGroupView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:14],
        [self.crxGroupView.widthAnchor constraintEqualToConstant:100],
        [self.crxGroupView.heightAnchor constraintEqualToConstant:30],
        [self.crxGroupView.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-16]
    ]];
    
    [self crx_updateMemberAvatarsWithNames:@[@"crx_head_1", @"crx_head_2", @"crx_head_3", @"crx_head_4"]];
    
    UIView *crxValueView = [[UIView alloc] init];
    crxValueView.backgroundColor = [UIColor colorWithRed:0x1B/255.0 green:0x15/255.0 blue:0x33/255.0 alpha:1];
    crxValueView.layer.cornerRadius = 15.f;
    crxValueView.layer.borderWidth = 1.f;
    crxValueView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.08].CGColor;
    [self.cardView addSubview:crxValueView];
    crxValueView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxValueView.centerYAnchor constraintEqualToAnchor:self.crxGroupView.centerYAnchor],
        [crxValueView.leadingAnchor constraintEqualToAnchor:self.crxGroupView.trailingAnchor constant:5],
        [crxValueView.heightAnchor constraintEqualToConstant:30]
    ]];
    
    self.crxValueLabel = [[UILabel alloc] init];
    self.crxValueLabel.text = @"🔥0.1k";
    self.crxValueLabel.textColor = [UIColor colorWithWhite:1 alpha:0.82];
    self.crxValueLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    
    UIStackView *crxValueStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.crxValueLabel]];
    crxValueStackView.axis = UILayoutConstraintAxisHorizontal;
    crxValueStackView.alignment = UIStackViewAlignmentCenter;
    crxValueStackView.spacing = 4;
    [crxValueView addSubview:crxValueStackView];
    crxValueStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxValueStackView.topAnchor constraintEqualToAnchor:crxValueView.topAnchor constant:6],
        [crxValueStackView.bottomAnchor constraintEqualToAnchor:crxValueView.bottomAnchor constant:-6],
        [crxValueStackView.leadingAnchor constraintEqualToAnchor:crxValueView.leadingAnchor constant:10],
        [crxValueStackView.trailingAnchor constraintEqualToAnchor:crxValueView.trailingAnchor constant:-10]
    ]];
    
    self.crxActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxActionButton setImage:[CAREXQImage imageNamed:@"crx_stage_jo"] forState:(UIControlStateNormal)];
    [self.cardView addSubview:self.crxActionButton];
    self.crxActionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxActionButton.centerYAnchor constraintEqualToAnchor:self.crxGroupView.centerYAnchor],
        [self.crxActionButton.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-14],
        [self.crxActionButton.widthAnchor constraintEqualToConstant:106],
        [self.crxActionButton.heightAnchor constraintEqualToConstant:36]
    ]];
}

- (void)crx_updateMemberAvatarsWithNames:(NSArray<NSString *> *)crxAvatarNames {
    [self.crxGroupView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSArray<NSString *> *crxResolvedNames = crxAvatarNames.count > 0 ? crxAvatarNames : @[@"crx_head_1", @"crx_head_2", @"crx_head_3", @"crx_head_4"];
    CGFloat crxDiameter = 30.f;
    CGFloat crxOverlap = 22.f;

    [crxResolvedNames enumerateObjectsUsingBlock:^(NSString * _Nonnull crxAvatarName, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *crxAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * crxOverlap, 0, crxDiameter, crxDiameter)];
        crxAvatarView.image = [CAREXQImage imageNamed:crxAvatarName] ?: [CAREXQImage imageNamed:@"crx_head_1"];
        crxAvatarView.contentMode = UIViewContentModeScaleAspectFill;
        crxAvatarView.clipsToBounds = YES;
        crxAvatarView.layer.cornerRadius = crxDiameter * 0.5;
        crxAvatarView.layer.borderWidth = 2.f;
        crxAvatarView.layer.borderColor = [UIColor colorWithRed:0x0E/255.0 green:0x0A/255.0 blue:0x24/255.0 alpha:1].CGColor;
        [self.crxGroupView addSubview:crxAvatarView];
    }];
}

- (void)crx_configureWithItem:(NSDictionary *)crxItem {
    UIImage *crxCoverImage = crxItem[@"crxCoverImage"];
    UIImage *crxAvatarImage = crxItem[@"crxAvatarImage"];
    NSString *crxName = crxItem[@"crxName"];
    NSString *crxMeta = crxItem[@"crxMeta"];
    NSString *crxTitle = crxItem[@"crxTitle"];
    
    self.coverImageView.image = crxCoverImage ?: [CAREXQImage imageNamed:@"crx_stage_aig"];
    self.crxBadgeView.image = crxAvatarImage ?: [CAREXQImage imageNamed:@"crx_harbor_logo"];
    self.crxNameLabel.text = crxName.length ? crxName : @"CAREXQ Showcase";
    self.crxMetaLabel.text = crxMeta.length ? crxMeta : @"Hand dance";
    self.crxTitleLabel.text = crxTitle.length ? crxTitle : @"";
    [self crx_updateMemberAvatarsWithNames:crxItem[@"crxAvatarGroupNames"]];
}

- (void)crx_moreTapped {
    if (self.crxMoreTappedBlock) {
        self.crxMoreTappedBlock();
    }
}

@end
