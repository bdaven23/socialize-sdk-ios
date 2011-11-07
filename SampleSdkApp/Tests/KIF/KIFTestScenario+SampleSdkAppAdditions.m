//
//  KIFTestScenario+SampleAdditions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestScenario+SampleSdkAppAdditions.h"
#import "KIFTestStep+SampleSdkAppAdditions.h"
#import "SampleSdkAppKIFTestController.h"
@implementation KIFTestScenario (SampleSdkAppAdditions)

+ (id)scenarioToTestViewOtherProfile {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that another user's profile can be viewed."];
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:url comment:@"comment!"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToGetCommentsForEntity:url]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"profile button"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"profile button"]];
    
    // edit should be here (our profile)
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Edit"]];
    
    // Exit and auth as new user
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToReturnToAuth]];
    [scenario addStepsFromArray:[KIFTestStep stepsToAuthenticate]];

    // View profile as a new user, verify not editable
    [scenario addStepsFromArray:[KIFTestStep stepsToGetCommentsForEntity:url]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"profile button"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"profile button"]];
    [scenario addStep:[KIFTestStep stepToVerifyElementWithAccessibilityLabelDoesNotExist:@"Edit"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1 description:@"end"]];

    return scenario;
}

+ (id)scenarioToTestCommentsViewControllerWithAutoAuth {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that test that socialize UI views work even when not logged in."];
    [scenario addStepsFromArray:[KIFTestStep stepsToNoAuth]];
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    NSString *commentString = [NSString stringWithFormat:@"Comment from %s", _cmd];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateCommentWithControllerForEntity:url comment:commentString]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyCommentExistsForEntity:url comment:commentString]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Comments List"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];   
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tests"]];   
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];   
    return scenario;
}

+ (id)scenarioToTestActionBar {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the Socialize Action Bar"];
    NSString *url = [SampleSdkAppKIFTestController testURL:[NSString stringWithFormat:@"%s/entity1", _cmd]];
    [scenario addStepsFromArray:[KIFTestStep stepsToShowTabbedActionBarForURL:url]];
    [scenario addStep:[KIFTestStep stepToVerifyViewWithAccessibilityLabel:@"Socialize Action View" passesTest:^BOOL(id view) {
        return CGRectEqualToRect(CGRectMake(0, 343, 320, 44), [view frame]);
    }]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:1]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Featured"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Action Bar!"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"In progress"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarViewsAtCount:2]];
    
    [scenario addStepsFromArray:[KIFTestStep stepsToLikeOnActionBar]];
    [scenario addStepsFromArray:[KIFTestStep stepsToVerifyActionBarLikesAtCount:1]];

    [scenario addStepsFromArray:[KIFTestStep stepsToCommentOnActionBar]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"add comment button"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToCreateComment:@"actionbar comment"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close"]];
    [scenario addStep:[KIFTestStep stepToCheckAccessibilityLabel:@"comment button" hasValue:@"1"]];

    return scenario;
}


+ (id)scenarioToTestUserProfile {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test Socialize User Profiles"];
    [scenario addStepsFromArray:[KIFTestStep stepsToTestUserProfile]];
    return scenario;
}

+ (id)scenarioToAuthenticate {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
    [scenario addStepsFromArray:[KIFTestStep stepsToAuthenticate]];
    return scenario;
}


@end
