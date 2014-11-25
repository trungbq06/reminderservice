//
//  AddReminderViewController.h
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddReminderViewController : UIViewController < UITextFieldDelegate >

@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtRenewalDate;
@property (weak, nonatomic) IBOutlet UITextField *txtProvider;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtNotes;

- (IBAction)btnAddClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;

@end
