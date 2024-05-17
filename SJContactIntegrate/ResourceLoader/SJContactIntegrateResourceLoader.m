//
//  SJContactIntegrateResourceLoader.m
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/11/27.
//

#import "SJContactIntegrateResourceLoader.h"
 
NS_ASSUME_NONNULL_BEGIN
@implementation SJContactIntegrateResourceLoader
static NSBundle *bundle = nil;
static NSBundle *preferredLanguageBundle = nil;
static NSBundle *enBundle = nil;
static NSBundle *zhHansBundle = nil;
static NSBundle *zhHantBundle = nil;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"SJContactIntegrate" ofType:@"bundle"]];
        NSString *preferredLanguage = [NSLocale preferredLanguages].firstObject;
        if      ( [preferredLanguage hasPrefix:@"en"] ) {
            preferredLanguage = @"en";
        }
        else {
            preferredLanguage = @"en";
        }
        preferredLanguageBundle = [NSBundle bundleWithPath:[bundle pathForResource:preferredLanguage ofType:@"lproj"]];
        enBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"en" ofType:@"lproj"]];
    });
}

+ (NSBundle *)bundle {
    return bundle;
}

+ (NSBundle *)preferredLanguageBundle {
    return preferredLanguageBundle;
}

+ (NSBundle *)enBundle {
    return enBundle;
}

+ (nullable UIImage *)imageNamed:(NSString *)name {
    if ( 0 == name.length )
        return nil;
    NSString *path = [self.bundle pathForResource:name ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:data scale:3.0];
    return image;
}
@end
NS_ASSUME_NONNULL_END
