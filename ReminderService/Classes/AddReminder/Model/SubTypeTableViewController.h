//
//  TypeTableViewController.h
//  ReminderService
//
//  Created by Mr Trung on 11/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTypeTableViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) IBOutlet UITableView    *tableView;
@property (nonatomic, retain) NSString *selectCate;
@property (nonatomic, retain) NSMutableDictionary *typeData;

- (IBAction)btnBackClick:(id)sender;

@end
