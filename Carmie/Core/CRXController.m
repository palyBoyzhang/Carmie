//
//  CRXController.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXController.h"

@interface CRXController ()

@end

@implementation CRXController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *crxImageView = [[UIImageView alloc] init];
    crxImageView.image = [UIImage imageNamed:@"crx_bg_icon"];
    crxImageView.contentMode = UIViewContentModeScaleAspectFill;
    crxImageView.frame = UIScreen.mainScreen.bounds;
    [self.view addSubview:crxImageView];
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
