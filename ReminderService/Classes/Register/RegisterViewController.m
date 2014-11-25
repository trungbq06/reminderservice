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

#define kSuccess 200

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
        [self showAlertError:@"Please enter title"];
        return FALSE;
    }
    if ([firstName isEqualToString:@""]) {
        [self showAlertError:@"Please enter first name"];
        return FALSE;
    }
    if ([surName isEqualToString:@""]) {
        [self showAlertError:@"Please enter surname"];
        return FALSE;
    }
    if (![self isValidEmail:email]) {
        [self showAlertError:@"Wrong email address"];
        return FALSE;
    }
    if (![self isValidEmail:cEmail]) {
        [self showAlertError:@"Email address confirmation incorrect"];
        return FALSE;
    }
    if (![email isEqualToString:cEmail]) {
        [self showAlertError:@"Confirm email is wrong"];
        return FALSE;
    }
    if (![self isValidMobile:mobile]) {
        [self showAlertError:@"Please enter valid mobile number"];
        return FALSE;
    }
    if ([password isEqualToString:@""]) {
        [self showAlertError:@"Please enter password"];
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

-(void) showAlertError:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void) showAlert: (NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - BUTTON CLICK
- (IBAction)btnLoginClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnRegisterClick:(id)sender {
    if ([self validateInput]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSString *title = _txtTitle.text;
        NSString *firstName = _txtFirstname.text;
        NSString *surName = _txtSurname.text;
        NSString *mobile = _txtMobile.text;
        NSString *password = _txtPassword.text;
        NSString *email = _txtEmail.text;
        
        [params setObject:title forKey:@"title"];
        [params setObject:firstName forKey:@"first_name"];
        [params setObject:surName forKey:@"surname"];
        [params setObject:mobile forKey:@"mobile"];
        [params setObject:password forKey:@"password"];
        [params setObject:email forKey:@"email"];
        
        [[AFNetworkingSingleton sharedClient] postPath:@"http://topapp.us/user/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            NSDictionary *result = (NSDictionary*) responseObject;
            int errorCode = [[result objectForKey:@"error_code"] intValue];
            NSString *errorMsg = [result objectForKey:@"error_msg"];
            
            if (errorCode == kSuccess) {
                [self showAlert:@"Register" message:@"Register successfully. You can login now !"];
                
                [self.navigationController popViewControllerAnimated:TRUE];
            } else {
                [self showAlert:@"Register" message:[NSString stringWithFormat:@"Register error. %@!", errorMsg]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (IBAction)btnAgreeClick:(id)sender {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
