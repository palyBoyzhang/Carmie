//
//  CAREXQSignalMessageCell.h
//  CAREXQ
//
//  Created by OpenAI on 2026/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAREXQSignalMessageCell : UITableViewCell

- (void)crx_configureWithMessage:(NSDictionary *)crxMessage;

@end

NS_ASSUME_NONNULL_END
