//
//  AddReminderViewController.m
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "AddReminderViewController.h"
#import "AFNetworkingSingleton.h"
#import "SVProgressHUD.h"

@interface AddReminderViewController ()

@end

#define kSuccess 200

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
            [self showAlert:@"Add Renewal" message:@"Added successfully. You can login now !"];
            
            [self.navigationController popViewControllerAnimated:TRUE];
        } else {
            [self showAlert:@"Add Renewal" message:[NSString stringWithFormat:@"Add error. %@!", errorMsg]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (IBAction)btnCancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
