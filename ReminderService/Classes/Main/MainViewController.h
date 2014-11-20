//
//  ViewController.h
//  ReminderService
//
//  Created by Mr Trung on 11/17/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtEmail;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtPassword;

- (IBAction)btnFacebookClick:(id)sender;
- (IBAction)btnTwitterClick:(id)sender;
- (IBAction)btnSignInClick:(id)sender;
- (IBAction)btnRegisterClick:(id)sender;

@end

