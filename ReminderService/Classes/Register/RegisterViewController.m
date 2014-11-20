//
//  RegisterViewController.m
//  ReminderService
//
//  Created by Mr Trung on 11/20/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworkingSingleton.h"
#import "SVProgressHUD.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VALIDATE DATA
- (BOOL) validateInput {
    NSString *title = _txtTitle.text;
    NSString *firstName = _txtFirstname.text;
    NSString *surName = _txtSurname.text;
    NSString *mobile = _txtMobile.text;
    NSString *password = _txtPassword.text;
    NSString *email = _txtEmail.text;
    NSString *cEmail = _txtConfirmEmail.text;
    
    if ([title isEqualToString:@""]) {
        [self showAlert:@"Please enter title"];
        return FALSE;
    }
    if ([firstName isEqualToString:@""]) {
        [self showAlert:@"Please enter first name"];
        return FALSE;
    }
    if ([surName isEqualToString:@""]) {
        [self showAlert:@"Please enter surname"];
        return FALSE;
    }
    if (![self isValidEmail:email]) {
        [self showAlert:@"Wrong email address"];
        return FALSE;
    }
    if (![self isValidEmail:cEmail]) {
        [self showAlert:@"Wrong confirm email address"];
        return FALSE;
    }
    if (![email isEqualToString:cEmail]) {
        [self showAlert:@"Confirm email is wrong"];
        return FALSE;
    }
    if (![self isValidMobile:mobile]) {
        [self showAlert:@"Please enter valid mobile number"];
        return FALSE;
    }
    if ([password isEqualToString:@""]) {
        [self showAlert:@"Please enter password"];
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) isValidMobile:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @"[0-9]+";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) showAlert:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - BUTTON CLICK
- (IBAction)btnLoginClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnRegisterClick:(id)sender {
    if ([self validateInput]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        [[AFNetworkingSingleton sharedClient] getPath:@"http://topapp.us/quiz/products" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Load done");
            
            [SVProgressHUD dismiss];
            
            [self showAlert:@"Register successfully"];
            [self.navigationController popViewControllerAnimated:TRUE];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (IBAction)btnAgreeClick:(id)sender {
}

@end
