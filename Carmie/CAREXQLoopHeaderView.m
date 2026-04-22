//
//  CAREXQLoopHeaderView.m
//  CAREXQ
//
//  Created by OpenAI on 2026/4/7.
//

#import "CAREXQLoopHeaderView.h"
#import "CAREXQImage.h"
#import "CAREXQLoopUserCell.h"

static NSString * const CAREXQLoopUserCellID = @"CAREXQLoopUserCellID";

@interface CAREXQLoopHeaderView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *crxCollectionView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxUsers;

@end

@implementation CAREXQLoopHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self crx_buildViews];
    }
    return self;
}

- (void)crx_buildViews {
    self.backgroundColor = UIColor.clearColor;
    
    UIView *crxCountView = [[UIView alloc] init];
    crxCountView.backgroundColor = [UIColor colorWithRed:0x2A/255.0 green:0x0D/255.0 blue:0x3C/255.0 alpha:0.92];
    crxCountView.layer.cornerRadius = 14.f;
    crxCountView.layer.borderWidth = 1.f;
    crxCountView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    [self addSubview:crxCountView];
    crxCountView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UICollectionViewFlowLayout *crxLayout = [[UICollectionViewFlowLayout alloc] init];
    crxLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    crxLayout.minimumLineSpacing = 14.f;
    crxLayout.minimumInteritemSpacing = 14.f;
    
    self.crxCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:crxLayout];
    self.crxCollectionView.backgroundColor = UIColor.clearColor;
    self.crxCollectionView.showsHorizontalScrollIndicator = NO;
    self.crxCollectionView.dataSource = self;
    self.crxCollectionView.delegate = self;
    [self.crxCollectionView registerClass:CAREXQLoopUserCell.class forCellWithReuseIdentifier:CAREXQLoopUserCellID];
    [self addSubview:self.crxCollectionView];
    self.crxCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *crxSectionView = [[UIImageView alloc] initWithImage:[CAREXQImage imageNamed:@"crx_board_show"]];
    crxSectionView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:crxSectionView];
    crxSectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
   
        [self.crxCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],
        [self.crxCollectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [self.crxCollectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
        [self.crxCollectionView.heightAnchor constraintEqualToConstant:86],
        
        [crxSectionView.topAnchor constraintEqualToAnchor:self.crxCollectionView.bottomAnchor constant:10],
        [crxSectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [crxSectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8]
    ]];
}

- (void)crx_configureWithUsers:(NSArray<NSDictionary *> *)crxUsers {
    self.crxUsers = crxUsers;
    [self.crxCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.crxUsers.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CAREXQLoopUserCell *crxCell = [collectionView dequeueReusableCellWithReuseIdentifier:CAREXQLoopUserCellID forIndexPath:indexPath];
    NSDictionary *crxUser = self.crxUsers[indexPath.item];
    [crxCell crx_configureWithName:crxUser[@"crxName"] image:crxUser[@"crxImage"]];
    return crxCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(64, 86);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.crxUserTappedBlock && indexPath.item < self.crxUsers.count) {
        self.crxUserTappedBlock(self.crxUsers[indexPath.item]);
    }
}

@end
