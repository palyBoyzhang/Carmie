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
#if __has_include(<AdjustSdk/AdjustSdk.h>)
#import <AdjustSdk/AdjustSdk.h>
#else
#import <Adjust.h>
#import <ADJConfig.h>
#import <ADJEvent.h>
#endif
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit-Swift.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self CAREXQfoldLaunchTrace:application options:launchOptions];
    [self CAREXQinitPushCenterWithApplication:application];
    return YES;
}

- (void)CAREXQfoldLaunchTrace:(UIApplication *)application options:(NSDictionary *)launchOptions {
    [self CAREXQlinkSignalGate:application options:launchOptions];
    [self CAREXQbindRhythmMark];
    [self CAREXQdriftSourceEvent];
}

- (void)CAREXQlinkSignalGate:(UIApplication *)application options:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)CAREXQbindRhythmMark {
    NSString *CAREXQPoint = [[CAREXQChordVault CAREXQlane] CAREXQtraceSeed];
    if (CAREXQPoint.length == 0) {
        CAREXQPoint = @"";
    }
    [Adjust addGlobalCallbackParameter:CAREXQPoint forKey:[self CAREXQtraceKey]];
}

- (void)CAREXQdriftSourceEvent {
    ADJConfig *CAREXQCofi = [self CAREXQmakeSourceConfig];
    [Adjust initSdk:CAREXQCofi];
    [Adjust trackEvent:[self CAREXQmakeWakeEvent]];
}

- (ADJConfig *)CAREXQmakeSourceConfig {
    NSString *CAREXQToken = [self CAREXQmergeParts:@[@"r0q", @"379", @"yxa", @"8e8"]];
    return [[ADJConfig alloc] initWithAppToken:CAREXQToken environment:ADJEnvironmentProduction];
}

- (ADJEvent *)CAREXQmakeWakeEvent {
    NSString *CAREXQToken = [self CAREXQmergeParts:@[@"ep", @"nm", @"62"]];
    return [[ADJEvent alloc] initWithEventToken:CAREXQToken];
}

- (NSString *)CAREXQtraceKey {
    return [self CAREXQmergeParts:@[@"ta", @"_", @"distinct", @"_", @"id"]];
}

- (NSString *)CAREXQmergeParts:(NSArray<NSString *> *)parts {
    return [parts componentsJoinedByString:@""];
}

- (void)CAREXQinitPushCenterWithApplication:(UIApplication *)application {
    UNUserNotificationCenter *CAREXQCenter = [UNUserNotificationCenter currentNotificationCenter];
    CAREXQCenter.delegate = self;
    [CAREXQCenter requestAuthorizationWithOptions:[self CAREXQpushMask]
                                completionHandler:^(BOOL granted, NSError *_Nullable error) {
        
    }];
    [application registerForRemoteNotifications];
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


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [self CAREXQmakeSceneConfig:connectingSceneSession];
}

- (UISceneConfiguration *)CAREXQmakeSceneConfig:(UISceneSession *)connectingSceneSession {
    NSString *CAREXQName = [self CAREXQmergeParts:@[@"Default", @" ", @"Configuration"]];
    return [[UISceneConfiguration alloc] initWithName:CAREXQName sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
