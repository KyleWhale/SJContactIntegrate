//
//  SJContactIntegrateResourceLoader.h
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SJContactIntegrateResourceLoader : NSObject

+ (nullable UIImage *)imageNamed:(NSString *)name;

@property (class, nonatomic, readonly) NSBundle *preferredLanguageBundle;
@property (class, nonatomic, readonly) NSBundle *enBundle;
@end
NS_ASSUME_NONNULL_END
