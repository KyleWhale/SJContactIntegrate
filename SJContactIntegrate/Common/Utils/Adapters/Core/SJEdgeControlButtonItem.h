//
//  SJEdgeControlButtonItem.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2018/10/19.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SJBaseSequenceInvolve/SJGestureControllerDefines.h>
typedef NSInteger SJEdgeControlButtonItemTag;
@class SJBaseSequenceInvolve, SJEdgeControlButtonItemAction;

typedef struct SJEdgeInsets {
    CGFloat front, rear;
} SJEdgeInsets;

UIKIT_STATIC_INLINE SJEdgeInsets SJEdgeInsetsMake(CGFloat front, CGFloat rear) {
    return (SJEdgeInsets){front, rear};
}

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSNotificationName const SJEdgeControlButtonItemPerformedActionNotification;

@interface SJEdgeControlButtonItem : NSObject
- (instancetype)initWithImage:(nullable UIImage *)image
                       target:(nullable id)target
                       action:(nullable SEL)action
                          tag:(SJEdgeControlButtonItemTag)tag;

- (instancetype)initWithTitle:(nullable NSAttributedString *)title
                       target:(nullable id)target
                       action:(nullable SEL)action
                          tag:(SJEdgeControlButtonItemTag)tag;

- (instancetype)initWithCustomView:(nullable __kindof UIView *)customView
                               tag:(SJEdgeControlButtonItemTag)tag;

- (instancetype)initWithTag:(SJEdgeControlButtonItemTag)tag;

@property (nonatomic) SJEdgeInsets insets;
@property (nonatomic) SJEdgeControlButtonItemTag tag;
@property (nonatomic, strong, nullable) __kindof UIView *customView;
@property (nonatomic, strong, nullable) NSAttributedString *title;
@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic) CGFloat alpha;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
@property (nonatomic) BOOL fill;

@property (nonatomic, readonly, nullable) NSArray<SJEdgeControlButtonItemAction *> *actions;
- (void)addAction:(SJEdgeControlButtonItemAction *)action;
- (void)removeAction:(SJEdgeControlButtonItemAction *)action;
- (void)removeAllActions;
- (void)performActions;
@end
typedef NS_ENUM(NSUInteger, SJButtonItemPlaceholderType) { 
    SJButtonItemPlaceholderType_Unknown,
    SJButtonItemPlaceholderType_49x49,
    SJButtonItemPlaceholderType_49xAutoresizing,
    SJButtonItemPlaceholderType_49xFill,
    SJButtonItemPlaceholderType_49xSpecifiedSize,
} ;

@interface SJEdgeControlButtonItem(Placeholder)
+ (instancetype)placeholderWithType:(SJButtonItemPlaceholderType)placeholderType tag:(SJEdgeControlButtonItemTag)tag;
+ (instancetype)placeholderWithSize:(CGFloat)size tag:(SJEdgeControlButtonItemTag)tag;
@property (nonatomic, readonly) SJButtonItemPlaceholderType placeholderType;
@property (nonatomic) CGFloat size;
@end

@interface SJEdgeControlButtonItem (FrameLayout)
+ (instancetype)frameLayoutWithCustomView:(__kindof UIView *)customView tag:(SJEdgeControlButtonItemTag)tag;
@property (nonatomic, readonly) BOOL wrapFrameLayout;
@end


@interface SJEdgeControlButtonItem (SJDeprecated)
- (void)addTarget:(id)target action:(nonnull SEL)action __deprecated_msg("use `addAction:`;");
- (void)performAction __deprecated_msg("use `performActions`;");
@end

#pragma mark -

@interface SJEdgeControlButtonItemAction : NSObject
+ (instancetype)actionWithTarget:(id)target action:(SEL)action;
- (instancetype)initWithTarget:(id)target action:(SEL)action;

+ (instancetype)actionWithHandler:(void(^)(SJEdgeControlButtonItemAction *action))handler;
- (instancetype)initWithHandler:(void(^)(SJEdgeControlButtonItemAction *action))handler;

@property (nonatomic, weak, readonly, nullable) id target;
@property (nonatomic, readonly, nullable) SEL action;
@property (nonatomic, copy, readonly, nullable) void(^handler)(SJEdgeControlButtonItemAction *action);
@end
NS_ASSUME_NONNULL_END
