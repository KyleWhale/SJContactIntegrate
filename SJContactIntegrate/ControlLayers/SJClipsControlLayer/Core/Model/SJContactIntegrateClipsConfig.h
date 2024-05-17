//
//  SJContactIntegrateClipsConfig.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/4/12.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJContactIntegrateClipsDefines.h"
#import "SJClipsResultShareItem.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SJContactIntegrateClipsResult, SJContactIntegrateClipsResultUpload;
@class SJBaseSequenceInvolve;

@interface SJContactIntegrateClipsConfig : NSObject

@property (nonatomic, copy, nullable) BOOL (^shouldStart)(__kindof SJBaseSequenceInvolve *alternateStructure, SJContactIntegrateClipsOperation selectedOperation);

@property (nonatomic, strong, nullable) NSArray<SJClipsResultShareItem *> *resultShareItems;

@property (nonatomic, copy, nullable) void(^clickedResultShareItemExeBlock)(__kindof SJBaseSequenceInvolve *player, SJClipsResultShareItem * item, id<SJContactIntegrateClipsResult> result);

@property (nonatomic) BOOL resultNeedUpload;
@property (nonatomic, weak, nullable) id<SJContactIntegrateClipsResultUpload> resultUploader;

@property (nonatomic) BOOL disableScreenshot;
@property (nonatomic) BOOL disableRecord;
@property (nonatomic) BOOL disableGIF;

@property (nonatomic) BOOL saveResultToAlbum; 

- (void)config:(SJContactIntegrateClipsConfig *)otherConfig;
@end
NS_ASSUME_NONNULL_END
