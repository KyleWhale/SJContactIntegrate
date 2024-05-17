//
//  SJSmallViewControlLayer.m
//  Pods
//
//  Created by 畅三江 on 2019/6/6.
//

#import "SJSmallViewControlLayer.h"
#import "UIView+SJAnimationAdded.h"
#import "SJContactIntegrateConfigurations.h"
#if __has_include(<SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>)
#import <SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>
#else
#import "SJBaseSequenceInvolve.h" 
#endif

NS_ASSUME_NONNULL_BEGIN
SJEdgeControlButtonItemTag const SJSmallViewControlLayerTopItem_Close = 10000;

@interface SJSmallViewControlLayer ()
@property (nonatomic, weak, nullable) __kindof SJBaseSequenceInvolve *player;
@end

@implementation SJSmallViewControlLayer
@synthesize restarted = _restarted;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _setupView];
    return self;
}

- (UIView *)controlView {
    return self;
}

- (void)installedControlViewAlternateThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    _player = alternateStructure;
}

- (void)restartControlLayer {
    _restarted = YES;
    sj_view_makeAppear(self.controlView, YES);
}

- (void)exitControlLayer {
    _restarted = NO;
    sj_view_makeDisappear(self.controlView, YES, ^{
        if ( !self->_restarted ) [self.controlView removeFromSuperview];
    });
}

- (void)tappedCloseItem:(SJEdgeControlButtonItem *)item {
    [self.player pauseForUser];
    [self.player.smallViewFloatingController dismiss];
}

- (void)_setupView {
    self.topMargin = 0;
    self.topHeight = 35;
    
    SJEdgeControlButtonItem *fillItem = [[SJEdgeControlButtonItem alloc] initWithTag:0];
    fillItem.fill = YES;
    [self.topAdapter addItem:fillItem];
    
    SJEdgeControlButtonItem *closeItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJSmallViewControlLayerTopItem_Close];
    [closeItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(tappedCloseItem:)]];
    closeItem.image = SJContactIntegrateConfigurations.shared.resources.floatSmallViewCloseImage;
    [self.topAdapter addItem:closeItem];
    
    [self.topAdapter reload];
}

- (void)controlLayerNeedAppear:(__kindof SJBaseSequenceInvolve *)alternateStructure { }

- (void)controlLayerNeedDisappear:(__kindof SJBaseSequenceInvolve *)alternateStructure { }

- (BOOL)canTriggerRotationAccuracyThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure {
    return NO;
}
@end
NS_ASSUME_NONNULL_END
