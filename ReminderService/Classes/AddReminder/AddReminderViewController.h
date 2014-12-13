//
//  AddReminderViewController.h
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeTableViewController.h"

@interface AddReminderViewController : UIViewController < UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtRenewalDate;
@property (weak, nonatomic) IBOutlet UITextField *txtProvider;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtNotes;

@property (nonatomic, retain) UIView            *dateView;
@property (nonatomic, retain) UIDatePicker      *datePicker;
@property (nonatomic, retain) UITextField       *currTextField;

@property (nonatomic, assign) int               renewalId;
@property (nonatomic, assign) int               typeId;
@property (nonatomic, retain) TypeTableViewController *typeController;
@property (nonatomic, retain) NSMutableArray    *typeData;
@property (nonatomic, retain) IBOutlet UITableView       *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;

- (IBAction)btnAddClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;

@end
