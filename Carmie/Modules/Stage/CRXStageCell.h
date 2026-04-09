//
//  CRXStageCell.h
//  Carmie
//
//  Created by w zhang on 2026/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRXStageCell : UITableViewCell

@property (nonatomic, copy) void (^crxMoreTappedBlock)(void);

- (void)crx_configureWithItem:(NSDictionary *)crxItem;

@end

NS_ASSUME_NONNULL_END
