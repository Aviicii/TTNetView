//
//  BaseVC.m
//  TTNetView
//
//  Created by Avicii on 2020/4/11.
//  Copyright © 2020 Avicii. All rights reserved.
//

#import "BaseVC.h"
#import "TTNetView.h"
#import "BaseNavigationVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (instancetype)init
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)push:(UIButton *)sender
{
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController pushViewController:[BaseVC new] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UINavigationController *)creatNavVCForMySelfIfNil
{
    if (!self.navigationController) {
        BaseNavigationVC *nav =  [[BaseNavigationVC alloc] initWithRootViewController:self];
        nav.navigationBar.barStyle = UIBarStyleDefault;
        nav.navigationBar.barTintColor = [UIColor whiteColor];
        nav.navigationBar.tintColor = [UIColor whiteColor];
        nav.navigationBar.translucent = NO;
        return nav;
    }else{
        return self.navigationController;
    }
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
