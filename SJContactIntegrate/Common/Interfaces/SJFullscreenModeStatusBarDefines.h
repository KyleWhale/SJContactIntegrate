//
//  SJFullscreenModeStatusBarDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/12/11.
//

#ifndef SJFullscreenModeStatusBarDefines_h
#define SJFullscreenModeStatusBarDefines_h
#import <UIKit/UIKit.h>
#import <SJBaseSequenceInvolve/SJReachabilityDefines.h>

NS_ASSUME_NONNULL_BEGIN
NS_AVAILABLE_IOS(11.0)
@protocol SJFullscreenModeStatusBar <NSObject>

@property (nonatomic) SJNetworkStatus networkStatus;

@property (nonatomic, strong, nullable) NSDate *date;

@property (nonatomic) UIDeviceBatteryState batteryState;

@property (nonatomic) float batteryLevel;
@end
NS_ASSUME_NONNULL_END

#endif /* SJFullscreenModeStatusBarDefines_h */
