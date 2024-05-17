

#if __has_include(<SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>)
#import <SJBaseSequenceInvolve/SJBaseSequenceInvolve.h>
#else
#import "SJBaseSequenceInvolve.h"
#endif
#import "SJControlLayerIdentifiers.h"
#import "SJContactIntegrateConfigurations.h"
#import "SJCompressContainSale+SJControlAdd.h"
#import "SJContactIntegrateClipsDefines.h"
#import "SJContactIntegrateClipsConfig.h"
#import "SJControlLayerSwitcher.h"

#import "SJEdgeControlLayer.h"
#import "SJClipsControlLayer.h"
#import "SJMoreSettingControlLayer.h"
#import "SJLoadFailedControlLayer.h"
#import "SJNotReachableControlLayer.h"
#import "SJSmallViewControlLayer.h"
#import "SJConfirmDefinitionOppositeControlLayer.h"
#import "SJContactIntegrateResourceLoader.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJContactIntegrate : SJBaseSequenceInvolve

+ (instancetype)inverseElement;

+ (instancetype)lightweightPlayer;

- (instancetype)init;

@property (nonatomic, strong, readonly) SJControlLayerSwitcher *switcher;

@property (nonatomic, strong, readonly) SJEdgeControlLayer *defaultEdgeControlLayer;

@property (nonatomic, strong, readonly) SJNotReachableControlLayer *defaultNotReachableControlLayer;

@property (nonatomic, strong, readonly) SJClipsControlLayer *defaultClipsControlLayer;

@property (nonatomic, strong, readonly) SJMoreSettingControlLayer *defaultMoreSettingControlLayer;

@property (nonatomic, strong, readonly) SJLoadFailedControlLayer *defaultLoadFailedControlLayer;

@property (nonatomic, strong, readonly) SJSmallViewControlLayer *defaultSmallViewControlLayer;

@property (nonatomic, strong, readonly) SJConfirmDefinitionOppositeControlLayer *defaultConfirmDefinitionOppositeControlLayer;


- (instancetype)_init;
+ (NSString *)version;
@end

@interface SJContactIntegrate (CommonSettings)

@property (class, nonatomic, copy, readonly) void(^updateResources)(void(^block)(id<SJContactIntegrateControlLayerResources> resources));
@property (class, nonatomic, copy, readonly) void(^updateLocalizedStrings)(void(^block)(id<SJContactIntegrateLocalizedStrings> strings));
@property (class, nonatomic, copy, readonly) void(^setLocalizedStrings)(NSBundle *bundle);

@property (class, nonatomic, copy, readonly) void(^update)(void(^block)(SJContactIntegrateConfigurations *configs));
@end


@interface SJContactIntegrate (SJExtendedVideoDefinitionSwitchingControlLayer)

@property (nonatomic, copy, nullable) NSArray<SJCompressContainSale *> *definitionURLAssets;

@property (nonatomic, getter=isDisabledDefinitionSwitchingPrompt) BOOL disabledDefinitionSwitchingPrompt;

@end
 

@interface SJContactIntegrate (RotationOrFitOnScreen)

@property (nonatomic) BOOL automaticallyPerformRotationOrFitOnScreen;

@property (nonatomic) BOOL needsFitOnScreenFirst;

@end


@interface SJEdgeControlLayer (SJContactIntegrateExtended)

@property (nonatomic) BOOL showsMoreItem;

@property (nonatomic, getter=isEnabledClips) BOOL enabledClips;

@property (nonatomic, strong, null_resettable) SJContactIntegrateClipsConfig *clipsConfig;

@end

@interface SJContactIntegrate (SJExtendedControlLayerSwitcher)

- (void)switchControlLayerForIdentifier:(SJControlLayerIdentifier)identifier;
@end
NS_ASSUME_NONNULL_END
