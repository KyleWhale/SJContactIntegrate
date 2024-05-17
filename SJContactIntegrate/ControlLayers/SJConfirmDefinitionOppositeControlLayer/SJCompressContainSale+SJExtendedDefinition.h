//
//  SJCompressContainSale+SJExtendedDefinition.h
//  Pods
//
//  Created by 畅三江 on 2019/7/12.
//

#if __has_include(<SJBaseSequenceInvolve/SJCompressContainSale.h>)
#import <SJBaseSequenceInvolve/SJCompressContainSale.h>
#else
#import "SJCompressContainSale.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SJCompressContainSale (SJExtendedDefinition)

@property (nonatomic, copy, nullable) NSString *definition_fullName;

@property (nonatomic, copy, nullable) NSString *definition_lastName;

@end

NS_ASSUME_NONNULL_END
