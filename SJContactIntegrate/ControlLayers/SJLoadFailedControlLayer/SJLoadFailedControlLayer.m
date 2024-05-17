//
//  SJLoadFailedControlLayer.m
//  SJContactIntegrate
//
//  Created by 畅三江 on 2018/10/27.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import "SJLoadFailedControlLayer.h"
#import "SJContactIntegrateConfigurations.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJLoadFailedControlLayer ()
@end

@implementation SJLoadFailedControlLayer
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _updateSettings];
    return self;
}

- (void)_updateSettings {
    id<SJContactIntegrateControlLayerResources> resources = SJContactIntegrateConfigurations.shared.resources;
    id<SJContactIntegrateLocalizedStrings> strings = SJContactIntegrateConfigurations.shared.localizedStrings;
    [self.reloadView.button setTitle:strings.reload forState:UIControlStateNormal];
    self.reloadView.backgroundColor = resources.playFailedButtonBackgroundColor;
    self.promptLabel.text = strings.contentDataFailedPrompt;
}
@end
NS_ASSUME_NONNULL_END
