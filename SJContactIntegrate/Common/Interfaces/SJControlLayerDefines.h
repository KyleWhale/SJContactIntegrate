//
//  SJControlLayerDefines.h
//  Pods
//
//  Created by 畅三江 on 2018/6/1.
//  Copyright © 2018年 畅三江. All rights reserved.
//

#ifndef SJControlLayerDefines_h
#define SJControlLayerDefines_h
#if __has_include(<SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>)
#import <SJBaseSequenceInvolve/SJContactIntegrateControlLayerProtocol.h>
#else
#import "SJContactIntegrateControlLayerProtocol.h"
#endif
@protocol SJControlLayerRestartProtocol, SJControlLayerExitProtocol;
typedef long SJControlLayerIdentifier;

NS_ASSUME_NONNULL_BEGIN

@protocol SJControlLayer <
    SJControlLayerDataSource,
    SJControlLayerDelegate,
    SJControlLayerRestartProtocol,
    SJControlLayerExitProtocol
>
@end

@protocol SJControlLayerRestartProtocol <NSObject>
@property (nonatomic, readonly) BOOL restarted; 
- (void)restartControlLayer;
@end


@protocol SJControlLayerExitProtocol <NSObject>
- (void)exitControlLayer;
@end
NS_ASSUME_NONNULL_END

#endif /* SJControlLayerDefines_h */
