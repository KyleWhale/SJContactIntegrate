//
//  SJConceptCompanyCountAugmentView.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/1/20.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJProgressSlider.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJConceptCompanyCountAugmentView : UIView
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic, strong, readonly) SJProgressSlider *progressSlider;
@end
NS_ASSUME_NONNULL_END
