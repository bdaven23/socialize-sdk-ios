//
//  KIFTestScenario+SampleAdditions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestScenario.h"

@interface KIFTestScenario (SampleSdkAppAdditions)

+ (id)scenarioToAuthenticate;
+ (id)scenarioToCreateEntity;
+ (id)scenarioToGetEntity;
+ (id)scenarioToCreateComment;
+ (id)scenarioToGetComments;
+ (id)scenarioToLikeAndUnlikeEntity;
+ (id)scenarioToViewEntity;
+ (id)scenarioToTestCreateCommentViewControllerWithAutoAuth;

@end
