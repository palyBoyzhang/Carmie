//
//  AppDelegate.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <SafariServices/SafariServices.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "CAREXQRouteManager.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)CAREXQinitPushCenterWithApplication {
    UNUserNotificationCenter *CAREXQCenter = [UNUserNotificationCenter currentNotificationCenter];
    CAREXQCenter.delegate = self;
    [CAREXQCenter requestAuthorizationWithOptions:[self CAREXQpushMask]
                                completionHandler:^(BOOL granted, NSError *_Nullable error) {
        
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (UNAuthorizationOptions)CAREXQpushMask {
    return (UNAuthorizationOptionBadge |
            UNAuthorizationOptionSound |
            UNAuthorizationOptionAlert);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self CAREXQsyncRemoteMark:deviceToken];
}

- (void)CAREXQsyncRemoteMark:(NSData *)deviceToken {
    if (deviceToken.length == 0) {
        return;
    }
    [[CAREXQChordVault CAREXQlane] CAREXQbindBellMark:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self CAREXQfinishRemote:userInfo handler:completionHandler];
}

- (void)CAREXQfinishRemote:(NSDictionary *)userInfo handler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

@end
