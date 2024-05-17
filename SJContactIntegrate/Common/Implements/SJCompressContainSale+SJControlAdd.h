//
//  SJCompressContainSale+SJControlAdd.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/2/4.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#if __has_include(<SJBaseSequenceInvolve/SJContactIntegrateURLAsset.h>)
#import <SJBaseSequenceInvolve/SJCompressContainSale.h>
#else
#import "SJCompressContainSale.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SJCompressContainSale (SJControlAdd)

- (nullable instancetype)initWithTitle:(NSString *)title
                          URL:(NSURL *)URL
                    playModel:(__kindof SJPlayModel *)playModel;

- (nullable instancetype)initWithTitle:(NSString *)title
                          URL:(NSURL *)URL
             startPosition:(NSTimeInterval)startPosition
                    playModel:(__kindof SJPlayModel *)playModel;

- (nullable instancetype)initWithAttributedTitle:(NSAttributedString *)title
                                             URL:(NSURL *)URL
                                       playModel:(__kindof SJPlayModel *)playModel;

- (nullable instancetype)initWithAttributedTitle:(NSAttributedString *)title
                                             URL:(NSURL *)URL
                                startPosition:(NSTimeInterval)startPosition
                                       playModel:(__kindof SJPlayModel *)playModel;


@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSAttributedString *attributedTitle;
@end
NS_ASSUME_NONNULL_END
