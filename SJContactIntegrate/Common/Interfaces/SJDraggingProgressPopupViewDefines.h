//
//  SJDraggingProgressPopupViewDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/11/27.
//

#ifndef SJDraggingProgressPopupViewDefines_h
#define SJDraggingProgressPopupViewDefines_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SJDraggingProgressPopupViewStyle) {
    SJDraggingProgressPopupViewStyleNormal,
    SJDraggingProgressPopupViewStyleFullscreen,
    SJDraggingProgressPopupViewStyleFitOnScreen
};

@protocol SJDraggingProgressPopupView <NSObject>
@property (nonatomic) SJDraggingProgressPopupViewStyle style;
@property (nonatomic) NSTimeInterval dragTime;  
@property (nonatomic) NSTimeInterval contentTime;
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic, readonly, getter=isPreviewImageHidden) BOOL previewImageHidden;
@property (nonatomic, strong, nullable) UIImage *previewImage;
@end
NS_ASSUME_NONNULL_END

#endif /* SJDraggingProgressPopupViewDefines_h */
