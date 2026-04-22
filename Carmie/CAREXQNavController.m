//
//  CAREXQNavController.m
//  CAREXQ
//
//  Created by CAREXQ on 2026/3/16.
//

#import "CAREXQNavController.h"
#import "CAREXQImage.h"

@interface CAREXQNavController ()

@end

@implementation CAREXQNavController

+ (void)load {
    UINavigationBar *crxNaviBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [crxNaviBar setTitleTextAttributes:attrs];
    [crxNaviBar setShadowImage:[UIImage new]];
    UINavigationBarAppearance *crxNaviBarAppearance = [[UINavigationBarAppearance alloc] init];
    [crxNaviBarAppearance configureWithOpaqueBackground];
    crxNaviBarAppearance.titleTextAttributes = attrs;
    crxNaviBarAppearance.backgroundColor = [UIColor clearColor];
    crxNaviBar.standardAppearance = crxNaviBarAppearance;
    crxNaviBar.scrollEdgeAppearance = crxNaviBarAppearance;
    [UITableView appearance].sectionHeaderTopPadding = 0;
    crxNaviBarAppearance.shadowColor = [UIColor clearColor];
    crxNaviBarAppearance.backgroundEffect = nil;
}

- (void)pushViewController:(UIViewController *)crxVC animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        crxVC.hidesBottomBarWhenPushed = YES;
        UIButton *crxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [crxButton setImage:[CAREXQImage imageNamed:@"crx_harbor_back@3x"] forState:UIControlStateNormal];
        [crxButton sizeToFit];
        [crxButton addTarget:self action:@selector(crxButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        crxVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:crxButton];
    }
    [super pushViewController:crxVC animated:animated];
}

- (void)crxButtonTapped {
    [self popViewControllerAnimated:YES];
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
