//
//  SJContactIntegrateConfigurations.m
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2017/9/25.
//  Copyright © 2017年 changsanjiang. All rights reserved.
//

#import "SJContactIntegrateConfigurations.h"
#import <UIKit/UIKit.h>
#import <AVKit/AVPictureInPictureController.h>
#import "SJContactIntegrateResourceLoader.h"

NS_ASSUME_NONNULL_BEGIN
NSNotificationName const SJContactIntegrateConfigurationsDidUpdateNotification = @"SJContactIntegrateConfigurationsDidUpdateNotification";

@interface SJContactIntegrateControlLayerResources : NSObject<SJContactIntegrateControlLayerResources>
@property (nonatomic, strong, nullable) UIImage *placeholder;

#pragma mark - SJEdgeControlLayer Resources

// picture in picture
@property (nonatomic, strong, nullable) UIImage *pictureInPictureItemStartImage API_AVAILABLE(ios(14.0));
@property (nonatomic, strong, nullable) UIImage *pictureInPictureItemStopImage API_AVAILABLE(ios(14.0));

// speedup contentData popup view(长按快进时显示的视图)
@property (nonatomic, strong, nullable) UIColor *speedupContentDataTriangleColor;
@property (nonatomic, strong, nullable) UIColor *speedupContentDataRateTextColor;
@property (nonatomic, strong, nullable) UIFont  *speedupContentDataRateTextFont;
@property (nonatomic, strong, nullable) UIColor *speedupContentDataTextColor;
@property (nonatomic, strong, nullable) UIFont  *speedupContentDataTextFont;

// loading view
@property (nonatomic, strong, nullable) UIColor *loadingNetworkSpeedTextColor;
@property (nonatomic, strong, nullable) UIFont  *loadingNetworkSpeedTextFont;
@property (nonatomic, strong, nullable) UIColor *loadingLineColor;

// dragging view
@property (nonatomic, strong, nullable) UIImage *fastImage;
@property (nonatomic, strong, nullable) UIImage *forwardImage;

// custom status bar
@property (nonatomic, strong, nullable) UIImage *batteryBorderImage;
@property (nonatomic, strong, nullable) UIImage *batteryNubImage;
@property (nonatomic, strong, nullable) UIImage *batteryLightningImage;

// top adapter items
@property (nonatomic, strong, nullable) UIImage *backImage;
@property (nonatomic, strong, nullable) UIImage *moreImage;
@property (nonatomic, strong, nullable) UIFont  *titleLabelFont;
@property (nonatomic, strong, nullable) UIColor *titleLabelColor;

// left adapter items
@property (nonatomic, strong, nullable) UIImage *lockImage;
@property (nonatomic, strong, nullable) UIImage *unlockImage;

// bottom adapter items
@property (nonatomic, strong, nullable) UIImage *pauseImage;
@property (nonatomic, strong, nullable) UIImage *playImage;

@property (nonatomic, strong, nullable) UIFont  *timeLabelFont;
@property (nonatomic, strong, nullable) UIColor *timeLabelColor;

@property (nonatomic, strong, nullable) UIImage *smallScreenImage;                  // 缩回小屏的图片
@property (nonatomic, strong, nullable) UIImage *fullscreenImage;                   // 全屏的图片

@property (nonatomic, strong, nullable) UIColor *progressTrackColor;                // 轨道颜色
@property (nonatomic)                   float    progressTrackHeight;               // 轨道高度
@property (nonatomic, strong, nullable) UIColor *progressTraceColor;                // 轨迹颜色, 走过的痕迹
@property (nonatomic, strong, nullable) UIColor *progressBufferColor;               // 缓冲颜色
@property (nonatomic, strong, nullable) UIColor *progressThumbColor;                // 滑块颜色, 请设置滑块大小
@property (nonatomic, strong, nullable) UIImage *progressThumbImage;                // 滑块图片, 优先使用, 为nil时将会使用滑块颜色
@property (nonatomic)                   float    progressThumbSize;                 // 滑块大小

@property (nonatomic, strong, nullable) UIColor *bottomIndicatorTrackColor;         // 底部指示条轨道颜色
@property (nonatomic, strong, nullable) UIColor *bottomIndicatorTraceColor;         // 底部指示条轨迹颜色
@property (nonatomic)                   float    bottomIndicatorHeight;             // 底部指示条高度
    
// right adapter items
@property (nonatomic, strong, nullable) UIImage *clipsImage;

// center adapter items
@property (nonatomic, strong, nullable) UIColor *replayTitleColor;
@property (nonatomic, strong, nullable) UIFont  *replayTitleFont;
@property (nonatomic, strong, nullable) UIImage *replayImage;


#pragma mark - SJMoreSettingControlLayer Resources

@property (nonatomic, strong, nullable) UIColor *moreControlLayerBackgroundColor;
@property (nonatomic, strong, nullable) UIColor *moreSliderTraceColor;              // sider trace color of more view
@property (nonatomic, strong, nullable) UIColor *moreSliderTrackColor;              // sider track color of more view
@property (nonatomic)                   float    moreSliderTrackHeight;             // sider track height of more view
@property (nonatomic, strong, nullable) UIImage *moreSliderThumbImage;              // sider thumb image of more view
@property (nonatomic)                   float    moreSliderThumbSize;               // sider thumb size of more view
@property (nonatomic)                   float    moreSliderMinRateValue;            // 最小播放倍速值
@property (nonatomic)                   float    moreSliderMaxRateValue;            // 最大播放倍速值
@property (nonatomic, strong, nullable) UIImage *moreSliderMinRateImage;            // 最小播放倍速图标
@property (nonatomic, strong, nullable) UIImage *moreSliderMaxRateImage;            // 最大播放倍速图标
@property (nonatomic, strong, nullable) UIImage *moreSliderMinVolumeImage;
@property (nonatomic, strong, nullable) UIImage *moreSliderMaxVolumeImage;
@property (nonatomic, strong, nullable) UIImage *moreSliderMinBrightnessImage;
@property (nonatomic, strong, nullable) UIImage *moreSliderMaxBrightnessImage;


#pragma mark - SJLoadFailedControlLayer Resources

@property (nonatomic, strong, nullable) UIColor  *playFailedButtonBackgroundColor;

#pragma mark - SJNotReachableControlLayer Resources

@property (nonatomic, strong, nullable) UIColor *noNetworkButtonBackgroundColor;

#pragma mark - SJSmallViewControlLayer Resources

@property (nonatomic, strong, nullable) UIImage *floatSmallViewCloseImage;

#pragma mark - SJClipsControlLayer Resources

@property (nonatomic, strong, nullable) UIImage *screenshotImage;
@property (nonatomic, strong, nullable) UIImage *interfereClipImage;
@property (nonatomic, strong, nullable) UIImage *GIFClipImage;

@property (nonatomic, strong, nullable) UIImage *recordsPreparingImage;
@property (nonatomic, strong, nullable) UIImage *recordsToFinishRecordingImage;
@end

@implementation SJContactIntegrateControlLayerResources
- (void)_loadSJEdgeControlLayerResources {
    if (@available(iOS 14.0, *)) {
        _pictureInPictureItemStartImage = [[AVPictureInPictureController.pictureInPictureButtonStartImage imageWithTintColor:UIColor.whiteColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _pictureInPictureItemStopImage = [[AVPictureInPictureController.pictureInPictureButtonStopImage imageWithTintColor:UIColor.whiteColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    _speedupContentDataTriangleColor = UIColor.whiteColor;
    _speedupContentDataRateTextColor = UIColor.whiteColor;
    _speedupContentDataRateTextFont = [UIFont boldSystemFontOfSize:12];
    _speedupContentDataTextColor = UIColor.whiteColor;
    _speedupContentDataTextFont = [UIFont boldSystemFontOfSize:12];
  
    _loadingNetworkSpeedTextColor = UIColor.whiteColor;
    _loadingNetworkSpeedTextFont = [UIFont systemFontOfSize:11];
    _loadingLineColor = UIColor.whiteColor;
 
    _fastImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_fast_right"];
    _forwardImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_left_fast"];

    _batteryBorderImage = [SJContactIntegrateResourceLoader imageNamed:@"battery_border"];
    _batteryNubImage = [SJContactIntegrateResourceLoader imageNamed:@"battery_nub"];
    _batteryLightningImage = [SJContactIntegrateResourceLoader imageNamed:@"battery_lightning"];
 
    _backImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_white_back"];
    _moreImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_white_more"];
    _titleLabelFont = [UIFont boldSystemFontOfSize:14];
    _titleLabelColor = [UIColor whiteColor];

    _lockImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_lock"];
    _unlockImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_unlock"];

    _pauseImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_cease"];
    _playImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_start"];
    _timeLabelFont = [UIFont systemFontOfSize:11];
    _timeLabelColor = UIColor.whiteColor;
    
    _smallScreenImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_small"];
    _fullscreenImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_large"];

    _progressTrackColor =  [UIColor whiteColor];
    _progressTrackHeight = 3;
    _progressTraceColor = [UIColor colorWithRed:2 / 256.0 green:141 / 256.0 blue:140 / 256.0 alpha:1];
    _progressBufferColor = [UIColor colorWithWhite:0 alpha:0.2];
    _progressThumbColor = _progressTraceColor;
    
    _bottomIndicatorTrackColor = _progressTrackColor;
    _bottomIndicatorTraceColor = _progressTraceColor;
    _bottomIndicatorHeight = 1;

    _clipsImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_circle_scissors"];

    _replayTitleColor = [UIColor whiteColor];
    _replayTitleFont = [UIFont boldSystemFontOfSize:12];
    _replayImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_reset"];
}

- (void)_loadSJMoreSettingControlLayerResources {
    _moreControlLayerBackgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    _moreSliderTraceColor = [UIColor colorWithRed:2 / 256.0 green:141 / 256.0 blue:140 / 256.0 alpha:1];
    _moreSliderTrackColor = [UIColor whiteColor];
    _moreSliderTrackHeight = 4;
    _moreSliderMinRateValue = 0.5;
    _moreSliderMaxRateValue = 1.5;
    _moreSliderMinRateImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_big_rate"];
    _moreSliderMaxRateImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_little_rate"];
    _moreSliderMinVolumeImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_little_volume"];
    _moreSliderMaxVolumeImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_big_volume"];
    _moreSliderMinBrightnessImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_little_sun"];
    _moreSliderMaxBrightnessImage = [SJContactIntegrateResourceLoader imageNamed:@"sj_big_sun"];
}

- (void)_loadSJLoadFailedControlLayerResources {
    _playFailedButtonBackgroundColor = [UIColor colorWithRed:36/255.0 green:171/255.0 blue:1 alpha:1];
}

- (void)_loadSJNotReachableControlLayerResources {
    _noNetworkButtonBackgroundColor = [UIColor colorWithRed:36/255.0 green:171/255.0 blue:1 alpha:1];
}

- (void)_loadSJSmallViewControlLayerResources {
    _floatSmallViewCloseImage = [SJContactIntegrateResourceLoader imageNamed:@"close"];
}

- (void)_loadSJClipsControlLayerResources {
    _screenshotImage = [SJContactIntegrateResourceLoader imageNamed:@"screenshot"];
    _interfereClipImage = [SJContactIntegrateResourceLoader imageNamed:@""];
    _GIFClipImage = [SJContactIntegrateResourceLoader imageNamed:@""];

    _recordsPreparingImage = [SJContactIntegrateResourceLoader imageNamed:@""];
    _recordsToFinishRecordingImage = [SJContactIntegrateResourceLoader imageNamed:@""];
}
@end


@interface SJContactIntegrateLocalizedStrings : NSObject<SJContactIntegrateLocalizedStrings>
- (void)setFromBundle:(NSBundle *)bundle;

@property (nonatomic, copy, nullable) NSString *longPressSpeedupContentData;
 
@property (nonatomic, copy, nullable) NSString *noNetWork;
@property (nonatomic, copy, nullable) NSString *WiFiNetwork;
@property (nonatomic, copy, nullable) NSString *cellularNetwork;

@property (nonatomic, copy, nullable) NSString *replay;
@property (nonatomic, copy, nullable) NSString *retry;
@property (nonatomic, copy, nullable) NSString *reload;
@property (nonatomic, copy, nullable) NSString *liveBroadcast;
@property (nonatomic, copy, nullable) NSString *cancel;
@property (nonatomic, copy, nullable) NSString *done;

@property (nonatomic, copy, nullable) NSString *unstableNetworkPrompt;
@property (nonatomic, copy, nullable) NSString *cellularNetworkPrompt;
@property (nonatomic, copy, nullable) NSString *noNetworkPrompt;
@property (nonatomic, copy, nullable) NSString *contentDataFailedPrompt;

@property (nonatomic, copy, nullable) NSString *recordsPreparingPrompt;
@property (nonatomic, copy, nullable) NSString *recordsToFinishRecordingPrompt;

@property (nonatomic, copy, nullable) NSString *exportsExportingPrompt;
@property (nonatomic, copy, nullable) NSString *exportsExportFailedPrompt;
@property (nonatomic, copy, nullable) NSString *exportsExportSuccessfullyPrompt;

@property (nonatomic, copy, nullable) NSString *uploadsUploadingPrompt;
@property (nonatomic, copy, nullable) NSString *uploadsUploadFailedPrompt;
@property (nonatomic, copy, nullable) NSString *uploadsUploadSuccessfullyPrompt;

@property (nonatomic, copy, nullable) NSString *screenshotSuccessfullyPrompt;

@property (nonatomic, copy, nullable) NSString *albumAuthDeniedPrompt;
@property (nonatomic, copy, nullable) NSString *albumSavingScreenshotToAlbumPrompt;
@property (nonatomic, copy, nullable) NSString *albumSavedToAlbumPrompt;

@property (nonatomic, copy, nullable) NSString *operationFailedPrompt;

@property (nonatomic, copy, nullable) NSString *definitionSwitchingPrompt;
@property (nonatomic, copy, nullable) NSString *definitionSwitchSuccessfullyPrompt;
@property (nonatomic, copy, nullable) NSString *definitionSwitchFailedPrompt;
@end

@implementation SJContactIntegrateLocalizedStrings {
    NSBundle *_bundle;
}
  
- (void)setFromBundle:(NSBundle *)bundle {
    _bundle = bundle;
    _longPressSpeedupContentData = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyLongPressSpeedupContentData];
    _noNetWork = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyNoNetwork];
    _WiFiNetwork = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyWiFiNetWork];
    _cellularNetwork = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyCellularNetwork];
    _replay = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyReplay];
    _retry = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyRetry];
    _reload = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyReload];
    _liveBroadcast = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyLiveBroadcast];
    _cancel = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyCancel];
    _done = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyDone];
    _unstableNetworkPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyUnstableNetworkPrompt];
    _cellularNetworkPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyCellularNetworkPrompt];
    _noNetworkPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyNoNetworkPrompt];
    _contentDataFailedPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyContentDataFailedPrompt];
    _recordsPreparingPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyRecordsPreparingPrompt];
    _recordsToFinishRecordingPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyRecordsToFinishRecordingPrompt];
    _exportsExportingPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyExportsExportingPrompt];
    _exportsExportFailedPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyExportsExportFailedPrompt];
    _exportsExportSuccessfullyPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyExportsExportSuccessfullyPrompt];
    _uploadsUploadingPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyUploadsUploadingPrompt];
    _uploadsUploadFailedPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyUploadsUploadFailedPrompt];
    _uploadsUploadSuccessfullyPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyUploadsUploadSuccessfullyPrompt];
    _screenshotSuccessfullyPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyScreenshotSuccessfullyPrompt];
    _albumAuthDeniedPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyAlbumAuthDeniedPrompt];
    _albumSavingScreenshotToAlbumPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyAlbumSavingScreenshotToAlbumPrompt];
    _albumSavedToAlbumPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyAlbumSavedToAlbumPrompt];
    _operationFailedPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyOperationFailedPrompt];
    _definitionSwitchingPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyDefinitionSwitchingPrompt];
    _definitionSwitchSuccessfullyPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyDefinitionSwitchSuccessfullyPrompt];
    _definitionSwitchFailedPrompt = [self localizedStringForKey:SJContactIntegrateLocalizedStringKeyDefinitionSwitchFailedPrompt];
}

- (nullable NSString *)localizedStringForKey:(NSString *)key {
    NSBundle *mainBundle = NSBundle.mainBundle;
    NSString *value = _bundle != mainBundle ? [_bundle localizedStringForKey:key value:nil table:nil] : nil;
    return [mainBundle localizedStringForKey:key value:value table:nil];
}
@end


@interface SJContactIntegrateConfigurations () {
    dispatch_group_t _group;
}

@end

@implementation SJContactIntegrateConfigurations
  
+ (instancetype)shared {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if ( self ) {
        _animationDuration = 0.4;
        _group = dispatch_group_create();
        [self localizedStrings];
        [self resources];
    }
    return self;
}

+ (void (^)(void (^ _Nonnull)(SJContactIntegrateConfigurations * _Nonnull)))update {
    return ^(void(^block)(SJContactIntegrateConfigurations *configs)) {
        SJContactIntegrateConfigurations *configs = SJContactIntegrateConfigurations.shared;
        dispatch_group_notify(configs->_group, dispatch_get_global_queue(0, 0), ^{
            block(SJContactIntegrateConfigurations.shared);
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSNotificationCenter.defaultCenter postNotificationName:SJContactIntegrateConfigurationsDidUpdateNotification object:configs];
            });
        });
    };
} 

- (id<SJContactIntegrateLocalizedStrings>)localizedStrings {
    if ( _localizedStrings == nil ) {
        SJContactIntegrateLocalizedStrings *strings = SJContactIntegrateLocalizedStrings.alloc.init;
        dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
            [strings setFromBundle:SJContactIntegrateResourceLoader.preferredLanguageBundle];
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSNotificationCenter.defaultCenter postNotificationName:SJContactIntegrateConfigurationsDidUpdateNotification object:self];
            });
        });
        _localizedStrings = strings;
    }
    return _localizedStrings;
}

- (id<SJContactIntegrateControlLayerResources>)resources {
    if ( _resources == nil ) {
        SJContactIntegrateControlLayerResources *resources = SJContactIntegrateControlLayerResources.alloc.init;
        dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
            [resources _loadSJEdgeControlLayerResources];
        });
        dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
            [resources _loadSJMoreSettingControlLayerResources];
        });
        dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
            [resources _loadSJLoadFailedControlLayerResources];
        });
        dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
            [resources _loadSJNotReachableControlLayerResources];
        });
        dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
            [resources _loadSJSmallViewControlLayerResources];
        });
        dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
            [resources _loadSJClipsControlLayerResources];
        });
        dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:SJContactIntegrateConfigurationsDidUpdateNotification object:self];
        });
        _resources = resources;
    }
    return _resources;
}
@end
NS_ASSUME_NONNULL_END
