//
//  SJProgressSlider.h
//  Pods-SJProgressSlider_Example
//
//  Created by 畅三江 on 2017/11/20.
//  Copyright © 2017年 changsanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJProgressSliderDelegate;

@interface SJProgressSlider : UIView

@property (nonatomic, weak) id <SJProgressSliderDelegate>delegate;

@property (nonatomic, getter=isRound) BOOL round;

@property (nonatomic) CGFloat trackHeight;

@property (nonatomic, strong, readonly) UIImageView *trackImageView;

@property (nonatomic, strong, readonly) UIImageView *traceImageView;

@property (nonatomic, strong, readonly) UIImageView *thumbImageView;


- (void)setThumbCornerRadius:(CGFloat)thumbCornerRadius
                        size:(CGSize)size;

- (void)setThumbCornerRadius:(CGFloat)thumbCornerRadius
                        size:(CGSize)size
        thumbBackgroundColor:(UIColor *)thumbBackgroundColor;

@property (nonatomic) CGFloat value;
- (void)setValue:(CGFloat)value animated:(BOOL)animated;
@property (nonatomic) CGFloat animaMaxDuration;

@property (nonatomic) CGFloat minValue;

@property (nonatomic) CGFloat maxValue;

@property (nonatomic) CGFloat expand;

@property (nonatomic) float thumbOutsideSpace;

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *pan;

@property (nonatomic, strong, readonly) UITapGestureRecognizer *tap;
@property (nonatomic, copy, nullable) void(^tappedExeBlock)(SJProgressSlider *slider, CGFloat location);

@property (nonatomic, assign, readonly) BOOL isDragging;
- (void)cancelDragging;

@property (nonatomic) BOOL isLoading;

@property (nonatomic, strong) UIColor *loadingColor;

@end


#pragma mark -

@interface SJProgressSlider (Prompt)

@property (nonatomic, strong, readonly) UILabel *promptLabel;

@property (nonatomic) CGFloat promptSpacing;

@end



#pragma mark -
@interface SJProgressSlider (Border)

@property (nonatomic) BOOL showsBorder;

@property (null_resettable, nonatomic, strong) UIColor *borderColor;

@property (nonatomic) CGFloat borderWidth;

@end



#pragma mark -

@interface SJProgressSlider (Buffer)

@property (nonatomic) BOOL showsBufferProgress;

@property (nonatomic, strong, null_resettable) UIColor *bufferProgressColor;

@property (nonatomic) CGFloat bufferProgress;

@end


#pragma mark -

@interface SJProgressSlider (StopNode)

@property (nonatomic) BOOL showsStopNode;

@property (nonatomic, strong, null_resettable) UIView *stopNodeView;

@property (nonatomic) CGFloat stopNodeLocation;

- (void)setStopNodeViewCornerRadius:(CGFloat)cornerRadius size:(CGSize)size;
- (void)setStopNodeViewCornerRadius:(CGFloat)cornerRadius size:(CGSize)size backgroundColor:(UIColor *)backgroundColor;
@end


#pragma mark -


@protocol SJProgressSliderDelegate <NSObject>

@optional

- (void)sliderWillBeginDragging:(SJProgressSlider *)slider;


- (void)slider:(SJProgressSlider *)slider valueDidChange:(CGFloat)value;

- (void)sliderDidEndDragging:(SJProgressSlider *)slider;



- (void)sliderDidDrag:(SJProgressSlider *)slider __deprecated_msg("use `slider:valueDidChange:`");
@end
NS_ASSUME_NONNULL_END
