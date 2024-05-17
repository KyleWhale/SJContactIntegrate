//
//  SJEdgeControlLayer.m
//  SJContactIntegrate
//
//  Created by 畅三江 on 2018/10/24.
//  Copyright © 2018 畅三江. All rights reserved.
//

#if __has_include(<SJUIKit/SJAttributesFactory.h>)
#import <SJUIKit/SJAttributesFactory.h>
#else
#import "SJAttributesFactory.h"
#endif

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

#if __has_include(<SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>)
#import <SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>
#import <SJBaseSequenceInvolve/SJTimerControl.h>
#else
#import "SJBaseSequenceInvolve.h"
#import "SJTimerControl.h"
#endif

#import "SJEdgeControlLayer.h"
#import "SJCompressContainSale+SJControlAdd.h"
#import "SJDraggingProgressPopupView.h"
#import "UIView+SJAnimationAdded.h"
#import "SJContactIntegrateConfigurations.h"
#import "SJProgressSlider.h"
#import "SJLoadingView.h"
#import "SJDraggingObservation.h"
#import "SJScrollingTextMarqueeView.h"
#import "SJFullscreenModeStatusBar.h"
#import "SJCompressSemicolonRestrictView.h"
#import "SJEdgeControlButtonItemInternal.h"
#import <objc/message.h>

#pragma mark - Top

@interface SJEdgeControlLayer ()<SJProgressSliderDelegate>
@property (nonatomic, weak, nullable) SJBaseSequenceInvolve *alternateStructure;

@property (nonatomic, strong, readonly) SJTimerControl *lockStateTappedTimerControl;
@property (nonatomic, strong, readonly) SJProgressSlider *bottomProgressIndicator;

@property (nonatomic, strong, readonly) UIButton *fixedBackButton;
@property (nonatomic, strong, readonly) SJEdgeControlButtonItem *backItem;

@property (nonatomic, strong, nullable) id<SJReachabilityObserver> reachabilityObserver;
@property (nonatomic, strong, readonly) SJTimerControl *dateTimerControl API_AVAILABLE(ios(11.0)); // refresh date for custom status bar
@property (nonatomic, strong, readonly) SJEdgeControlButtonItem *pictureInPictureItem API_AVAILABLE(ios(14.0));

@property (nonatomic) BOOL automaticallyFitOnScreen;
@end

@implementation SJEdgeControlLayer
@synthesize restarted = _restarted;
@synthesize draggingProgressPopupView = _draggingProgressPopupView;
@synthesize draggingObserver = _draggingObserver;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    _bottomProgressIndicatorHeight = 1;
    _automaticallyPerformRotationOrFitOnScreen = YES;
    [self _setupView];
    self.autoAdjustTopSpacing = YES;
    self.hiddenBottomProgressIndicator = YES;
    if (@available(iOS 14.0, *)) {
        self.automaticallyShowsPictureInPictureItem = YES;
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark -

- (void)restartControlLayer {
    _restarted = YES;
    sj_view_makeAppear(self.controlView, YES);
    [self _showOrHiddenLoadingView];
    [self _updateAppearStateForContainerViews];
    [self _reloadAdaptersIfNeeded];
}

- (void)exitControlLayer {
    _restarted = NO;
    
    sj_view_makeDisappear(self.controlView, YES, ^{
        if ( !self->_restarted ) [self.controlView removeFromSuperview];
    });
    
    sj_view_makeDisappear(_topContainerView, YES);
    sj_view_makeDisappear(_leftContainerView, YES);
    sj_view_makeDisappear(_bottomContainerView, YES);
    sj_view_makeDisappear(_rightContainerView, YES);
    sj_view_makeDisappear(_draggingProgressPopupView, YES);
    sj_view_makeDisappear(_centerContainerView, YES);
}

#pragma mark - item actions

- (void)_fixedBackButtonWasTapped {
    [self.backItem performActions];
}

- (void)_backItemWasTapped {
    if ( [self.delegate respondsToSelector:@selector(backItemWasTappedForControlLayer:)] ) {
        [self.delegate backItemWasTappedForControlLayer:self];
    }
}

- (void)_lockItemWasTapped {
    self.alternateStructure.lockedScreen = !self.alternateStructure.lightLockedStructure;
}

- (void)_playItemWasTapped {
    _alternateStructure.ellipsisRule ? [self.alternateStructure play] : [self.alternateStructure pauseForUser];
}

- (void)_fullItemWasTapped {
    if ( _alternateStructure.onlyFitOnScreen || _automaticallyFitOnScreen ) {
        [_alternateStructure setFitOnScreen:!_alternateStructure.fncyFitOnScreen];
        return;
    }
    
    if ( _needsFitOnScreenFirst && !_alternateStructure.fncyFitOnScreen ) {
        [_alternateStructure setFitOnScreen:YES];
        return;
    }
    
    [_alternateStructure rotate];
}

- (void)_replayItemWasTapped {
    [_alternateStructure replay];
}

- (void)pictureInPictureItemWasTapped API_AVAILABLE(ios(14.0)) {
    switch (_alternateStructure.contactIntegrateController.pictureInPictureStatus) {
        case SJPictureInPictureStatusStarting:
        case SJPictureInPictureStatusRunning:
            [_alternateStructure.contactIntegrateController stopPictureInPicture];
            break;
        case SJPictureInPictureStatusUnknown:
        case SJPictureInPictureStatusStopping:
        case SJPictureInPictureStatusStopped:
            [_alternateStructure.contactIntegrateController startPictureInPicture];
            break;
    }
}

#pragma mark - slider delegate methods

- (void)sliderWillBeginDragging:(SJProgressSlider *)slider {
    if ( _alternateStructure.reserveStatus != SJDuplicateStatusReady ) {
        [slider cancelDragging];
        return;
    }
    else if ( _alternateStructure.canSeekToTime && !_alternateStructure.canSeekToTime(_alternateStructure) ) {
        [slider cancelDragging];
        return;
    }
    
    [self _willBeginDragging];
}

- (void)slider:(SJProgressSlider *)slider valueDidChange:(CGFloat)value {
    if ( slider.isDragging ) [self _didMove:value];
}

- (void)sliderDidEndDragging:(SJProgressSlider *)slider {
    [self _endDragging];
}

#pragma mark - player delegate methods

- (UIView *)controlView {
    return self;
}

- (void)installedControlViewAlternateThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    _alternateStructure = alternateStructure;
    sj_view_makeDisappear(_topContainerView, NO);
    sj_view_makeDisappear(_leftContainerView, NO);
    sj_view_makeDisappear(_bottomContainerView, NO);
    sj_view_makeDisappear(_rightContainerView, NO);
    sj_view_makeDisappear(_centerContainerView, NO);
    
    [self _reloadSizeForBottomTimeLabel];
    [self _updateContentForBottomContentTimeItemIfNeeded];
    [self _updateContentForBottomDurationItemIfNeeded];
    
    _reachabilityObserver = [alternateStructure.reachability getObserver];
    __weak typeof(self) _self = self;
    _reachabilityObserver.networkSpeedDidChangeExeBlock = ^(id<SJReachability> r) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self _updateNetworkSpeedStrForLoadingView];
    };
}

- (BOOL)controlLayerAccuracyThousandCanAutomaticallyDisappear:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    SJEdgeControlButtonItem *progressItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemPattern];
    if ( progressItem != nil && !progressItem.isHidden ) {
        SJProgressSlider *slider = progressItem.customView;
        return !slider.isDragging;
    }
    return YES;
}

- (void)controlLayerNeedAppear:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    if ( alternateStructure.lightLockedStructure )
        return;
    
    [self _updateAppearStateForFixedBackButtonIfNeeded];
    [self _updateAppearStateForContainerViews];
    [self _reloadAdaptersIfNeeded];
    [self _updateContentForBottomContentTimeItemIfNeeded];
    [self _updateContentForBottomProgressSliderItemIfNeeded];
    [self _updateAppearStateForBottomProgressIndicatorIfNeeded];
    if (@available(iOS 11.0, *)) {
        [self _reloadCustomStatusBarIfNeeded];
    }
}

- (void)controlLayerNeedDisappear:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    if ( alternateStructure.lightLockedStructure )
        return;
    
    [self _updateAppearStateForFixedBackButtonIfNeeded];
    [self _updateAppearStateForContainerViews];
    [self _updateAppearStateForBottomProgressIndicatorIfNeeded];
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure prepareToPlay:(SJCompressContainSale *)asset {
    _automaticallyFitOnScreen = NO;
    [self _reloadSizeForBottomTimeLabel];
    [self _updateContentForBottomDurationItemIfNeeded];
    [self _updateContentForBottomContentTimeItemIfNeeded];
    [self _updateContentForBottomProgressSliderItemIfNeeded];
    [self _updateContentForBottomProgressIndicatorIfNeeded];
    [self _updateAppearStateForFixedBackButtonIfNeeded];
    [self _updateAppearStateForBottomProgressIndicatorIfNeeded];
    [self _reloadAdaptersIfNeeded];
    [self _showOrHiddenLoadingView];
}

- (void)declarePortBoundarySaveStatusDidChange:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    [self _reloadAdaptersIfNeeded];
    [self _showOrHiddenLoadingView];
    [self _updateContentForBottomContentTimeItemIfNeeded];
    [self _updateContentForBottomDurationItemIfNeeded];
    [self _updateContentForBottomProgressIndicatorIfNeeded];
    [self _updateContentForBottomProgressSliderItemIfNeeded];
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure pictureInPictureStatusDidChange:(SJPictureInPictureStatus)status API_AVAILABLE(ios(14.0)) {
    [self _updateContentForPictureInPictureItem];
    [self.topAdapter reload];
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure timeDidChange:(NSTimeInterval)currentTime {
    [self _updateContentForBottomContentTimeItemIfNeeded];
    [self _updateContentForBottomProgressIndicatorIfNeeded];
    [self _updateContentForBottomProgressSliderItemIfNeeded];
    [self _updateContentTimeForDraggingProgressPopupViewIfNeeded];
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure durationDidChange:(NSTimeInterval)duration {
    [self _reloadSizeForBottomTimeLabel];
    [self _updateContentForBottomDurationItemIfNeeded];
    [self _updateContentForBottomProgressIndicatorIfNeeded];
    [self _updateContentForBottomProgressSliderItemIfNeeded];
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure playableDurationDidChange:(NSTimeInterval)duration {
    [self _updateContentForBottomProgressSliderItemIfNeeded];
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure developBackTypeDidChange:(SJDevelopbackType)developBackType {
    SJEdgeControlButtonItem *timeItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemContentTime];
    SJEdgeControlButtonItem *separatorItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemSeparator];
    SJEdgeControlButtonItem *durationTimeItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemPresentTime];
    SJEdgeControlButtonItem *progressItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemPattern];
    SJEdgeControlButtonItem *liveItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemReverse];
    switch ( developBackType ) {
        case SJDevelopbackTypeLIVE: {
            timeItem.innerHidden = YES;
            separatorItem.innerHidden = YES;
            durationTimeItem.innerHidden = YES;
            progressItem.innerHidden = YES;
            liveItem.innerHidden = NO;
        }
            break;
        case SJDevelopbackTypeUnknown:
        case SJDevelopbackTypeVOD:
        case SJDevelopbackTypeFILE: {
            timeItem.innerHidden = NO;
            separatorItem.innerHidden = NO;
            durationTimeItem.innerHidden = NO;
            progressItem.innerHidden = NO;
            liveItem.innerHidden = YES;
        }
            break;
    }
    [self.bottomAdapter reload];
    [self _showOrRemoveBottomProgressIndicator];
}

- (BOOL)canTriggerRotationAccuracyThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    if ( _needsFitOnScreenFirst || _automaticallyFitOnScreen )
        return alternateStructure.fncyFitOnScreen;
    
    if ( _automaticallyFitOnScreen ) {
        if ( alternateStructure.fncyFitOnScreen ) return alternateStructure.allowsRotationInFitOnScreen;
        return NO;
    }
    
    return YES;
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure willRotateView:(BOOL)isFull {
    [self _updateAppearStateForBottomProgressIndicatorIfNeeded];
    [self _updateAppearStateForFixedBackButtonIfNeeded];
    [self _updateAppearStateForContainerViews];
    [self _reloadAdaptersIfNeeded];
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure didEndRotation:(BOOL)isFull {
    [self _updateAppearStateForBottomProgressIndicatorIfNeeded];
    [self _updateAppearStateForFixedBackButtonIfNeeded];
    [self _updateAppearStateForContainerViews];
    [self _reloadAdaptersIfNeeded];
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure willFitOnScreen:(BOOL)fncyFitOnScreen {
    [self _updateAppearStateForFixedBackButtonIfNeeded];
    [self _updateAppearStateForContainerViews];
    [self _reloadAdaptersIfNeeded];
}

/// 是否可以触发播放器的手势
- (BOOL)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure gestureRecognizerShouldTrigger:(SJAccidentPresenceGestureType)type location:(CGPoint)location {
    SJEdgeControlButtonItemAdapter *adapter = nil;
    BOOL(^_locationInTheView)(UIView *) = ^BOOL(UIView *container) {
        return CGRectContainsPoint(container.frame, location) && !sj_view_isDisappeared(container);
    };
    
    if ( _locationInTheView(_topContainerView) ) {
        adapter = _topAdapter;
    }
    else if ( _locationInTheView(_bottomContainerView) ) {
        adapter = _bottomAdapter;
    }
    else if ( _locationInTheView(_leftContainerView) ) {
        adapter = _leftAdapter;
    }
    else if ( _locationInTheView(_rightContainerView) ) {
        adapter = _rightAdapter;
    }
    else if ( _locationInTheView(_centerContainerView) ) {
        adapter = _centerAdapter;
    }
    if ( !adapter ) return YES;
    
    CGPoint point = [self.controlView convertPoint:location toView:adapter.view];
    if ( !CGRectContainsPoint(adapter.view.frame, point) ) return YES;
    
    SJEdgeControlButtonItem *_Nullable item = [adapter itemAtPoint:point];
    return item != nil ? (item.actions.count == 0)  : YES;
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure panGestureTriggeredInTheHorizontalDirection:(SJPanGestureRecognizerState)state progressTime:(NSTimeInterval)progressTime {
    switch ( state ) {
        case SJPanGestureRecognizerStateBegan:
            [self _willBeginDragging];
            break;
        case SJPanGestureRecognizerStateChanged:
            [self _didMove:progressTime];
            break;
        case SJPanGestureRecognizerStateEnded:
            [self _endDragging];
            break;
    }
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure longPressGestureStateDidChange:(SJLongPressGestureRecognizerState)state {
    if ( [(id)self.speedupContentDataPopupView respondsToSelector:@selector(layoutInRect:gestureState:contentDataRate:)] ) {
        if ( state == SJLongPressGestureRecognizerStateBegan ) {
            if ( self.speedupContentDataPopupView.superview != self ) {
                [self insertSubview:self.speedupContentDataPopupView atIndex:0];
            }
        }
        [self.speedupContentDataPopupView layoutInRect:self.frame gestureState:state contentDataRate:alternateStructure.rate];
    }
    else {
        switch ( state ) {
            case SJLongPressGestureRecognizerStateChanged: break;
            case SJLongPressGestureRecognizerStateBegan: {
                if ( self.speedupContentDataPopupView.superview != self ) {
                    [self insertSubview:self.speedupContentDataPopupView atIndex:0];
                    [self.speedupContentDataPopupView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.equalTo(self.topAdapter);
                    }];
                }
                self.speedupContentDataPopupView.rate = alternateStructure.rateWhenLongPressGestureTriggered;
                [self.speedupContentDataPopupView show];
            }
                break;
            case SJLongPressGestureRecognizerStateEnded: {
                [self.speedupContentDataPopupView hidden];
            }
                break;
        }
    }
}

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure presentationSizeDidChange:(CGSize)size {
    if ( _automaticallyPerformRotationOrFitOnScreen && !alternateStructure.indntImplement && !alternateStructure.fncyFitOnScreen ) {
        _automaticallyFitOnScreen = size.width < size.height;
    }
}

- (void)tappedMaskOnTheLockedState:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    if ( sj_view_isDisappeared(_leftContainerView) ) {
        sj_view_makeAppear(_leftContainerView, YES);
        [self.lockStateTappedTimerControl resume];
    }
    else {
        sj_view_makeDisappear(_leftContainerView, YES);
        [self.lockStateTappedTimerControl interrupt];
    }
}

- (void)lockedControlLongShip:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    [self _updateAppearStateForFixedBackButtonIfNeeded];
    [self _updateAppearStateForBottomProgressIndicatorIfNeeded];
    [self _updateAppearStateForContainerViews];
    [self _reloadAdaptersIfNeeded];
    [self.lockStateTappedTimerControl resume];
}

- (void)unlockedCompressScanPast:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    [self _updateAppearStateForBottomProgressIndicatorIfNeeded];
    [self.lockStateTappedTimerControl interrupt];
    [alternateStructure controlLayerNeedAppear];
}

- (void)alternateStructure:(SJBaseSequenceInvolve *)alternateStructure reachabilityChanged:(SJNetworkStatus)status {
    if (@available(iOS 11.0, *)) {
        [self _reloadCustomStatusBarIfNeeded];
    }
    if ( _disabledPromptingWhenNetworkStatusChanges ) return;
    if ( [self.alternateStructure.assetURL isFileURL] ) return;
    
    switch ( status ) {
        case SJNetworkStatus_NotReachable: {
            [_alternateStructure.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.append(SJContactIntegrateConfigurations.shared.localizedStrings.unstableNetworkPrompt);
                make.textColor(UIColor.whiteColor);
            }] duration:3];
        }
            break;
        case SJNetworkStatus_ReachableViaWWAN: {
            [_alternateStructure.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.append(SJContactIntegrateConfigurations.shared.localizedStrings.cellularNetworkPrompt);
                make.textColor(UIColor.whiteColor);
            }] duration:3];
        }
            break;
        case SJNetworkStatus_ReachableViaWiFi: {}
            break;
    }
}

#pragma mark -

- (NSString *)stringForSeconds:(NSInteger)secs {
    return _alternateStructure ? [_alternateStructure stringForSeconds:secs] : @"";
}

#pragma mark -

- (void)setHiddenBackButtonWhenOrientationIsPortrait:(BOOL)hiddenBackButtonWhenOrientationIsPortrait {
    if ( _hiddenBackButtonWhenOrientationIsPortrait != hiddenBackButtonWhenOrientationIsPortrait ) {
        _hiddenBackButtonWhenOrientationIsPortrait = hiddenBackButtonWhenOrientationIsPortrait;
        [self _updateAppearStateForFixedBackButtonIfNeeded];
        [self _reloadTopAdapterIfNeeded];
    }
}

- (void)setFixesBackItem:(BOOL)fixesBackItem {
    if ( fixesBackItem == _fixesBackItem )
        return;
    _fixesBackItem = fixesBackItem;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( self->_fixesBackItem ) {
            [self.controlView addSubview:self.fixedBackButton];
            [self->_fixedBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self.topAdapter.view);
                make.width.equalTo(self.topAdapter.view.mas_height);
            }];
            
            [self _updateAppearStateForFixedBackButtonIfNeeded];
            [self _reloadTopAdapterIfNeeded];
        }
        else {
            if ( self->_fixedBackButton ) {
                [self->_fixedBackButton removeFromSuperview];
                self->_fixedBackButton = nil;
                
                // back item
                [self _reloadTopAdapterIfNeeded];
            }
        }
    });
}

- (void)setHiddenBottomProgressIndicator:(BOOL)hiddenBottomProgressIndicator {
    if ( hiddenBottomProgressIndicator != _hiddenBottomProgressIndicator ) {
        _hiddenBottomProgressIndicator = hiddenBottomProgressIndicator;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _showOrRemoveBottomProgressIndicator];
        });
    }
}

- (void)setBottomProgressIndicatorHeight:(CGFloat)bottomProgressIndicatorHeight {
    if ( bottomProgressIndicatorHeight != _bottomProgressIndicatorHeight ) {
        
        _bottomProgressIndicatorHeight = bottomProgressIndicatorHeight;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _updateLayoutForBottomProgressIndicator];
        });
    }
}

- (void)setLoadingView:(nullable UIView<SJLoadingView> *)loadingView {
    if ( loadingView != _loadingView ) {
        [_loadingView removeFromSuperview];
        _loadingView = loadingView;
        if ( loadingView != nil ) {
            [self.controlView addSubview:loadingView];
            [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.offset(0);
            }];
        }
    }
}

- (void)setDraggingProgressPopupView:(nullable __kindof UIView<SJDraggingProgressPopupView> *)draggingProgressPopupView {
    _draggingProgressPopupView = draggingProgressPopupView;
    [self _updateForDraggingProgressPopupView];
}

- (void)setTitleView:(nullable __kindof UIView<SJScrollingTextMarqueeView> *)titleView {
    _titleView = titleView;
    [self _reloadTopAdapterIfNeeded];
}

- (void)setCustomStatusBar:(UIView<SJFullscreenModeStatusBar> *)customStatusBar NS_AVAILABLE_IOS(11.0) {
    if ( customStatusBar != _customStatusBar ) {
        [_customStatusBar removeFromSuperview];
        _customStatusBar = customStatusBar;
        [self _reloadCustomStatusBarIfNeeded];
    }
}

- (void)setShouldShowsCustomStatusBar:(BOOL (^)(SJEdgeControlLayer * _Nonnull))shouldShowsCustomStatusBar NS_AVAILABLE_IOS(11.0) {
    _shouldShowsCustomStatusBar = shouldShowsCustomStatusBar;
    [self _updateAppearStateForCustomStatusBar];
}

- (void)setSpeedupContentDataPopupView:(UIView<SJCompressSemicolonRestrictView> *)speedupContentDataPopupView {
    if ( _speedupContentDataPopupView != speedupContentDataPopupView ) {
        [_speedupContentDataPopupView removeFromSuperview];
        _speedupContentDataPopupView = speedupContentDataPopupView;
    }
}

- (void)setAutomaticallyShowsPictureInPictureItem:(BOOL)automaticallyShowsPictureInPictureItem {
    if ( automaticallyShowsPictureInPictureItem != _automaticallyShowsPictureInPictureItem ) {
        _automaticallyShowsPictureInPictureItem = automaticallyShowsPictureInPictureItem;
        [self _reloadTopAdapterIfNeeded];
    }
}

#pragma mark - setup view

- (void)_setupView {
    [self _addItemsToTopAdapter];
    [self _addItemsToLeftAdapter];
    [self _addItemsToBottomAdapter];
    [self _addItemsToRightAdapter];
    [self _addItemsToCenterAdapter];
    
    self.topContainerView.disappearvisibleDirection = SJViewDisappearAnimation_Top;
    self.leftContainerView.disappearvisibleDirection = SJViewDisappearAnimation_Left;
    self.bottomContainerView.disappearvisibleDirection = SJViewDisappearAnimation_Bottom;
    self.rightContainerView.disappearvisibleDirection = SJViewDisappearAnimation_Right;
    self.centerContainerView.disappearvisibleDirection = SJViewDisappearAnimation_None;
    
    sj_view_initializes(@[self.topContainerView, self.leftContainerView,
                          self.bottomContainerView, self.rightContainerView]);
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_resetControlLayerAppearIntervalForItemIfNeeded:) name:SJEdgeControlButtonItemPerformedActionNotification object:nil];
}

@synthesize fixedBackButton = _fixedBackButton;
- (UIButton *)fixedBackButton {
    if ( _fixedBackButton ) return _fixedBackButton;
    _fixedBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fixedBackButton setImage:SJContactIntegrateConfigurations.shared.resources.backImage forState:UIControlStateNormal];
    [_fixedBackButton addTarget:self action:@selector(_fixedBackButtonWasTapped) forControlEvents:UIControlEventTouchUpInside];
    return _fixedBackButton;
}

@synthesize bottomProgressIndicator = _bottomProgressIndicator;
- (SJProgressSlider *)bottomProgressIndicator {
    if ( _bottomProgressIndicator ) return _bottomProgressIndicator;
    _bottomProgressIndicator = [SJProgressSlider new];
    _bottomProgressIndicator.pan.enabled = NO;
    _bottomProgressIndicator.trackHeight = _bottomProgressIndicatorHeight;
    _bottomProgressIndicator.round = NO;
    id<SJContactIntegrateControlLayerResources> sources = SJContactIntegrateConfigurations.shared.resources;
    UIColor *traceColor = sources.bottomIndicatorTraceColor ?: sources.progressTraceColor;
    UIColor *trackColor = sources.bottomIndicatorTrackColor ?: sources.progressTrackColor;
    _bottomProgressIndicator.traceImageView.backgroundColor = traceColor;
    _bottomProgressIndicator.trackImageView.backgroundColor = trackColor;
    _bottomProgressIndicator.frame = CGRectMake(0, self.bounds.size.height - _bottomProgressIndicatorHeight, self.bounds.size.width, _bottomProgressIndicatorHeight);
    _bottomProgressIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    return _bottomProgressIndicator;
}

@synthesize loadingView = _loadingView;
- (UIView<SJLoadingView> *)loadingView {
    if ( _loadingView == nil ) {
        [self setLoadingView:[SJLoadingView.alloc initWithFrame:CGRectZero]];
    }
    return _loadingView;
}

- (__kindof UIView<SJDraggingProgressPopupView> *)draggingProgressPopupView {
    if ( _draggingProgressPopupView == nil ) {
        [self setDraggingProgressPopupView:[SJDraggingProgressPopupView.alloc initWithFrame:CGRectZero]];
    }
    return _draggingProgressPopupView;
}

- (id<SJDraggingObservation>)draggingObserver {
    if ( _draggingObserver == nil ) {
        _draggingObserver = [SJDraggingObservation new];
    }
    return _draggingObserver;
}

@synthesize lockStateTappedTimerControl = _lockStateTappedTimerControl;
- (SJTimerControl *)lockStateTappedTimerControl {
    if ( _lockStateTappedTimerControl ) return _lockStateTappedTimerControl;
    _lockStateTappedTimerControl = [[SJTimerControl alloc] init];
    __weak typeof(self) _self = self;
    _lockStateTappedTimerControl.exeBlock = ^(SJTimerControl * _Nonnull control) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        sj_view_makeDisappear(self.leftContainerView, YES);
        [control interrupt];
    };
    return _lockStateTappedTimerControl;
}

@synthesize titleView = _titleView;
- (UIView<SJScrollingTextMarqueeView> *)titleView {
    if ( _titleView == nil ) {
        [self setTitleView:[SJScrollingTextMarqueeView.alloc initWithFrame:CGRectZero]];
    }
    return _titleView;
}

@synthesize speedupContentDataPopupView = _speedupContentDataPopupView;
- (UIView<SJCompressSemicolonRestrictView> *)speedupContentDataPopupView {
    if ( _speedupContentDataPopupView == nil ) {
        _speedupContentDataPopupView = [SJCompressSemicolonRestrictView.alloc initWithFrame:CGRectZero];
    }
    return _speedupContentDataPopupView;
}

@synthesize pictureInPictureItem = _pictureInPictureItem;
- (SJEdgeControlButtonItem *)pictureInPictureItem API_AVAILABLE(ios(14.0)) {
    if ( _pictureInPictureItem == nil ) {
        _pictureInPictureItem = [SJEdgeControlButtonItem.alloc initWithTag:SJEdgeControlLayerTopItemPictureInPicture];
        [_pictureInPictureItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(pictureInPictureItemWasTapped)]];
    }
    return _pictureInPictureItem;
}

@synthesize customStatusBar = _customStatusBar;
- (UIView<SJFullscreenModeStatusBar> *)customStatusBar {
    if ( _customStatusBar == nil ) {
        [self setCustomStatusBar:[SJFullscreenModeStatusBar.alloc initWithFrame:CGRectZero]];
    }
    return _customStatusBar;
}

@synthesize shouldShowsCustomStatusBar = _shouldShowsCustomStatusBar;
- (BOOL (^)(SJEdgeControlLayer * _Nonnull))shouldShowsCustomStatusBar {
    if ( _shouldShowsCustomStatusBar == nil ) {
        BOOL series = _screen.saleInnerries;
        [self setShouldShowsCustomStatusBar:^BOOL(SJEdgeControlLayer * _Nonnull controlLayer) {
            if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) return NO;
            
            if ( controlLayer.alternateStructure.fncyFitOnScreen ) return NO;
            if ( controlLayer.alternateStructure.rotationManager.simplRedundant ) return NO;
            
            BOOL indntImplement = controlLayer.alternateStructure.indntImplement;
            if ( indntImplement == NO ) {
                CGRect bounds = UIScreen.mainScreen.bounds;
                if ( bounds.size.width > bounds.size.height )
                    indntImplement = CGRectEqualToRect(controlLayer.bounds, bounds);
            }
            
            BOOL shouldShow = NO;
            if ( indntImplement ) {

                if ( @available(iOS 13.0, *) ) {
                    shouldShow = YES;
                }

                else if ( @available(iOS 11.0, *) ) {
                    shouldShow = series;
                }
            }
            return shouldShow;
        }];
    }
    return _shouldShowsCustomStatusBar;
}

@synthesize dateTimerControl = _dateTimerControl;
- (SJTimerControl *)dateTimerControl {
    if ( _dateTimerControl == nil ) {
        _dateTimerControl = SJTimerControl.alloc.init;
        _dateTimerControl.interval = 1;
        __weak typeof(self) _self = self;
        _dateTimerControl.exeBlock = ^(SJTimerControl * _Nonnull control) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            self.customStatusBar.isHidden ? [control interrupt] : [self _reloadCustomStatusBarIfNeeded];
        };
    }
    return _dateTimerControl;
}

- (void)_addItemsToTopAdapter {
    SJEdgeControlButtonItem *backItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJEdgeControlLayerTopItemBack];
    backItem.resetsAppearIntervalWhenPerformingItemAction = NO;
    [backItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(_backItemWasTapped)]];
    [self.topAdapter addItem:backItem];
    _backItem = backItem;

    SJEdgeControlButtonItem *titleItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49xFill tag:SJEdgeControlLayerTopItemTitle];
    [self.topAdapter addItem:titleItem];
    
    [self.topAdapter reload];
}

- (void)_addItemsToLeftAdapter {
    SJEdgeControlButtonItem *lockItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJEdgeControlLayerLeftItemLock];
    [lockItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(_lockItemWasTapped)]];
    [self.leftAdapter addItem:lockItem];
    
    [self.leftAdapter reload];
}

- (void)_addItemsToBottomAdapter {
    SJEdgeControlButtonItem *playItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJEdgeControlLayerBottomItemImplement];
    [playItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(_playItemWasTapped)]];
    [self.bottomAdapter addItem:playItem];
    
    SJEdgeControlButtonItem *liveItem = [[SJEdgeControlButtonItem alloc] initWithTag:SJEdgeControlLayerBottomItemReverse];
    liveItem.innerHidden = YES;
    [self.bottomAdapter addItem:liveItem];
    
    SJEdgeControlButtonItem *timeItem = [SJEdgeControlButtonItem placeholderWithSize:8 tag:SJEdgeControlLayerBottomItemContentTime];
    [self.bottomAdapter addItem:timeItem];
    
    SJEdgeControlButtonItem *separatorItem = [[SJEdgeControlButtonItem alloc] initWithTitle:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(@"/ ").font([UIFont systemFontOfSize:11]).textColor([UIColor whiteColor]).alignment(NSTextAlignmentCenter);
    }] target:nil action:NULL tag:SJEdgeControlLayerBottomItemSeparator];
    [self.bottomAdapter addItem:separatorItem];
    
    SJEdgeControlButtonItem *durationTimeItem = [SJEdgeControlButtonItem placeholderWithSize:8 tag:SJEdgeControlLayerBottomItemPresentTime];
    [self.bottomAdapter addItem:durationTimeItem];
    
    SJProgressSlider *slider = [SJProgressSlider new];
    slider.trackHeight = 3;
    slider.delegate = self;
    slider.tap.enabled = YES;
    slider.showsBufferProgress = YES;
    __weak typeof(self) _self = self;
    slider.tappedExeBlock = ^(SJProgressSlider * _Nonnull slider, CGFloat location) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.alternateStructure.canSeekToTime && self.alternateStructure.canSeekToTime(self.alternateStructure) == NO ) {
            return;
        }
        
        if ( self.alternateStructure.reserveStatus != SJDuplicateStatusReady ) {
            return;
        }
    
        [self.alternateStructure seekToTime:location completionHandler:nil];
    };
    SJEdgeControlButtonItem *progressItem = [[SJEdgeControlButtonItem alloc] initWithCustomView:slider tag:SJEdgeControlLayerBottomItemPattern];
    progressItem.insets = SJEdgeInsetsMake(8, 8);
    progressItem.fill = YES;
    [self.bottomAdapter addItem:progressItem];

    SJEdgeControlButtonItem *fullItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJEdgeControlLayerBottomItemManifest];
    fullItem.resetsAppearIntervalWhenPerformingItemAction = NO;
    [fullItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(_fullItemWasTapped)]];
    [self.bottomAdapter addItem:fullItem];

    [self.bottomAdapter reload];
}

- (void)_addItemsToRightAdapter {
    
}

- (void)_addItemsToCenterAdapter {
    UILabel *replayLabel = [UILabel new];
    replayLabel.numberOfLines = 0;
    SJEdgeControlButtonItem *replayItem = [SJEdgeControlButtonItem frameLayoutWithCustomView:replayLabel tag:SJEdgeControlLayerCenterItemAutomatic];
    [replayItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(_replayItemWasTapped)]];
    [self.centerAdapter addItem:replayItem];
    [self.centerAdapter reload];
}


#pragma mark -

- (void)_updateAppearStateForContainerViews {
    [self _updateAppearStateForTopContainerView];
    [self _updateAppearStateForLeftContainerView];
    [self _updateAppearStateForBottomContainerView];
    [self _updateAppearStateForRightContainerView];
    [self _updateAppearStateForCenterContainerView];
    if (@available(iOS 11.0, *)) {
        [self _updateAppearStateForCustomStatusBar];
    }
}

- (void)_updateAppearStateForTopContainerView {
    if ( 0 == _topAdapter.numberOfItems ) {
        sj_view_makeDisappear(_topContainerView, YES);
        return;
    }
    
    if ( _alternateStructure.lightLockedStructure ) {
        sj_view_makeDisappear(_topContainerView, YES);
        return;
    }
    
    if ( _alternateStructure.isControlLayerAppeared ) {
        sj_view_makeAppear(_topContainerView, YES);
    }
    else {
        sj_view_makeDisappear(_topContainerView, YES);
    }
}

- (void)_updateAppearStateForLeftContainerView {
    if ( 0 == _leftAdapter.numberOfItems ) {
        sj_view_makeDisappear(_leftContainerView, YES);
        return;
    }
    
    if ( _alternateStructure.lightLockedStructure ) {
        sj_view_makeAppear(_leftContainerView, YES);
        return;
    }
    
    if ( _alternateStructure.isControlLayerAppeared ) {
        sj_view_makeAppear(_leftContainerView, YES);
    }
    else {
        sj_view_makeDisappear(_leftContainerView, YES);
    }
}

- (void)_updateAppearStateForBottomContainerView {
    if ( 0 == _bottomAdapter.numberOfItems ) {
        sj_view_makeDisappear(_bottomContainerView, YES);
        return;
    }
    
    if ( _alternateStructure.lightLockedStructure ) {
        sj_view_makeDisappear(_bottomContainerView, YES);
        return;
    }
    
    if ( _alternateStructure.isControlLayerAppeared ) {
        sj_view_makeAppear(_bottomContainerView, YES);
    }
    else {
        sj_view_makeDisappear(_bottomContainerView, YES);
    }
}

- (void)_updateAppearStateForRightContainerView {
    if ( 0 == _rightAdapter.numberOfItems ) {
        sj_view_makeDisappear(_rightContainerView, YES);
        return;
    }
    
    if ( _alternateStructure.lightLockedStructure ) {
        sj_view_makeDisappear(_rightContainerView, YES);
        return;
    }
    
    if ( _alternateStructure.isControlLayerAppeared ) {
        sj_view_makeAppear(_rightContainerView, YES);
    }
    else {
        sj_view_makeDisappear(_rightContainerView, YES);
    }
}

- (void)_updateAppearStateForCenterContainerView {
    if ( 0 == _centerAdapter.numberOfItems ) {
        sj_view_makeDisappear(_centerContainerView, YES);
        return;
    }
    
    sj_view_makeAppear(_centerContainerView, YES);
}

- (void)_updateAppearStateForBottomProgressIndicatorIfNeeded {
    if ( _bottomProgressIndicator == nil )
        return;
    
    BOOL hidden = (_alternateStructure.isControlLayerAppeared && !_alternateStructure.lightLockedStructure) || (_alternateStructure.simplRedundant);
    
    hidden ? sj_view_makeDisappear(_bottomProgressIndicator, NO) :
             sj_view_makeAppear(_bottomProgressIndicator, NO);
}

- (void)_updateAppearStateForCustomStatusBar NS_AVAILABLE_IOS(11.0) {
    BOOL shouldShow = self.shouldShowsCustomStatusBar(self);
    if ( shouldShow ) {
        if ( self.customStatusBar.superview == nil ) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                UIDevice.currentDevice.batteryMonitoringEnabled = YES;
            });
            
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_reloadCustomStatusBarIfNeeded) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_reloadCustomStatusBarIfNeeded) name:UIDeviceBatteryStateDidChangeNotification object:nil];
            
            self.customStatusBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            [self.topContainerView addSubview:self.customStatusBar];
        }
        CGFloat containerW = self.topContainerView.frame.size.width;
        CGFloat statusBarW = self.topAdapter.frame.size.width;
        CGFloat startX = (containerW - statusBarW) * 0.5;
        self.customStatusBar.frame = CGRectMake(startX, 0, self.topAdapter.bounds.size.width, 20);
    }
    
    _customStatusBar.hidden = !shouldShow;
    _customStatusBar.isHidden ? [self.dateTimerControl interrupt] : [self.dateTimerControl resume];
}

- (void)_updateContentForPictureInPictureItem API_AVAILABLE(ios(14.0)) {
    id<SJContactIntegrateControlLayerResources> sources = SJContactIntegrateConfigurations.shared.resources;
    switch ( self.alternateStructure.contactIntegrateController.pictureInPictureStatus ) {
        case SJPictureInPictureStatusRunning:
            self.pictureInPictureItem.image = sources.pictureInPictureItemStopImage;
            break;
        case SJPictureInPictureStatusUnknown:
        case SJPictureInPictureStatusStarting:
        case SJPictureInPictureStatusStopping:
        case SJPictureInPictureStatusStopped:
            self.pictureInPictureItem.image = sources.pictureInPictureItemStartImage;
            break;
    }
}

#pragma mark - update items

- (void)_reloadAdaptersIfNeeded {
    [self _reloadTopAdapterIfNeeded];
    [self _reloadLeftAdapterIfNeeded];
    [self _reloadBottomAdapterIfNeeded];
    [self _reloadRightAdapterIfNeeded];
    [self _reloadCenterAdapterIfNeeded];
}

- (void)_reloadTopAdapterIfNeeded {
    if ( sj_view_isDisappeared(_topContainerView) ) return;
    id<SJContactIntegrateControlLayerResources> sources = SJContactIntegrateConfigurations.shared.resources;
    BOOL indntImplement = _alternateStructure.indntImplement;
    BOOL fncyFitOnScreen = _alternateStructure.fncyFitOnScreen;
    BOOL pridFindOnScrollView = _alternateStructure.pridFindOnScrollView;
    BOOL smallscreen = !indntImplement && !fncyFitOnScreen;

    {
        SJEdgeControlButtonItem *backItem = [self.topAdapter itemForTag:SJEdgeControlLayerTopItemBack];
        if ( backItem != nil ) {
            if ( _fixesBackItem ) {
                if ( !indntImplement && _hiddenBackButtonWhenOrientationIsPortrait )
                    backItem.innerHidden = YES;
                else
                    backItem.innerHidden = NO;
            }
            else {
                if ( indntImplement || fncyFitOnScreen )
                    backItem.innerHidden = NO;
                else if ( _hiddenBackButtonWhenOrientationIsPortrait )
                    backItem.innerHidden = YES;
                else
                    backItem.innerHidden = pridFindOnScrollView;
            }

            if ( backItem.hidden == NO ) {
                backItem.alpha = 1.0;
                backItem.image = _fixesBackItem ? nil : sources.backImage;
            }
            else {
                backItem.alpha = 0;
                backItem.image = nil;
            }
        }
    }
    
    {
        SJEdgeControlButtonItem *titleItem = [self.topAdapter itemForTag:SJEdgeControlLayerTopItemTitle];
        if ( titleItem != nil ) {
            if ( self.isHiddenTitleItemWhenOrientationIsPortrait && smallscreen ) {
                titleItem.innerHidden = YES;
            }
            else {
                if ( titleItem.customView != self.titleView )
                    titleItem.customView = self.titleView;
                SJCompressContainSale *asset = _alternateStructure.containSale.original ?: _alternateStructure.containSale;
                NSAttributedString *_Nullable attributedTitle = asset.attributedTitle;
                self.titleView.attributedText = attributedTitle;
                titleItem.innerHidden = (attributedTitle.length == 0);
            }

            if ( titleItem.hidden == NO ) {
                NSInteger atIndex = [_topAdapter indexOfItemForTag:SJEdgeControlLayerTopItemTitle];
                CGFloat left  = [_topAdapter recursiveSortWithRange:NSMakeRange(0, atIndex)] ? 16 : 0;
                CGFloat right = [_topAdapter recursiveSortWithRange:NSMakeRange(atIndex, _topAdapter.numberOfItems)] ? 16 : 0;
                titleItem.insets = SJEdgeInsetsMake(left, right);
            }
        }
    }
    
    {
        if (@available(iOS 14.0, *)) {
            if ( !self.automaticallyShowsPictureInPictureItem || (self.alternateStructure.pridFindOnScrollView && smallscreen) ) {
                [self.topAdapter removeItemForTag:SJEdgeControlLayerTopItemPictureInPicture];
            }
            else if ( self.alternateStructure.contactIntegrateController.seekPictureInPictureSupported ) {
                if ( ![self.topAdapter containsItem:self.pictureInPictureItem] ) {
                    [self _updateContentForPictureInPictureItem];
                    [self.topAdapter insertItem:self.pictureInPictureItem frontItem:SJEdgeControlLayerTopItemTitle];
                }
            }
        }
    }
    
    [_topAdapter reload];
}

- (void)_reloadLeftAdapterIfNeeded {
    if ( sj_view_isDisappeared(_leftContainerView) ) return;
    
    BOOL indntImplement = _alternateStructure.indntImplement;
    BOOL lightLockedStructure = _alternateStructure.lightLockedStructure;
    BOOL showsLockItem = indntImplement && !_alternateStructure.rotationManager.simplRedundant;

    SJEdgeControlButtonItem *lockItem = [self.leftAdapter itemForTag:SJEdgeControlLayerLeftItemLock];
    if ( lockItem != nil ) {
        lockItem.innerHidden = !showsLockItem;
        if ( showsLockItem ) {
            id<SJContactIntegrateControlLayerResources> sources = SJContactIntegrateConfigurations.shared.resources;
            lockItem.image = lightLockedStructure ? sources.lockImage : sources.unlockImage;
        }
    }
    
    [_leftAdapter reload];
}

- (void)_reloadBottomAdapterIfNeeded {
    if ( sj_view_isDisappeared(_bottomContainerView) ) return;
    
    id<SJContactIntegrateControlLayerResources> sources = SJContactIntegrateConfigurations.shared.resources;
    id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;
    
    {
        SJEdgeControlButtonItem *playItem = [self.bottomAdapter itemForTag:SJEdgeControlLayerBottomItemImplement];
        if ( playItem != nil && playItem.hidden == NO ) {
            playItem.image = _alternateStructure.ellipsisRule ? sources.playImage : sources.pauseImage;
        }
    }
    
    {
        SJEdgeControlButtonItem *progressItem = [self.bottomAdapter itemForTag:SJEdgeControlLayerBottomItemPattern];
        if ( progressItem != nil && progressItem.hidden == NO ) {
            SJProgressSlider *slider = progressItem.customView;
            slider.traceImageView.backgroundColor = sources.progressTraceColor;
            slider.trackImageView.backgroundColor = sources.progressTrackColor;
            slider.bufferProgressColor = sources.progressBufferColor;
            slider.trackHeight = sources.progressTrackHeight;
            slider.loadingColor = sources.loadingLineColor;
            
            if ( sources.progressThumbImage ) {
                slider.thumbImageView.image = sources.progressThumbImage;
            }
            else if ( sources.progressThumbSize ) {
                [slider setThumbCornerRadius:sources.progressThumbSize * 0.5 size:CGSizeMake(sources.progressThumbSize, sources.progressThumbSize) thumbBackgroundColor:sources.progressThumbColor];
            }
        }
    }
    
    {
        SJEdgeControlButtonItem *fullItem = [self.bottomAdapter itemForTag:SJEdgeControlLayerBottomItemManifest];
        if ( fullItem != nil && fullItem.hidden == NO ) {
            BOOL indntImplement = _alternateStructure.indntImplement;
            BOOL fncyFitOnScreen = _alternateStructure.fncyFitOnScreen;
            fullItem.image = (indntImplement || fncyFitOnScreen) ? sources.smallScreenImage : sources.fullscreenImage;
        }
    }
    
    {
        SJEdgeControlButtonItem *liveItem = [self.bottomAdapter itemForTag:SJEdgeControlLayerBottomItemReverse];
        if ( liveItem != nil && liveItem.hidden == NO ) {
            liveItem.title = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.append(strings.liveBroadcast);
                make.font(sources.titleLabelFont);
                make.textColor(sources.titleLabelColor);
                make.shadow(^(NSShadow * _Nonnull make) {
                    make.shadowOffset = CGSizeMake(0, 0.5);
                    make.shadowColor = UIColor.blackColor;
                });
            }];
        }
    }
    
    [_bottomAdapter reload];
}

- (void)_reloadRightAdapterIfNeeded {
    
}

- (void)_reloadCenterAdapterIfNeeded {
    if ( sj_view_isDisappeared(_centerContainerView) ) return;
    
    SJEdgeControlButtonItem *replayItem = [self.centerAdapter itemForTag:SJEdgeControlLayerCenterItemAutomatic];
    if ( replayItem != nil ) {
        replayItem.innerHidden = !_alternateStructure.machContentInstantDataFinished;
        if ( replayItem.hidden == NO && replayItem.title == nil ) {
            id<SJContactIntegrateControlLayerResources> resources = SJContactIntegrateConfigurations.shared.resources;
            id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;
            UILabel *textLabel = replayItem.customView;
            textLabel.attributedText = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.alignment(NSTextAlignmentCenter).lineSpacing(6);
                make.font(resources.replayTitleFont);
                make.textColor(resources.replayTitleColor);
                if ( resources.replayImage != nil ) {
                    make.appendImage(^(id<SJUTImageAttachment>  _Nonnull make) {
                        make.image = resources.replayImage;
                    });
                }
                if ( strings.replay.length != 0 ) {
                    if ( resources.replayImage != nil ) make.append(@"\n");
                    make.append(strings.replay);
                }
            }];
            textLabel.bounds = (CGRect){CGPointZero, [textLabel.attributedText sj_textSize]};
        }
    }
    
    [_centerAdapter reload];
}

- (void)_updateContentForBottomContentTimeItemIfNeeded {
    if ( sj_view_isDisappeared(_bottomContainerView) )
        return;
    NSString *timeStr = [_alternateStructure stringForSeconds:_alternateStructure.contentTime];
    SJEdgeControlButtonItem *timeItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemContentTime];
    if ( timeItem != nil && timeItem.isHidden == NO ) {
        timeItem.title = [self _textForTimeString:timeStr];
        [_bottomAdapter updateContentForItemWithTag:SJEdgeControlLayerBottomItemContentTime];
    }
}

- (void)_updateContentForBottomDurationItemIfNeeded {
    SJEdgeControlButtonItem *durationTimeItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemPresentTime];
    if ( durationTimeItem != nil && durationTimeItem.isHidden == NO ) {
        durationTimeItem.title = [self _textForTimeString:[_alternateStructure stringForSeconds:_alternateStructure.duration]];
        [_bottomAdapter updateContentForItemWithTag:SJEdgeControlLayerBottomItemPresentTime];
    }
}

- (void)_reloadSizeForBottomTimeLabel {

    NSString *ms = @"00:00";
    NSString *hms = @"00:00:00";
    NSString *durationTimeStr = [_alternateStructure stringForSeconds:_alternateStructure.duration];
    NSString *format = (durationTimeStr.length == ms.length)?ms:hms;
    CGSize formatSize = [[self _textForTimeString:format] sj_textSize];
    
    SJEdgeControlButtonItem *timeItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemContentTime];
    SJEdgeControlButtonItem *durationTimeItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemPresentTime];
    
    if ( !durationTimeItem && !timeItem ) return;
    timeItem.size = formatSize.width;
    durationTimeItem.size = formatSize.width;
    [_bottomAdapter reload];
}

- (void)_updateContentForBottomProgressSliderItemIfNeeded {
    if ( !sj_view_isDisappeared(_bottomContainerView) ) {
        SJEdgeControlButtonItem *progressItem = [_bottomAdapter itemForTag:SJEdgeControlLayerBottomItemPattern];
        if ( progressItem != nil && !progressItem.isHidden ) {
            SJProgressSlider *slider = progressItem.customView;
            slider.maxValue = _alternateStructure.duration ? : 1;
            if ( !slider.isDragging ) slider.value = _alternateStructure.contentTime;
            slider.bufferProgress = _alternateStructure.playableDuration / slider.maxValue;
        }
    }
}

- (void)_updateContentForBottomProgressIndicatorIfNeeded {
    if ( _bottomProgressIndicator != nil && !sj_view_isDisappeared(_bottomProgressIndicator) ) {
        _bottomProgressIndicator.value = _alternateStructure.contentTime;
        _bottomProgressIndicator.maxValue = _alternateStructure.duration ? : 1;
    }
}

- (void)_updateContentTimeForDraggingProgressPopupViewIfNeeded {
    if ( !sj_view_isDisappeared(_draggingProgressPopupView) )
        _draggingProgressPopupView.contentTime = _alternateStructure.contentTime;
}

- (void)_updateAppearStateForFixedBackButtonIfNeeded {
    if ( !_fixesBackItem )
        return;
    BOOL fncyFitOnScreen = _alternateStructure.fncyFitOnScreen;
    BOOL indntImplement = _alternateStructure.indntImplement;
    BOOL lightLockedStructure = _alternateStructure.lightLockedStructure;
    if ( lightLockedStructure ) {
        _fixedBackButton.hidden = YES;
    }
    else if ( _hiddenBackButtonWhenOrientationIsPortrait && !indntImplement ) {
        _fixedBackButton.hidden = YES;
    }
    else {
        BOOL pridFindOnScrollView = _alternateStructure.pridFindOnScrollView;
        _fixedBackButton.hidden = pridFindOnScrollView && !fncyFitOnScreen && !indntImplement;
    }
}

- (void)_updateNetworkSpeedStrForLoadingView {
    if ( !_alternateStructure || !self.loadingView.isAnimating )
        return;
    
    if ( self.loadingView.showsNetworkSpeed && !_alternateStructure.assetURL.isFileURL ) {
        self.loadingView.networkSpeedStr = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
            id<SJContactIntegrateControlLayerResources> resources = SJContactIntegrateConfigurations.shared.resources;
            make.font(resources.loadingNetworkSpeedTextFont);
            make.textColor(resources.loadingNetworkSpeedTextColor);
            make.alignment(NSTextAlignmentCenter);
            make.append(self.alternateStructure.reachability.networkSpeedStr);
        }];
    }
    else {
        self.loadingView.networkSpeedStr = nil;
    }
}

- (void)_reloadCustomStatusBarIfNeeded NS_AVAILABLE_IOS(11.0) {
    if ( sj_view_isDisappeared(_customStatusBar) )
        return;
    _customStatusBar.networkStatus = _alternateStructure.reachability.networkStatus;
    _customStatusBar.date = NSDate.date;
    _customStatusBar.batteryState = UIDevice.currentDevice.batteryState;
    _customStatusBar.batteryLevel = UIDevice.currentDevice.batteryLevel;
}

#pragma mark -

- (void)_updateForDraggingProgressPopupView {
    SJDraggingProgressPopupViewStyle style = SJDraggingProgressPopupViewStyleNormal;
    if ( !_alternateStructure.containSale.isM3u8 &&
         [_alternateStructure.contactIntegrateController respondsToSelector:@selector(screenshotWithTime:size:completion:)] ) {
        if ( _alternateStructure.indntImplement ) {
            style = SJDraggingProgressPopupViewStyleFullscreen;
        }
        else if ( _alternateStructure.fncyFitOnScreen ) {
            style = SJDraggingProgressPopupViewStyleFitOnScreen;
        }
    }
    _draggingProgressPopupView.style = style;
    _draggingProgressPopupView.duration = _alternateStructure.duration ?: 1;
    _draggingProgressPopupView.contentTime = _alternateStructure.contentTime;
    _draggingProgressPopupView.dragTime = _alternateStructure.contentTime;
}

- (nullable NSAttributedString *)_textForTimeString:(NSString *)timeStr {
    id<SJContactIntegrateControlLayerResources> resources = SJContactIntegrateConfigurations.shared.resources;
    return [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(timeStr).font(resources.timeLabelFont).textColor(resources.timeLabelColor).alignment(NSTextAlignmentCenter);
    }];
}

/// 此处为重置控制层的隐藏间隔.(如果点击到当前控制层上的item, 则重置控制层的隐藏间隔)
- (void)_resetControlLayerAppearIntervalForItemIfNeeded:(NSNotification *)note {
    SJEdgeControlButtonItem *item = note.object;
    if ( item.resetsAppearIntervalWhenPerformingItemAction ) {
        if ( [_topAdapter containsItem:item] ||
             [_leftAdapter containsItem:item] ||
             [_bottomAdapter containsItem:item] ||
             [_rightAdapter containsItem:item] )
            [_alternateStructure controlLayerNeedAppear];
    }
}

- (void)_showOrRemoveBottomProgressIndicator {
    if ( _hiddenBottomProgressIndicator || _alternateStructure.developBackType == SJDevelopbackTypeLIVE ) {
        if ( _bottomProgressIndicator ) {
            [_bottomProgressIndicator removeFromSuperview];
            _bottomProgressIndicator = nil;
        }
    }
    else {
        if ( !_bottomProgressIndicator ) {
            [self.controlView addSubview:self.bottomProgressIndicator];
            [self _updateLayoutForBottomProgressIndicator];
        }
    }
}

- (void)_updateLayoutForBottomProgressIndicator {
    if ( _bottomProgressIndicator == nil ) return;
    _bottomProgressIndicator.trackHeight = _bottomProgressIndicatorHeight;
    _bottomProgressIndicator.frame = CGRectMake(0, self.bounds.size.height - _bottomProgressIndicatorHeight, self.bounds.size.width, _bottomProgressIndicatorHeight);
}

- (void)_showOrHiddenLoadingView {
    if ( _alternateStructure == nil || _alternateStructure.containSale == nil ) {
        [self.loadingView stop];
        return;
    }
    
    if ( _alternateStructure.ellipsisRule ) {
        [self.loadingView stop];
    }
    else if ( _alternateStructure.reserveStatus == SJDuplicateStatusPreparing ) {
        [self.loadingView start];
    }
    else if ( _alternateStructure.reserveStatus == SJDuplicateStatusFailed ) {
        [self.loadingView stop];
    }
    else if ( _alternateStructure.reserveStatus == SJDuplicateStatusReady ) {
        self.alternateStructure.reasonForWaitingCompose == SJWaitingToMinimizeStallsReason ? [self.loadingView start] : [self.loadingView stop];
    }
}

- (void)_willBeginDragging {
    [self.controlView addSubview:self.draggingProgressPopupView];
    [self _updateForDraggingProgressPopupView];
    [_draggingProgressPopupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    sj_view_initializes(_draggingProgressPopupView);
    sj_view_makeAppear(_draggingProgressPopupView, NO);
    
    if ( _draggingObserver.willBeginDraggingExeBlock )
        _draggingObserver.willBeginDraggingExeBlock(_draggingProgressPopupView.dragTime);
}

- (void)_didMove:(NSTimeInterval)progressTime {
    _draggingProgressPopupView.dragTime = progressTime;
    if ( _draggingProgressPopupView.isPreviewImageHidden == NO ) {
        __weak typeof(self) _self = self;
        [_alternateStructure screenshotWithTime:progressTime size:CGSizeMake(_draggingProgressPopupView.frame.size.width, _draggingProgressPopupView.frame.size.height) completion:^(SJBaseSequenceInvolve * _Nonnull alternateStructure, UIImage * _Nullable image, NSError * _Nullable error) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            [self.draggingProgressPopupView setPreviewImage:image];
        }];
    }
    
    if ( _draggingObserver.didMoveExeBlock )
        _draggingObserver.didMoveExeBlock(_draggingProgressPopupView.dragTime);
}

- (void)_endDragging {
    NSTimeInterval time = _draggingProgressPopupView.dragTime;
    if ( _draggingObserver.willEndDraggingExeBlock )
        _draggingObserver.willEndDraggingExeBlock(time);
    
    [_alternateStructure seekToTime:time completionHandler:nil];

    sj_view_makeDisappear(_draggingProgressPopupView, YES, ^{
        if ( sj_view_isDisappeared(self->_draggingProgressPopupView) ) {
            [self->_draggingProgressPopupView removeFromSuperview];
        }
    });
    
    if ( _draggingObserver.didEndDraggingExeBlock )
        _draggingObserver.didEndDraggingExeBlock(time);
}

@end


@implementation SJEdgeControlButtonItem (SJControlLayerExtended)
- (void)setResetsAppearIntervalWhenPerformingItemAction:(BOOL)resetsAppearIntervalWhenPerformingItemAction {
    objc_setAssociatedObject(self, @selector(resetsAppearIntervalWhenPerformingItemAction), @(resetsAppearIntervalWhenPerformingItemAction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)resetsAppearIntervalWhenPerformingItemAction {
    id result = objc_getAssociatedObject(self, _cmd);
    return result == nil ? YES : [result boolValue];
}
@end
