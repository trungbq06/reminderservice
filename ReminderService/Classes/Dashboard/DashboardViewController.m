//
//  DashboardViewController.m
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardTableViewCell.h"
#import "RenewalViewController.h"
#import "AFNetworkingSingleton.h"
#import "SVProgressHUD.h"
#import "AddReminderViewController.h"

#define kCellIdentifier @"CellIdentifier"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"DashboardTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = [UIColor clearColor];
    
    _lessData = [[NSMutableArray alloc] initWithCapacity:0];
    _largeData = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:userId forKey:@"user_id"];
    
    [[AFNetworkingSingleton sharedClient] getPath:@"http://topapp.us/renewal/list" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [_lessData removeAllObjects];
        [_largeData removeAllObjects];
        
        NSDictionary *result = [responseObject objectForKey:@"result"];
        
        if ([result count] > 0) {
            [_lessData addObjectsFromArray:[result objectForKey:@"less"]];
            
            [_largeData addObjectsFromArray:[result objectForKey:@"large"]];
        }
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [self showAlert:@"Error" message:[error localizedDescription]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showAlert: (NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

# pragma mark - TABLE VIEW DATA SOURCE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == 0) {
        title = @"RENEWALS WITHIN 30 DAYS";
    } else {
        title =  @"RENEWALS OVER A MONTH AWAY";
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 40)];
    label.text = title;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    
    [view addSubview:label];
    
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"RENEWALS WITHIN 30 DAYS";
    } else {
        return @"RENEWALS OVER A MONTH AWAY";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_lessData count];
    } else {
        return [_largeData count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    NSDictionary *currObject = nil;
    
    if ([_lessData count] > 0 || [_largeData count] > 0) {
        if (indexPath.section == 0) {
            currObject = [_lessData objectAtIndex:indexPath.row];
        } else {
            currObject = [_largeData objectAtIndex:indexPath.row];
        }
        
        cell.title.text = [currObject objectForKey:@"type"];
        cell.dueDay.text = [NSString stringWithFormat:@"%d DAYS", [[currObject objectForKey:@"due"] intValue]];
        NSString *provider = [currObject objectForKey:@"provider"];
        if ([provider isEqualToString:@""])
            cell.peopleWith.hidden = YES;
        else
            cell.peopleWith.text = [NSString stringWithFormat:@"%@", [currObject objectForKey:@"provider"]];
        
        int _typeId = [[currObject objectForKey:@"type_id"] intValue];
        [cell.imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"type_%d", _typeId]]];
//        cell.type = [NSString stringWithFormat:@"type_%d_bg", _typeId];
        cell.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"type_%d_bg", _typeId]];
//        [cell.bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"type_%d_bg", _typeId]]]];
        
//        CGRect cellFrame = cell.frame;
//        cell.rightImg.frame = CGRectMake(cellFrame.size.width - 100, 0, 100, cell.rightImg.frame.size.height);
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RenewalViewController *renewal = [[RenewalViewController alloc] initWithNibName:@"RenewalViewController" bundle:nil];
    
    NSDictionary *currObject = nil;
    if (indexPath.section == 0) {
        currObject = [_lessData objectAtIndex:indexPath.row];
    } else {
        currObject = [_largeData objectAtIndex:indexPath.row];
    }
//
//    [renewal setRenewal:currObject];
    renewal.renewalId = [[currObject objectForKey:@"id"] intValue];
    
    [self.navigationController pushViewController:renewal animated:YES];
}

- (IBAction)btnMenuClick:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

- (IBAction)btnAddClick:(id)sender {
    AddReminderViewController *reminderController = [[AddReminderViewController alloc] initWithNibName:@"AddReminderViewController" bundle:nil];
    
    [self.navigationController pushViewController:reminderController animated:YES];
}

@end
