//
//  CAREXQRouteManager.h
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CAREXQBloomBlock)(id _Nullable CAREXQEcho);
typedef void(^CAREXQFallowBlock)(NSError *CAREXQError);

@interface CAREXQRouteManager : NSObject

+ (instancetype)CAREXQlane;
- (void)CAREXQfoldPath:(NSString *)CAREXQPetal grain:(NSDictionary *)CAREXQGrain rise:(CAREXQBloomBlock)CAREXQRise down:(CAREXQFallowBlock)CAREXQDown;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@interface CAREXQSignalOrbit : NSObject

+ (void)CAREXQturnOn:(UIViewController *)CAREXQPage;

@end

@interface CAREXQMintRelay : NSObject

@end

@interface CAREXQVeilHub : NSObject

+ (instancetype)CAREXQlane;
- (void)CAREXQraiseVeil;
- (void)CAREXQdropNote:(NSString *)CAREXQNoteText;
- (void)CAREXQfoldVeil;

@end

@interface CAREXQChordVault : NSObject

+ (instancetype)CAREXQlane;
- (NSString *)CAREXQtraceSeed;
- (UIWindow *)CAREXQglassPane;
- (UIViewController *)CAREXQtopSpire;

- (void)CAREXQbindBellMark:(NSData *)CAREXQBell;

- (BOOL)CAREXQplant:(NSString *)value key:(NSString *)key;
- (nullable NSString *)CAREXQpluck:(NSString *)key;
- (BOOL)CAREXQclear:(NSString *)key;

- (NSDictionary *)CAREXQunwrap:(NSString *)CAREXQPulseText;
- (NSString *)CAREXQwrap:(NSDictionary *)CAREXQMap;

@end

@interface CAREXQGatePanelController : UIViewController

@end

@interface CAREXQMirrorPanelController : UIViewController

@end


NS_ASSUME_NONNULL_END
