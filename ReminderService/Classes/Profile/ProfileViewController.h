//
//  ProfileViewController.h
//  ReminderService
//
//  Created by TrungBQ on 12/7/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController < UITextFieldDelegate >

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UITextField *txtSurename;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;

@property (nonatomic, assign) int                userId;

@property (nonatomic, retain) NSMutableArray             *typeData;
@property (nonatomic, retain) IBOutlet UITableView       *tableView;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnSaveClick:(id)sender;

@end
