//
//  SJContactIntegrateClipsConfig.m
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/4/12.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#import "SJContactIntegrateClipsConfig.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJContactIntegrateClipsConfig
- (void)config:(SJContactIntegrateClipsConfig *)otherConfig {
    self.shouldStart = otherConfig.shouldStart;
    self.resultShareItems = otherConfig.resultShareItems;
    self.clickedResultShareItemExeBlock = otherConfig.clickedResultShareItemExeBlock;
    self.resultNeedUpload = otherConfig.resultNeedUpload;
    self.resultUploader = otherConfig.resultUploader;
    self.disableScreenshot = otherConfig.disableScreenshot;
    self.disableRecord = otherConfig.disableRecord;
    self.disableGIF = otherConfig.disableGIF;
    self.saveResultToAlbum = otherConfig.saveResultToAlbum;
}
@end
NS_ASSUME_NONNULL_END
