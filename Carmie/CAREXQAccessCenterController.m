//
//  CAREXQAccessCenterController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQAccessCenterController.h"
#import "CAREXQImage.h"
#import <StoreKit/StoreKit.h>

static NSString * const CAREXQAccessCoinCountKey = @"CAREXQAccessCoinCountKey";
static NSString * const CAREXQAccessPackageCellID = @"CAREXQAccessPackageCellID";

@interface CAREXQAccessPackageCell : UICollectionViewCell

@property (nonatomic, strong) UIView *crxCardView;
@property (nonatomic, strong) UIView *crxBadgeView;
@property (nonatomic, strong) UIImageView *crxBadgeIconView;
@property (nonatomic, strong) UILabel *crxAmountLabel;
@property (nonatomic, strong) UILabel *crxPriceLabel;
@property (nonatomic, strong) UIButton *crxActionButton;
@property (nonatomic, strong) CAGradientLayer *crxActionGradientLayer;
@property (nonatomic, copy) void (^crxActionHandler)(void);

- (void)crx_configureWithPackage:(NSDictionary *)crxPackage
                    displayPrice:(NSString *)crxDisplayPrice
                        selected:(BOOL)crxSelected
                       purchasing:(BOOL)crxPurchasing;

@end

@implementation CAREXQAccessPackageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self crx_buildViews];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.crxActionHandler = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.crxActionGradientLayer.frame = self.crxActionButton.bounds;
    self.crxActionGradientLayer.cornerRadius = CGRectGetHeight(self.crxActionButton.bounds) * 0.5;
}

- (void)crx_buildViews {
    self.backgroundColor = UIColor.clearColor;
    
    self.crxCardView = [[UIView alloc] init];
    self.crxCardView.backgroundColor = [UIColor colorWithRed:0x2E/255.0 green:0x11/255.0 blue:0x46/255.0 alpha:0.92];
    self.crxCardView.layer.cornerRadius = 18.f;
    self.crxCardView.layer.borderWidth = 1.f;
    [self.contentView addSubview:self.crxCardView];
    self.crxCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxBadgeView = [[UIView alloc] init];
    self.crxBadgeView.backgroundColor = [UIColor colorWithRed:0x37/255.0 green:0x19/255.0 blue:0x53/255.0 alpha:1];
    self.crxBadgeView.layer.cornerRadius = 10.f;
    self.crxBadgeView.layer.borderWidth = 1.f;
    self.crxBadgeView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.14].CGColor;
    [self.crxCardView addSubview:self.crxBadgeView];
    self.crxBadgeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxBadgeIconView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_harbor_zhs"]];
    self.crxBadgeIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.crxBadgeView addSubview:self.crxBadgeIconView];
    self.crxBadgeIconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxAmountLabel = [[UILabel alloc] init];
    self.crxAmountLabel.textColor = UIColor.whiteColor;
    self.crxAmountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [self.crxBadgeView addSubview:self.crxAmountLabel];
    self.crxAmountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxPriceLabel = [[UILabel alloc] init];
    self.crxPriceLabel.textColor = UIColor.whiteColor;
    self.crxPriceLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBlack];
    self.crxPriceLabel.textAlignment = NSTextAlignmentCenter;
    [self.crxCardView addSubview:self.crxPriceLabel];
    self.crxPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crxActionButton.layer.cornerRadius = 17.f;
    self.crxActionButton.layer.masksToBounds = YES;
    self.crxActionButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [self.crxActionButton addTarget:self action:@selector(crxActionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.crxCardView addSubview:self.crxActionButton];
    self.crxActionButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.crxActionGradientLayer = [CAGradientLayer layer];
    self.crxActionGradientLayer.startPoint = CGPointMake(0, 0.5);
    self.crxActionGradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.crxActionButton.layer insertSublayer:self.crxActionGradientLayer atIndex:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.crxCardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.crxCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.crxCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.crxCardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        
        [self.crxBadgeView.topAnchor constraintEqualToAnchor:self.crxCardView.topAnchor constant:6],
        [self.crxBadgeView.leadingAnchor constraintEqualToAnchor:self.crxCardView.leadingAnchor constant:7],
        [self.crxBadgeView.trailingAnchor constraintEqualToAnchor:self.crxCardView.trailingAnchor constant:-7],
        [self.crxBadgeView.heightAnchor constraintEqualToConstant:24],
        
        [self.crxBadgeIconView.centerYAnchor constraintEqualToAnchor:self.crxBadgeView.centerYAnchor],
        [self.crxBadgeIconView.leadingAnchor constraintEqualToAnchor:self.crxBadgeView.leadingAnchor constant:8],
        [self.crxBadgeIconView.widthAnchor constraintEqualToConstant:14],
        [self.crxBadgeIconView.heightAnchor constraintEqualToConstant:14],
        
        [self.crxAmountLabel.centerYAnchor constraintEqualToAnchor:self.crxBadgeView.centerYAnchor],
        [self.crxAmountLabel.leadingAnchor constraintEqualToAnchor:self.crxBadgeIconView.trailingAnchor constant:4],
        [self.crxAmountLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.crxBadgeView.trailingAnchor constant:-8],
        
        [self.crxPriceLabel.centerXAnchor constraintEqualToAnchor:self.crxCardView.centerXAnchor],
        [self.crxPriceLabel.topAnchor constraintEqualToAnchor:self.crxBadgeView.bottomAnchor constant:18],
        
        [self.crxActionButton.leadingAnchor constraintEqualToAnchor:self.crxCardView.leadingAnchor constant:10],
        [self.crxActionButton.trailingAnchor constraintEqualToAnchor:self.crxCardView.trailingAnchor constant:-10],
        [self.crxActionButton.bottomAnchor constraintEqualToAnchor:self.crxCardView.bottomAnchor constant:-10],
        [self.crxActionButton.heightAnchor constraintEqualToConstant:34]
    ]];
}

- (void)crx_configureWithPackage:(NSDictionary *)crxPackage
                    displayPrice:(NSString *)crxDisplayPrice
                        selected:(BOOL)crxSelected
                       purchasing:(BOOL)crxPurchasing {
    self.crxAmountLabel.text = [NSString stringWithFormat:@"x%@", crxPackage[@"crxAmount"]];
    self.crxPriceLabel.text = crxDisplayPrice;
    [self.crxActionButton setTitle:(crxPurchasing ? @"Loading" : @"Recharge") forState:UIControlStateNormal];
    self.crxActionButton.enabled = crxSelected && !crxPurchasing;
    
    self.crxCardView.layer.borderColor = (crxSelected ? [UIColor colorWithRed:1 green:0.62 blue:0.25 alpha:1].CGColor : [UIColor colorWithWhite:1 alpha:0.16].CGColor);
    self.crxCardView.layer.shadowColor = [UIColor colorWithRed:1 green:0.32 blue:0.70 alpha:1].CGColor;
    self.crxCardView.layer.shadowRadius = 12.f;
    self.crxCardView.layer.shadowOffset = CGSizeMake(0, 5);
    self.crxCardView.layer.shadowOpacity = crxSelected ? 0.28f : 0.f;
    
    if (crxSelected) {
        self.crxActionGradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:1 green:0.69 blue:0.24 alpha:1].CGColor,
            (__bridge id)[UIColor colorWithRed:1 green:0.18 blue:0.58 alpha:1].CGColor,
            (__bridge id)[UIColor colorWithRed:0x8E/255.0 green:0x42/255.0 blue:1 alpha:1].CGColor
        ];
        [self.crxActionButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        self.crxActionGradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:0x57/255.0 green:0x3E/255.0 blue:0x67/255.0 alpha:1].CGColor,
            (__bridge id)[UIColor colorWithRed:0x45/255.0 green:0x33/255.0 blue:0x58/255.0 alpha:1].CGColor
        ];
        [self.crxActionButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.56] forState:UIControlStateNormal];
    }
    
    if (crxPurchasing) {
        self.crxActionGradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:0x6B/255.0 green:0x56/255.0 blue:0x7E/255.0 alpha:1].CGColor,
            (__bridge id)[UIColor colorWithRed:0x53/255.0 green:0x44/255.0 blue:0x65/255.0 alpha:1].CGColor
        ];
        [self.crxActionButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.68] forState:UIControlStateNormal];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)crxActionButtonTapped {
    if (self.crxActionHandler != nil) {
        self.crxActionHandler();
    }
}

@end

@interface CAREXQAccessCenterController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) UIImageView *crxBackgroundImageView;
@property (nonatomic, strong) UIButton *crxBackButton;
@property (nonatomic, strong) UILabel *crxBalanceLabel;
@property (nonatomic, strong) UICollectionView *crxCollectionView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxPackageList;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SKProduct *> *crxProductMap;
@property (nonatomic, strong) SKProductsRequest *crxProductsRequest;
@property (nonatomic, copy) NSString *crxPurchasingProductID;
@property (nonatomic, assign) NSInteger crxSelectedIndex;

@end

@implementation CAREXQAccessCenterController

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [self.crxProductsRequest cancel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self crx_updateBalanceLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0x18/255.0 green:0x04/255.0 blue:0x2D/255.0 alpha:1];
    self.crxSelectedIndex = 0;
    self.crxProductMap = [NSMutableDictionary dictionary];
    self.crxPackageList = [self crx_buildPackageList];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self crx_setupAccessCenterViews];
    [self crx_updateBalanceLabel];
    [self crx_requestProducts];
}

- (NSArray<NSDictionary *> *)crx_buildPackageList {
    NSArray<NSDictionary *> *crxRawPackageList = @[
        @{@"crxPriceValue": @99.99, @"crxAmount": @63700, @"crxProductID": @"hdjkqzqormduvhmo"},
        @{@"crxPriceValue": @49.99, @"crxAmount": @29400, @"crxProductID": @"dgnnazuqssqdiqab"},
        @{@"crxPriceValue": @19.99, @"crxAmount": @10800, @"crxProductID": @"lkztrlipbvreumhq"},
        @{@"crxPriceValue": @9.99, @"crxAmount": @5150, @"crxProductID": @"fjrjwoaqcnircoak"},
        @{@"crxPriceValue": @4.99, @"crxAmount": @2450, @"crxProductID": @"mukxfhxfhqjoycmz"},
        @{@"crxPriceValue": @2.99, @"crxAmount": @1350, @"crxProductID": @"jakdelldajfjekdek"},
        @{@"crxPriceValue": @1.99, @"crxAmount": @800, @"crxProductID": @"meiowhjadamxwmwg"},
        @{@"crxPriceValue": @0.99, @"crxAmount": @400, @"crxProductID": @"rqllhdutrfilbnar"}
    ];
    
    return [crxRawPackageList sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull crxLeftPackage, NSDictionary * _Nonnull crxRightPackage) {
        return [crxLeftPackage[@"crxPriceValue"] compare:crxRightPackage[@"crxPriceValue"]];
    }];
}

- (void)crx_setupAccessCenterViews {
    self.crxBackgroundImageView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_access_bg"]];
    self.crxBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.crxBackgroundImageView.clipsToBounds = YES;
    [self.view addSubview:self.crxBackgroundImageView];
    self.crxBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxBackgroundImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.crxBackgroundImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.crxBackgroundImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.crxBackgroundImageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    UIView *crxOverlayView = [[UIView alloc] init];
    crxOverlayView.backgroundColor = [UIColor colorWithRed:0x14/255.0 green:0x04/255.0 blue:0x28/255.0 alpha:0.34];
    [self.view addSubview:crxOverlayView];
    crxOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxOverlayView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [crxOverlayView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxOverlayView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxOverlayView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.crxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crxBackButton setImage:[CAREXQImage imageNamed:@"crx_harbor_back"] forState:UIControlStateNormal];
    self.crxBackButton.backgroundColor = [UIColor colorWithRed:0x2B/255.0 green:0x0B/255.0 blue:0x47/255.0 alpha:0.92];
    self.crxBackButton.layer.cornerRadius = 18.f;
    [self.crxBackButton addTarget:self action:@selector(crxBackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crxBackButton];
    self.crxBackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxBackButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.crxBackButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [self.crxBackButton.widthAnchor constraintEqualToConstant:36],
        [self.crxBackButton.heightAnchor constraintEqualToConstant:36]
    ]];
    
    UILabel *crxTitleLabel = [[UILabel alloc] init];
    crxTitleLabel.text = @"My Wallet";
    crxTitleLabel.textColor = UIColor.whiteColor;
    crxTitleLabel.font = [UIFont italicSystemFontOfSize:18];
    [self.view addSubview:crxTitleLabel];
    crxTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxTitleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [crxTitleLabel.centerYAnchor constraintEqualToAnchor:self.crxBackButton.centerYAnchor]
    ]];
    
    self.crxBalanceLabel = [[UILabel alloc] init];
    self.crxBalanceLabel.textColor = UIColor.whiteColor;
    self.crxBalanceLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBlack];
    [self.view addSubview:self.crxBalanceLabel];
    self.crxBalanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxBalanceLabel.topAnchor constraintEqualToAnchor:self.crxBackButton.bottomAnchor constant:24],
        [self.crxBalanceLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24]
    ]];
    
    UILabel *crxSubLabel = [[UILabel alloc] init];
    crxSubLabel.text = @"My gold coins";
    crxSubLabel.textColor = [UIColor colorWithWhite:1 alpha:0.76];
    crxSubLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [self.view addSubview:crxSubLabel];
    crxSubLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxSubLabel.topAnchor constraintEqualToAnchor:self.crxBalanceLabel.bottomAnchor constant:6],
        [crxSubLabel.leadingAnchor constraintEqualToAnchor:self.crxBalanceLabel.leadingAnchor]
    ]];
    
    UIImageView *crxGemImageView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_harbor_zhs"]];
    crxGemImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:crxGemImageView];
    crxGemImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxGemImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [crxGemImageView.centerYAnchor constraintEqualToAnchor:self.crxBalanceLabel.centerYAnchor constant:20],
        [crxGemImageView.widthAnchor constraintEqualToConstant:88],
        [crxGemImageView.heightAnchor constraintEqualToConstant:88]
    ]];
    
    UIView *crxPanelView = [[UIView alloc] init];
    crxPanelView.backgroundColor = [UIColor colorWithRed:0x2B/255.0 green:0x08/255.0 blue:0x46/255.0 alpha:0.82];
    crxPanelView.layer.cornerRadius = 28.f;
    crxPanelView.layer.borderWidth = 1.f;
    crxPanelView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.08].CGColor;
    [self.view addSubview:crxPanelView];
    crxPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [crxPanelView.topAnchor constraintEqualToAnchor:crxSubLabel.bottomAnchor constant:18],
        [crxPanelView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [crxPanelView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [crxPanelView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    UICollectionViewFlowLayout *crxLayout = [[UICollectionViewFlowLayout alloc] init];
    crxLayout.minimumLineSpacing = 10.f;
    crxLayout.minimumInteritemSpacing = 10.f;
    crxLayout.sectionInset = UIEdgeInsetsMake(18, 22, 22, 22);
    
    self.crxCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:crxLayout];
    self.crxCollectionView.backgroundColor = UIColor.clearColor;
    self.crxCollectionView.showsVerticalScrollIndicator = NO;
    self.crxCollectionView.dataSource = self;
    self.crxCollectionView.delegate = self;
    [self.crxCollectionView registerClass:CAREXQAccessPackageCell.class forCellWithReuseIdentifier:CAREXQAccessPackageCellID];
    [crxPanelView addSubview:self.crxCollectionView];
    self.crxCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.crxCollectionView.topAnchor constraintEqualToAnchor:crxPanelView.topAnchor],
        [self.crxCollectionView.leadingAnchor constraintEqualToAnchor:crxPanelView.leadingAnchor],
        [self.crxCollectionView.trailingAnchor constraintEqualToAnchor:crxPanelView.trailingAnchor],
        [self.crxCollectionView.bottomAnchor constraintEqualToAnchor:crxPanelView.bottomAnchor]
    ]];
}

- (void)crx_requestProducts {
    [self crx_showLoadingWithText:@"Loading..."];
    [self.crxProductsRequest cancel];
    NSSet *crxIdentifiers = [NSSet setWithArray:[self.crxPackageList valueForKey:@"crxProductID"]];
    self.crxProductsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:crxIdentifiers];
    self.crxProductsRequest.delegate = self;
    [self.crxProductsRequest start];
}

- (void)crx_runOnMain:(dispatch_block_t)crxBlock {
    if (crxBlock == nil) {
        return;
    }
    
    if ([NSThread isMainThread]) {
        crxBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), crxBlock);
    }
}

- (void)crx_updateBalanceLabel {
    NSInteger crxCoinCount = [[NSUserDefaults standardUserDefaults] integerForKey:CAREXQAccessCoinCountKey];
    self.crxBalanceLabel.text = [NSString stringWithFormat:@"%ld", (long)crxCoinCount];
}

- (NSString *)crx_displayPriceForPackage:(NSDictionary *)crxPackage {
    NSString *crxProductID = crxPackage[@"crxProductID"];
    SKProduct *crxProduct = self.crxProductMap[crxProductID];
    if (crxProduct != nil) {
        NSNumberFormatter *crxFormatter = [[NSNumberFormatter alloc] init];
        crxFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        crxFormatter.locale = crxProduct.priceLocale;
        return [crxFormatter stringFromNumber:crxProduct.price] ?: [NSString stringWithFormat:@"%@$", crxPackage[@"crxPriceValue"]];
    }
    
    return [NSString stringWithFormat:@"%.2f$", [crxPackage[@"crxPriceValue"] doubleValue]];
}

- (void)crx_startPurchaseForIndex:(NSInteger)crxIndex {
    if (crxIndex < 0 || crxIndex >= self.crxPackageList.count) {
        return;
    }
    
    if (![SKPaymentQueue canMakePayments]) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"In-app purchases are not available on this device."];
        return;
    }
    
    NSDictionary *crxPackage = self.crxPackageList[crxIndex];
    NSString *crxProductID = crxPackage[@"crxProductID"];
    SKProduct *crxProduct = self.crxProductMap[crxProductID];
    if (crxProduct == nil) {
        [self crx_showAlertWithTitle:@"Reminder" message:@"Product information is loading, please try again shortly."];
        [self crx_requestProducts];
        return;
    }
    
    self.crxSelectedIndex = crxIndex;
    self.crxPurchasingProductID = crxProductID;
    [self.crxCollectionView reloadData];
    [self crx_showLoadingWithText:@"Processing..."];
    [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProduct:crxProduct]];
}

- (void)crx_finishSuccessfulPurchaseForProductID:(NSString *)crxProductID {
    NSDictionary *crxMatchedPackage = nil;
    for (NSDictionary *crxPackage in self.crxPackageList) {
        if ([crxPackage[@"crxProductID"] isEqualToString:crxProductID]) {
            crxMatchedPackage = crxPackage;
            break;
        }
    }
    
    if (crxMatchedPackage == nil) {
        return;
    }
    
    NSInteger crxCurrentCount = [[NSUserDefaults standardUserDefaults] integerForKey:CAREXQAccessCoinCountKey];
    NSInteger crxAddedCount = [crxMatchedPackage[@"crxAmount"] integerValue];
    NSInteger crxUpdatedCount = crxCurrentCount + crxAddedCount;
    [[NSUserDefaults standardUserDefaults] setInteger:crxUpdatedCount forKey:CAREXQAccessCoinCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self crx_updateBalanceLabel];
    [self crx_showAlertWithTitle:@"Success" message:[NSString stringWithFormat:@"Recharge completed. Added %ld coins.", (long)crxAddedCount]];
}

- (void)crx_showAlertWithTitle:(NSString *)crxTitle message:(NSString *)crxMessage {
    [self crx_runOnMain:^{
        if (self.presentedViewController != nil) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        
        UIAlertController *crxAlertController = [UIAlertController alertControllerWithTitle:crxTitle
                                                                                    message:crxMessage
                                                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *crxConfirmAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
        [crxAlertController addAction:crxConfirmAction];
        [self presentViewController:crxAlertController animated:YES completion:nil];
    }];
}

- (void)crxBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.crxPackageList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CAREXQAccessPackageCell *crxCell = [collectionView dequeueReusableCellWithReuseIdentifier:CAREXQAccessPackageCellID forIndexPath:indexPath];
    NSDictionary *crxPackage = self.crxPackageList[indexPath.item];
    NSString *crxDisplayPrice = [self crx_displayPriceForPackage:crxPackage];
    BOOL crxSelected = (indexPath.item == self.crxSelectedIndex);
    BOOL crxPurchasing = [self.crxPurchasingProductID isEqualToString:crxPackage[@"crxProductID"]];
    
    [crxCell crx_configureWithPackage:crxPackage
                         displayPrice:crxDisplayPrice
                             selected:crxSelected
                            purchasing:crxPurchasing];
    
    __weak typeof(self) crxWeakSelf = self;
    crxCell.crxActionHandler = ^{
        if (crxWeakSelf.crxSelectedIndex == indexPath.item) {
            [crxWeakSelf crx_startPurchaseForIndex:indexPath.item];
        }
    };
    return crxCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.crxSelectedIndex = indexPath.item;
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat crxAvailableWidth = CGRectGetWidth(collectionView.bounds) - 44.f - 20.f;
    CGFloat crxCardWidth = floor(crxAvailableWidth / 3.f);
    return CGSizeMake(crxCardWidth, 124.f);
}

#pragma mark - StoreKit

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [self crx_runOnMain:^{
        [self crx_hideLoading];
        [self.crxProductMap removeAllObjects];
        for (SKProduct *crxProduct in response.products) {
            self.crxProductMap[crxProduct.productIdentifier] = crxProduct;
        }
        self.crxProductsRequest = nil;
        [self.crxCollectionView reloadData];
    }];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self crx_runOnMain:^{
        [self crx_hideLoading];
        self.crxProductsRequest = nil;
        [self crx_showAlertWithTitle:@"Reminder" message:error.localizedDescription ?: @"Failed to load products."];
    }];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    [self crx_runOnMain:^{
        for (SKPaymentTransaction *crxTransaction in transactions) {
            switch (crxTransaction.transactionState) {
                case SKPaymentTransactionStatePurchased:
                    [self crx_finishSuccessfulPurchaseForProductID:crxTransaction.payment.productIdentifier];
                    [[SKPaymentQueue defaultQueue] finishTransaction:crxTransaction];
                    self.crxPurchasingProductID = nil;
                    [self crx_hideLoading];
                    [self.crxCollectionView reloadData];
                    break;
                case SKPaymentTransactionStateFailed: {
                    NSString *crxMessage = crxTransaction.error.code == SKErrorPaymentCancelled ? @"Purchase cancelled." : (crxTransaction.error.localizedDescription ?: @"Purchase failed.");
                    [[SKPaymentQueue defaultQueue] finishTransaction:crxTransaction];
                    self.crxPurchasingProductID = nil;
                    [self crx_hideLoading];
                    [self.crxCollectionView reloadData];
                    [self crx_showAlertWithTitle:@"Reminder" message:crxMessage];
                    break;
                }
                case SKPaymentTransactionStateRestored:
                    [[SKPaymentQueue defaultQueue] finishTransaction:crxTransaction];
                    self.crxPurchasingProductID = nil;
                    [self crx_hideLoading];
                    [self.crxCollectionView reloadData];
                    break;
                case SKPaymentTransactionStateDeferred:
                    [self crx_hideLoading];
                    [self crx_showAlertWithTitle:@"Reminder" message:@"Purchase is waiting for approval."];
                    break;
                case SKPaymentTransactionStatePurchasing:
                    break;
            }
        }
    }];
}

@end
