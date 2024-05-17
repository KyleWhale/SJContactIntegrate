//
//  SJCommonProgressSlider.h
//  SJProgressSlider
//
//  Created by 畅三江 on 2017/11/20.
//  Copyright © 2017年 changsanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJProgressSlider.h"

@interface SJCommonProgressSlider : UIView

@property (nonatomic, assign, readwrite) float spacing;

@property (nonatomic, strong, readonly) UIView *leftContainerView;
@property (nonatomic, strong, readonly) SJProgressSlider *slider;
@property (nonatomic, strong, readonly) UIView *rightContainerView;

@end
