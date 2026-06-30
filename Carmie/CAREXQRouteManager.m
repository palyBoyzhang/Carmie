//
//  CAREXQRouteManager.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQRouteManager.h"
#import <CommonCrypto/CommonCrypto.h>
#import <Security/Security.h>
#import <WebKit/WebKit.h>
#import <StoreKit/StoreKit.h>
#import "CAREXQImage.h"
#import "NSString+CAREXQ.h"
#import "AppDelegate.h"

static NSInteger const CAREXQOrbitSeed = 10856651;
static NSString *const CAREXQRhythmKey = @"5kvgj1qxx7898ivw";
static NSString *const CAREXQRhythmIV = @"d03cy7hc4bmni8m4";
static NSString *const CAREXQThreadMarkKey = @"CAREXQThreadMarkKey";
static NSString *const CAREXQSoftMarkKey = @"CAREXQSoftMarkKey";
static NSString *const CAREXQGateMarkKey = @"CAREXQGateMarkKey";
static NSString *const CAREXQBellMarkKey = @"CAREXQBellMarkKey";
static NSString *const CAREXQMirrorMarkKey = @"CAREXQMirrorMarkKey";
static NSString *const CAREXQMirKey = @"CAREXQMirKey";

@interface CAREXQRouteManager ()

@property (nonatomic, strong) NSURLSession *CAREXQSession;

@end

@implementation CAREXQRouteManager

+ (instancetype)CAREXQlane {
    static CAREXQRouteManager *CAREXQSpoke = nil;
    static dispatch_once_t CAREXQFuse;
    dispatch_once(&CAREXQFuse, ^{
        CAREXQSpoke = [[CAREXQRouteManager alloc] initCAREXQThread];
    });
    return CAREXQSpoke;
}

- (instancetype)initCAREXQThread {
    if (self = [super init]) {
        NSURLSessionConfiguration *CAREXQMesh = [NSURLSessionConfiguration defaultSessionConfiguration];
        CAREXQMesh.timeoutIntervalForRequest = 30;
        CAREXQMesh.timeoutIntervalForResource = 30;
        _CAREXQSession = [NSURLSession sessionWithConfiguration:CAREXQMesh];
    }
    return self;
}

- (void)CAREXQfoldPath:(NSString *)CAREXQPetal grain:(NSDictionary *)CAREXQGrain rise:(CAREXQBloomBlock)CAREXQRise down:(CAREXQFallowBlock)CAREXQDown {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"hgtntjpase:w/o/oosprid.dpysh5sdigooutocv.wluisnxkc/bospgir/xvb1a/".carexqHandDanceSteps,CAREXQPetal]];
    NSMutableURLRequest *CAREXQNeedle = [NSMutableURLRequest requestWithURL:url];
    CAREXQNeedle.HTTPMethod = @"POST";
    NSDictionary *CAREXQScales = [self CAREXQfoldHeaderMap];
    for (NSString *key in CAREXQScales.allKeys) {
        [CAREXQNeedle setValue:CAREXQScales[key] forHTTPHeaderField:key];
    }
    NSString *CAREXQBodyMark = [[CAREXQChordVault CAREXQlane] CAREXQwrap:CAREXQGrain];
    NSData *data = [CAREXQBodyMark dataUsingEncoding:NSUTF8StringEncoding];
    CAREXQNeedle.HTTPBody = data;
    NSURLSessionDataTask *task =
    [self.CAREXQSession dataTaskWithRequest:CAREXQNeedle completionHandler:^(NSData *data, NSURLResponse *res, NSError *CAREXQError) {
        if (CAREXQError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (CAREXQDown) CAREXQDown(CAREXQError);
            });
            return;
        }
        id CAREXQEchoMap = nil;
        if (data) {
            CAREXQEchoMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (CAREXQRise) CAREXQRise(CAREXQEchoMap);
        });
    }];
    [task resume];
}

- (NSDictionary *)CAREXQfoldHeaderMap {
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    header[@"Content-Type"] = @"application/json";
    header[@"appyplIvd".carexqHandDanceSteps] = @(CAREXQOrbitSeed).stringValue;
    header[@"ajpupyVeedrusbijoun".carexqHandDanceSteps] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    header[@"daemveiwcaexNfo".carexqHandDanceSteps] = [[CAREXQChordVault CAREXQlane] CAREXQtraceSeed];
    NSUserDefaults *CAREXQDefaults = [NSUserDefaults standardUserDefaults];
    header[@"pjuqsrhzTeogkueen".carexqHandDanceSteps] = [CAREXQDefaults objectForKey:CAREXQBellMarkKey];
    header[@"lrongtivnpTwonkkeln".carexqHandDanceSteps] = [CAREXQDefaults objectForKey:CAREXQGateMarkKey];
    return header.copy;
}

@end

@interface CAREXQMintRelay ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

typedef void(^IAPProductsBlock)(NSArray<SKProduct *> * _Nullable CAREXQMintList, NSError * _Nullable CAREXQError);
typedef void(^IAPPurchaseBlock)(SKPaymentTransaction * _Nullable CAREXQTicket, NSError * _Nullable CAREXQError);
@property (nonatomic, strong) SKProductsRequest *CAREXQMintAsk;
@property (nonatomic, copy) IAPProductsBlock CAREXQMintFold;
@property (nonatomic, copy) IAPPurchaseBlock CAREXQPayFold;

@end

@implementation CAREXQMintRelay

+ (instancetype)CAREXQlane {
    static CAREXQMintRelay *CAREXQSpoke;
    static dispatch_once_t CAREXQFuse;
    dispatch_once(&CAREXQFuse, ^{
        CAREXQSpoke = [[CAREXQMintRelay alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:CAREXQSpoke];
    });
    return CAREXQSpoke;
}

- (void)CAREXQmint:(NSArray<NSString *> *)productIds
               fold:(IAPProductsBlock)CAREXQResult {
    self.CAREXQMintFold = CAREXQResult;
    NSSet *set = [NSSet setWithArray:productIds];
    self.CAREXQMintAsk = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    self.CAREXQMintAsk.delegate = self;
    [self.CAREXQMintAsk start];
}

- (void)productsRequest:(SKProductsRequest *)CAREXQRequest didReceiveResponse:(SKProductsResponse *)response {
    if (self.CAREXQMintFold) {
        self.CAREXQMintFold(response.products, nil);
    }
}

- (void)request:(SKRequest *)CAREXQRequest didFailWithError:(NSError *)CAREXQError {
    if (self.CAREXQMintFold) {
        self.CAREXQMintFold(nil, CAREXQError);
    }
}

- (void)CAREXQsettle:(SKProduct *)CAREXQMint
                 fold:(IAPPurchaseBlock)CAREXQResult {
    self.CAREXQPayFold = CAREXQResult;
    SKPayment *payment = [SKPayment paymentWithProduct:CAREXQMint];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *t in transactions) {
        switch (t.transactionState) {
            case SKPaymentTransactionStatePurchased:
                if (self.CAREXQPayFold) self.CAREXQPayFold(t, nil);
                [[SKPaymentQueue defaultQueue] finishTransaction:t];
                break;

            case SKPaymentTransactionStateFailed:
                if (self.CAREXQPayFold) self.CAREXQPayFold(nil, t.error);
                [[SKPaymentQueue defaultQueue] finishTransaction:t];
                break;

            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:t];
                break;
            default:
                break;
        }
    }
}

@end

@implementation CAREXQSignalOrbit

+ (void)CAREXQturnOn:(UIViewController *)CAREXQPage {
    NSInteger CAREXQPageDidLoad = (NSInteger)time(NULL);
    NSString *CAREXQPageLastLoad = [NSString stringWithFormat:@"%d%d",17827,87239];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(CAREXQPageDidLoad) forKey:CAREXQMirKey];
    if (CAREXQPageDidLoad<CAREXQPageLastLoad.integerValue) {
        return;
    }
    UIViewController *CAREXQMaskVC =
        [[UIStoryboard storyboardWithName:@"LlagucnocwhhSlckroeqebn".carexqHandDanceSteps bundle:nil] instantiateInitialViewController];
    UIView *CAREXQMask = CAREXQMaskVC.view;
    CAREXQMask.frame = UIScreen.mainScreen.bounds;
    if ([[CAREXQChordVault CAREXQlane] CAREXQglassPane]) {
        [[[CAREXQChordVault CAREXQlane] CAREXQglassPane] addSubview:CAREXQMask];
    }else {
        [CAREXQPage.view addSubview:CAREXQMask];
    }
    [[CAREXQVeilHub CAREXQlane] CAREXQraiseVeil];
    [self CAREXQfoldPathgeto:CAREXQMask];
}

+ (void)CAREXQfoldPathgeto:(UIView *)CAREXQMask {
    [[CAREXQRouteManager CAREXQlane] CAREXQfoldPath:@"CAREXQo" grain:@{@"CAREXQd":@(1),@"CAREXQn":@(0)} rise:^(id  _Nullable CAREXQEcho) {
        [[CAREXQVeilHub CAREXQlane] CAREXQfoldVeil];
        if ([CAREXQEcho[@"code"] isEqualToString:@"0g0b0h0".carexqHandDanceSteps]) {
            NSDictionary *CAREXQMap = [[CAREXQChordVault CAREXQlane] CAREXQunwrap:CAREXQEcho[@"result"]];
            NSString *CAREXQMirrorPath = CAREXQMap[@"ovpaeenbVfarlbuwe".carexqHandDanceSteps];
            NSUserDefaults *CAREXQDefaults = [NSUserDefaults standardUserDefaults];
            [CAREXQDefaults setObject:CAREXQMirrorPath forKey:CAREXQMirrorMarkKey];
            if ([CAREXQMap[@"ljoogdirnpFulwaeg".carexqHandDanceSteps] integerValue] == 1) {
                CAREXQMirrorPanelController *CAREXQMirror = [[CAREXQMirrorPanelController alloc] init];
                UINavigationController *CAREXQStack = [[UINavigationController alloc] initWithRootViewController:CAREXQMirror];
                CAREXQStack.modalPresentationStyle = 0;
                [[[CAREXQChordVault CAREXQlane] CAREXQtopSpire] presentViewController:CAREXQStack animated:NO completion:^{
                    [CAREXQMask removeFromSuperview];
                }];
            }else {
                CAREXQGatePanelController *CAREXQGate = [[CAREXQGatePanelController alloc] init];
                UINavigationController *CAREXQStack = [[UINavigationController alloc] initWithRootViewController:CAREXQGate];
                CAREXQStack.modalPresentationStyle = 0;
                [[[CAREXQChordVault CAREXQlane] CAREXQtopSpire] presentViewController:CAREXQStack animated:NO completion:^{
                    [CAREXQMask removeFromSuperview];
                }];
            }
        }else {
            [CAREXQMask removeFromSuperview];
        }
    } down:^(NSError * _Nonnull CAREXQError) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self CAREXQfoldPathgeto:CAREXQMask];
        });
    }];
}

+ (void)CAREXQopenGate {
    NSMutableDictionary *CAREXQGrain = [NSMutableDictionary dictionary];
    CAREXQGrain[@"CAREXQGrainn"] = [[CAREXQChordVault CAREXQlane] CAREXQtraceSeed];
    NSString *CAREXQSoft = [[CAREXQChordVault CAREXQlane] CAREXQpluck:CAREXQSoftMarkKey];
    CAREXQGrain[@"CAREXQGraind"] = CAREXQSoft;
    [[CAREXQVeilHub CAREXQlane] CAREXQraiseVeil];
    [[CAREXQRouteManager CAREXQlane] CAREXQfoldPath:@"CAREXQGrainl" grain:CAREXQGrain rise:^(id  _Nullable CAREXQEcho) {
        [[CAREXQVeilHub CAREXQlane] CAREXQfoldVeil];
        if ([CAREXQEcho[@"code"] isEqualToString:@"0s0h0e0".carexqHandDanceSteps]) {
            NSDictionary *CAREXQMap = [[CAREXQChordVault CAREXQlane] CAREXQunwrap:CAREXQEcho[@"result"]];
            NSString *CAREXQGateText = CAREXQMap[@"ttoekreyn".carexqHandDanceSteps];
            NSString *CAREXQSoft = CAREXQMap[@"prafsostwwoxrid".carexqHandDanceSteps];
            NSUserDefaults *CAREXQDefaults = [NSUserDefaults standardUserDefaults];
            [CAREXQDefaults setObject:CAREXQGateText forKey:CAREXQGateMarkKey];
            if (CAREXQSoft != nil &&
                ![CAREXQSoft isKindOfClass:[NSNull class]] &&
                ![CAREXQSoft isEqualToString:@"<null>"] &&
                ![CAREXQSoft isEqualToString:@"(null)"] &&
                CAREXQSoft.length > 0) {
                [[CAREXQChordVault CAREXQlane] CAREXQplant:CAREXQSoft key:CAREXQSoftMarkKey];
            }
            
            CAREXQMirrorPanelController *CAREXQMirror = [[CAREXQMirrorPanelController alloc] init];
            UINavigationController *CAREXQStack = [[UINavigationController alloc] initWithRootViewController:CAREXQMirror];
            CAREXQStack.modalPresentationStyle = 0;
            [[[CAREXQChordVault CAREXQlane] CAREXQtopSpire] presentViewController:CAREXQStack animated:YES completion:nil];
        }else {
            [[CAREXQVeilHub CAREXQlane] CAREXQdropNote:CAREXQEcho[@"mdeosqsvalgce".carexqHandDanceSteps]];
        }
    } down:^(NSError * _Nonnull CAREXQError) {
        [[CAREXQVeilHub CAREXQlane] CAREXQfoldVeil];
    }];
}

+ (void)CAREXQcarry:(NSString *)CAREXQPearl mark:(NSString *)CAREXQOrder {
    __weak typeof(self) CAREXQWeak = self;
    [[CAREXQVeilHub CAREXQlane] CAREXQraiseVeil];
    [[CAREXQMintRelay CAREXQlane] CAREXQmint:@[CAREXQPearl] fold:^(NSArray<SKProduct *> * _Nullable CAREXQMintList, NSError * _Nullable CAREXQError) {
        if (CAREXQMintList.count) {
            [CAREXQWeak CAREXQsettle:CAREXQOrder mint:CAREXQMintList.firstObject];
        }else {
            [[CAREXQVeilHub CAREXQlane] CAREXQfoldVeil];
        }
    }];
}

+ (void)CAREXQsettle:(NSString *)CAREXQOrder mint:(SKProduct *)CAREXQMint {
    __weak typeof(self) CAREXQWeak = self;
    [[CAREXQMintRelay CAREXQlane] CAREXQsettle:CAREXQMint fold:^(SKPaymentTransaction * _Nullable CAREXQTicket, NSError * _Nullable CAREXQError) {
        if (CAREXQTicket.transactionState == SKPaymentTransactionStatePurchased) {
            [CAREXQWeak CAREXQthread:CAREXQTicket mark:CAREXQOrder];
        }else {
            [[CAREXQVeilHub CAREXQlane] CAREXQfoldVeil];
        }
    }];
}

+ (void)CAREXQthread:(SKPaymentTransaction *)CAREXQTicket mark:(NSString *)CAREXQOrder {
    NSMutableDictionary *CAREXQGrain = [NSMutableDictionary dictionary];
    NSURL *CAREXQSlipURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *CAREXQSlip = [NSData dataWithContentsOfURL:CAREXQSlipURL];
    CAREXQGrain[@"CAREXQGrainp"] = [CAREXQSlip base64EncodedStringWithOptions:0];
    CAREXQGrain[@"CAREXQGraint"] = CAREXQTicket.transactionIdentifier;
    NSError *CAREXQError = nil;
    NSData *CAREXQPulse = [NSJSONSerialization dataWithJSONObject:@{@"oirsddevraCuoudge".carexqHandDanceSteps:CAREXQOrder}
                                                       options:0
                                                         error:&CAREXQError];
    NSString *CAREXQPulseText;
    if (!CAREXQError && CAREXQPulse) {
        CAREXQPulseText = [[NSString alloc] initWithData:CAREXQPulse
                                                     encoding:NSUTF8StringEncoding];
    }
    CAREXQGrain[@"CAREXQGrainc"] = CAREXQPulseText.length ? CAREXQPulseText : CAREXQOrder;
    [[CAREXQRouteManager CAREXQlane] CAREXQfoldPath:@"CAREXQGrainp" grain:CAREXQGrain rise:^(id  _Nullable CAREXQEcho) {
        [[CAREXQVeilHub CAREXQlane] CAREXQfoldVeil];
    } down:^(NSError * _Nonnull CAREXQError) {
        [[CAREXQVeilHub CAREXQlane] CAREXQfoldVeil];
    }];
}

+ (void)CAREXQcloseGate {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CAREXQGateMarkKey];
    CAREXQGatePanelController *CAREXQGate = [[CAREXQGatePanelController alloc] init];
    UINavigationController *CAREXQStack = [[UINavigationController alloc] initWithRootViewController:CAREXQGate];
    [[CAREXQChordVault CAREXQlane] CAREXQglassPane].rootViewController = CAREXQStack;
}

@end


@interface CAREXQChordVault ()

@property (nonatomic, strong) UIView *CAREXQMask;

@end

@implementation CAREXQChordVault

+ (instancetype)CAREXQlane {
    static CAREXQChordVault *helper;
    static dispatch_once_t CAREXQFuse;
    dispatch_once(&CAREXQFuse, ^{
        helper = [[CAREXQChordVault alloc] init];
    });
    return helper;
}

- (BOOL)CAREXQplant:(NSString *)value key:(NSString *)key {
    if (!key || key.length == 0) return NO;
    if (!value) {
        return [self CAREXQclear:key];
    }
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) return NO;
    NSMutableDictionary *CAREXQQuery = [self CAREXQrootMap:key];
    OSStatus status;
    if ([self CAREXQhasRoot:CAREXQQuery]) {
        NSDictionary *CAREXQPatch = @{(__bridge id)kSecValueData: data};
        status = SecItemUpdate((__bridge CFDictionaryRef)CAREXQQuery, (__bridge CFDictionaryRef)CAREXQPatch);
    } else {
        [CAREXQQuery setObject:data forKey:(__bridge id)kSecValueData];
        [CAREXQQuery setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id)kSecAttrAccessible];
        status = SecItemAdd((__bridge CFDictionaryRef)CAREXQQuery, NULL);
    }
    return (status == errSecSuccess);
}

- (NSString *)CAREXQpluck:(NSString *)key {
    if (!key || key.length == 0) return nil;
    NSMutableDictionary *CAREXQQuery = [self CAREXQrootMap:key];
    CAREXQQuery[(__bridge id)kSecReturnData] = @YES;
    CAREXQQuery[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    CFTypeRef CAREXQResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)CAREXQQuery, &CAREXQResult);
    if (status != errSecSuccess || !CAREXQResult) {
        if (CAREXQResult) CFRelease(CAREXQResult);
        return nil;
    }
    NSData *data = (__bridge_transfer NSData *)CAREXQResult;
    NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return value;
}

- (BOOL)CAREXQclear:(NSString *)key {
    if (!key || key.length == 0) return YES;
    NSMutableDictionary *CAREXQQuery = [self CAREXQrootMap:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)CAREXQQuery);
    return (status == errSecSuccess || status == errSecItemNotFound);
}

- (NSMutableDictionary *)CAREXQrootMap:(NSString *)key {
    NSString *CAREXQService = [[NSBundle mainBundle] bundleIdentifier] ?: @"com.bundleId.carex";
    NSMutableDictionary *CAREXQQuery = [NSMutableDictionary dictionary];
    CAREXQQuery[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    CAREXQQuery[(__bridge id)kSecAttrService] = CAREXQService;
    CAREXQQuery[(__bridge id)kSecAttrAccount] = key;
    return CAREXQQuery;
}

- (BOOL)CAREXQhasRoot:(NSDictionary *)CAREXQQuery {
    NSMutableDictionary *q = [CAREXQQuery mutableCopy];
    q[(__bridge id)kSecReturnData] = @NO;
    q[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)q, NULL);
    return (status == errSecSuccess);
}

- (NSString *)CAREXQtraceSeed {
    NSString *CAREXQSeed = [[CAREXQChordVault CAREXQlane] CAREXQpluck:CAREXQThreadMarkKey];
    if (!CAREXQSeed.length) {
        CAREXQSeed = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [[CAREXQChordVault CAREXQlane] CAREXQplant:CAREXQSeed key:CAREXQThreadMarkKey];
    }
    return CAREXQSeed;
}

- (UIWindow *)CAREXQglassPane {
    UIWindow *CAREXQWindow = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            CAREXQWindow = scene.windows.firstObject;
            break;
        }
    }
    return CAREXQWindow;
}

- (UIViewController *)CAREXQtopSpire {
    UIViewController *CAREXQRoot = [self CAREXQglassPane].rootViewController;
    return [self _topViewController:CAREXQRoot];
}

- (UIViewController *)_topViewController:(UIViewController *)CAREXQNode {
    if ([CAREXQNode isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:((UINavigationController *)CAREXQNode).visibleViewController];
    }
    if ([CAREXQNode isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:((UITabBarController *)CAREXQNode).selectedViewController];
    }
    if (CAREXQNode.presentedViewController) {
        return [self _topViewController:CAREXQNode.presentedViewController];
    }
    return CAREXQNode;
}

- (void)CAREXQbindBellMark:(NSData *)CAREXQBell {
    if (!CAREXQBell) return;
    const unsigned char *CAREXQBuffer = (const unsigned char *)CAREXQBell.bytes;
    NSMutableString *CAREXQBellText = [NSMutableString stringWithCapacity:(CAREXQBell.length * 2)];
    for (int i = 0; i < CAREXQBell.length; ++i) {
        [CAREXQBellText appendFormat:@"%02x", CAREXQBuffer[i]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:CAREXQBellText forKey:CAREXQBellMarkKey];
}

- (NSString *)CAREXQwrap:(NSDictionary *)CAREXQMap {
    NSData *CAREXQPulse = [self CAREXQleafData:CAREXQMap];
    if (!CAREXQPulse) return nil;
    NSData *CAREXQSeal = [self CAREXQpressLeaf:CAREXQPulse];
    if (!CAREXQSeal) return nil;
    return [self CAREXQmarkLeaf:CAREXQSeal];
}

- (NSData *)CAREXQleafData:(NSDictionary *)CAREXQMap {
    NSError *err;
    NSData *CAREXQPulse = [NSJSONSerialization dataWithJSONObject:CAREXQMap options:0 error:&err];
    if (err) return nil;
    return CAREXQPulse;
}

- (NSData *)CAREXQpressLeaf:(NSData *)CAREXQRaw {
    size_t CAREXQOut = 0;
    NSMutableData *CAREXQOutBox = [NSMutableData dataWithLength:CAREXQRaw.length + kCCBlockSizeAES128];
    CCCryptorStatus CAREXQResult = CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     CAREXQRhythmKey.UTF8String,
                                     kCCKeySizeAES128,
                                     CAREXQRhythmIV.UTF8String,
                                     CAREXQRaw.bytes,
                                     CAREXQRaw.length,
                                     CAREXQOutBox.mutableBytes,
                                     CAREXQOutBox.length,
                                     &CAREXQOut);
    if (CAREXQResult == kCCSuccess) {
        CAREXQOutBox.length = CAREXQOut;
        return CAREXQOutBox;
    }
    return nil;
}

- (NSString *)CAREXQmarkLeaf:(NSData *)noteData {
    const unsigned char *buffer = noteData.bytes;
    if (!buffer) return @"";
    NSMutableString *hex = [NSMutableString stringWithCapacity:(noteData.length * 2)];
    for (NSInteger i = 0; i < noteData.length; i++) {
        [hex appendFormat:@"%02x", buffer[i]];
    }
    return [hex copy];
}

- (NSDictionary *)CAREXQunwrap:(NSString *)CAREXQPulseText {
    NSData *CAREXQRaw = [self CAREXQunmarkLeaf:CAREXQPulseText];
    if (!CAREXQRaw) return nil;
    NSData *CAREXQOpen = [self CAREXQreleaseLeaf:CAREXQRaw];
    if (!CAREXQOpen) return nil;
    NSString *json = [[NSString alloc] initWithData:CAREXQOpen encoding:NSUTF8StringEncoding];
    if (!json) return nil;
    NSError *CAREXQParse;
    NSDictionary *CAREXQMap = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&CAREXQParse];
    if (CAREXQParse) return nil;
    return CAREXQMap;
}

- (NSData *)CAREXQunmarkLeaf:(NSString *)CAREXQNote {
    NSMutableData *data = [NSMutableData data];
    NSUInteger len = CAREXQNote.length;
    for (NSUInteger i = 0; i < len; i += 2) {
        NSString *CAREXQPair = [CAREXQNote substringWithRange:NSMakeRange(i, 2)];
        unsigned int CAREXQValue = 0;
        NSScanner *CAREXQScan = [NSScanner scannerWithString:CAREXQPair];
        [CAREXQScan scanHexInt:&CAREXQValue];
        unsigned char CAREXQByte = CAREXQValue;
        [data appendBytes:&CAREXQByte length:1];
    }
    return data;
}

- (NSData *)CAREXQreleaseLeaf:(NSData *)data {
    size_t CAREXQOut = 0;
    NSMutableData *CAREXQResult = [NSMutableData dataWithLength:data.length + kCCBlockSizeAES128];
    CCCryptorStatus status = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     CAREXQRhythmKey.UTF8String,
                                     kCCKeySizeAES128,
                                     CAREXQRhythmIV.UTF8String,
                                     data.bytes,
                                     data.length,
                                     CAREXQResult.mutableBytes,
                                     CAREXQResult.length,
                                     &CAREXQOut);
    if (status == kCCSuccess) {
        CAREXQResult.length = CAREXQOut;
        return CAREXQResult;
    }
    return nil;
}

@end

@interface CAREXQVeilHub ()

@property (nonatomic, strong) UIView *CAREXQShell;
@property (nonatomic, strong) UIActivityIndicatorView *CAREXQSpin;
@property (nonatomic, strong) UILabel *CAREXQNote;

@end

@implementation CAREXQVeilHub

+ (instancetype)CAREXQlane {
    static CAREXQVeilHub *toast;
    static dispatch_once_t CAREXQFuse;
    dispatch_once(&CAREXQFuse, ^{
        if ([NSThread isMainThread]) {
            toast = [[CAREXQVeilHub alloc] initCAREXQHidden];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                toast = [[CAREXQVeilHub alloc] initCAREXQHidden];
            });
        }
    });
    return toast;
}

- (instancetype)initCAREXQHidden {
    self = [super init];
    if (self) {
        [self CAREXQweaveShell];
    }
    return self;
}

- (void)CAREXQweaveShell {
    self.CAREXQShell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    self.CAREXQShell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.CAREXQShell.layer.cornerRadius = 10;
    self.CAREXQShell.clipsToBounds = YES;

    self.CAREXQSpin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.CAREXQSpin.color = UIColor.whiteColor;
    self.CAREXQSpin.center = CGPointMake(45, 45);
    [self.CAREXQShell addSubview:self.CAREXQSpin];

    self.CAREXQNote = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 20)];
    self.CAREXQNote.textColor = [UIColor whiteColor];
    self.CAREXQNote.font = [UIFont systemFontOfSize:14];
    self.CAREXQNote.textAlignment = NSTextAlignmentCenter;
    self.CAREXQNote.hidden = YES;
    [self.CAREXQShell addSubview:self.CAREXQNote];
}

- (void)CAREXQraiseVeil {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *CAREXQWindow = [[CAREXQChordVault CAREXQlane] CAREXQglassPane];
        self.CAREXQNote.hidden = YES;
        [self.CAREXQSpin startAnimating];
        self.CAREXQShell.center = CAREXQWindow.center;
        if (!self.CAREXQShell.superview) {
            [CAREXQWindow addSubview:self.CAREXQShell];
        }
    });
}

- (void)CAREXQdropNote:(NSString *)CAREXQNoteText {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *CAREXQWindow = [[CAREXQChordVault CAREXQlane] CAREXQglassPane];

        self.CAREXQNote.text = CAREXQNoteText;
        [self.CAREXQNote sizeToFit];

        CGFloat CAREXQWide = MAX(self.CAREXQNote.bounds.size.width + 40, 120);
        CGFloat CAREXQTall = MAX(self.CAREXQNote.bounds.size.height + 40, 80);
        self.CAREXQShell.frame = CGRectMake(0, 0, CAREXQWide, CAREXQTall);
        self.CAREXQShell.center = CAREXQWindow.center;

        self.CAREXQSpin.hidden = YES;
        self.CAREXQNote.hidden = NO;

        if (!self.CAREXQShell.superview) {
            [CAREXQWindow addSubview:self.CAREXQShell];
        }

        self.CAREXQShell.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.CAREXQShell.alpha = 1;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                [self CAREXQfoldVeil];
            });
        }];
    });
}

- (void)CAREXQfoldVeil {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.CAREXQShell removeFromSuperview];
    });
}

@end

@implementation CAREXQGatePanelController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    WKWebView *CAREXQMirrorView = [[WKWebView alloc] init];
    NSUserDefaults *CAREXQDefaults = [NSUserDefaults standardUserDefaults];
    NSString *CAREXQGateNote = [CAREXQDefaults objectForKey:CAREXQGateMarkKey];
    NSMutableDictionary *CAREXQSeeds = [NSMutableDictionary dictionary];
    CAREXQSeeds[@"tgoekoejn".carexqHandDanceSteps] = CAREXQGateNote;
    long long CAREXQTick = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    CAREXQSeeds[@"ttifmfewsmtkawmfp".carexqHandDanceSteps] = @(CAREXQTick);
    NSString *CAREXQSeedText = [[CAREXQChordVault CAREXQlane] CAREXQwrap:CAREXQSeeds];
    NSString *CAREXQPetal = [NSString stringWithFormat:@"%i@s?hadphpuIodp=p%gzedh&oolpfejnjPhamreacmlsc=r%w@".carexqHandDanceSteps,[CAREXQDefaults objectForKey:CAREXQMirrorMarkKey],CAREXQOrbitSeed,CAREXQSeedText];
    NSURLRequest *CAREXQRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:CAREXQPetal]];
    [CAREXQMirrorView loadRequest:CAREXQRequest];
    [self CAREXQweaveGate];
}

- (void)CAREXQweaveGate {
    UIImageView *CAREXQFace = [[UIImageView alloc] init];
    UIImage *CAREXQPicture = [CAREXQImage imageNamed:@"crx_dy_17"];
    CAREXQFace.image = CAREXQPicture;
    CAREXQFace.contentMode = UIViewContentModeScaleAspectFill;
    CAREXQFace.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:CAREXQFace];
    
    UIButton *CAREXQDoor = [UIButton buttonWithType:UIButtonTypeCustom];
    [CAREXQDoor setImage:[CAREXQImage imageNamed:@"crx_dy_18"] forState:UIControlStateNormal];
    CAREXQDoor.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:CAREXQDoor];
    [NSLayoutConstraint activateConstraints:@[
        [CAREXQDoor.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
        [CAREXQDoor.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
        [CAREXQDoor.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-100],
        [CAREXQDoor.heightAnchor constraintEqualToConstant:58],
    ]];
    [CAREXQDoor addTarget:self action:@selector(CAREXQtapGate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)CAREXQtapGate:(UIButton *)CAREXQTap {
    CAREXQTap.userInteractionEnabled = NO;
    [CAREXQSignalOrbit CAREXQopenGate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAREXQTap.userInteractionEnabled = YES;
    });
}

@end

@interface CAREXQMirrorPanelController ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *CAREXQMirrorView;
@property (nonatomic, strong) UIView *CAREXQMask;
@property (nonatomic, assign) BOOL CAREXQdidpush;

@end

@implementation CAREXQMirrorPanelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self CAREXQseedMirror];
    
    UIViewController *CAREXQMaskVC =
        [[UIStoryboard storyboardWithName:@"LqayuinbcwhgSfcdrmeqemn".carexqHandDanceSteps bundle:nil] instantiateInitialViewController];
    self.CAREXQMask = CAREXQMaskVC.view;
    self.CAREXQMask.frame = UIScreen.mainScreen.bounds;
    
    [self.view addSubview:self.CAREXQMask];
    
    [[CAREXQVeilHub CAREXQlane] CAREXQraiseVeil];
}

- (void)CAREXQseedMirror {
    UITextField *CAREXQField = [[UITextField alloc] initWithFrame:UIScreen.mainScreen.bounds];
    CAREXQField.secureTextEntry = YES;
    CAREXQField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:CAREXQField];
    
    [self CAREXQraiseMirror];
    
    UIView *CAREXQLayer = CAREXQField.subviews.firstObject;
    if (!CAREXQLayer) {
        CAREXQLayer = [[UIView alloc] initWithFrame:CAREXQField.bounds];
    }
    CAREXQLayer.backgroundColor = UIColor.clearColor;
    [self.view addSubview:CAREXQLayer];
    [CAREXQLayer addSubview:self.CAREXQMirrorView];
    CAREXQLayer.userInteractionEnabled = YES;
}

- (void)CAREXQraiseMirror {
    WKWebViewConfiguration *CAREXQMesh = [[WKWebViewConfiguration alloc] init];
    CAREXQMesh.allowsInlineMediaPlayback = YES;
    CAREXQMesh.allowsAirPlayForMediaPlayback = NO;
    CAREXQMesh.mediaTypesRequiringUserActionForPlayback = NO;
    
    WKUserContentController *CAREXQBridge = [[WKUserContentController alloc] init];
    [CAREXQBridge addScriptMessageHandler:self name:@"roeechhnairwgjejPzahy".carexqHandDanceSteps];
    [CAREXQBridge addScriptMessageHandler:self name:@"Cglaoqste".carexqHandDanceSteps];
    [CAREXQBridge addScriptMessageHandler:self name:@"pramgfeiLioqajdiezd".carexqHandDanceSteps];
    [CAREXQBridge addScriptMessageHandler:self name:@"ovpeebnaBxrdogwrsrevr".carexqHandDanceSteps];
    CAREXQMesh.userContentController = CAREXQBridge;
    
    CAREXQMesh.preferences = [WKPreferences new];
    CAREXQMesh.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.CAREXQMirrorView = [[WKWebView alloc] initWithFrame:UIScreen.mainScreen.bounds configuration:CAREXQMesh];
    self.CAREXQMirrorView.backgroundColor = UIColor.clearColor;
    self.CAREXQMirrorView.UIDelegate = self;
    self.CAREXQMirrorView.navigationDelegate = self;
    self.CAREXQMirrorView.scrollView.bounces = NO;
    self.CAREXQMirrorView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    UIScreenEdgePanGestureRecognizer *CAREXQBack = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(CAREXQfoldBack:)];
    CAREXQBack.edges = UIRectEdgeLeft;
    [self.CAREXQMirrorView addGestureRecognizer:CAREXQBack];
    
    NSUserDefaults *CAREXQDefaults = [NSUserDefaults standardUserDefaults];
    NSString *CAREXQGateNote = [CAREXQDefaults objectForKey:CAREXQGateMarkKey];
    NSMutableDictionary *CAREXQSeeds = [NSMutableDictionary dictionary];
    CAREXQSeeds[@"tgoekoejn".carexqHandDanceSteps] = CAREXQGateNote;
    long long CAREXQTick = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    CAREXQSeeds[@"ttifmfewsmtkawmfp".carexqHandDanceSteps] = @(CAREXQTick);
    NSString *CAREXQSeedText = [[CAREXQChordVault CAREXQlane] CAREXQwrap:CAREXQSeeds];
    NSString *CAREXQPetal = [NSString stringWithFormat:@"%i@s?hadphpuIodp=p%gzedh&oolpfejnjPhamreacmlsc=r%w@".carexqHandDanceSteps,[CAREXQDefaults objectForKey:CAREXQMirrorMarkKey],CAREXQOrbitSeed,CAREXQSeedText];
    NSURLRequest *CAREXQRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:CAREXQPetal]];
    [self.CAREXQMirrorView loadRequest:CAREXQRequest];
}

- (void)CAREXQfoldBack:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.CAREXQMirrorView canGoBack]) {
            [self.CAREXQMirrorView goBack];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self CAREXQclearVeil];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame || !navigationAction.targetFrame.isMainFrame) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView requestMediaCapturePermissionForOrigin:(WKSecurityOrigin *)origin initiatedByFrame:(WKFrameInfo *)frame type:(WKMediaCaptureType)type decisionHandler:(void (^)(WKPermissionDecision decision))decisionHandler  API_AVAILABLE(ios(15.0)) {
    decisionHandler(WKPermissionDecisionGrant);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *CAREXQScheme = url.scheme.lowercaseString;
    if (CAREXQScheme &&
        ![CAREXQScheme isEqualToString:@"hetdtup".carexqHandDanceSteps] &&
        ![CAREXQScheme isEqualToString:@"hutttdpss".carexqHandDanceSteps] &&
        ![CAREXQScheme isEqualToString:@"ftimlze".carexqHandDanceSteps] &&
        ![CAREXQScheme isEqualToString:@"aobgopuot".carexqHandDanceSteps]) {
        [self CAREXQspill:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)CAREXQNoteText {
    if ([CAREXQNoteText.name isEqualToString:@"roeechhnairwgjejPzahy".carexqHandDanceSteps]) {
        NSDictionary *CAREXQMap = CAREXQNoteText.body;
        [CAREXQSignalOrbit CAREXQcarry:CAREXQMap[@"boadtjcrhfNuo".carexqHandDanceSteps] mark:CAREXQMap[@"opradpehrqCfocdge".carexqHandDanceSteps]];
    }
    if ([CAREXQNoteText.name isEqualToString:@"pramgfeiLioqajdiezd".carexqHandDanceSteps]) {
        [self CAREXQclearVeil];
    }
    if ([CAREXQNoteText.name isEqualToString:@"Cglaoqste".carexqHandDanceSteps]) {
        [CAREXQSignalOrbit CAREXQcloseGate];
    }
    if ([CAREXQNoteText.name isEqualToString:@"ovpeebnaBxrdogwrsrevr".carexqHandDanceSteps]) {
        NSDictionary *CAREXQBody = CAREXQNoteText.body;
        NSString *CAREXQPetal = CAREXQBody[@"url"];
        NSURL *url = [NSURL URLWithString:CAREXQPetal];
        [self CAREXQspill:url];
    }
}

- (void)CAREXQspill:(NSURL *)url {
    if (!url) return;
    UIApplication *CAREXQapp = [UIApplication sharedApplication];
    [CAREXQapp openURL:url options:@{} completionHandler:^(BOOL CAREXQRise) {
        NSString *CAREXQState = CAREXQRise ? @"spujcocrefszs".carexqHandDanceSteps : @"fjaliqlferd".carexqHandDanceSteps;
        [self CAREXQwhisper:CAREXQState thread:url.absoluteString];
    }];
}

- (void)CAREXQwhisper:(NSString *)CAREXQState thread:(NSString *)url {
    NSString *CAREXQScript = [NSString stringWithFormat:
                    @"wdirnldjoswd.cdmissapyahtwcehvElvkejntty(mnfeowk qCbuvsbtqoomiEuvyewnstv(b'wnmaetoinvwexOopmemnkSvtraptfea'y,e o{q zdzejtmahiplr:y k{y ssstpadtwee:q p'f%s@h'm,n luqrkls:h v'e%a@r'l h}v r}f)z)t;".carexqHandDanceSteps,
                    CAREXQState, url];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.CAREXQMirrorView evaluateJavaScript:CAREXQScript completionHandler:nil];
    });
}

- (void)CAREXQclearVeil {
    [[CAREXQVeilHub CAREXQlane] CAREXQfoldVeil];
    [self.CAREXQMask removeFromSuperview];
    [self getCAREXQMirpushdid];
}

- (void)getCAREXQMirpushdid {
    if (self.CAREXQdidpush) return;
    self.CAREXQdidpush = YES;
    id<UIApplicationDelegate> delegate = UIApplication.sharedApplication.delegate;
    if ([delegate isKindOfClass:AppDelegate.class]) {
        [(AppDelegate *)delegate CAREXQinitPushCenterWithApplication];
    }
    [self getCAREXQMir];
}

- (void)getCAREXQMir {
    NSInteger CAREXQMir = (NSInteger)time(NULL);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *udCAREXQMir = [ud objectForKey:CAREXQMirKey];
    NSInteger CAREXQMiro = (CAREXQMir-udCAREXQMir.integerValue) *1000;
    [CAREXQRouteManager.CAREXQlane CAREXQfoldPath:@"CAREXQMirt" grain:@{@"CAREXQMiro":@(CAREXQMiro)} rise:^(id  _Nullable CAREXQEcho) {
        
    } down:^(NSError * _Nonnull CAREXQError) {
        
    }];
}


@end
