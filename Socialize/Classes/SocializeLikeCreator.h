//
//  SocializeLikeCreator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeActivityCreator.h"
#import "SocializeLike.h"

@interface SocializeLikeCreator : SocializeActivityCreator
@property (nonatomic, readonly) id<SocializeLike> like;

@end
