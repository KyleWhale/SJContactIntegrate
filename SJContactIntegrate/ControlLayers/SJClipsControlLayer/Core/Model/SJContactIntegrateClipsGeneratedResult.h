//
//  SJContactIntegrateClipsGeneratedResult.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/1/20.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJContactIntegrateClipsDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJContactIntegrateClipsGeneratedResult : NSObject<SJContactIntegrateClipsResult>
@property (nonatomic) SJContactIntegrateClipsOperation operation;
@property (nonatomic) SJClipsExportState exportState;
@property (nonatomic) float exportProgress;
@property (nonatomic) SJClipsResultUploadState uploadState;
@property (nonatomic) float uploadProgress;

// results
@property (nonatomic, strong, nullable) UIImage *thumbnailImage;
@property (nonatomic, strong, nullable) UIImage *image; // screenshot or GIF
@property (nonatomic, strong, nullable) NSURL *fileURL;
@property (nonatomic, strong, nullable) SJCompressContainSale *currentPlayAsset;
- (NSData * __nullable)data;

@property (nonatomic, copy, nullable) void(^exportProgressDidChangeExeBlock)(SJContactIntegrateClipsGeneratedResult *result);
@property (nonatomic, copy, nullable) void(^uploadProgressDidChangeExeBlock)(SJContactIntegrateClipsGeneratedResult *result);

@property (nonatomic, copy, nullable) void(^exportStateDidChangeExeBlock)(SJContactIntegrateClipsGeneratedResult *result);
@property (nonatomic, copy, nullable) void(^uploadStateDidChangeExeBlock)(SJContactIntegrateClipsGeneratedResult *result);
@end
NS_ASSUME_NONNULL_END
