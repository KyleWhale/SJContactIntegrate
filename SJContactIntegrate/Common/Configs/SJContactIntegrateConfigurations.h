//
//  SJContactIntegrateConfigurations.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2017/9/25.
//  Copyright © 2017年 changsanjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJContactIntegrateLocalizedStringKeys.h"
@class UIImage, UIColor, UIFont, SJContactIntegrateConfigurations;
@protocol SJContactIntegrateControlLayerResources, SJContactIntegrateLocalizedStrings;

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSNotificationName const SJContactIntegrateConfigurationsDidUpdateNotification;

@interface SJContactIntegrateConfigurations : NSObject
+ (instancetype)shared;

@property (class, nonatomic, copy, readonly) void(^update)(void(^block)(SJContactIntegrateConfigurations *configs));
 
@property (nonatomic, strong, null_resettable) id<SJContactIntegrateLocalizedStrings> localizedStrings;

@property (nonatomic, strong, null_resettable) id<SJContactIntegrateControlLayerResources> resources;
 
@property (nonatomic) NSTimeInterval animationDuration;

@end
  

@protocol SJContactIntegrateControlLayerResources <NSObject>

@property (nonatomic, strong, nullable) UIImage *placeholder;

#pragma mark -

@property (nonatomic, strong, nullable) UIImage *pictureInPictureItemStartImage API_AVAILABLE(ios(14.0));
@property (nonatomic, strong, nullable) UIImage *pictureInPictureItemStopImage API_AVAILABLE(ios(14.0));

@property (nonatomic, strong, nullable) UIColor *speedupContentDataTriangleColor;
@property (nonatomic, strong, nullable) UIColor *speedupContentDataRateTextColor;
@property (nonatomic, strong, nullable) UIFont  *speedupContentDataRateTextFont;
@property (nonatomic, strong, nullable) UIColor *speedupContentDataTextColor;
@property (nonatomic, strong, nullable) UIFont  *speedupContentDataTextFont;

@property (nonatomic, strong, nullable) UIColor *loadingNetworkSpeedTextColor;
@property (nonatomic, strong, nullable) UIFont  *loadingNetworkSpeedTextFont;
@property (nonatomic, strong, nullable) UIColor *loadingLineColor;

@property (nonatomic, strong, nullable) UIImage *fastImage;
@property (nonatomic, strong, nullable) UIImage *forwardImage;

@property (nonatomic, strong, nullable) UIImage *batteryBorderImage;
@property (nonatomic, strong, nullable) UIImage *batteryNubImage;
@property (nonatomic, strong, nullable) UIImage *batteryLightningImage;

@property (nonatomic, strong, nullable) UIImage *backImage;
@property (nonatomic, strong, nullable) UIImage *moreImage;
@property (nonatomic, strong, nullable) UIFont  *titleLabelFont;
@property (nonatomic, strong, nullable) UIColor *titleLabelColor;

@property (nonatomic, strong, nullable) UIImage *lockImage;
@property (nonatomic, strong, nullable) UIImage *unlockImage;

@property (nonatomic, strong, nullable) UIImage *pauseImage;
@property (nonatomic, strong, nullable) UIImage *playImage;

@property (nonatomic, strong, nullable) UIFont  *timeLabelFont;
@property (nonatomic, strong, nullable) UIColor *timeLabelColor;

@property (nonatomic, strong, nullable) UIImage *smallScreenImage;
@property (nonatomic, strong, nullable) UIImage *fullscreenImage;

@property (nonatomic, strong, nullable) UIColor *progressTrackColor;
@property (nonatomic)                   float    progressTrackHeight;
@property (nonatomic, strong, nullable) UIColor *progressTraceColor;
@property (nonatomic, strong, nullable) UIColor *progressBufferColor;
@property (nonatomic, strong, nullable) UIColor *progressThumbColor;
@property (nonatomic, strong, nullable) UIImage *progressThumbImage;
@property (nonatomic)                   float    progressThumbSize;

@property (nonatomic, strong, nullable) UIColor *bottomIndicatorTrackColor;
@property (nonatomic, strong, nullable) UIColor *bottomIndicatorTraceColor;
@property (nonatomic)                   float    bottomIndicatorHeight;
    
@property (nonatomic, strong, nullable) UIImage *clipsImage;

@property (nonatomic, strong, nullable) UIColor *replayTitleColor;
@property (nonatomic, strong, nullable) UIFont  *replayTitleFont;
@property (nonatomic, strong, nullable) UIImage *replayImage;


#pragma mark -

@property (nonatomic, strong, nullable) UIColor *moreControlLayerBackgroundColor;
@property (nonatomic, strong, nullable) UIColor *moreSliderTraceColor;
@property (nonatomic, strong, nullable) UIColor *moreSliderTrackColor;
@property (nonatomic)                   float    moreSliderTrackHeight;
@property (nonatomic, strong, nullable) UIImage *moreSliderThumbImage;
@property (nonatomic)                   float    moreSliderThumbSize;
@property (nonatomic)                   float    moreSliderMinRateValue;
@property (nonatomic)                   float    moreSliderMaxRateValue;
@property (nonatomic, strong, nullable) UIImage *moreSliderMinRateImage;
@property (nonatomic, strong, nullable) UIImage *moreSliderMaxRateImage;
@property (nonatomic, strong, nullable) UIImage *moreSliderMinVolumeImage;
@property (nonatomic, strong, nullable) UIImage *moreSliderMaxVolumeImage;
@property (nonatomic, strong, nullable) UIImage *moreSliderMinBrightnessImage;
@property (nonatomic, strong, nullable) UIImage *moreSliderMaxBrightnessImage;



@property (nonatomic, strong, nullable) UIColor  *playFailedButtonBackgroundColor;


@property (nonatomic, strong, nullable) UIColor *noNetworkButtonBackgroundColor;


@property (nonatomic, strong, nullable) UIImage *floatSmallViewCloseImage;


@property (nonatomic, strong, nullable) UIImage *screenshotImage;
@property (nonatomic, strong, nullable) UIImage *interfereClipImage;
@property (nonatomic, strong, nullable) UIImage *GIFClipImage;

@property (nonatomic, strong, nullable) UIImage *recordsPreparingImage;
@property (nonatomic, strong, nullable) UIImage *recordsToFinishRecordingImage;
 
@end


@protocol SJContactIntegrateLocalizedStrings <NSObject>

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
NS_ASSUME_NONNULL_END
