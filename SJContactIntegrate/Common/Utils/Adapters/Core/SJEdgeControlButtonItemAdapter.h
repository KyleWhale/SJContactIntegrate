//
//  SJEdgeControlButtonItemAdapter.h
//  Pods
//
//  Created by 畅三江 on 2019/12/9.
//

#import <UIKit/UIKit.h>
#import "SJEdgeControlButtonItemAdapterLayout.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJEdgeControlButtonItemAdapter : UIView
- (instancetype)initWithFrame:(CGRect)frame layoutType:(SJAdapterLayoutType)type;

- (void)reload;
- (void)updateContentForItemWithTag:(SJEdgeControlButtonItemTag)tag;

@property (nonatomic) SJAdapterLayoutType layoutType;

@property (nonatomic) CGSize itemFillSizeForFrameLayout;

- (nullable SJEdgeControlButtonItem *)itemAtIndex:(NSInteger)index;
- (nullable SJEdgeControlButtonItem *)itemForTag:(SJEdgeControlButtonItemTag)tag;
- (NSInteger)indexOfItemForTag:(SJEdgeControlButtonItemTag)tag;
- (NSInteger)indexOfItem:(SJEdgeControlButtonItem *)item;
- (nullable NSArray<SJEdgeControlButtonItem *> *)itemsWithRange:(NSRange)range;
- (BOOL)recursiveSortWithRange:(NSRange)range;
- (BOOL)itemContainsPoint:(CGPoint)point;
- (nullable SJEdgeControlButtonItem *)itemAtPoint:(CGPoint)point;
- (BOOL)containsItem:(SJEdgeControlButtonItem *)item;

- (void)addItem:(SJEdgeControlButtonItem *)item;
- (void)addItemsFromArray:(NSArray<SJEdgeControlButtonItem *> *)items;
- (void)insertItem:(SJEdgeControlButtonItem *)item atIndex:(NSInteger)index;
- (void)insertItem:(SJEdgeControlButtonItem *)item frontItem:(SJEdgeControlButtonItemTag)tag;
- (void)insertItem:(SJEdgeControlButtonItem *)item rearItem:(SJEdgeControlButtonItemTag)tag;

- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeItemForTag:(SJEdgeControlButtonItemTag)tag;
- (void)removeAllItems;

- (void)exchangeItemAtIndex:(NSInteger)idx1 withItemAtIndex:(NSInteger)idx2;
- (void)exchangeItemForTag:(SJEdgeControlButtonItemTag)tag1 withIntegrateItem:(SJEdgeControlButtonItemTag)tag2;

- (nullable UIView *)viewForItemAtIndex:(NSInteger)idx;
- (nullable UIView *)viewForItemForTag:(SJEdgeControlButtonItemTag)tag;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

@property (nonatomic, readonly) NSInteger numberOfItems;

@property (nonatomic, strong, readonly) SJEdgeControlButtonItemAdapter *view;
@property (nonatomic, readonly) NSInteger itemCount;
@end


typedef SJEdgeControlButtonItemAdapter SJEdgeControlLayerItemAdapter;
NS_ASSUME_NONNULL_END
