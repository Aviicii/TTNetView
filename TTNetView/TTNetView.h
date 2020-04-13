//
//  TTNetView.h
//  TTNetView
//
//  Created by Avicii on 2020/4/11.
//  Copyright © 2020 Avicii. All rights reserved.
//

typedef enum {
    NoNet = 0, // 无网
    YesNet // 有网
} NetMore;

#import <UIKit/UIKit.h>

#define ShowViewNotification @"ShowViewNotification" ///< 窗口弹出通知
#define DisMissViewNotification @"DisMissViewNotification" ///< 窗口消除通知
#define ShowBarNotification @"ShowBarNotification" ///< Bar上移通知
#define DisMissBarNotification @"DisMissBarNotification" ///< Bar下移通知
#define TTHeight 20

NS_ASSUME_NONNULL_BEGIN

@interface TTNetView : UIView

+ (instancetype)shareManager;

- (void)AFNReachability;

- (void)show;

- (void)disMiss;

@property (nonatomic, assign) NetMore more; ///< 网络状态

@end

NS_ASSUME_NONNULL_END
