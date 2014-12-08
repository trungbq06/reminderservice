//
//  RegisterViewController.h
//  ReminderService
//
//  Created by Mr Trung on 11/20/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UITextField *txtSurname;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet UIView *registerBg;

- (IBAction)btnLoginClick:(id)sender;
- (IBAction)btnRegisterClick:(id)sender;
- (IBAction)btnAgreeClick:(id)sender;
- (IBAction)termClick:(id)sender;

@end
