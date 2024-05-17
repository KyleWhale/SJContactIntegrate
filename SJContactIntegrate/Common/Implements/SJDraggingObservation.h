//
//  SJDraggingObservation.h
//  Pods
//
//  Created by 畅三江 on 2019/11/27.
//

#import <Foundation/Foundation.h>
#import "SJDraggingObservationDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJDraggingObservation : NSObject<SJDraggingObservation>

@property (nonatomic, copy, nullable) void(^willBeginDraggingExeBlock)(NSTimeInterval time);


@property (nonatomic, copy, nullable) void(^didMoveExeBlock)(NSTimeInterval time);


@property (nonatomic, copy, nullable) void(^willEndDraggingExeBlock)(NSTimeInterval time);


@property (nonatomic, copy, nullable) void(^didEndDraggingExeBlock)(NSTimeInterval time);
@end
NS_ASSUME_NONNULL_END
