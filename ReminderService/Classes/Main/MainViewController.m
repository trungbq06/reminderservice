//
//  ViewController.m
//  ReminderService
//
//  Created by Mr Trung on 11/17/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "MainViewController.h"
#import <Accounts/Accounts.h>
#import "PasswordViewController.h"
#import "RegisterViewController.h"
#import "FHSTwitterEngine.h"
#import "AppDelegate.h"
#import "AFNetworkingSingleton.h"
#import "SVProgressHUD.h"

// The twitter API key you setup in the Twitter developer console
static NSString * const kTwitterAPIKey = @"KOW7ZDftiz1nn1DpMOEsELnkb";
static NSString * const kTwitterSecretKey = @"EKsolzE25JCONdI6NfiaTX51W8TNqnAMtfAS0fckohAGJKkB3M";

@interface MainViewController () <FHSTwitterEngineAccessTokenDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self loggedIn];
//                PasswordViewController *forgetController = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController" bundle:nil];
//                
//                [self.navigationController pushViewController:forgetController animated:YES];
            }];
        }
    }
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:kTwitterAPIKey andSecret:kTwitterSecretKey];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
}

- (void)loggedIn {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Successfull Logged In" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnFacebookClick:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self loggedIn];
        }];
    }
}

- (IBAction)btnTwitterClick:(id)sender {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(@"%@", [FHSTwitterEngine sharedEngine].authenticatedUsername);
        
        [self loggedIn];
        
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (IBAction)btnSignInClick:(id)sender {
    
}

- (IBAction)btnRegisterClick:(id)sender {
    RegisterViewController *registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    
    [self.navigationController pushViewController:registerController animated:YES];
}

#pragma mark - FHSTwitter Engine
/*
- (void)handleTwitterAccounts:(NSArray *)twitterAccounts
{
    switch ([twitterAccounts count]) {
        case 0:
        {
            [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey: kTwitterAPIKey andSecret: kTwitterSecretKey];
            UIViewController *loginController = [[FHSTwitterEngine sharedEngine] loginControllerWithCompletionHandler:^(BOOL success) {
                if (success) {
                    // Login User
                }
            }];
            [self presentViewController:loginController animated:YES completion:nil];
            
        }
            break;
        case 1:
            [self onUserTwitterAccountSelection:twitterAccounts[0]];
            break;
        default:
            self.twitterAccounts = twitterAccounts;
            [self displayTwitterAccounts:twitterAccounts];
            break;
    }
    
}
*/
@end
