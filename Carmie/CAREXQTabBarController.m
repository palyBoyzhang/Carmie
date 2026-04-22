//
//  CAREXQTabBarController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQTabBarController.h"
#import "CAREXQImage.h"
#import "CAREXQStageController.h"
#import "CAREXQLoopBoardController.h"
#import "CAREXQSignalBoardController.h"
#import "CAREXQHarborController.h"
#import "CAREXQTabBar.h"
#import "CAREXQNavController.h"
#import "CAREXQForgeController.h"
#import "CAREXQEntryController.h"

@interface CAREXQTabBarController ()

@end

@implementation CAREXQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self crx_replaceTabBar];
    
    [self crx_setupControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crxForgeButtonTapped) name:CAREXQForgeButtonDidTapNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)crx_replaceTabBar {
    
    CAREXQTabBar *tabBar = [[CAREXQTabBar alloc] init];
    
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)crx_setupControllers {
    
    CAREXQStageController *stage = [[CAREXQStageController alloc] init];
    [self crx_addChildController:stage
                           image:@"tab_stage"
                   selectedImage:@"tab_stage_sel"];
    
    
    CAREXQLoopBoardController *loop = [[CAREXQLoopBoardController alloc] init];
    [self crx_addChildController:loop
                           image:@"tab_loop"
                   selectedImage:@"tab_loop_sel"];
    
    
    CAREXQSignalBoardController *signal = [[CAREXQSignalBoardController alloc] init];
    [self crx_addChildController:signal
                           image:@"tab_signal"
                   selectedImage:@"tab_signal_sel"];
    
    
    CAREXQHarborController *harbor = [[CAREXQHarborController alloc] init];
    [self crx_addChildController:harbor
                           image:@"tab_harbor"
                   selectedImage:@"tab_harbor_sel"];
}

- (void)crx_addChildController:(UIViewController *)controller
                         image:(NSString *)image
                 selectedImage:(NSString *)selectedImage {
    
    controller.tabBarItem.image = [[CAREXQImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller.tabBarItem.selectedImage = [[CAREXQImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller.tabBarItem.title = nil;
    
    CAREXQNavController *nav = [[CAREXQNavController alloc] initWithRootViewController:controller];
    
    [self addChildViewController:nav];
}

- (void)crxForgeButtonTapped {
    UIViewController *crxSelectedController = self.selectedViewController;
    if (![crxSelectedController isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    UINavigationController *crxNavigationController = (UINavigationController *)crxSelectedController;
    if (![CAREXQController crx_isLoggedIn]) {
        CAREXQEntryController *crxEntryController = [[CAREXQEntryController alloc] init];
        [crxNavigationController pushViewController:crxEntryController animated:YES];
        return;
    }
    if ([crxNavigationController.topViewController isKindOfClass:[CAREXQForgeController class]]) {
        return;
    }
    
    CAREXQForgeController *crxForgeController = [[CAREXQForgeController alloc] init];
    [crxNavigationController pushViewController:crxForgeController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
