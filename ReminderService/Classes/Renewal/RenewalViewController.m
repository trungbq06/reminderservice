//
//  RenewalViewController.m
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "RenewalViewController.h"
#import "AddReminderViewController.h"

@interface RenewalViewController ()

@end

@implementation RenewalViewController

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

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEditClick:(id)sender {
    AddReminderViewController *reminderController = [[AddReminderViewController alloc] initWithNibName:@"AddReminderViewController" bundle:nil];
    
    [self.navigationController pushViewController:reminderController animated:YES];
}

@end
