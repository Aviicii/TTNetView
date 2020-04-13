//
//  BaseTabBar.m
//  TTNetView
//
//  Created by Avicii on 2020/4/11.
//  Copyright © 2020 Avicii. All rights reserved.
//

#import "BaseTabBar.h"
#import "BaseVC.h"
#import "TTNetView.h"
#import "AppDelegate.h"

@interface BaseTabBar ()

@end

@implementation BaseTabBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ShowBarNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DisMissBarNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initChildViewControllers];
    [self setupConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:ShowBarNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disMiss) name:DisMissBarNotification object:nil];
}

- (void)initChildViewControllers
{
    
    NSArray *classStrs = @[
                           NSStringFromClass([BaseVC class]),
                           NSStringFromClass([BaseVC class]),
                           NSStringFromClass([BaseVC class]),
                           NSStringFromClass([BaseVC class])
                           ];
    NSMutableArray *VCS = @[].mutableCopy;
    for (int i = 0; i < classStrs.count; i++) {
        NSString *classStr = classStrs[i];
        Class class = NSClassFromString(classStr);
        BaseVC *VC = [class new];
        UINavigationController *nav = [VC creatNavVCForMySelfIfNil];
        [VCS addObject:nav];
    }
    
    self.viewControllers = VCS;
}

- (void)setupConfig
{
    self.tabBar.tintColor = [UIColor redColor];
    NSArray *titles = @[@"首页", @"二页", @"三页", @"四页"];
    for (int i = 0; i < titles.count; i++) {
        UIViewController *VC = self.childViewControllers[i];
        VC.tabBarItem.title = titles[i];
    }
}

- (void)show
{
    NSLog(@"%ld",[self topViewController:nil].navigationController.childViewControllers.count);
    if ([self topViewController:nil].navigationController.childViewControllers.count <= 1) {
        [UIView animateWithDuration:1.f animations:^{
            CGRect tabFrame = self.tabBar.frame;
            tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height - TTHeight;
            self.tabBar.frame = tabFrame;
        }];
    }
}

- (void)disMiss
{
    if ([self topViewController:nil].navigationController.childViewControllers.count <= 1) {
        [UIView animateWithDuration:1.f animations:^{
            CGRect tabFrame = self.tabBar.frame;
            tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height;
            self.tabBar.frame = tabFrame;
        }];
    }
}

#pragma mark 获取当前弹窗所在控制器
- (UIViewController *)topViewController:(UIViewController *)baseViewController {
    if (baseViewController == nil) {
        baseViewController = [[[UIApplication sharedApplication] windows] objectAtIndex:0].rootViewController;
    }
    
    if ([baseViewController isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:((UINavigationController *)baseViewController).visibleViewController];
    }
    
    if ([baseViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectViewController = ((UITabBarController *)baseViewController).selectedViewController;
        if (selectViewController) {
            return [self topViewController:selectViewController];
        }
    }
    
    UIViewController *presentViewController = baseViewController.presentedViewController;
    if (presentViewController) {
        return [self topViewController:presentViewController];
    }
    
    return baseViewController;
}

@end
