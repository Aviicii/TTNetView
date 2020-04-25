//
//  TTNetView.m
//  TTNetView
//
//  Created by Avicii on 2020/4/11.
//  Copyright © 2020 Avicii. All rights reserved.
//

#import "TTNetView.h"
#import "AFNetworking.h"
#import <AudioToolbox/AudioToolbox.h>

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface TTNetView ()

@property (nonatomic, strong) UILabel *tip; ///< 文字描述
@property (nonatomic, assign) BOOL isGet; ///< 是否收到AF通知，防止AF通知数次重复执行
@property (nonatomic, assign) BOOL isExist; ///< 是否已经存在弹窗
@end

@implementation TTNetView {
    
}
static TTNetView *manager = nil;



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ShowViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DisMissViewNotification object:nil];
}

+ (instancetype)shareManager {
//    static TTNetView *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [super new];
        }
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupView];
        self.isGet = NO;
    }
    return self;
}

- (void)setupView
{
    self.tip = [UILabel new];
    self.tip.frame = CGRectMake(0, 0, Screen_Width, TTHeight);
    self.tip.font = [UIFont systemFontOfSize:14];
    self.tip.textAlignment = NSTextAlignmentCenter;
}

- (void)setConfig:(NetMore)more
{
    [manager addSubview:self.tip];
    
    if (!more) {
        manager.backgroundColor = [UIColor redColor];
        self.tip.text = @"无网络连接";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.more == NoNet) {
                UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
                [impactLight impactOccurred];
            }
        });
    }else{
        manager.backgroundColor = [UIColor greenColor];
        self.tip.text = @"已重新连接网络";
    }
}

- (void)show
{
    if (!self.isExist) {
        manager.frame = CGRectMake(0, Screen_Height, Screen_Width, TTHeight);
    }
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:manager];
    [UIView animateWithDuration:1.f animations:^{
        if (!self.isExist) {
            manager.frame = CGRectMake(0, manager.frame.origin.y - TTHeight, Screen_Width, TTHeight);
        }
    } completion:^(BOOL finished) {
        self.isExist = YES;
    }];
}

- (void)disMiss
{
    if (self.more == YesNet) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DisMissBarNotification object:nil];
        [UIView animateWithDuration:1.f animations:^{
            manager.frame = CGRectMake(0, Screen_Height, Screen_Width, TTHeight);
        } completion:^(BOOL finished) {
            [manager removeFromSuperview];
            if (self.more == YesNet) {
                self.isExist = NO;
            }
        
        }];
    }
}

#pragma mark AFN监测网络状态变化
- (void)AFNReachability
{
  AFNetworkReachabilityManager *AFNManager = [AFNetworkReachabilityManager sharedManager];
    __weak AFNetworkReachabilityManager *weakManager = AFNManager;
    __weak TTNetView *weakSelf = self;
  [AFNManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
          
          if (!weakSelf.isGet) {
              weakSelf.isGet = YES;
              weakSelf.more = NoNet;
              [[NSNotificationCenter defaultCenter] postNotificationName:ShowBarNotification object:nil];
              [weakSelf setConfig:NoNet];
              [weakSelf show];
          }
      }else{
          if (weakSelf.isGet) {
              weakSelf.isGet = NO;
              weakSelf.more = YesNet;
              [weakSelf setConfig:YesNet];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [weakSelf disMiss];
              });
          }
      }
      [weakManager startMonitoring];
  }];
 
  //3.开始监听
  [AFNManager startMonitoring];
}

#pragma mark 判断设备
+ (BOOL)isiPhoneXSeries
{
    BOOL iPhoneX = NO;
    /// 先判断设备是否是iPhone/iPod
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    
    if (@available(iOS 11.0, *)) {
        /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}

@end
