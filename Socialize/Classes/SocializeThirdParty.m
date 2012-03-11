
//
//  SocializeThirdParty.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdParty.h"

#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"

@implementation SocializeThirdParty
+ (NSArray*)allThirdParties {
    return [NSArray arrayWithObjects:[SocializeThirdPartyTwitter class], [SocializeThirdPartyFacebook class], nil];
}
@end