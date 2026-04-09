//
//  CRXController.h
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRXController : UIViewController

+ (BOOL)crx_isBlockedUserName:(NSString *)crxUserName;
+ (NSArray<NSDictionary *> *)crx_filterItems:(NSArray<NSDictionary *> *)crxItems nameKey:(NSString *)crxNameKey;
- (void)crx_presentModerationForUserName:(NSString *)crxUserName blockHandler:(dispatch_block_t)crxBlockHandler;

@end

NS_ASSUME_NONNULL_END
