//
//  SJContactIntegrateClipsParameters.m
//  SJContactIntegrate
//
//  Created by 畅三江 on 2019/1/20.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import "SJContactIntegrateClipsParameters.h"

@implementation SJContactIntegrateClipsParameters
@synthesize operation = _operation;
@synthesize range = _range;
@synthesize resultNeedUpload = _resultNeedUpload;
@synthesize resultUploader = _resultUploader;
@synthesize saveResultToAlbum = _saveResultToAlbum;

- (instancetype)initWithOperation:(SJContactIntegrateClipsOperation)operation range:(CMTimeRange)range {
    self = [super init];
    if ( !self ) return nil;
    _operation = operation;
    _range = range;
    return self;
}
@end
