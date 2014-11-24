//
//  RenewalViewController.h
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenewalViewController : UIViewController

@property (nonatomic, retain) NSDictionary *renewal;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *dueDay;
@property (weak, nonatomic) IBOutlet UILabel *provider;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *renewalDate;
@property (weak, nonatomic) IBOutlet UILabel *provider2;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITextView *notes;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnEditClick:(id)sender;
@end
