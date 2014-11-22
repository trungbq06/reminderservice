//
//  DashboardTableViewCell.h
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dueDay;
@property (weak, nonatomic) IBOutlet UILabel *peopleWith;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
