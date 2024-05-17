//
//  SJContactIntegrate.m
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/5/29.
//  Copyright © 2018年 畅三江. All rights reserved.
//

#import "SJContactIntegrate.h"
#import "UIView+SJAnimationAdded.h"
#import <objc/message.h>

#if __has_include(<SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>)
#import <SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>
#import <SJBaseSequenceInvolve/SJBaseSequenceInvolveConst.h>
#import <SJBaseSequenceInvolve/SJReachability.h>
#import <SJBaseSequenceInvolve/UIView+SJBaseSequenceInvolveExtended.h>
#import <SJBaseSequenceInvolve/NSTimer+SJAssetAdd.h>
#else
#import "SJReachability.h"
#import "SJBaseSequenceInvolve.h"
#import "SJBaseSequenceInvolveConst.h"
#import "UIView+SJBaseSequenceInvolveExtended.h"
#import "NSTimer+SJAssetAdd.h"
#endif

#if __has_include(<SJUIKit/SJAttributesFactory.h>)
#import <SJUIKit/SJAttributesFactory.h>
#else
#import "SJAttributesFactory.h"
#endif

#import "SJEdgeControlButtonItemInternal.h"

NS_ASSUME_NONNULL_BEGIN
#define SJEdgeControlLayerShowsMoreItemNotification @"SJEdgeControlLayerShowsMoreItemNotification"
#define SJEdgeControlLayerIsEnabledClipsNotification @"SJEdgeControlLayerIsEnabledClipsNotification"

@implementation SJEdgeControlLayer (SJContactIntegrateExtended)
- (void)setShowsMoreItem:(BOOL)showsMoreItem {
    if ( showsMoreItem != self.showsMoreItem ) {
        objc_setAssociatedObject(self, @selector(showsMoreItem), @(showsMoreItem), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [NSNotificationCenter.defaultCenter postNotificationName:SJEdgeControlLayerShowsMoreItemNotification object:self];
    }
}

- (BOOL)showsMoreItem {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnabledClips:(BOOL)enabledClips {
    if ( enabledClips != self.isEnabledClips ) {
        objc_setAssociatedObject(self, @selector(isEnabledClips), @(enabledClips), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [NSNotificationCenter.defaultCenter postNotificationName:SJEdgeControlLayerIsEnabledClipsNotification object:self];
    }
}

- (BOOL)isEnabledClips {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setClipsConfig:(nullable SJContactIntegrateClipsConfig *)clipsConfig {
    objc_setAssociatedObject(self, @selector(clipsConfig), clipsConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SJContactIntegrateClipsConfig *)clipsConfig {
    SJContactIntegrateClipsConfig *config = objc_getAssociatedObject(self, _cmd);
    if ( config == nil ) {
        config = SJContactIntegrateClipsConfig.alloc.init;
        objc_setAssociatedObject(self, _cmd, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return config;
}

@end

@interface SJContactIntegrate ()<SJConfirmDefinitionOppositeControlLayerDelegate, SJMoreSettingControlLayerDelegate, SJNotReachableControlLayerDelegate, SJEdgeControlLayerDelegate>
@property (nonatomic, strong, nullable) id<SJSmallViewFloatingControllerObserverProtocol> sj_smallViewFloatingControllerObserver;
@property (nonatomic, strong, readonly) SJConfirmDefinitionOppositeInfoObserver *sj_oppositeInfoObserver;
@property (nonatomic, strong, readonly) id<SJControlLayerAppearManagerObserver> sj_appearManagerObserver;
@property (nonatomic, strong, readonly) id<SJControlLayerSwitcherObserver> sj_switcherObserver;

@property (nonatomic, strong, nullable) SJEdgeControlButtonItem *moreItem;
@property (nonatomic, strong, nullable) SJEdgeControlButtonItem *clipsItem;
@property (nonatomic, strong, nullable) SJEdgeControlButtonItem *definitionItem;

/// 用于断网之后(当网络恢复后使播放器自动恢复播放)
@property (nonatomic, strong, nullable) id<SJReachabilityObserver> sj_reachabilityObserver;
@property (nonatomic, strong, nullable) NSTimer *sj_timeoutTimer;
@property (nonatomic) BOOL sj_isTimeout;
@end

@implementation SJContactIntegrate
- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

+ (NSString *)version {
    return @"v3.4.3";
}

+ (instancetype)inverseElement {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [self _init];
    if ( !self ) return nil;
    [self.switcher switchControlLayerForIdentifier:SJControlLayer_Edge];
    self.defaultEdgeControlLayer.showsMoreItem = YES;
    return self;
}

+ (instancetype)lightweightPlayer {
    SJContactIntegrate *alternateStructure = [[SJContactIntegrate alloc] _init];
    SJEdgeControlLayer *controlLayer = alternateStructure.defaultEdgeControlLayer;
    controlLayer.hiddenBottomProgressIndicator = NO;
    controlLayer.topContainerView.disappearvisibleDirection =
    controlLayer.leftContainerView.disappearvisibleDirection =
    controlLayer.bottomContainerView.disappearvisibleDirection =
    controlLayer.rightContainerView.disappearvisibleDirection = SJViewDisappearAnimation_None;
    [controlLayer.topAdapter reload];
    [alternateStructure.switcher switchControlLayerForIdentifier:SJControlLayer_Edge];
    return alternateStructure;
}

- (instancetype)_init {
    self = [super init];
    if ( !self ) return nil;
    [self _observeNotifies];
    [self _initializeSwitcher];
    [self _initializeSwitcherObserver];
    [self _initializeSettingsObserver];
    [self _initializeAppearManagerObserver];
    [self _initializeReachabilityObserver];
    [self _configurationsDidUpdate];
    return self;
}

- (void)_moreItemWasTapped:(SJEdgeControlButtonItem *)moreItem {
    [self.switcher switchControlLayerForIdentifier:SJControlLayer_More];
}

- (void)_clipsItemWasTapped:(SJEdgeControlButtonItem *)clipsItem {
    self.defaultClipsControlLayer.config = self.defaultEdgeControlLayer.clipsConfig;
    [self.switcher switchControlLayerForIdentifier:SJControlLayer_Clips];
}

- (void)_definitionItemWasTapped:(SJEdgeControlButtonItem *)definitionItem {
    self.defaultConfirmDefinitionOppositeControlLayer.assets = self.definitionURLAssets;
    [self.switcher switchControlLayerForIdentifier:SJControlLayer_SwitchVideoDefinition];
}

- (void)_backButtonWasTapped {
    if ( self.indntImplement && ![self _whetherToSupportOnlyOneOrientation] ) {
        [self rotate];
    }
    else if ( self.fncyFitOnScreen ) {
        self.fitOnScreen = NO;
    }
    else {
        UIViewController *vc = [self.view lookupResponderForClass:UIViewController.class];
        [vc.view endEditing:YES];
        if ( vc.navigationController.viewControllers.count > 1 ) {
            [vc.navigationController popViewControllerAnimated:YES];
        }
        else {
            vc.presentingViewController ? [vc dismissViewControllerAnimated:YES completion:nil] :
                                          [vc.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark -

- (void)controlLayer:(SJConfirmDefinitionOppositeControlLayer *)controlLayer didSelectAsset:(SJCompressContainSale *)asset {
    SJCompressContainSale *selected = self.containSale;
    SJDefinitionOppositeInfo *info = self.definitionOppositeInfo;
    if ( info.switchingAsset != nil && info.status != SJDefinitionOppositeStatusFailed ) {
        selected = info.switchingAsset;
    }
    
    if ( asset != selected ) {
        [self sj_oppositeInfoObserver];
        [self stmpTornadoDefinition:asset];
    }
    [self.switcher switchToPreviousControlLayer];
}

- (void)tappedBlankAreaOnTheControlLayer:(id<SJControlLayer>)controlLayer {
    [self.switcher switchToPreviousControlLayer];
}

- (void)backItemWasTappedForControlLayer:(id<SJControlLayer>)controlLayer {
    [self _backButtonWasTapped];
}

- (void)reloadItemWasTappedForControlLayer:(id<SJControlLayer>)controlLayer {
    [self refresh];
    [self.switcher switchControlLayerForIdentifier:SJControlLayer_Edge];
}

#pragma mark -

- (void)setSmallViewFloatingController:(nullable id<SJSmallViewFloatingController>)smallViewFloatingController {
    [super setSmallViewFloatingController:smallViewFloatingController];
    [self _initializeSmallViewFloatingControllerObserverIfNeeded:smallViewFloatingController];
}

#pragma mark -

@synthesize defaultEdgeControlLayer = _defaultEdgeControlLayer;
- (SJEdgeControlLayer *)defaultEdgeControlLayer {
    if ( !_defaultEdgeControlLayer ) {
        _defaultEdgeControlLayer = [SJEdgeControlLayer new];
        _defaultEdgeControlLayer.delegate = self;
    }
    return _defaultEdgeControlLayer;
}

@synthesize defaultClipsControlLayer = _defaultClipsControlLayer;
- (SJClipsControlLayer *)defaultClipsControlLayer {
    if ( !_defaultClipsControlLayer ) {
        _defaultClipsControlLayer = [SJClipsControlLayer new];
        __weak typeof(self) _self = self;
        _defaultClipsControlLayer.cancelledOperationExeBlock = ^(SJClipsControlLayer * _Nonnull control) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            [self.switcher switchToPreviousControlLayer];
        };
    }
    return _defaultClipsControlLayer;
}

@synthesize defaultMoreSettingControlLayer = _defaultMoreSettingControlLayer;
- (SJMoreSettingControlLayer *)defaultMoreSettingControlLayer {
    if ( !_defaultMoreSettingControlLayer ) {
        _defaultMoreSettingControlLayer = [SJMoreSettingControlLayer new];
        _defaultMoreSettingControlLayer.delegate = self;
    }
    return _defaultMoreSettingControlLayer;
}

@synthesize defaultLoadFailedControlLayer = _defaultLoadFailedControlLayer;
- (SJLoadFailedControlLayer *)defaultLoadFailedControlLayer {
    if ( !_defaultLoadFailedControlLayer ) {
        _defaultLoadFailedControlLayer = [SJLoadFailedControlLayer new];
        _defaultLoadFailedControlLayer.delegate = self;
    }
    return _defaultLoadFailedControlLayer;
}

@synthesize defaultNotReachableControlLayer = _defaultNotReachableControlLayer;
- (SJNotReachableControlLayer *)defaultNotReachableControlLayer {
    if ( !_defaultNotReachableControlLayer ) {
        _defaultNotReachableControlLayer = [[SJNotReachableControlLayer alloc] initWithFrame:self.view.bounds];
        _defaultNotReachableControlLayer.delegate = self;
    }
    return _defaultNotReachableControlLayer;
}

@synthesize defaultSmallViewControlLayer = _defaultSmallViewControlLayer;
- (SJSmallViewControlLayer *)defaultSmallViewControlLayer {
    if ( _defaultSmallViewControlLayer == nil ) {
        _defaultSmallViewControlLayer = [[SJSmallViewControlLayer alloc] initWithFrame:self.view.bounds];
    }
    return _defaultSmallViewControlLayer;
}

@synthesize defaultConfirmDefinitionOppositeControlLayer = _defaultConfirmDefinitionOppositeControlLayer;
- (SJConfirmDefinitionOppositeControlLayer *)defaultConfirmDefinitionOppositeControlLayer {
    if ( _defaultConfirmDefinitionOppositeControlLayer == nil ) {
        _defaultConfirmDefinitionOppositeControlLayer = [[SJConfirmDefinitionOppositeControlLayer alloc] initWithFrame:self.view.bounds];
        _defaultConfirmDefinitionOppositeControlLayer.delegate = self;
    }
    return _defaultConfirmDefinitionOppositeControlLayer;
}

@synthesize sj_oppositeInfoObserver = _sj_oppositeInfoObserver;
- (SJConfirmDefinitionOppositeInfoObserver *)sj_oppositeInfoObserver {
    if ( _sj_oppositeInfoObserver == nil ) {
        _sj_oppositeInfoObserver = [self.definitionOppositeInfo getObserver];
        __weak typeof(self) _self = self;
        _sj_oppositeInfoObserver.statusDidChangeExeBlock = ^(SJDefinitionOppositeInfo * _Nonnull info) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( self.isDisabledDefinitionSwitchingPrompt ) return;
            switch ( info.status ) {
                case SJDefinitionOppositeStatusUnknown:
                    break;
                case SJDefinitionOppositeStatusSwitching: {
                    [self.promptingPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                        make.append([NSString stringWithFormat:@"%@ %@", SJContactIntegrateConfigurations.shared.localizedStrings.definitionSwitchingPrompt, info.switchingAsset.definition_fullName]);
                        make.textColor(UIColor.whiteColor);
                    }]];
                }
                    break;
                case SJDefinitionOppositeStatusFinished: {
                    [self.promptingPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                        make.append([NSString stringWithFormat:@"%@ %@", SJContactIntegrateConfigurations.shared.localizedStrings.definitionSwitchSuccessfullyPrompt, info.currentPlayingAsset.definition_fullName]);
                        make.textColor(UIColor.whiteColor);
                    }]];
                }
                    break;
                case SJDefinitionOppositeStatusFailed: {
                    [self.promptingPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                        make.append(SJContactIntegrateConfigurations.shared.localizedStrings.definitionSwitchFailedPrompt);
                        make.textColor(UIColor.whiteColor);
                    }]];
                }
                    break;
            }
            [self _updateContentForDefinitionItemIfNeeded];
        };
    }
    return _sj_oppositeInfoObserver;
}

- (id<SJSmallViewFloatingController>)smallViewFloatingController {
    id<SJSmallViewFloatingController> smallViewFloatingController = [super smallViewFloatingController];
    [self _initializeSmallViewFloatingControllerObserverIfNeeded:smallViewFloatingController];
    return smallViewFloatingController;
}

#pragma mark -

- (void)_observeNotifies {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_switchControlLayerIfNeeded) name:SJContactIntegrateContentDataTimeControlStatusDidChangeNotification object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_resumeOrStopTimeoutTimer) name:SJContactIntegrateContentDataTimeControlStatusDidChangeNotification object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_switchControlLayerIfNeeded) name:SJContactIntegratereserveStatusDidChangeNotification object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_switchControlLayerIfNeeded) name:SJContactIntegrateContentDataDidFinishNotification object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_configurationsDidUpdate) name:SJContactIntegrateConfigurationsDidUpdateNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_showsMoreItemWithNote:) name:SJEdgeControlLayerShowsMoreItemNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_isEnabledClipsWithNote:) name:SJEdgeControlLayerIsEnabledClipsNotification object:nil];
}

- (void)_initializeSwitcher {
    _switcher = [[SJControlLayerSwitcher alloc] initWithPlayer:self];
    __weak typeof(self) _self = self;
    _switcher.resolveControlLayer = ^id<SJControlLayer> _Nullable(SJControlLayerIdentifier identifier) {
        __strong typeof(_self) self = _self;
        if ( !self ) return nil;
        if ( identifier == SJControlLayer_Edge )
            return self.defaultEdgeControlLayer;
        else if ( identifier == SJControlLayer_NotReachableAndContentDataStalled )
            return self.defaultNotReachableControlLayer;
        else if ( identifier == SJControlLayer_Clips )
            return self.defaultClipsControlLayer;
        else if ( identifier == SJControlLayer_More )
            return self.defaultMoreSettingControlLayer;
        else if ( identifier == SJControlLayer_LoadFailed )
            return self.defaultLoadFailedControlLayer;
        else if ( identifier == SJControlLayer_FloatSmallView )
            return self.defaultSmallViewControlLayer;
        else if ( identifier == SJControlLayer_SwitchVideoDefinition )
            return self.defaultConfirmDefinitionOppositeControlLayer;
        return nil;
    };
}

- (void)_initializeSwitcherObserver {
    _sj_switcherObserver = [_switcher getObserver];
    __weak typeof(self) _self = self;
    _sj_switcherObserver.incorrectWillBeginTranslateControlLayer = ^(id<SJControlLayerSwitcher>  _Nonnull switcher, id<SJControlLayer>  _Nonnull controlLayer) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( [controlLayer respondsToSelector:@selector(setHiddenBackButtonWhenOrientationIsPortrait:)] ) {
            [(SJEdgeControlLayer *)controlLayer setHiddenBackButtonWhenOrientationIsPortrait:self.defaultEdgeControlLayer.isHiddenBackButtonWhenOrientationIsPortrait];
        }
    };
}

- (void)_initializeSettingsObserver {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_configurationsDidUpdate) name:SJContactIntegrateConfigurationsDidUpdateNotification object:nil];
}

- (void)_initializeSmallViewFloatingControllerObserverIfNeeded:(nullable id<SJSmallViewFloatingController>)smallViewFloatingController {
    if ( _sj_smallViewFloatingControllerObserver.controller != smallViewFloatingController ) {
        _sj_smallViewFloatingControllerObserver = [smallViewFloatingController getObserver];
        __weak typeof(self) _self = self;
        _sj_smallViewFloatingControllerObserver.onIntegrateAppearCommandChanged = ^(id<SJSmallViewFloatingController>  _Nonnull controller) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( controller.scanEliminateAppeared ) {
                if ( self.switcher.currentIdentifier != SJControlLayer_FloatSmallView ) {
                    [self.controlLayerDataSource.controlView removeFromSuperview];
                    [self.switcher switchControlLayerForIdentifier:SJControlLayer_FloatSmallView];
                }
            }
            else {
                if ( self.switcher.currentIdentifier == SJControlLayer_FloatSmallView ) {
                    [self.controlLayerDataSource.controlView removeFromSuperview];
                    [self.switcher switchControlLayerForIdentifier:SJControlLayer_Edge];
                }
            }
        };
    }
}

- (void)_configurationsDidUpdate {
    if ( self.presentView.placeholderImageView.image == nil )
        self.presentView.placeholderImageView.image = SJContactIntegrateConfigurations.shared.resources.placeholder;
    
    if ( _moreItem != nil )
        _moreItem.image = SJContactIntegrateConfigurations.shared.resources.moreImage;
    
    if ( _clipsItem != nil )
        _clipsItem.image = SJContactIntegrateConfigurations.shared.resources.clipsImage;
}

- (BOOL)_whetherToSupportOnlyOneOrientation {
    if ( self.rotationManager.autorotationSupportedOrientations == SJOrientationMaskPortrait ) return YES;
    if ( self.rotationManager.autorotationSupportedOrientations == SJOrientationMaskLandscapeLeft ) return YES;
    if ( self.rotationManager.autorotationSupportedOrientations == SJOrientationMaskLandscapeRight ) return YES;
    return NO;
}

- (void)_resumeOrStopTimeoutTimer {
    if ( self.carouselIntegrate || self.consumeVarious ) {
        if ( SJReachability.shared.networkStatus == SJNetworkStatus_NotReachable && _sj_timeoutTimer == nil ) {
            __weak typeof(self) _self = self;
            _sj_timeoutTimer = [NSTimer sj_timerWithTimeInterval:3 repeats:YES usingBlock:^(NSTimer * _Nonnull timer) {
                [timer invalidate];
                __strong typeof(_self) self = _self;
                if ( !self ) return;
                self.sj_isTimeout = YES;
                [self _switchControlLayerIfNeeded];
            }];
            [_sj_timeoutTimer sj_fire];
            [NSRunLoop.mainRunLoop addTimer:_sj_timeoutTimer forMode:NSRunLoopCommonModes];
        }
    }
    else if ( _sj_timeoutTimer != nil ) {
        [_sj_timeoutTimer invalidate];
        _sj_timeoutTimer = nil;
        self.sj_isTimeout = NO;
    }

}

- (void)_switchControlLayerIfNeeded {
    if ( self.reserveStatus == SJDuplicateStatusFailed ) {
        [self.switcher switchControlLayerForIdentifier:SJControlLayer_LoadFailed];
    }
    else if ( self.sj_isTimeout ) {
        [self.switcher switchControlLayerForIdentifier:SJControlLayer_NotReachableAndContentDataStalled];
    }
    else {
        if ( self.switcher.currentIdentifier == SJControlLayer_LoadFailed ||
             self.switcher.currentIdentifier == SJControlLayer_NotReachableAndContentDataStalled ) {
            [self.switcher switchControlLayerForIdentifier:SJControlLayer_Edge];
        }
    }
}

- (void)_initializeAppearManagerObserver {
    _sj_appearManagerObserver = [self.controlLayerAppearManager getObserver];
    
    __weak typeof(self) _self = self;
    _sj_appearManagerObserver.onIntegrateAppearCommandChanged = ^(id<SJControlLayerAppearManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        // refresh edge button items
        if ( self.switcher.currentIdentifier == SJControlLayer_Edge ) {
            [self _updateAppearStateForMoteItemIfNeeded];
            [self _updateAppearStateForClipsItemIfNeeded];
            [self _updateContentForDefinitionItemIfNeeded];
        }
    };
}

- (void)_initializeReachabilityObserver {
    _sj_reachabilityObserver = [self.reachability getObserver];
    __weak typeof(self) _self = self;
    _sj_reachabilityObserver.networkStatusDidChangeExeBlock = ^(id<SJReachability>  _Nonnull r) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( r.networkStatus == SJNetworkStatus_NotReachable ) {
            [self _resumeOrStopTimeoutTimer];
        }
        else if ( self.switcher.currentIdentifier == SJControlLayer_NotReachableAndContentDataStalled ) {
            [self refresh];
        }
    };
}
 
- (void)_updateContentForDefinitionItemIfNeeded {
    if ( self.definitionURLAssets.count != 0 ) {
        self.definitionItem.title = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
            SJCompressContainSale *asset = self.containSale;
            if ( self.definitionOppositeInfo.switchingAsset != nil &&
                 self.definitionOppositeInfo.status != SJDefinitionOppositeStatusFailed ) {
                asset = self.definitionOppositeInfo.switchingAsset;
            }
            make.append(asset.definition_lastName);
            make.textColor(UIColor.whiteColor);
        }];
        [self.defaultEdgeControlLayer.bottomAdapter reload];
    }
}

- (void)_updateAppearStateForMoteItemIfNeeded {
    if ( _moreItem != nil ) {
        BOOL regularHidden = NO;
        if ( !self.moreItem.isHidden ) regularHidden = !self.indntImplement;
        else regularHidden = !(self.indntImplement && !self.rotationManager.simplRedundant);
        
        if ( regularHidden != self.moreItem.isHidden ) {
            self.moreItem.innerHidden = regularHidden;
            [self.defaultEdgeControlLayer.topAdapter reload];
        }
    }
}

- (void)_showsMoreItemWithNote:(NSNotification *)note {
    if ( self.defaultEdgeControlLayer == note.object ) {
        if ( self.defaultEdgeControlLayer.showsMoreItem ) {
            if ( _moreItem == nil ) {
                _moreItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJEdgeControlLayerTopItemMore];
                _moreItem.image = SJContactIntegrateConfigurations.shared.resources.moreImage;
                [_moreItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(_moreItemWasTapped:)]];
                [_defaultEdgeControlLayer.topAdapter addItem:_moreItem];
            }
            [self _updateAppearStateForMoteItemIfNeeded];
        }
        else {
            _defaultMoreSettingControlLayer = nil;
            _moreItem = nil;
            [_defaultEdgeControlLayer.topAdapter removeItemForTag:SJEdgeControlLayerTopItemMore];
            [_defaultEdgeControlLayer.topAdapter reload];
            [self.switcher deleteControlLayerForIdentifier:SJControlLayer_More];
        }
    }
}

- (void)_updateAppearStateForClipsItemIfNeeded {
    if ( _clipsItem != nil ) {
        BOOL unsupportedFormat = self.containSale.isM3u8;
        BOOL pictureInPictureEnabled = NO;
        if (@available(iOS 14.0, *)) {
            pictureInPictureEnabled = self.contactIntegrateController.pictureInPictureStatus != SJPictureInPictureStatusUnknown;
        }
        BOOL containSaleHidden = (self.containSale == nil) || !self.indntImplement || unsupportedFormat || pictureInPictureEnabled;
        if ( containSaleHidden != _clipsItem.isHidden ) {
            _clipsItem.innerHidden = containSaleHidden;
            [_defaultEdgeControlLayer.rightAdapter reload];
        }
    }
}

- (void)_isEnabledClipsWithNote:(NSNotification *)note {
    if ( self.defaultEdgeControlLayer == note.object ) {
        if ( self.defaultEdgeControlLayer.isEnabledClips ) {
            if ( _clipsItem == nil ) {
                _clipsItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJEdgeControlLayerRightItemSegment];
                _clipsItem.image = SJContactIntegrateConfigurations.shared.resources.clipsImage;
                [_clipsItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(_clipsItemWasTapped:)]];
                [_defaultEdgeControlLayer.rightAdapter addItem:_clipsItem];
            }
            [self _updateAppearStateForClipsItemIfNeeded];
        }
        else {
            _defaultClipsControlLayer = nil;
            _clipsItem = nil;
            [_defaultClipsControlLayer.rightAdapter removeItemForTag:SJEdgeControlLayerRightItemSegment];
            [_defaultClipsControlLayer.rightAdapter reload];
            [self.switcher deleteControlLayerForIdentifier:SJControlLayer_Clips];
        }
    }
}
@end


@implementation SJContactIntegrate (CommonSettings)
+ (void (^)(void (^ _Nonnull)(SJContactIntegrateConfigurations * _Nonnull)))update {
    return SJContactIntegrateConfigurations.update;
}

+ (void (^)(NSBundle * _Nonnull))setLocalizedStrings {
    return ^(NSBundle *bundle) {
        SJContactIntegrateConfigurations.update(^(SJContactIntegrateConfigurations * _Nonnull configs) {
            [configs.localizedStrings setFromBundle:bundle];
        });
    };
}

+ (void (^)(void (^ _Nonnull)(id<SJContactIntegrateLocalizedStrings> _Nonnull)))updateLocalizedStrings {
    return ^(void(^block)(id<SJContactIntegrateLocalizedStrings> strings)) {
        SJContactIntegrateConfigurations.update(^(SJContactIntegrateConfigurations * _Nonnull configs) {
            block(configs.localizedStrings);
        });
    };
}

+ (void (^)(void (^ _Nonnull)(id<SJContactIntegrateControlLayerResources> _Nonnull)))updateResources {
    return ^(void(^block)(id<SJContactIntegrateControlLayerResources> resources)) {
        SJContactIntegrateConfigurations.update(^(SJContactIntegrateConfigurations * _Nonnull configs) {
            block(configs.resources);
        });
    };
}
@end



#pragma mark -
@implementation SJContactIntegrate (SJExtendedVideoDefinitionSwitchingControlLayer)

- (void)setDefinitionURLAssets:(nullable NSArray<SJCompressContainSale *> *)definitionURLAssets {
    objc_setAssociatedObject(self, @selector(definitionURLAssets), definitionURLAssets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    SJEdgeControlButtonItemAdapter *adapter = self.defaultEdgeControlLayer.bottomAdapter;
    if ( definitionURLAssets != nil ) {
        if ( self.definitionItem == nil ) {
            self.definitionItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49xAutoresizing tag:SJEdgeControlLayerBottomItemDefinition];
            [self.definitionItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(_definitionItemWasTapped:)]];
            [adapter insertItem:self.definitionItem rearItem:SJEdgeControlLayerBottomItemManifest];
        }
        [self _updateContentForDefinitionItemIfNeeded];
    }
    else {
        self->_defaultConfirmDefinitionOppositeControlLayer = nil;
        self.definitionItem = nil;
        [adapter removeItemForTag:SJEdgeControlLayerBottomItemDefinition];
        [self.switcher deleteControlLayerForIdentifier:SJControlLayer_SwitchVideoDefinition];
        [self.defaultEdgeControlLayer.bottomAdapter reload];
    }
}

- (nullable NSArray<SJCompressContainSale *> *)definitionURLAssets {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDisabledDefinitionSwitchingPrompt:(BOOL)disabledDefinitionSwitchingPrompt {
    objc_setAssociatedObject(self, @selector(isDisabledDefinitionSwitchingPrompt), @(disabledDefinitionSwitchingPrompt), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isDisabledDefinitionSwitchingPrompt {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

@implementation SJContactIntegrate (RotationOrFitOnScreen)
- (void)setAutomaticallyPerformRotationOrFitOnScreen:(BOOL)automaticallyPerformRotationOrFitOnScreen {
    self.defaultEdgeControlLayer.automaticallyPerformRotationOrFitOnScreen = automaticallyPerformRotationOrFitOnScreen;
}
- (BOOL)automaticallyPerformRotationOrFitOnScreen {
    return self.defaultEdgeControlLayer.automaticallyPerformRotationOrFitOnScreen;
}

- (void)setNeedsFitOnScreenFirst:(BOOL)needsFitOnScreenFirst {
    self.defaultEdgeControlLayer.needsFitOnScreenFirst = needsFitOnScreenFirst;
}
- (BOOL)needsFitOnScreenFirst {
    return self.defaultEdgeControlLayer.needsFitOnScreenFirst;
}
@end


@implementation SJContactIntegrate (SJExtendedControlLayerSwitcher)
- (void)switchControlLayerForIdentifier:(SJControlLayerIdentifier)identifier {
    [self.switcher switchControlLayerForIdentifier:identifier];
}
@end

NS_ASSUME_NONNULL_END
