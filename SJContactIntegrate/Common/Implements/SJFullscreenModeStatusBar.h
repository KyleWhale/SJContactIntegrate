//
//  SJFullscreenModeStatusBar.h
//  Pods
//
//  Created by 畅三江 on 2019/12/11.
//

#import <UIKit/UIKit.h>
#import "SJFullscreenModeStatusBarDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJFullscreenModeStatusBar : UIView<SJFullscreenModeStatusBar>

@property (nonatomic) SJNetworkStatus networkStatus;

@property (nonatomic, strong, nullable) NSDate *date;

@property (nonatomic) UIDeviceBatteryState batteryState;

@property (nonatomic) float batteryLevel;
@end
NS_ASSUME_NONNULL_END
