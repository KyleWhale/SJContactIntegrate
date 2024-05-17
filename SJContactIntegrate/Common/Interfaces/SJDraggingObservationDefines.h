//
//  SJDraggingObservationDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/11/27.
//

#ifndef SJDraggingObservationDefines_h
#define SJDraggingObservationDefines_h

NS_ASSUME_NONNULL_BEGIN
@protocol SJDraggingObservation <NSObject>

@property (nonatomic, copy, nullable) void(^willBeginDraggingExeBlock)(NSTimeInterval time);

@property (nonatomic, copy, nullable) void(^didMoveExeBlock)(NSTimeInterval time);

@property (nonatomic, copy, nullable) void(^willEndDraggingExeBlock)(NSTimeInterval time);

@property (nonatomic, copy, nullable) void(^didEndDraggingExeBlock)(NSTimeInterval time);
@end
NS_ASSUME_NONNULL_END

#endif /* SJDraggingObservationDefines_h */
