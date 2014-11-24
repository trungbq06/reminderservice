//
//  ViewController.h
//  ReminderService
//
//  Created by Mr Trung on 11/17/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#define kSuccess 200

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnFacebookClick:(id)sender;
- (IBAction)btnTwitterClick:(id)sender;
- (IBAction)btnSignInClick:(id)sender;
- (IBAction)btnRegisterClick:(id)sender;

@end

