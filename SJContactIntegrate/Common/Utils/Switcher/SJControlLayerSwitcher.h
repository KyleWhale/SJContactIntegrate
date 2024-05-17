//
//  SJControlLayerSwitcher.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/6/1.
//  Copyright © 2018年 畅三江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJControlLayerDefines.h"
#if __has_include(<SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>)
#import <SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>
#else
#import "SJBaseSequenceInvolve.h"
#endif
@protocol SJControlLayerSwitcherObserver, SJControlLayerSwitcherDelegate;

NS_ASSUME_NONNULL_BEGIN
extern SJControlLayerIdentifier SJControlLayer_Uninitialized;

@protocol SJControlLayerSwitcher <NSObject>
- (instancetype)initWithPlayer:(__weak SJBaseSequenceInvolve *)player;

- (void)switchControlLayerForIdentifier:(SJControlLayerIdentifier)identifier;
- (BOOL)switchToPreviousControlLayer;

- (void)addControlLayerForIdentifier:(SJControlLayerIdentifier)identifier
                         lazyLoading:(nullable id<SJControlLayer>(^)(SJControlLayerIdentifier identifier))loading;

- (void)deleteControlLayerForIdentifier:(SJControlLayerIdentifier)identifier;

- (BOOL)containsControlLayer:(SJControlLayerIdentifier)identifier;

- (nullable id<SJControlLayer>)controlLayerForIdentifier:(SJControlLayerIdentifier)identifier;

- (id<SJControlLayerSwitcherObserver>)getObserver;

@property (nonatomic, copy, nullable) id<SJControlLayer> _Nullable (^resolveControlLayer)(SJControlLayerIdentifier identifier);

@property (nonatomic, weak, nullable) id<SJControlLayerSwitcherDelegate> delegate;
@property (nonatomic, readonly) SJControlLayerIdentifier previousIdentifier;
@property (nonatomic, readonly) SJControlLayerIdentifier currentIdentifier;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end


@interface SJControlLayerSwitcher : NSObject<SJControlLayerSwitcher>

@end

@protocol SJControlLayerSwitcherDelegate <NSObject>
@optional
- (BOOL)switcher:(id<SJControlLayerSwitcher>)switcher shouldSwitchToControlLayer:(SJControlLayerIdentifier)identifier;
- (nullable id<SJControlLayer>)switcher:(id<SJControlLayerSwitcher>)switcher controlLayerForIdentifier:(SJControlLayerIdentifier)identifier;
@end

// - observer -
@protocol SJControlLayerSwitcherObserver <NSObject>
@property (nonatomic, copy, nullable) void(^incorrectWillBeginTranslateControlLayer)(id<SJControlLayerSwitcher> switcher, id<SJControlLayer> controlLayer);
@property (nonatomic, copy, nullable) void(^incorrectDidEndTranslateControlLayer)(id<SJControlLayerSwitcher> switcher, id<SJControlLayer> controlLayer);
@end
NS_ASSUME_NONNULL_END
