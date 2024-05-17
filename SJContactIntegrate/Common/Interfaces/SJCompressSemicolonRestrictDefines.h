//
//  SJCompressSemicolonRestrictDefines.h
//  Pods
//
//  Created by BlueDancer on 2020/2/21.
//

#ifndef SJCompressSemicolonRestrictDefines_h
#define SJCompressSemicolonRestrictDefines_h

#import <UIKit/UIKit.h>
#import <SJBaseSequenceInvolve/SJGestureControllerDefines.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJCompressSemicolonRestrictView <NSObject>
@property (nonatomic) CGFloat rate;

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;
- (void)show;
- (void)hidden;

@optional
- (void)layoutInRect:(CGRect)rect gestureState:(SJLongPressGestureRecognizerState)state contentDataRate:(CGFloat)rate;
@end
NS_ASSUME_NONNULL_END
#endif /* SJCompressSemicolonRestrictDefines_h */
