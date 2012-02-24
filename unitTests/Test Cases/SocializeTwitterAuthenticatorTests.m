//
//  SocializeTwitterAuthenticatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTwitterAuthenticatorTests.h"
#import "OCMock/OCMock.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeTwitterAuthViewController.h"
#import "UIViewController+Socialize.h"
#import "_Socialize.h"

@implementation SocializeTwitterAuthenticatorTests
@synthesize twitterAuthenticator = twitterAuthenticator_;
@synthesize mockSocialize = mockSocialize_;
@synthesize mockDelegate = mockDelegate_;
@synthesize mockTwitterAuthViewController = mockTwitterAuthViewController_;
@synthesize mockNavigationForTwitterAuthViewController = mockNavigationForTwitterAuthViewController_;
@synthesize mockPresentationTarget = mockPresentationTarget_;
#if 0
- (void)setUp {
    self.mockPresentationTarget = [OCMockObject mockForClass:[UIViewController class]];

    self.twitterAuthenticator = [[[SocializeTwitterAuthenticator alloc] initWithDisplayObject:nil
                                                                                      display:self.mockPresentationTarget
                                                                                      options:nil
                                                                                      success:^{
                                                                                          [self notify:kGHUnitWaitStatusSuccess ];
                                                                                      } 
                                                                                      failure:^(NSError *error) {
                                                                                          [self notify:kGHUnitWaitStatusSuccess];
                                                                                      }] autorelease];
                                  
    self.twitterAuthenticator = [OCMockObject partialMockForObject:self.twitterAuthenticator];
    self.twitterAuthenticator.failureBlock = ^(NSError *error) {
        [self notify:kGHUnitWaitStatusSuccess];
    };
    self.twitterAuthenticator.successBlock = ^{
        [self notify:kGHUnitWaitStatusSuccess];        
    };
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[self.mockSocialize stub] setDelegate:nil];
    
    self.twitterAuthenticator.socialize = self.mockSocialize;
    
    
    self.mockTwitterAuthViewController = [OCMockObject mockForClass:[SocializeTwitterAuthViewController class]];
    [[self.mockTwitterAuthViewController stub] setDelegate:nil];
    self.twitterAuthenticator.twitterAuthViewController = self.mockTwitterAuthViewController;
    
    self.mockNavigationForTwitterAuthViewController = [OCMockObject mockForClass:[UINavigationController class]];
    [[[self.mockTwitterAuthViewController stub] andReturn:self.mockNavigationForTwitterAuthViewController] wrappingSocializeNavigationController];
}

- (void)tearDown {
    [self.mockSocialize verify];
    [self.mockDelegate verify];
    [self.mockTwitterAuthViewController verify];
    [self.mockPresentationTarget verify];
    
    self.mockTwitterAuthViewController = nil;
    self.mockSocialize = nil;
    self.mockDelegate = nil;
    self.twitterAuthenticator = nil;
    self.mockPresentationTarget = nil;
}

- (UIViewController*)twitterAuthenticatorRequiresModalPresentationTarget:(SocializeTwitterAuthenticator *)twitterAuthenticator {
    return self.mockPresentationTarget;
}

- (void)expectModalDisplayOfTwitterAuth {
    [[self.mockPresentationTarget expect] presentModalViewController:self.mockNavigationForTwitterAuthViewController animated:YES];
}

- (void)testAuthenticateWithTwitterShowsTwitterAuthControllerIfNeeded {
    
    // Should clear controller
    [[(id)self.twitterAuthenticator expect] setTwitterAuthViewController:nil];
    
    // Twitter session not valid
    [[[self.mockSocialize stub] andReturnBool:NO] twitterSessionValid];

    // Should show modal controller
    [self expectModalDisplayOfTwitterAuth];
    
    [self.twitterAuthenticator authenticateWithTwitter];
}

- (void)testReceivingAccessTokenUpdatesStoredCredentials {
    NSString *accessToken = @"accessToken";
    NSString *accessTokenSecret = @"accessTokenSecret";
    NSString *screenName = @"screenName";
    NSString *userID = @"userID";
    
    [self.twitterAuthenticator twitterAuthViewController:self.mockTwitterAuthViewController didReceiveAccessToken:accessToken accessTokenSecret:accessTokenSecret screenName:screenName userID:userID];
    
    GHAssertEqualStrings([Socialize twitterAccessToken], accessToken, @"Does Not Match");
    GHAssertEqualStrings([Socialize twitterAccessTokenSecret], accessTokenSecret, @"Does Not Match");
    GHAssertEqualStrings([Socialize twitterScreenName], screenName, @"Does Not Match");
}

- (void)testCompletingTwitterAuthSendsCredentialsToSocializeIfSessionValid {
    
    // Twitter session already valid
    [[[self.mockSocialize stub] andReturnBool:YES] twitterSessionValid];

    // Not already authed
    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticatedWithThirdParty];
    
    // Should send store credentials to Socialize server
    [[self.mockSocialize expect] authenticateViaTwitterWithStoredCredentials];

    [self.twitterAuthenticator baseViewControllerDidFinish:self.mockTwitterAuthViewController];
}

- (void)testCancellingNotifiesDelegateOfError {

    // Should dismiss on our modal target
    [[self.mockPresentationTarget expect] dismissModalViewControllerAnimated:YES];
    
    
    // Cancel
    [self prepare];
    [self.twitterAuthenticator baseViewControllerDidCancel:self.mockTwitterAuthViewController];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void)testCompletingSocializeAuthenticationNotifiesDelegateOfSuccess {
    // Twitter session already valid
    [[[self.mockSocialize stub] andReturnBool:YES] twitterSessionValid];
    
    // Already authed
    [[[self.mockSocialize stub] andReturnBool:YES] isAuthenticatedWithThirdParty];
    
    // Should dismiss on our modal target
    [[self.mockPresentationTarget expect] dismissModalViewControllerAnimated:YES];
    
    [self prepare];
    [self.twitterAuthenticator didAuthenticate:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void)twitterAuthenticatorDidSucceed:(SocializeTwitterAuthenticator *)twitterAuthenticator {
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)testDefaultTwitterAuthViewController {
    self.twitterAuthenticator.twitterAuthViewController = nil;
    SocializeTwitterAuthViewController *controller = self.twitterAuthenticator.twitterAuthViewController;
    
    GHAssertEquals(controller.delegate, [(id)self.twitterAuthenticator realObject], @"Bad delegate");
}

- (void)testFailingSocializeServiceCausesFailure {
    [[self.mockPresentationTarget expect] dismissModalViewControllerAnimated:YES];
    [self prepare];
    [self.twitterAuthenticator service:nil didFail:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}
#endif                                                                        
@end
