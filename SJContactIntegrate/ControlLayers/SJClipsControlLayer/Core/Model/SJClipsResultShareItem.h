//
//  SJClipsResultShareItem.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/4/12.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJClipsResultShareItem : NSObject
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic) BOOL canAlsoClickedWhenUploading;
@end
