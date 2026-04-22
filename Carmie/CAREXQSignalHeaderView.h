//
//  CAREXQSignalHeaderView.h
//  CAREXQ
//
//  Created by OpenAI on 2026/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAREXQSignalHeaderView : UIView

@property (nonatomic, copy) void (^crxUserTappedBlock)(NSDictionary *crxUserItem);

- (void)crx_configureWithUsers:(NSArray<NSDictionary *> *)crxUsers;

@end

NS_ASSUME_NONNULL_END
