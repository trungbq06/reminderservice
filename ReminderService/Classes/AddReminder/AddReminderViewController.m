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
    _txtStartDate.leftView = paddingView;
    _txtStartDate.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txtPrice.leftView = paddingView2;
    _txtPrice.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txtProvider.leftView = paddingView3;
    _txtProvider.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txtRenewalDate.leftView = paddingView4;
    _txtRenewalDate.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txtType.leftView = paddingView5;
    _txtType.leftViewMode = UITextFieldViewModeAlways;
    
    _typeData = [[NSMutableArray alloc] initWithObjects:@"Mr", @"Mrs", @"Miss", @"Mis", @"Doctor", nil];
    [_tableView reloadData];
    _tableView.hidden = YES;
    
    if (_renewalId > 0) {
        [self loadData];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *sType = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_type"];

    if (sType)
        _txtType.text = sType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_typeData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TypeCell"];
    }
    
    NSString *type = [_typeData objectAtIndex:indexPath.row];
    cell.textLabel.text = type;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sType = [_typeData objectAtIndex:indexPath.row];
    
    _txtType.text = sType;
    _tableView.hidden = YES;
}

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
    [params setObject:[NSNumber numberWithInt:_renewalId] forKey:@"id"];
    
    NSString *url = @"http://topapp.us/renewal/create";
    if (_renewalId > 0) {
        url = @"http://topapp.us/renewal/edit";
    }
    [[AFNetworkingSingleton sharedClient] postPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *result = (NSDictionary*) responseObject;
        int errorCode = [[result objectForKey:@"error_code"] intValue];
        NSString *errorMsg = [result objectForKey:@"error_msg"];
        
        if (errorCode == kSuccess) {
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
    _tableView.hidden = YES;
}

#pragma mark - Load data
- (void) loadData {
    NSString *urlGet = [NSString stringWithFormat:@"http://topapp.us/renewal/view?id=%d", _renewalId];
    
    [[AFNetworkingSingleton sharedClient] getPath:urlGet parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [responseObject objectForKey:@"result"];
        
        _txtType.text = [result objectForKey:@"type"];
        _txtStartDate.text = [result objectForKey:@"start_date"];
        _txtRenewalDate.text = [result objectForKey:@"renewal_date"];
        _txtProvider.text = [result objectForKey:@"provider"];
        _txtPrice.text = [result objectForKey:@"price"];
        _txtNotes.text = [result objectForKey:@"notes"];
        
        _txtStartDate.userInteractionEnabled = NO;
        _txtRenewalDate.userInteractionEnabled = NO;
        [_btnAdd setTitle:@"Save" forState:UIControlStateNormal];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
    [formatter setDateFormat:@"dd-MM-YYYY"];
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
    [formatter setDateFormat:@"dd-MM-YYYY"];
    
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
    } else if (textField == _txtType) {
        NSIndexPath *selected = [_tableView indexPathForSelectedRow];
        [_tableView deselectRowAtIndexPath:selected animated:NO];
        _tableView.hidden = NO;
        
        return NO;
    }
    
    return TRUE;
}

@end
