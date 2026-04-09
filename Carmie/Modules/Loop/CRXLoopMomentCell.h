//
//  CRXLoopMomentCell.h
//  Carmie
//
//  Created by OpenAI on 2026/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRXLoopMomentCell : UITableViewCell

@property (nonatomic, copy) void (^crxMoreTappedBlock)(void);

- (void)crx_configureWithMoment:(NSDictionary *)crxMoment;

@end

NS_ASSUME_NONNULL_END
