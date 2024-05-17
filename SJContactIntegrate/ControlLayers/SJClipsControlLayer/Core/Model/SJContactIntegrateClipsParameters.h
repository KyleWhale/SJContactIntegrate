//
//  SJContactIntegrateClipsParameters.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/1/20.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJContactIntegrateClipsDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJContactIntegrateClipsParameters : NSObject<SJContactIntegrateClipsParameters>
- (instancetype)initWithOperation:(SJContactIntegrateClipsOperation)operation range:(CMTimeRange)range;
@end

NS_ASSUME_NONNULL_END
