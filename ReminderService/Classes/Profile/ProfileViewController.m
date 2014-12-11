//
//  ProfileViewController.m
//  ReminderService
//
//  Created by TrungBQ on 12/7/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "ProfileViewController.h"
#import "AFNetworkingSingleton.h"
#import "MenuViewController.h"
#import "DashboardViewController.h"
#import "SVProgressHUD.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    _typeData = [[NSMutableArray alloc] initWithObjects:@"Mr", @"Mrs", @"Miss", @"Mis", @"Doctor", nil];
    [_tableView reloadData];
    _tableView.hidden = YES;
    
    _userId = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserId] intValue];
    
    [[AFNetworkingSingleton sharedClient] getPath:[NSString stringWithFormat:@"http://topapp.us/user/view?id=%d", _userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *user = [responseObject objectForKey:@"user"];
        
        _txtTitle.text = [user objectForKey:@"title"];
        _txtEmail.text = [user objectForKey:@"email"];
        _txtFirstname.text = [user objectForKey:@"firstname"];
        _txtMobile.text = [user objectForKey:@"mobile"];
        _txtSurename.text = [user objectForKey:@"surname"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    _tableView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
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

- (BOOL) validateInput {
    NSString *title = _txtTitle.text;
    NSString *firstName = _txtFirstname.text;
    NSString *surName = _txtSurename.text;
    NSString *mobile = _txtMobile.text;
    NSString *email = _txtEmail.text;
    
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
    if (![mobile isEqualToString:@""] && ![self mobileAllow:mobile]) {
        [self showAlertError:@"Your contact number must start 01, 02, 07 or 08"];
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL) mobileAllow:(NSString *) checkString {
    NSString *two = [checkString substringWithRange:NSMakeRange(0, 2)];
    
    if (![two isEqualToString:@"01"] && ![two isEqualToString:@"02"] && ![two isEqualToString:@"07"] && ![two isEqualToString:@"08"]) {
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
    
    _txtTitle.text = sType;
    _tableView.hidden = YES;
}

- (IBAction)btnSaveClick:(id)sender {
    if ([self validateInput]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSString *title = _txtTitle.text;
        NSString *firstName = _txtFirstname.text;
        NSString *surName = _txtSurename.text;
        NSString *mobile = _txtMobile.text;
        NSString *email = _txtEmail.text;
        
        [params setObject:[NSNumber numberWithInt: _userId] forKey:@"id"];
        [params setObject:title forKey:@"title"];
        [params setObject:firstName forKey:@"first_name"];
        [params setObject:surName forKey:@"surname"];
        [params setObject:mobile forKey:@"mobile"];
        [params setObject:email forKey:@"email"];
        
        [[AFNetworkingSingleton sharedClient] postPath:@"http://topapp.us/user/save" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            NSDictionary *result = (NSDictionary*) responseObject;
            int errorCode = [[result objectForKey:@"error_code"] intValue];
            
            if (errorCode == kSuccess) {
                [self showAlert:@"Edit Profile" message:@"You’ve been successfully updated"];
            } else {
                [self showAlert:@"Edit Profile" message:[NSString stringWithFormat:@"Save error. There is problem with server!"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _txtTitle) {
        NSIndexPath *selected = [_tableView indexPathForSelectedRow];
        [_tableView deselectRowAtIndexPath:selected animated:NO];
        _tableView.hidden = NO;
        
        return NO;
    }
    
    return YES;
}

@end
