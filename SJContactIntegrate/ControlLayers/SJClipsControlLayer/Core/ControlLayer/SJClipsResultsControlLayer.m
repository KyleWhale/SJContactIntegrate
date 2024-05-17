//
//  SJClipsResultsControlLayer.m
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/1/20.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import "SJClipsResultsControlLayer.h"
#import "UIView+SJAnimationAdded.h"
#import "SJClipsBackButton.h"
#import "SJClipsButtonContainerView.h"
#import "SJClipsResultShareItem.h"
#import "SJClipsResultShareItemsContainerView.h"
#import "SJContactIntegrateClipsGeneratedResult.h"
#import "SJClipsSaveResultToAlbumHandler.h"
#import "SJContactIntegrateConfigurations.h"

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

NS_ASSUME_NONNULL_BEGIN
static SJEdgeControlButtonItemTag SJTopItem_Back = 1;

@interface SJClipsResultsControlLayer ()
@property (nonatomic, weak, nullable) __kindof SJBaseSequenceInvolve *player;
@property (nonatomic, strong, readonly) SJClipsSaveResultToAlbumHandler *saveHandler;
@property (nonatomic, strong, readonly) SJClipsButtonContainerView *backButtonContainerView;
@property (nonatomic, strong, readonly) SJClipsResultShareItemsContainerView *itemsContainerView;

@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@property (nonatomic, strong, nullable) SJContactIntegrateClipsGeneratedResult *result;
@property (nonatomic, strong, readonly) SJBaseSequenceInvolve *exportedIncorrectSubscript;
@property (nonatomic, strong, readonly) UIView *flashingView;
@end

@implementation SJClipsResultsControlLayer {
    BOOL _needDelay;
}
@synthesize restarted = _restarted;

- (void)restartControlLayer {
    _restarted = YES;
    self.flashingView.alpha = 0.001;
    self.itemsContainerView.alpha = 0.001;
    self.flashingView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.coverImageView.alpha = 0.001;
    sj_view_makeAppear(self.controlView, YES);
    __weak typeof(self) _self = self;
    [self _getScreenshot:^(UIImage * _Nullable img) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self.coverImageView.image = img;
        [UIView animateWithDuration:0 animations:^{} completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.flashingView.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.flashingView.alpha = 0.001;
                    self.coverImageView.alpha = 1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.itemsContainerView.alpha = 1;
                    }];
                    
                    sj_view_makeAppear(self.topContainerView, YES);
                    [self.flashingView removeFromSuperview];
                    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
                    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
                    CGFloat min = MIN(screenWidth, screenHeight);
                    CGFloat max = MAX(screenWidth, screenHeight);
                    
                    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.offset(0);
                        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.82);
                        make.width.equalTo(self).multipliedBy(0.4);
                        make.height.equalTo(self.coverImageView.mas_width).multipliedBy(min/max);
                    }];
                    
                    CGFloat scale = img?(self.coverImageView.image.size.width / self.coverImageView.image.size.height):0;
                    CGFloat maxW = self.bounds.size.width * 0.4;
                    CGFloat showH = maxW * min / max;
                    CGFloat showW = showH * scale;
                    CGFloat rightMargin = floor((maxW - showW) * 0.5);
                    [self.promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.offset(-8);
                        make.right.offset(-(rightMargin + 8));
                    }];
                    
                    [UIView animateWithDuration:0.6 animations:^{
                        [self layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        [self _results];
                    }];
                }];
            }];
        }];
    }];
}

- (void)_getScreenshot:(void(^)(UIImage *_Nullable img))block {
    if ( [self.player.assetURL isFileURL] ) {
        if ( block ) block(self.player.screenshot);
    }
    else {
        [self.player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
            make.append(@"...");
            make.textColor(UIColor.whiteColor);
        }] duration:-1];
        __weak typeof(self) _self = self;
        [self.player screenshotWithTime:self.player.contentTime completion:^(__kindof SJBaseSequenceInvolve * _Nonnull alternateStructure, UIImage * _Nullable image, NSError * _Nullable error) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            [alternateStructure.textPopupController hidden];
            if ( block ) block(image);
        }];
    }
}

- (void)exitControlLayer {
    _restarted = NO;
    sj_view_makeDisappear(self.topContainerView, YES);
    sj_view_makeDisappear(self.controlView, YES, ^{
        if ( !self->_restarted ) {
            [self.controlView removeFromSuperview];
            [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
        }
    });
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { 
        [self _setupViews];
    }
    return self;
}

- (void)setShareItems:(nullable NSArray<SJClipsResultShareItem *> *)shareItems {
    _itemsContainerView.shareItems = shareItems;
}

- (nullable NSArray<SJClipsResultShareItem *> *)shareItems {
    return _itemsContainerView.shareItems;
}

- (void)_results {
    _result = [[SJContactIntegrateClipsGeneratedResult alloc] init];
    
    __weak typeof(self) _self = self;
    _result.exportProgressDidChangeExeBlock = ^(SJContactIntegrateClipsGeneratedResult * _Nonnull result) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;
        [self _updatePromptLabelText:[NSString stringWithFormat:@"%@ %.0f%%", strings.exportsExportingPrompt, result.exportProgress * 100]];
    };
    
    _result.exportStateDidChangeExeBlock = ^(SJContactIntegrateClipsGeneratedResult * _Nonnull result) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;
        [self _updateTopItemSettings];
        switch ( result.exportState ) {
            case SJClipsExportStateUnknown:
            case SJClipsExportStateCancelled:
            case SJClipsExportStateExporting:
                break;
            case SJClipsExportStateFailed: {
                [self _updatePromptLabelText:strings.exportsExportFailedPrompt];
            }
                break;
            case SJClipsExportStateSuccess: {
                if ( result.operation == SJContactIntegrateClipsOperation_Screenshot ) {
                    [self _updatePromptLabelText:strings.screenshotSuccessfullyPrompt];
                }
                else {
                    [self _updatePromptLabelText:strings.exportsExportSuccessfullyPrompt];
                }
                
                switch ( result.operation ) {
                    case SJContactIntegrateClipsOperation_Unknown:
                    case SJContactIntegrateClipsOperation_Screenshot:
                        break;
                    case SJContactIntegrateClipsOperation_Export: {
                        self.exportedIncorrectSubscript.assetURL = self.result.fileURL;
                        [self.coverImageView insertSubview:self.exportedIncorrectSubscript.view belowSubview:self.promptLabel];
                        self.exportedIncorrectSubscript.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                        self.exportedIncorrectSubscript.view.frame = self.coverImageView.bounds;
                    }
                        break;
                    case SJContactIntegrateClipsOperation_GIF: {
                        self.coverImageView.image = self.result.image;
                    }
                        break;
                }
                
                 [self _uploadResultIfNeeded];
                
                if ( self.parameters.saveResultToAlbum ) {
                    [self.player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                        make.append(strings.albumSavingScreenshotToAlbumPrompt);
                        make.textColor(UIColor.whiteColor);
                    }] duration:-1];
                    [self.saveHandler saveResult:result completionHandler:^(BOOL r, id<SJClipsSaveResultFailed>  _Nonnull failed) {
                        __strong typeof(_self) self = _self;
                        if ( !self ) return ;
                        if ( r ) {
                            [self.player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                                make.append(strings.albumSavedToAlbumPrompt);
                                make.textColor(UIColor.whiteColor);
                            }]];
                            if ( !self.parameters.resultNeedUpload ) {
                                [self _updatePromptLabelText:strings.albumSavedToAlbumPrompt];
                            }
                        }
                        else {
                            [self.player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                                make.append(failed.toString);
                                make.textColor(UIColor.whiteColor);
                            }]];
                            if ( !self.parameters.resultNeedUpload ) {
                                [self _updatePromptLabelText:strings.albumAuthDeniedPrompt];
                            }
                        }
                        
                    }];
                }
            }
                break;
        }
    };
    
    _result.uploadProgressDidChangeExeBlock = ^(SJContactIntegrateClipsGeneratedResult * _Nonnull result) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;
        [self _updatePromptLabelText:[NSString stringWithFormat:@"%@ %.0f%%", strings.uploadsUploadingPrompt, result.uploadProgress * 100]];
    };
    
    _result.uploadStateDidChangeExeBlock = ^(SJContactIntegrateClipsGeneratedResult * _Nonnull result) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;
        switch ( result.uploadState ) {
            case SJClipsResultUploadStateUnknown:
            case SJClipsResultUploadStateUploading:
            case SJClipsResultUploadStateCancelled:
                break;
            case SJClipsResultUploadStateFailed: {
                [self _updatePromptLabelText:strings.uploadsUploadFailedPrompt];
            }
                break;
            case SJClipsResultUploadStateSuccessfully: {
                [self _updatePromptLabelText:strings.uploadsUploadSuccessfullyPrompt];
            }
                break;
        }
    };
    
    switch ( _parameters.operation ) {
        case SJContactIntegrateClipsOperation_Unknown:
            return;
        case SJContactIntegrateClipsOperation_Screenshot: {
            [self _generateScreenshot];
        }
            break;
        case SJContactIntegrateClipsOperation_Export: {
            [self _generateVideo];
        }
            break;
        case SJContactIntegrateClipsOperation_GIF: {
            [self _generateGIF];
        }
            break;
    }
}

- (void)_generateScreenshot {
    _result.operation = SJContactIntegrateClipsOperation_Screenshot;
    _result.thumbnailImage = _result.image = _coverImageView.image;
    _result.exportState = _coverImageView.image?SJClipsExportStateSuccess:SJClipsExportStateFailed;
}

- (void)_generateVideo {
    _result.operation = SJContactIntegrateClipsOperation_Export;
    _result.exportState = SJClipsExportStateExporting;
    _result.exportProgress = 0.001;
    
    NSTimeInterval begin = CMTimeGetSeconds(_parameters.range.start);
    NSTimeInterval duration = CMTimeGetSeconds(_parameters.range.duration);
    __weak typeof(self) _self = self;
    [_player exportWithBeginTime:begin duration:duration presetName:nil progress:^(__kindof SJBaseSequenceInvolve * _Nonnull alternateStructure, float progress) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.exportProgress = progress;
    } completion:^(__kindof SJBaseSequenceInvolve * _Nonnull alternateStructure, NSURL * _Nonnull fileURL, UIImage * _Nonnull thumbnailImage) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.thumbnailImage = thumbnailImage;
        self.result.fileURL = fileURL;
        self.result.exportProgress = 1;
        self.result.exportState = SJClipsExportStateSuccess;
    } failure:^(__kindof SJBaseSequenceInvolve * _Nonnull alternateStructure, NSError * _Nonnull error) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.exportState = SJClipsExportStateFailed;
    }];
}

- (void)_generateGIF {
    _result.operation = SJContactIntegrateClipsOperation_GIF;
    _result.exportState = SJClipsExportStateExporting;
    _result.exportProgress = 0.001;
    
    NSTimeInterval begin = CMTimeGetSeconds(_parameters.range.start);
    NSTimeInterval duration = CMTimeGetSeconds(_parameters.range.duration);
    __weak typeof(self) _self = self;
    [_player generateGIFWithBeginTime:begin duration:duration progress:^(__kindof SJBaseSequenceInvolve * _Nonnull alternateStructure, float progress) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.exportProgress = progress;
    } completion:^(__kindof SJBaseSequenceInvolve * _Nonnull alternateStructure, UIImage * _Nonnull imageGIF, UIImage * _Nonnull thumbnailImage, NSURL * _Nonnull filePath) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.image = imageGIF;
        self.result.thumbnailImage = thumbnailImage;
        self.result.fileURL = filePath;
        self.result.exportProgress = 1;
        self.result.exportState = SJClipsExportStateSuccess;
    } failure:^(__kindof SJBaseSequenceInvolve * _Nonnull alternateStructure, NSError * _Nonnull error) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.exportState = SJClipsExportStateFailed;
    }];
}

- (void)_uploadResultIfNeeded {
    if ( !_parameters.resultNeedUpload ) {
        return;
    }
    
    if ( !_parameters.resultUploader ) {
        return;
    }
    
    self.result.uploadState = SJClipsResultUploadStateUploading;
    
    __weak typeof(self) _self = self;
    [_parameters.resultUploader upload:_result progress:^(float progress) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.uploadProgress = progress;
    } success:^{
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.uploadState = SJClipsResultUploadStateSuccessfully;
    } failure:^(NSError * _Nonnull error) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self.result.uploadState = SJClipsResultUploadStateFailed;
    }];
}

- (void)_updatePromptLabelText:(NSString *)text {
    _promptLabel.attributedText = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.font([UIFont systemFontOfSize:12]).textColor([UIColor whiteColor]);
        make.append(text);
        make.shadow(^(NSShadow * _Nonnull make) {
            make.shadowColor = UIColor.blackColor;
            make.shadowOffset = CGSizeMake(0, 0.5);
        });
    }];
}

- (void)_cancel {
    if ( self.result.exportState == SJClipsExportStateExporting ) {
        [_player cancelExportOperation];
        [_player cancelGenerateGIFOperation];
    }
    
    if ( self.result.uploadState == SJClipsResultUploadStateUploading ) {
        [self.parameters.resultUploader cancelUpload:self.result];
    }
    
    if ( self.cancelledOperationExeBlock )
        self.cancelledOperationExeBlock(self);
}

- (void)_handleClickedShareItemEvent:(SJClipsResultShareItem *)item {
    if ( _needDelay )
        return;
    _needDelay = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_needDelay = NO;
    });
    
    if ( !self.clickedResultShareItemExeBlock ) {
        return;
    }
    
    id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;

    // export
    switch ( self.result.exportState ) {
        case SJClipsExportStateSuccess: break;
            
        case SJClipsExportStateUnknown:
        case SJClipsExportStateCancelled: return;
        case SJClipsExportStateFailed: {
            [_player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.append(strings.exportsExportFailedPrompt);
                make.textColor(UIColor.whiteColor);
            }]];
        }
            return;
            
        case SJClipsExportStateExporting: {
            [_player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.append(strings.exportsExportingPrompt);
                make.textColor(UIColor.whiteColor);
            }]];
        }
            return;
    }
    
    if ( !self.parameters.resultNeedUpload || item.canAlsoClickedWhenUploading ) {
        self.clickedResultShareItemExeBlock(self.player, item, self.result);
        return;
    }
    
    // upload
    switch ( self.result.uploadState ) {
        case SJClipsResultUploadStateUnknown: break;
        case SJClipsResultUploadStateCancelled: break;
        case SJClipsResultUploadStateFailed: {
            [_player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.append(strings.uploadsUploadFailedPrompt);
                make.textColor(UIColor.whiteColor);
            }]];
        }
            break;
        case SJClipsResultUploadStateSuccessfully: {
            self.clickedResultShareItemExeBlock(self.player, item, self.result);
        }
            break;
        case SJClipsResultUploadStateUploading: {
            [_player.textPopupController show:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
                make.append(strings.uploadsUploadingPrompt);
                make.textColor(UIColor.whiteColor);
            }]];
        }
            break;
    }
}

#pragma mark -

- (void)_setupViews {
    self.autoAdjustTopSpacing = NO;
    self.topMargin = 20;
    self.topHeight = 35;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [self _addItemToTopAdapter];
    [self _updateTopItemSettings];
        
    _coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self insertSubview:_coverImageView atIndex:0];
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    _itemsContainerView = [[SJClipsResultShareItemsContainerView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) _self = self;
    _itemsContainerView.clickedShareItemExeBlock = ^(SJClipsResultShareItemsContainerView * _Nonnull view, SJClipsResultShareItem * _Nonnull item) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [self _handleClickedShareItemEvent:item];
    };
    [self addSubview:_itemsContainerView];
    [_itemsContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.coverImageView.mas_bottom);
        make.bottom.equalTo(self);
    }];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_coverImageView addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-8);
    }];
    
    _flashingView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_flashingView];
    [_flashingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)_addItemToTopAdapter {
    self.topContainerView.disappearvisibleDirection = SJViewDisappearAnimation_Top;
    [self.topContainerView cleanColors];
    sj_view_initializes(self.topContainerView);
    CGFloat buttonH = self.topHeight;
    CGFloat buttonW = ceil(buttonH * 2.8);
    _backButtonContainerView = [[SJClipsButtonContainerView alloc] initWithFrame:CGRectZero buttonSize:CGSizeMake(buttonW, buttonH)];
    _backButtonContainerView.frame = CGRectMake(0, 0, buttonW, buttonH);
    __weak typeof(self) _self = self;
    _backButtonContainerView.clickedBackButtonExeBlock = ^(SJClipsButtonContainerView * _Nonnull view) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [self _cancel];
    };
    
    SJEdgeControlButtonItem *backItem = [[SJEdgeControlButtonItem alloc] initWithTag:SJTopItem_Back];
    backItem.insets = SJEdgeInsetsMake(self.topMargin, 0);
    backItem.customView = _backButtonContainerView;
    [self.topAdapter addItem:backItem];
}

- (void)_updateTopItemSettings {
    id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;
    SJClipsBackButton *backButton = _backButtonContainerView.button;
    if ( _result.exportState != SJClipsExportStateSuccess ) {
        [backButton setTitle:strings.cancel forState:UIControlStateNormal];
    }
    else {
        [backButton setTitle:strings.done forState:UIControlStateNormal];
    }
    [self.topAdapter reload];
}

#pragma mark -

@synthesize exportedIncorrectSubscript = _exportedIncorrectSubscript;
- (SJBaseSequenceInvolve *)exportedIncorrectSubscript {
    if ( _exportedIncorrectSubscript ) return _exportedIncorrectSubscript;
    _exportedIncorrectSubscript = [SJBaseSequenceInvolve inverseElement];
    _exportedIncorrectSubscript.pausedInBackground = YES;
    _exportedIncorrectSubscript.resumeContentDataWhenAppDidEnterForeground = YES;
    _exportedIncorrectSubscript.view.backgroundColor = [UIColor clearColor];
    for ( UIView *view in _exportedIncorrectSubscript.view.subviews ) {
        view.backgroundColor = [UIColor clearColor];
    }
    _exportedIncorrectSubscript.gestureController.supportedGestureTypes = SJAccidentPresenceGestureTypeMask_None;
    _exportedIncorrectSubscript.rotationManager.disabledAutorotation = YES;
    _exportedIncorrectSubscript.smplProvide.contentDataDidFinishExeBlock = ^(SJBaseSequenceInvolve * _Nonnull player) {
        [player replay];
    };
    return _exportedIncorrectSubscript;
}

@synthesize saveHandler = _saveHandler;
- (SJClipsSaveResultToAlbumHandler *)saveHandler {
    if ( _saveHandler ) return _saveHandler;
    return _saveHandler = [SJClipsSaveResultToAlbumHandler new];
}
#pragma mark -

- (UIView *)controlView {
    return self;
}

- (void)installedControlViewAlternateThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    _player = alternateStructure;
    [alternateStructure needHiddenStatusBar];
    sj_view_makeDisappear(self.topContainerView, NO);
}

- (BOOL)canTriggerRotationAccuracyThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    return NO;
}

- (BOOL)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure gestureRecognizerShouldTrigger:(SJAccidentPresenceGestureType)type location:(CGPoint)location {
    return NO;
}

- (BOOL)canPerformAccuracyForThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    return NO;
}
- (void)controlLayerNeedAppear:(__kindof SJBaseSequenceInvolve *)alternateStructure { }
- (void)controlLayerNeedDisappear:(__kindof SJBaseSequenceInvolve *)alternateStructure { }
@end
NS_ASSUME_NONNULL_END
