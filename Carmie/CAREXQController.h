//
//  CAREXQController.h
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAREXQController : UIViewController

+ (BOOL)crx_isLoggedIn;
+ (BOOL)crx_isBlockedUserName:(NSString *)crxUserName;
+ (NSArray<NSDictionary *> *)crx_filterItems:(NSArray<NSDictionary *> *)crxItems nameKey:(NSString *)crxNameKey;
- (void)crx_presentModerationForUserName:(NSString *)crxUserName blockHandler:(dispatch_block_t)crxBlockHandler;
- (void)crx_showLoadingWithText:(nullable NSString *)crxText;
- (void)crx_hideLoading;

@end

NS_ASSUME_NONNULL_END
