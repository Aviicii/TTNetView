//
//  BaseNavigationVC.m
//  BaoliProp
//
//  Created by Jason on 19/6/16.
//  Copyright © 2016年 com.baoli. All rights reserved.
//

#import "BaseNavigationVC.h"
#import "TTNetView.h"

@interface BaseNavigationVC ()

@end

@implementation BaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark 重写push、pop方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    //改tabBar的frame
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.tabBarController.tabBar.frame = frame;
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [super popViewControllerAnimated:animated];
    
    if (self.childViewControllers.count <= 1) {
        //改tabBar的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        if ([TTNetView shareManager].more == NoNet) {
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - TTHeight;
        }else{
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        }
        self.tabBarController.tabBar.frame = frame;
    }
    return self;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    [super popToRootViewControllerAnimated:animated];
    if (self.childViewControllers.count <= 1) {
        //改tabBar的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        if ([TTNetView shareManager].more == NoNet) {
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - TTHeight;
        }else{
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        }
        self.tabBarController.tabBar.frame = frame;
    }
    return self.childViewControllers;
}

@end
