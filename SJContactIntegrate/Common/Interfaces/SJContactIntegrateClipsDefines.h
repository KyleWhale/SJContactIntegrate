//
//  SJContactIntegrateClipsDefines.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/4/12.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#ifndef SJContactIntegrateClipsDefines_h
#define SJContactIntegrateClipsDefines_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class SJClipsControlLayer, SJClipsResultShareItem, SJCompressContainSale, SJBaseSequenceInvolve;
@protocol SJContactIntegrateClipsResult, SJContactIntegrateClipsResultUpload;

typedef NS_ENUM(NSUInteger, SJClipsStatus) {
    SJClipsStatus_Unknown,
    SJClipsStatus_Recording,
    SJClipsStatus_Cancelled,
    SJClipsStatus_Paused,
    SJClipsStatus_Finished,
};

typedef NS_ENUM(NSUInteger, SJContactIntegrateClipsOperation) {
    SJContactIntegrateClipsOperation_Unknown,
    SJContactIntegrateClipsOperation_Screenshot,
    SJContactIntegrateClipsOperation_Export,
    SJContactIntegrateClipsOperation_GIF,
} ;

typedef NS_ENUM(NSUInteger, SJClipsResultUploadState) {
    SJClipsResultUploadStateUnknown,
    SJClipsResultUploadStateUploading,
    SJClipsResultUploadStateFailed,
    SJClipsResultUploadStateSuccessfully,
    SJClipsResultUploadStateCancelled,
} ;

typedef NS_ENUM(NSUInteger, SJClipsExportState) {
    SJClipsExportStateUnknown,
    SJClipsExportStateExporting,
    SJClipsExportStateFailed,
    SJClipsExportStateSuccess,
    SJClipsExportStateCancelled,
} ;

NS_ASSUME_NONNULL_BEGIN
@protocol SJContactIntegrateClipsParameters <NSObject>
// operation
@property (nonatomic, readonly) SJContactIntegrateClipsOperation operation;
@property (nonatomic, readonly) CMTimeRange range;

// upload
@property (nonatomic) BOOL resultNeedUpload;
@property (nonatomic, weak, nullable) id<SJContactIntegrateClipsResultUpload> resultUploader;

// album
@property (nonatomic) BOOL saveResultToAlbum;
@end

@protocol SJContactIntegrateClipsResult <NSObject>
@property (nonatomic, readonly) SJContactIntegrateClipsOperation operation;
@property (nonatomic, readonly) SJClipsExportState exportState;
@property (nonatomic, readonly) SJClipsResultUploadState uploadState;

/// results
@property (nonatomic, strong, readonly, nullable) UIImage *thumbnailImage;
@property (nonatomic, strong, readonly, nullable) UIImage *image; // screenshot or GIF
@property (nonatomic, strong, readonly, nullable) NSURL *fileURL;
@property (nonatomic, strong, readonly, nullable) SJCompressContainSale *currentPlayAsset;
- (NSData * __nullable)data;
@end

@protocol SJContactIntegrateClipsResultUpload <NSObject>
- (void)upload:(id<SJContactIntegrateClipsResult>)result
      progress:(void(^ __nullable)(float progress))progressBlock
       success:(void(^ __nullable)(void))success
       failure:(void (^ __nullable)(NSError *error))failure;

- (void)cancelUpload:(id<SJContactIntegrateClipsResult>)result;
@end
NS_ASSUME_NONNULL_END

#endif /* SJContactIntegrateClipsDefines_h */
