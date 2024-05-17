//
//  SJClipsControlLayer.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/1/19.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import "SJEdgeControlLayerAdapters.h"
#import "SJContactIntegrateClipsConfig.h"
#import "SJControlLayerDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJClipsControlLayer : SJEdgeControlLayerAdapters<SJControlLayer>
@property (nonatomic, copy, nullable) void(^cancelledOperationExeBlock)(SJClipsControlLayer *control);
@property (nonatomic, strong, nullable) SJContactIntegrateClipsConfig *config;
@end
NS_ASSUME_NONNULL_END
