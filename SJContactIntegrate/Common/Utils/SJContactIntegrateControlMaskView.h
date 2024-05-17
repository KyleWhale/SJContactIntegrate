//
//  SJContactIntegrateControlMaskView.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2017/9/25.
//  Copyright © 2017年 changsanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SJMaskStyle) {
    SJMaskStyle_bottom,
    SJMaskStyle_top,
};

@interface SJContactIntegrateControlMaskView : UIView

- (instancetype)initWithStyle:(SJMaskStyle)style;

- (void)cleanColors;
@end

NS_ASSUME_NONNULL_END
