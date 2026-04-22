//
//  CAREXQVideoCallController.h
//  CAREXQ
//
//  Created by OpenAI on 2026/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAREXQVideoCallController : UIViewController

@property (nonatomic, strong) NSDictionary *crxMessageItem;
@property (nonatomic, copy, nullable) dispatch_block_t crxTimeoutHandler;

@end

NS_ASSUME_NONNULL_END
