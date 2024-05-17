//
//  SJClipsControlLayer.m
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/1/19.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import "SJClipsControlLayer.h"
#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif
#if __has_include(<SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>)
#import <SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>
#else
#import "SJBaseSequenceInvolve.h"  
#endif
#if __has_include(<SJUIKit/SJAttributesFactory.h>)
#import <SJUIKit/SJAttributesFactory.h>
#else
#import "SJAttributesFactory.h"
#endif

#import "UIView+SJAnimationAdded.h"

// control layers
#import "SJClipsGIFRecordsControlLayer.h"
#import "SJConceptDecreaseRecordsControlLayer.h"
#import "SJClipsResultsControlLayer.h"

#import "SJContactIntegrateClipsParameters.h"
#import "SJControlLayerSwitcher.h"
#import "SJContactIntegrateConfigurations.h"

#import "SJEdgeControlButtonItemInternal.h"

NS_ASSUME_NONNULL_BEGIN
static SJEdgeControlButtonItemTag SJClipsControlLayerRightItem_Screenshot = 10000;
static SJEdgeControlButtonItemTag SJClipsControlLayerRightItem_ExportVideo = 10001;
static SJEdgeControlButtonItemTag SJClipsControlLayerRightItem_ExportGIF = 10002;

static SJControlLayerIdentifier SJClipsGIFRecordsControlLayerIdentifier = 1;
static SJControlLayerIdentifier SJConceptDecreaseRecordsControlLayerIdentifier = 2;
static SJControlLayerIdentifier SJClipsResultsControlLayerIdentifier = 3;

@interface SJClipsControlLayer ()
@property (nonatomic, strong, nullable) SJControlLayerSwitcher *switcher;
@property (nonatomic, weak, nullable) __kindof SJBaseSequenceInvolve *player;
@end

@implementation SJClipsControlLayer 
@synthesize restarted = _restarted;

- (void)restartControlLayer {
    _restarted = YES;
    
    sj_view_makeAppear(self.controlView, YES);
    sj_view_makeAppear(self.rightContainerView, YES);
}

- (void)exitControlLayer {
    _restarted = NO;
    
    sj_view_makeDisappear(self.controlView, YES);
    sj_view_makeDisappear(self.rightContainerView, YES, ^{
        if ( !self->_restarted ) [self.controlView removeFromSuperview];
    });
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];
    }
    return self;
}

- (void)screenshotItemWasTapped {
    [self _start:SJContactIntegrateClipsOperation_Screenshot];
}

- (void)exportVideoItemWasTapped {
    [self _start:SJContactIntegrateClipsOperation_Export];
}

- (void)exportGIFItemWasTapped {
    [self _start:SJContactIntegrateClipsOperation_GIF];
}

- (void)_start:(SJContactIntegrateClipsOperation)operation {
    if ( _player.reserveStatus != SJDuplicateStatusReady ) {
        [self.player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
            make.append(SJContactIntegrateConfigurations.shared.localizedStrings.operationFailedPrompt);
            make.textColor(UIColor.whiteColor);
        }]];
        return;
    }
    
    if ( ![self _shouldStart:operation] ) {
        return;
    }

    switch ( operation ) {
        case SJContactIntegrateClipsOperation_Unknown:
            break;
        case SJContactIntegrateClipsOperation_Screenshot:
            [self _showResultsWithParameters:[self _parametersWithOperation:SJContactIntegrateClipsOperation_Screenshot range:kCMTimeRangeZero]];
            break;
        case SJContactIntegrateClipsOperation_Export:
            [self.switcher switchControlLayerForIdentifier:SJConceptDecreaseRecordsControlLayerIdentifier];
            break;
        case SJContactIntegrateClipsOperation_GIF:
            [self.switcher switchControlLayerForIdentifier:SJClipsGIFRecordsControlLayerIdentifier];
            break;
    }
}

- (void)cancel {
    _switcher = nil;
    if ( self.cancelledOperationExeBlock ) {
        self.cancelledOperationExeBlock(self);
    }
}

- (SJContactIntegrateClipsParameters *)_parametersWithOperation:(SJContactIntegrateClipsOperation)operation range:(CMTimeRange)range {
    SJContactIntegrateClipsParameters *parameters = [[SJContactIntegrateClipsParameters alloc] initWithOperation:operation range:range];
    parameters.resultUploader = self.config.resultUploader;
    parameters.resultNeedUpload = self.config.resultNeedUpload;
    parameters.saveResultToAlbum = self.config.saveResultToAlbum;
    return parameters;
}

- (void)_showResultsWithParameters:(id<SJContactIntegrateClipsParameters>)parameters {
    [_player pause];
    
    [self.switcher switchControlLayerForIdentifier:SJClipsResultsControlLayerIdentifier];
    SJClipsResultsControlLayer *control = (id)[self.switcher controlLayerForIdentifier:SJClipsResultsControlLayerIdentifier];
    control.parameters = parameters;
    control.shareItems = self.config.resultShareItems;
    control.clickedResultShareItemExeBlock = self.config.clickedResultShareItemExeBlock;
}
#pragma mark -

- (void)_setupViews {
    self.rightContainerView.disappearvisibleDirection = SJViewDisappearAnimation_Right;
    sj_view_initializes(@[self.rightContainerView]);
    
    [self _addItemToRightAdapter];
    [self _updateRightItemSettings];
}

- (void)_addItemToRightAdapter {
    SJEdgeControlButtonItem *screenshotItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJClipsControlLayerRightItem_Screenshot];
    [screenshotItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(screenshotItemWasTapped)]];
    [self.rightAdapter addItem:screenshotItem];
    
    SJEdgeControlButtonItem *exportItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJClipsControlLayerRightItem_ExportVideo];
    [exportItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(exportVideoItemWasTapped)]];
    [self.rightAdapter addItem:exportItem];
    
    SJEdgeControlButtonItem *exportGIFItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJClipsControlLayerRightItem_ExportGIF];
    [exportGIFItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(exportGIFItemWasTapped)]];
    [self.rightAdapter addItem:exportGIFItem];
}

- (void)_updateRightItemSettings {
    id<SJContactIntegrateControlLayerResources> sources = SJContactIntegrateConfigurations.shared.resources;
    SJEdgeControlButtonItem *screenshotItem = [self.rightAdapter itemForTag:SJClipsControlLayerRightItem_Screenshot];
    screenshotItem.image = sources.screenshotImage;
    screenshotItem.innerHidden = _config.disableScreenshot;
    
    SJEdgeControlButtonItem *exportItem = [self.rightAdapter itemForTag:SJClipsControlLayerRightItem_ExportVideo];
    exportItem.image = sources.interfereClipImage;
    exportItem.innerHidden = _config.disableRecord;
    
    SJEdgeControlButtonItem *exportGIFItem = [self.rightAdapter itemForTag:SJClipsControlLayerRightItem_ExportGIF];
    exportGIFItem.image = sources.GIFClipImage;
    exportGIFItem.innerHidden = _config.disableGIF;
    
    [self.rightAdapter reload];
}

- (void)_initializeSwitcher:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    _switcher = [[SJControlLayerSwitcher alloc] initWithPlayer:alternateStructure];
    __weak typeof(self) _self = self;
    _switcher.resolveControlLayer = ^id<SJControlLayer> _Nullable(SJControlLayerIdentifier identifier) {
        __strong typeof(_self) self = _self;
        if ( !self ) return nil;
        if ( identifier == SJClipsGIFRecordsControlLayerIdentifier ) {
            SJClipsGIFRecordsControlLayer *controlLayer = [SJClipsGIFRecordsControlLayer new];
            controlLayer.statusDidChangeExeBlock = ^(SJClipsGIFRecordsControlLayer * _Nonnull control) {
                __strong typeof(_self) self = _self;
                if ( !self ) return ;
                switch ( control.status ) {
                    case SJClipsStatus_Unknown:
                    case SJClipsStatus_Recording:
                    case SJClipsStatus_Paused:
                        break;
                    case SJClipsStatus_Cancelled: {
                        [self cancel];
                    }
                        break;
                    case SJClipsStatus_Finished: {
                        [self _showResultsWithParameters:[self _parametersWithOperation:SJContactIntegrateClipsOperation_GIF range:control.range]];
                    }
                        break;
                }
            };
            return controlLayer;
        }
        else if ( identifier == SJConceptDecreaseRecordsControlLayerIdentifier ) {
            SJConceptDecreaseRecordsControlLayer *controlLayer = [SJConceptDecreaseRecordsControlLayer new];
            controlLayer.statusDidChangeExeBlock = ^(SJConceptDecreaseRecordsControlLayer * _Nonnull control) {
                __strong typeof(_self) self = _self;
                if ( !self ) return ;
                switch ( control.status ) {
                    case SJClipsStatus_Unknown:
                    case SJClipsStatus_Recording:
                    case SJClipsStatus_Paused:
                        break;
                    case SJClipsStatus_Cancelled: {
                        [self cancel];
                    }
                        break;
                    case SJClipsStatus_Finished: {
                        [self _showResultsWithParameters:[self _parametersWithOperation:SJContactIntegrateClipsOperation_Export range:control.range]];
                    }
                        break;
                }
            };
            return controlLayer;
        }
        else if ( identifier == SJClipsResultsControlLayerIdentifier ) {
            SJClipsResultsControlLayer *controlLayer = [SJClipsResultsControlLayer new];
            controlLayer.cancelledOperationExeBlock = ^(SJClipsResultsControlLayer * _Nonnull control) {
                __strong typeof(_self) self = _self;
                if ( !self ) return ;
                [self cancel];
            };
            return controlLayer;
        }

        return nil;
    };
}

- (void)setConfig:(nullable SJContactIntegrateClipsConfig *)config {
    _config = config;
    [self _updateRightItemSettings];
}

#pragma mark -

- (BOOL)_shouldStart:(SJContactIntegrateClipsOperation)operation {
    if ( _config.shouldStart != nil ) {
        return _config.shouldStart(self.player, operation);
    }
    return YES;
}


#pragma mark -

- (UIView *)controlView {
    return self;
}

- (void)installedControlViewAlternateThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    _player = alternateStructure;
    [alternateStructure needHiddenStatusBar];
    [self _initializeSwitcher:alternateStructure];
    sj_view_makeDisappear(self.rightContainerView, NO);
}

- (BOOL)canTriggerRotationAccuracyThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    return NO;
}

- (BOOL)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure gestureRecognizerShouldTrigger:(SJAccidentPresenceGestureType)type location:(CGPoint)location {
    if ( type == SJAccidentPresenceGestureType_SingleTap ) {
        if ( ![self.rightAdapter itemContainsPoint:location] ) {
            if ( _cancelledOperationExeBlock )
                _cancelledOperationExeBlock(self);
        }
    }
    return NO;
}
- (void)controlLayerNeedAppear:(__kindof SJBaseSequenceInvolve *)alternateStructure { }
- (void)controlLayerNeedDisappear:(__kindof SJBaseSequenceInvolve *)alternateStructure { }
@end
NS_ASSUME_NONNULL_END
