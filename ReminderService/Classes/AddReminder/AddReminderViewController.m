//
//  AddReminderViewController.m
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "AddReminderViewController.h"
#import "DatePickerPopoverController.h"
#import "AFNetworkingSingleton.h"
#import "SVProgressHUD.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
//    _txtStartDate.leftView = paddingView;
//    _txtStartDate.leftViewMode = UITextFieldViewModeAlways;
//    
//    _txtPrice.leftView = paddingView;
//    _txtPrice.leftViewMode = UITextFieldViewModeAlways;
//    
//    _txtProvider.leftView = paddingView;
//    _txtProvider.leftViewMode = UITextFieldViewModeAlways;
//    
//    _txtRenewalDate.leftView = paddingView;
//    _txtRenewalDate.leftViewMode = UITextFieldViewModeAlways;
//    
//    _txtType.leftView = paddingView;
//    _txtType.leftViewMode = UITextFieldViewModeAlways;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) showAlert: (NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    [SVProgressHUD dismiss];
}

- (IBAction)btnAddClick:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *type = _txtType.text;
    NSString *startDate = _txtStartDate.text;
    NSString *renewalDate = _txtRenewalDate.text;
    NSString *provider = _txtProvider.text;
    NSString *price = _txtPrice.text;
    NSString *notes = _txtNotes.text;
    
    if ([type isEqualToString:@""]) {
        [self showAlert:@"Error" message:@"Please enter Type"];
        return;
    }
    if ([startDate isEqualToString:@""]) {
        [self showAlert:@"Error" message:@"Please enter Start Date"];
        return;
    }
    if ([renewalDate isEqualToString:@""]) {
        [self showAlert:@"Error" message:@"Please enter Renewal Date"];
        return;
    }
    if ([provider isEqualToString:@""]) {
        [self showAlert:@"Error" message:@"Please enter Provider"];
        return;
    }
    if ([price isEqualToString:@""]) {
        [self showAlert:@"Error" message:@"Please enter Price"];
        return;
    }
    if ([notes isEqualToString:@""]) {
        [self showAlert:@"Error" message:@"Please enter Notes"];
        return;
    }
    
    [params setObject:type forKey:@"type"];
    [params setObject:startDate forKey:@"start_date"];
    [params setObject:renewalDate forKey:@"renewal_date"];
    [params setObject:provider forKey:@"provider"];
    [params setObject:price forKey:@"price"];
    [params setObject:notes forKey:@"notes"];
    
    [[AFNetworkingSingleton sharedClient] postPath:@"http://topapp.us/renewal/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *result = (NSDictionary*) responseObject;
        int errorCode = [[result objectForKey:@"error_code"] intValue];
        NSString *errorMsg = [result objectForKey:@"error_msg"];
        
        if (errorCode == kSuccess) {
            [self showAlert:@"Add Renewal" message:@"Added successfully !"];
            
            [self.navigationController popViewControllerAnimated:TRUE];
        } else {
            [self showAlert:@"Add Renewal" message:[NSString stringWithFormat:@"Add error. %@!", errorMsg]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [self showAlert:@"Add Renewal" message:[error localizedDescription]];
    }];
}

- (IBAction)btnCancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [_dateView removeFromSuperview];
}

- (void) initDatePicker {
    CGRect frame = self.view.frame;
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
    _dateView.backgroundColor = [UIColor whiteColor];
    
    _datePicker=[[UIDatePicker alloc]init];
    _datePicker.frame=CGRectMake(0,0,320, 216);
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *currDate = [NSDate date];
    
    NSString *txtDate = _currTextField.text;
    if ([txtDate isEqualToString:@""]) {
        _datePicker.date = currDate;
    } else {
        _datePicker.date = [formatter dateFromString:txtDate];
    }
    
    [_dateView addSubview:_datePicker];
    
    [self.view addSubview:_dateView];
}

- (void) dateChanged:(id) sender {
    NSDate * dateSelected = ((UIDatePicker *) sender).date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *strDate = [formatter stringFromDate:dateSelected];
    _currTextField.text = strDate;
}

#pragma mark - TEXTFIELD DELEGATE
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _txtStartDate || textField == _txtRenewalDate) {
        [self.view endEditing:YES];
        [_dateView removeFromSuperview];
        
        _currTextField = textField;
        [self initDatePicker];
        
        return NO;
    }
    
    return TRUE;
}

@end
