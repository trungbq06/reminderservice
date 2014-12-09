//
//  TypeTableViewController.m
//  ReminderService
//
//  Created by Mr Trung on 11/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "TypeTableViewController.h"
#import "SubTypeTableViewController.h"

@interface TypeTableViewController ()

@end

@implementation TypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _data = [[NSMutableArray alloc] initWithObjects:@"Home", @"Insurance", @"Lifestyle", @"Motoring", @"Travel", @"Utilities & Service", nil];
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
    
    SubTypeTableViewController *subController = [[SubTypeTableViewController alloc] initWithNibName:@"SubTypeTableViewController" bundle:nil];
    subController.selectCate = sType;
    [self.navigationController pushViewController:subController animated:TRUE];
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
