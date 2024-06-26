//
//  UIView+SJAnimationAdded.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2018/10/23.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SJViewDisappearAnimation) {
    SJViewDisappearAnimation_None,
    SJViewDisappearAnimation_Top,
    SJViewDisappearAnimation_Left,
    SJViewDisappearAnimation_Bottom,
    SJViewDisappearAnimation_Right,
    SJViewDisappearAnimation_HorizontalScaling,
    SJViewDisappearAnimation_VerticalScaling,
} ;

NS_ASSUME_NONNULL_BEGIN
extern BOOL
sj_view_isDisappeared(UIView *view);

extern void
sj_view_initializes(UIView *view);
extern void __attribute__((overloadable))
sj_view_initializes(NSArray<UIView *> *views);

extern void
sj_view_makeAppear(NSArray<UIView *> *views, BOOL animated, void(^_Nullable completionHandler)(void));
extern void __attribute__((overloadable))
sj_view_makeAppear(UIView *view, BOOL animated);
extern void __attribute__((overloadable))
sj_view_makeAppear(UIView *view, BOOL animated, void(^_Nullable completionHandler)(void));
extern void __attribute__((overloadable))
sj_view_makeAppear(NSArray<UIView *> *views, BOOL animated);

extern void
sj_view_makeDisappear(NSArray<UIView *> *views, BOOL animated, void(^_Nullable completionHandler)(void));
extern void __attribute__((overloadable))
sj_view_makeDisappear(UIView *view, BOOL animated);
extern void __attribute__((overloadable))
sj_view_makeDisappear(UIView *view, BOOL animated, void(^_Nullable completionHandler)(void));
extern void __attribute__((overloadable))
sj_view_makeDisappear(NSArray<UIView *> *views, BOOL animated);

@interface UIView (SJAnimationAdded)
@property (nonatomic) SJViewDisappearAnimation disappearvisibleDirection;
@property (nonatomic, readonly) BOOL sjv_disappeared;

- (void)sjv_disapear;
- (void)sjv_appear;
@end
NS_ASSUME_NONNULL_END
