//
//  TypeTableViewController.m
//  ReminderService
//
//  Created by Mr Trung on 11/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "SubTypeTableViewController.h"
#import "AppDelegate.h"

@interface SubTypeTableViewController ()

@end

@implementation SubTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _typeData = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSArray *home = [NSArray arrayWithObjects:@"Boiler Cover", @"Home Emergency Cover", @"Home Insurance", @"Landlord Insurance", nil];
    [_typeData setObject:home forKey:@"Home"];
    
    NSArray *insurance = [NSArray arrayWithObjects:@"Boiler Cover", @"Car Insurance", @"Caravan Insurance", @"Health Insurance", @"Gadget Insurance", @"Landlord Insurance", @"Business Insurance", @"Home Insurance", @"Life Insurance", @"Motorbike Insurance", @"Travel Insurance (Multi Trip)", @"Travel Insurance (Single Trip)", @"BusineVanss Insurance", nil];
    [_typeData setObject:insurance forKey:@"Insurance"];
    
    NSArray *lifeStyle = [NSArray arrayWithObjects:@"Health Insurance", @"Mobile Phone Contract", @"Life Insurance", @"Pet Insurance", nil];
    [_typeData setObject:lifeStyle forKey:@"Lifestyle"];
    
    NSArray *monitoring = [NSArray arrayWithObjects:@"Car Breakdown Cover", @"Car Leasing Contract", @"Car Insurance", @"Car MOT", @"Car Road Tax", @"Car Servicing", @"Motorbike Insurance", @"Motorbike MOT", @"Motorbike Road Tax", @"Motorbike Servicing", @"Van Breakdown Cover", @"Van Insurance", @"Van Leasing Contract", @"Van MOT", @"Van Road Tax", @"Van Servicing", nil];
    [_typeData setObject:monitoring forKey:@"Motoring"];
    
    NSArray *travel = [NSArray arrayWithObjects: @"Travel Insurance (Multi Trip)", @"Travel Insurance (Single Trip)", @"Caravan Insurance", nil];
    [_typeData setObject:travel forKey:@"Travel"];
    
    NSArray *service = [NSArray arrayWithObjects:@"Broadband", @"Digital TV Service", @"Gadget Insurance", nil];
    [_typeData setObject:service forKey:@"Utilities & Service"];
    
    _data = [[NSMutableArray alloc] initWithArray:[_typeData objectForKey:_selectCate]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TypeCell"];
    }
    
    NSString *type = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = type;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sType = [_data objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:sType forKey:@"s_type"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: _typeId] forKey:@"type_id"];
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:[viewControllers count] - 3] animated:NO];
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
