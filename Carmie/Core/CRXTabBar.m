//
//  CRXTabBar.m
//  Carmie
//
//  Created by w zhang on 2026/3/16.
//

#import "CRXTabBar.h"

NSNotificationName const CRXForgeButtonDidTapNotification = @"CRXForgeButtonDidTapNotification";

@interface CRXTabBar ()

@property (nonatomic, strong) UIButton *crxForgeButton;

@end

@implementation CRXTabBar

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:0x00/255.0
                                               green:0x06/255.0
                                                blue:0x16/255.0
                                               alpha:1];
        
        [self addSubview:self.crxForgeButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat buttonW = width / 5.0;
    
    NSInteger index = 0;
    
    for (UIView *subView in self.subviews) {
        
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            CGRect frame = subView.frame;
            
            frame.size.width = buttonW;
            frame.origin.x = buttonW * (index >= 2 ? index + 1 : index);
            
            subView.frame = frame;
            
            index++;
        }
    }
    
    self.crxForgeButton.frame = CGRectMake(0, 0, 52, 52);
    self.crxForgeButton.center = CGPointMake(width * 0.5, height * 0.5 - 25);
}

- (UIButton *)crxForgeButton {
    
    if (!_crxForgeButton) {
        
        _crxForgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_crxForgeButton setImage:[UIImage imageNamed:@"tab_btn"]
                         forState:UIControlStateNormal];
        [_crxForgeButton setImage:[UIImage imageNamed:@"tab_btn"]
                         forState:UIControlStateHighlighted];
        [_crxForgeButton addTarget:self
                            action:@selector(crxForgeAction)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _crxForgeButton;
}

- (void)crxForgeAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:CRXForgeButtonDidTapNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
