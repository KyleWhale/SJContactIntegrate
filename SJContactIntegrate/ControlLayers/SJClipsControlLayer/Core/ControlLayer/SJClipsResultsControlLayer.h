//
//  SJClipsResultsControlLayer.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/1/20.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import "SJEdgeControlLayerAdapters.h"
#import "SJContactIntegrateClipsDefines.h"
#import "SJControlLayerDefines.h"

@class SJClipsResultShareItem;

NS_ASSUME_NONNULL_BEGIN
@interface SJClipsResultsControlLayer : SJEdgeControlLayerAdapters<SJControlLayer>
@property (nonatomic, strong, nullable) NSArray<SJClipsResultShareItem *> *shareItems;
@property (nonatomic, strong, nullable) id<SJContactIntegrateClipsParameters> parameters;

@property (nonatomic, copy, nullable) void(^cancelledOperationExeBlock)(SJClipsResultsControlLayer *control);
@property (nonatomic, copy, nullable) void(^clickedResultShareItemExeBlock)(__kindof SJBaseSequenceInvolve *player, SJClipsResultShareItem * item, id<SJContactIntegrateClipsResult> result);
@end
NS_ASSUME_NONNULL_END
