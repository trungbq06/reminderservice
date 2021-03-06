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
#import "MFSideMenuContainerViewController.h"
#import "MenuViewController.h"
#import "DashboardViewController.h"
#import "ProfileViewController.h"
#import "SVProgressHUD.h"

// The twitter API key you setup in the Twitter developer console
static NSString * const kTwitterAPIKey = @"KOW7ZDftiz1nn1DpMOEsELnkb";
static NSString * const kTwitterSecretKey = @"EKsolzE25JCONdI6NfiaTX51W8TNqnAMtfAS0fckohAGJKkB3M";

#define kUserEmail @"user_email"
#define kUserPassword @"user_password"
#define kFacebook 1
#define kTwitter  2

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
            }];
        }
    }
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:kTwitterAPIKey andSecret:kTwitterSecretKey];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    BOOL isKeep = [[NSUserDefaults standardUserDefaults] boolForKey:@"keep"];
    if (isKeep) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:kUserEmail];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPassword];
        
        if (email && password) {
            [params setObject:email forKey:@"email"];
            [params setObject:password forKey:@"password"];
            
            [self login:params];
        }
    }
}

- (void) updateDevice
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    
    if (![deviceToken isEqualToString:@""]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:deviceToken forKey:@"device_id"];
        [params setObject:userId forKey:@"user_id"];
        
        [[AFNetworkingSingleton sharedClient] postPath:@"http://topapp.us/user/device" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = (NSDictionary*) responseObject;
            int errorCode = [[result objectForKey:@"error_code"] intValue];
            
            if (errorCode == kSuccess) {
                NSLog(@"Created");
            } else {
                NSLog(@"Exist");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (void) updateUser:(NSString*) email username:(NSString*) username service: (int) service
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *title = @"";
    NSString *firstName = username;
    NSString *surName = @"";
    NSString *mobile = @"";
    NSString *password = @"";
    
    [params setObject:title forKey:@"title"];
    [params setObject:firstName forKey:@"firstname"];
    [params setObject:surName forKey:@"surname"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:password forKey:@"password"];
    [params setObject:email forKey:@"email"];
    [params setObject:[NSNumber numberWithInt:service] forKey:@"service"];
    
    [[AFNetworkingSingleton sharedClient] postPath:@"http://topapp.us/user/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *result = (NSDictionary*) responseObject;
        int errorCode = [[result objectForKey:@"error_code"] intValue];
        
        NSString *userId = [result objectForKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[userId intValue]] forKey:kUserId];
        
        if (errorCode == kSuccess) {
            NSLog(@"Created device");
        } else {
            NSLog(@"Device exist");
        }
        
        [self loggedIn];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)loggedIn {
    [self updateDevice];
    
    [self showDashboard];
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
            [FBSession setActiveSession:appDelegate.session];
            
            // and here we make sure to update our UX according to the new session state
            [FBRequestConnection startWithGraphPath:@"/v1.0/me"
                                         parameters:nil
                                         HTTPMethod:@"GET"
                                  completionHandler:^(
                                                      FBRequestConnection *connection,
                                                      NSDictionary *result,
                                                      NSError *error
                                                      ) {
                                      NSString* _fbName = [result objectForKey:@"name"];
                                      NSString* _fbEmail = [result objectForKey:@"email"];
                                      
                                      [self updateUser:_fbEmail username:_fbName service:kFacebook];
                                  }];
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
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *email = _txtEmail.text;
    NSString *password = _txtPassword.text;
    
    if ([email isEqualToString:@""]) {
        [self showAlert:@"Login Error" message:@"Please enter your email address"];
        return;
    }
    
    if ([password isEqualToString:@""]) {
        [self showAlert:@"Login Error" message:@"Please enter password"];
        return;
    }
    
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    
    [self login:params];
}

- (void) login:(NSDictionary*) params
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [[AFNetworkingSingleton sharedClient] postPath:@"http://topapp.us/user/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *result = (NSDictionary*) responseObject;
        int errorCode = [[result objectForKey:@"error_code"] intValue];
        NSString *userId = [result objectForKey:@"user_id"];
        
        if (errorCode == kSuccess) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[userId intValue]] forKey:kUserId];
            
            if (_btnKeep.selected) {
                // Save session
                [[NSUserDefaults standardUserDefaults] setObject:[params objectForKey:@"email"] forKey:kUserEmail];
                [[NSUserDefaults standardUserDefaults] setObject:[params objectForKey:@"password"] forKey:kUserPassword];
            }
            
            [self loggedIn];
        } else {
            [self showAlert:@"Error" message:@"Your details appear to be incorrect, please try again"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [self showAlert:@"Error" message:@"Your details appear to be incorrect, please try again"];
    }];
}

- (void) showDashboard {
    MenuViewController *menuController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];

    DashboardViewController *contentController = [[DashboardViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contentController];
    navController.navigationBarHidden = TRUE;
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navController
                                                    leftMenuViewController:menuController
                                                    rightMenuViewController:nil];
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:container];
}

-(void) showAlert:(NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)btnRegisterClick:(id)sender {
    RegisterViewController *registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    
    [self.navigationController pushViewController:registerController animated:YES];
}

- (IBAction)keepMeSignInClick:(id)sender {
    _btnKeep.selected = !_btnKeep.selected;
    
    [[NSUserDefaults standardUserDefaults] setBool:_btnKeep.selected forKey:@"keep"];
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
