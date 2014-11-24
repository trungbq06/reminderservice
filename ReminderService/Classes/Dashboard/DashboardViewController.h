//
//  DashboardViewController.h
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"

@interface DashboardViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray     *lessData;
@property (nonatomic, retain) NSMutableArray     *largeData;

- (IBAction)btnMenuClick:(id)sender;
- (IBAction)btnAddClick:(id)sender;

@end
