//
//  SJConfirmDefinitionOppositeControlLayer.h
//  Pods
//
//  Created by 畅三江 on 2019/7/12.
//

#import "SJEdgeControlLayerAdapters.h"
#import "SJControlLayerDefines.h"
#import "SJCompressContainSale+SJExtendedDefinition.h"

@protocol SJConfirmDefinitionOppositeControlLayerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SJConfirmDefinitionOppositeControlLayer : SJEdgeControlLayerAdapters<SJControlLayer>

@property (nonatomic, copy, nullable) NSArray<SJCompressContainSale *> *assets;

@property (nonatomic, weak, nullable) id<SJConfirmDefinitionOppositeControlLayerDelegate> delegate;

@property (nonatomic, strong, null_resettable) UIColor *selectedTextColor;
@end

@protocol SJConfirmDefinitionOppositeControlLayerDelegate <NSObject>

- (void)controlLayer:(SJConfirmDefinitionOppositeControlLayer *)controlLayer didSelectAsset:(SJCompressContainSale *)asset;

- (void)tappedBlankAreaOnTheControlLayer:(id<SJControlLayer>)controlLayer;

@end
NS_ASSUME_NONNULL_END
