//
//  MenuViewController.m
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "MenuViewController.h"
#import "MainViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "ProfileViewController.h"

#define kUserEmail @"user_email"
#define kUserPassword @"user_password"

@interface MenuViewController ()

@end

@implementation MenuViewController

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

- (IBAction)profileClick:(id)sender {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    
    MenuViewController *menuController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:profile];
    navController.navigationBarHidden = TRUE;
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navController
                                                    leftMenuViewController:menuController
                                                    rightMenuViewController:nil];
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:container];
}

- (IBAction)webSiteClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.comparewithus.com"]];
}

- (IBAction)logoutClick:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserEmail];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserPassword];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"keep"];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    MainViewController *mainController = (MainViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    navController.navigationBarHidden = YES;
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:navController];
}
@end
