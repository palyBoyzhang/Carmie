//
//  CRXSignalHeaderView.m
//  Carmie
//
//  Created by OpenAI on 2026/4/7.
//

#import "CRXSignalHeaderView.h"
#import "CRXSignalUserCell.h"

static NSString * const CRXSignalUserCellID = @"CRXSignalUserCellID";

@interface CRXSignalHeaderView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *crxCollectionView;
@property (nonatomic, strong) NSArray<NSDictionary *> *crxUsers;

@end

@implementation CRXSignalHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self crx_buildViews];
    }
    return self;
}

- (void)crx_buildViews {
    self.backgroundColor = UIColor.clearColor;
    
    UICollectionViewFlowLayout *crxLayout = [[UICollectionViewFlowLayout alloc] init];
    crxLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    crxLayout.minimumLineSpacing = 14.f;
    crxLayout.minimumInteritemSpacing = 14.f;
    crxLayout.sectionInset = UIEdgeInsetsMake(4, 0, 0, 0);
    
    self.crxCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:crxLayout];
    self.crxCollectionView.backgroundColor = UIColor.clearColor;
    self.crxCollectionView.showsHorizontalScrollIndicator = NO;
    self.crxCollectionView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
    self.crxCollectionView.dataSource = self;
    self.crxCollectionView.delegate = self;
    [self.crxCollectionView registerClass:CRXSignalUserCell.class forCellWithReuseIdentifier:CRXSignalUserCellID];
    [self addSubview:self.crxCollectionView];
    self.crxCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *crxSectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crx_signal_cha"]];
    crxSectionView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:crxSectionView];
    crxSectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.crxCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [self.crxCollectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [self.crxCollectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
        [self.crxCollectionView.heightAnchor constraintEqualToConstant:92],
        
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
    CRXSignalUserCell *crxCell = [collectionView dequeueReusableCellWithReuseIdentifier:CRXSignalUserCellID forIndexPath:indexPath];
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
