//
//  TypeTableViewController.h
//  ReminderService
//
//  Created by Mr Trung on 11/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeTableViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) IBOutlet UITableView    *tableView;

- (IBAction)btnBackClick:(id)sender;

@end
