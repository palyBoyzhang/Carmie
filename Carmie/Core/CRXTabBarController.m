//
//  CRXTabBarController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXTabBarController.h"
#import "CRXStageController.h"
#import "CRXLoopBoardController.h"
#import "CRXSignalBoardController.h"
#import "CRXHarborController.h"
#import "CRXTabBar.h"
#import "CRXNavController.h"

@interface CRXTabBarController ()

@end

@implementation CRXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self crx_replaceTabBar];
    
    [self crx_setupControllers];
}

- (void)crx_replaceTabBar {
    
    CRXTabBar *tabBar = [[CRXTabBar alloc] init];
    
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)crx_setupControllers {
    
    CRXStageController *stage = [[CRXStageController alloc] init];
    [self crx_addChildController:stage
                           image:@"tab_stage"
                   selectedImage:@"tab_stage_sel"];
    
    
    CRXLoopBoardController *loop = [[CRXLoopBoardController alloc] init];
    [self crx_addChildController:loop
                           image:@"tab_loop"
                   selectedImage:@"tab_loop_sel"];
    
    
    CRXSignalBoardController *signal = [[CRXSignalBoardController alloc] init];
    [self crx_addChildController:signal
                           image:@"tab_signal"
                   selectedImage:@"tab_signal_sel"];
    
    
    CRXHarborController *harbor = [[CRXHarborController alloc] init];
    [self crx_addChildController:harbor
                           image:@"tab_harbor"
                   selectedImage:@"tab_harbor_sel"];
}

- (void)crx_addChildController:(UIViewController *)controller
                         image:(NSString *)image
                 selectedImage:(NSString *)selectedImage {
    
    controller.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller.tabBarItem.title = nil;
    
    CRXNavController *nav = [[CRXNavController alloc] initWithRootViewController:controller];
    
    [self addChildViewController:nav];
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
