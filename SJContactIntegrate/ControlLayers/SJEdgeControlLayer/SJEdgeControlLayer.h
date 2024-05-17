//
//  SJEdgeControlLayer.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2018/10/24.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import "SJEdgeControlLayerAdapters.h"
#import "SJDraggingProgressPopupViewDefines.h"
#import "SJDraggingObservationDefines.h"
#import "SJControlLayerDefines.h"
#import "SJLoadingViewDefines.h"
#import "SJScrollingTextMarqueeViewDefines.h"
#import "SJFullscreenModeStatusBarDefines.h"
#import "SJCompressSemicolonRestrictDefines.h"
#import "SJItemTags.h"

#pragma mark -

@protocol SJEdgeControlLayerDelegate;

NS_ASSUME_NONNULL_BEGIN
@interface SJEdgeControlLayer : SJEdgeControlLayerAdapters<SJControlLayer>

@property (nonatomic, strong, null_resettable) __kindof UIView<SJLoadingView> *loadingView;

@property (nonatomic, strong, null_resettable) __kindof UIView<SJDraggingProgressPopupView> *draggingProgressPopupView;

@property (nonatomic, strong, readonly) id<SJDraggingObservation> draggingObserver;

@property (nonatomic, strong, null_resettable) __kindof UIView<SJScrollingTextMarqueeView> *titleView;

@property (nonatomic, strong, null_resettable) UIView<SJCompressSemicolonRestrictView> *speedupContentDataPopupView;

@property (nonatomic) BOOL automaticallyShowsPictureInPictureItem API_AVAILABLE(ios(14.0));

@property (nonatomic, getter=isHiddenTitleItemWhenOrientationIsPortrait) BOOL hiddenTitleItemWhenOrientationIsPortrait;

@property (nonatomic, getter=isHiddenBackButtonWhenOrientationIsPortrait) BOOL hiddenBackButtonWhenOrientationIsPortrait;

@property (nonatomic) BOOL fixesBackItem;

@property (nonatomic, getter=isDisabledPromptingWhenNetworkStatusChanges) BOOL disabledPromptingWhenNetworkStatusChanges;

@property (nonatomic, getter=isHiddenBottomProgressIndicator) BOOL hiddenBottomProgressIndicator;

@property (nonatomic) CGFloat bottomProgressIndicatorHeight;

@property (nonatomic, strong, null_resettable) UIView<SJFullscreenModeStatusBar> *customStatusBar NS_AVAILABLE_IOS(11.0);

@property (nonatomic, copy, null_resettable) BOOL(^shouldShowsCustomStatusBar)(SJEdgeControlLayer *controlLayer) NS_AVAILABLE_IOS(11.0);

@property (nonatomic) BOOL automaticallyPerformRotationOrFitOnScreen;

@property (nonatomic) BOOL needsFitOnScreenFirst;

@property (nonatomic, weak, nullable) id<SJEdgeControlLayerDelegate> delegate;
@end


@protocol SJEdgeControlLayerDelegate <NSObject>
- (void)backItemWasTappedForControlLayer:(id<SJControlLayer>)controlLayer;
@end


@interface SJEdgeControlButtonItem (SJControlLayerExtended)

@property (nonatomic) BOOL resetsAppearIntervalWhenPerformingItemAction;
@end
NS_ASSUME_NONNULL_END
