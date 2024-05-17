//
//  SJEdgeControlLayerAdapters.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2018/10/20.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJContactIntegrateControlMaskView.h"
#import "SJEdgeControlButtonItemAdapter.h"

NS_ASSUME_NONNULL_BEGIN
struct SJ_Screen {
    CGFloat max;
    CGFloat min;
    BOOL saleInnerries;
};

@interface SJEdgeControlLayerAdapters : UIView {
    @protected
    SJEdgeControlButtonItemAdapter *_Nullable _topAdapter;
    SJEdgeControlButtonItemAdapter *_Nullable _leftAdapter;
    SJEdgeControlButtonItemAdapter *_Nullable _bottomAdapter;
    SJEdgeControlButtonItemAdapter *_Nullable _rightAdapter;
    SJEdgeControlButtonItemAdapter *_Nullable _centerAdapter;
    
    SJContactIntegrateControlMaskView *_Nullable _topContainerView;
    SJContactIntegrateControlMaskView *_Nullable _bottomContainerView;
    UIView *_Nullable _leftContainerView;
    UIView *_Nullable _rightContainerView;
    UIView *_Nullable _centerContainerView;
    
    struct SJ_Screen _screen;
}

@property (nonatomic, strong, readonly) SJEdgeControlButtonItemAdapter *topAdapter;    // lazy load
@property (nonatomic, strong, readonly) SJEdgeControlButtonItemAdapter *leftAdapter;   // lazy load
@property (nonatomic, strong, readonly) SJEdgeControlButtonItemAdapter *bottomAdapter; // lazy load
@property (nonatomic, strong, readonly) SJEdgeControlButtonItemAdapter *rightAdapter;  // lazy load
@property (nonatomic, strong, readonly) SJEdgeControlButtonItemAdapter *centerAdapter; // lazy load


@property (nonatomic, strong, readonly) SJContactIntegrateControlMaskView *topContainerView;
@property (nonatomic, strong, readonly) SJContactIntegrateControlMaskView *bottomContainerView;
@property (nonatomic, strong, readonly) UIView *leftContainerView;
@property (nonatomic, strong, readonly) UIView *rightContainerView;
@property (nonatomic, strong, readonly) UIView *centerContainerView;

@property (nonatomic) BOOL autoAdjustTopSpacing;

@property (nonatomic) BOOL autoAdjustLayoutWhenDeviceIsIPhoneXSeries;

#ifdef DEBUG
@property (nonatomic) BOOL showBackgroundColor;
#endif

@property (nonatomic) CGFloat topHeight;
@property (nonatomic) CGFloat leftWidth;
@property (nonatomic) CGFloat bottomHeight;
@property (nonatomic) CGFloat rightWidth;

@property (nonatomic) CGFloat topMargin;
@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat bottomMargin;
@property (nonatomic) CGFloat rightMargin;
@end
NS_ASSUME_NONNULL_END
