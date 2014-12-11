//
//  RenewalViewController.m
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "RenewalViewController.h"
#import "AddReminderViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworkingSingleton.h"

@interface RenewalViewController ()

@end

@implementation RenewalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    [_dueDay setText:[NSString stringWithFormat:@"%@ days", [_renewal objectForKey:@"due"]]];
    [_lbTitle setText:[_renewal objectForKey:@"type"]];
    [_startDate setText:[_renewal objectForKey:@"start_date"]];
    [_renewalDate setText:[_renewal objectForKey:@"renewal_date"]];
    [_provider setText:[_renewal objectForKey:@"provider"]];
    [_provider2 setText:[_renewal objectForKey:@"provider"]];
    [_price setText:[_renewal objectForKey:@"price"]];
    [_notes setText:[_renewal objectForKey:@"notes"]];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void) loadData {
    NSString *urlGet = [NSString stringWithFormat:@"http://topapp.us/renewal/view?id=%d", _renewalId];
    
    [[AFNetworkingSingleton sharedClient] getPath:urlGet parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [responseObject objectForKey:@"result"];
        
        _typeId = [[result objectForKey:@"type_id"] intValue];
        _lbTitle.text = [result objectForKey:@"type"];
        _startDate.text = [result objectForKey:@"start_date"];
        _renewalDate.text = [result objectForKey:@"renewal_date"];
        _provider.text = [result objectForKey:@"provider"];
        _price.text = [result objectForKey:@"price"];
        _notes.text = [result objectForKey:@"notes"];
        _dueDay.text = [NSString stringWithFormat:@"%d DAYS", [[result objectForKey:@"due"] intValue]];
        
        [_typeIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"type_%d", _typeId]]];
        [_typeView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"type_%d_bg", _typeId]]]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEditClick:(id)sender {
    AddReminderViewController *reminderController = [[AddReminderViewController alloc] initWithNibName:@"AddReminderViewController" bundle:nil];
    reminderController.renewalId = _renewalId;
    reminderController.typeId = _typeId;
    
    [self.navigationController pushViewController:reminderController animated:YES];
}

-(void) showAlert: (NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)btnDeleteClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure to delete ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [params setObject:[NSNumber numberWithInt:_renewalId] forKey:@"id"];
        
        [[AFNetworkingSingleton sharedClient] postPath:@"http://topapp.us/renewal/delete" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            NSDictionary *result = (NSDictionary*) responseObject;
            int errorCode = [[result objectForKey:@"error_code"] intValue];
            
            if (errorCode == kSuccess) {
//                [self showAlert:@"Delete" message:@"Deleted successfully"];
                
                [self.navigationController popViewControllerAnimated:TRUE];
            } else {
                [self showAlert:@"Delete" message:[NSString stringWithFormat:@"Delete error. There is some error with server!"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

@end
