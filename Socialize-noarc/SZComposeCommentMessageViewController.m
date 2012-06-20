//
//  SZComposeCommentViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/10/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SZComposeCommentMessageViewController.h"
#import "SocializeLocationManager.h"
#import "CommentMapView.h"
#import "UINavigationController+Socialize.h"
#import "_SZLinkDialogViewController.h"
#import "SocializeSubscriptionService.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"
#import "SZCommentUtils.h"
#import "SocializePrivateDefinitions.h"

@implementation SZComposeCommentMessageViewController
@synthesize commentObject = commentObject_;
@synthesize facebookButton = facebookButton_;
@synthesize delegate = delegate_;
@synthesize unsubscribeButton = unsubscribeButton_;
@synthesize dontSubscribeToDiscussion = dontSubscribeToDiscussion_;
@synthesize enableSubscribeButton = enabledSubscribeButton_;
@synthesize subscribeContainer = subscribeContainer_;
@synthesize twitterButton = twitterButton_;
@synthesize completionBlock = completionBlock_;

+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL delegate:(id<SZComposeCommentViewControllerDelegate>)delegate {
    SZComposeCommentMessageViewController *postCommentViewController = [self postCommentViewControllerWithEntityURL:entityURL];
    postCommentViewController.delegate = delegate;
    UINavigationController *navigationController = [UINavigationController socializeNavigationControllerWithRootViewController:postCommentViewController];
    return navigationController;    
}

+ (SZComposeCommentMessageViewController*)composeCommentViewControllerWithEntity:(id<SZEntity>)entity {
    return [[[self alloc] initWithEntity:entity] autorelease];
}

+ (SZComposeCommentMessageViewController*)postCommentViewControllerWithEntityURL:(NSString*)entityURL {
    SZComposeCommentMessageViewController *postCommentViewController = [[[SZComposeCommentMessageViewController alloc]
                                                       initWithEntityUrlString:entityURL]
                                                      autorelease];
    return postCommentViewController;
}

- (void)dealloc {
    self.facebookButton = nil;
    self.commentObject = nil;
    self.unsubscribeButton = nil;
    self.enableSubscribeButton = nil;
    self.subscribeContainer = nil;
    self.twitterButton = nil;

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"New Comment";
    [self addSocializeRoundedGrayButtonImagesToButton:self.unsubscribeButton];
    self.dontSubscribeToDiscussion = NO;
    
    if ([self.socialize isAuthenticated]) {
        [self configureForNewUser];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.facebookButton = nil;
    self.unsubscribeButton = nil;
    self.enableSubscribeButton = nil;
    self.subscribeContainer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configureMessageActionButtons {
    NSMutableArray *buttons = [NSMutableArray array];

    if ([self.socialize notificationsAreConfigured]) {
        [buttons addObject:self.enableSubscribeButton];
    } else {
        DebugLog(SOCIALIZE_NOTIFICATIONS_NOT_CONFIGURED_MESSAGE);
    }
    
    self.messageActionButtons = buttons;
}

- (void)executeAfterModalDismissDelay:(void (^)())block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, MIN_MODAL_DISMISS_INTERVAL * NSEC_PER_SEC), 
                   dispatch_get_main_queue(),
                   block);
}

- (void)dismissSelf {
    // In the case that the user just came back from the _SZLinkDialogViewController, and the 
    // socialize server finishes creating the comment before the modal dismissal animation has played,
    // we need to hack a delay for iOS5 or the second dismissal will not happen
    
    // Double animated dismissal does not work on iOS5 (but works in iOS4)
    // Allow previous modal dismisalls to complete. iOS5 added dismissViewControllerAnimated:completion:, which
    // we could also use for the previous dismissal, but this is a little simpler and lets us ignore version differences.
    [self executeAfterModalDismissDelay:^{
        [self stopLoadAnimation];
        [self dismissModalViewControllerAnimated:YES];
    }];
}

- (void)callCompletion {
    SZCommentOptions *options = [SZCommentOptions defaultOptions];
    options.dontShareLocation = ![[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey] boolValue];
    options.dontSubscribeToNotifications = self.dontSubscribeToDiscussion;

    self.completionBlock(self.commentTextView.text, options);
}

- (void)notifyDelegateOrDismissSelf {
    if ([self.delegate respondsToSelector:@selector(postCommentViewController:didCreateComment:)]) {
        [self executeAfterModalDismissDelay:^{
            [self stopLoadAnimation];
            [self.delegate postCommentViewController:self didCreateComment:self.commentObject];
        }];
    } else {
        [self dismissSelf];
    }
}

- (void)createComment {
    [self startLoading];
    
    SZCommentOptions *options = [SZCommentUtils userCommentOptions];
    options.dontSubscribeToNotifications = self.dontSubscribeToDiscussion;
    
    [SZCommentUtils addCommentWithDisplay:self entity:self.entity text:commentTextView.text options:options success:^(id<SZComment> comment) {
        self.commentObject = comment;
        [self notifyDelegateOrDismissSelf];
    } failure:^(NSError *error) {
        [self stopLoading];
        [self failWithError:error];
    }];
}

- (void)configureForNewUser {
    [self getSubscriptionStatus];
}

- (void)afterLoginAction:(BOOL)userChanged {
    [super afterLoginAction:userChanged];
    
    [self configureMessageActionButtons];
    
    if (userChanged) {
        [self configureForNewUser];
    }
}

-(void)sendButtonPressed:(UIButton*)button {
    if (self.completionBlock != nil) {
        [self callCompletion];
    } else {
        [self createComment];
    }
}

- (void)setDontSubscribeToDiscussion:(BOOL)dontSubscribeToDiscussion {
    dontSubscribeToDiscussion_ = dontSubscribeToDiscussion;
    self.enableSubscribeButton.selected = !self.dontSubscribeToDiscussion;
}

-(IBAction)enableSubscribeButtonPressed:(id)sender {

    if (self.dontSubscribeToDiscussion) {
        [self setDontSubscribeToDiscussion:NO];
        [self setSubviewForLowerContainer:self.subscribeContainer];
    } else {
        if ([commentTextView isFirstResponder]) 
        {
            [self setSubviewForLowerContainer:self.subscribeContainer];
            [commentTextView resignFirstResponder];          
        }
        else
        {
            [commentTextView becomeFirstResponder];
        }            
    }
}

-(IBAction)unsubscribeButtonPressed:(id)sender {
    [self setDontSubscribeToDiscussion:YES];
    [commentTextView becomeFirstResponder];
}

-(void)authorizationSkipped {
    [self createComment];    
}

- (BOOL)elementsHaveInactiveSubscription:(NSArray*)elements {
    for (id<SocializeSubscription> subscription in elements) {
        if (![subscription subscribed]) {
            return YES;
        }
    }
    
    return NO;
}

-(void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    if ([service isKindOfClass:[SocializeSubscriptionService class]]) {
        // The only time we want the button off is if they have previously posted without subscription
        BOOL subscribeHasBeenDisabled = [self elementsHaveInactiveSubscription:dataArray];
        self.enableSubscribeButton.enabled = YES;
        [self setDontSubscribeToDiscussion:subscribeHasBeenDisabled];
        
    } else {
        [super service:service didFetchElements:dataArray];
    }
}

- (void)getSubscriptionStatus {
    self.enableSubscribeButton.enabled = NO;
    [self.socialize getSubscriptionsForEntityKey:self.entity.key first:nil last:nil];
}


@end
