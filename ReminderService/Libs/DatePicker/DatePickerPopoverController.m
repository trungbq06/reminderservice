//
//  DatePickerPopoverController.m
//  ReminderService
//
//  Created by Mr Trung on 11/25/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "DatePickerPopoverController.h"

@implementation DatePickerPopoverController

- (id) initWithTitle:(NSString *)_poptitle selectedDate:(id)selected contentFrame:(CGRect)contentFrame delegate:(id)delegate output:(UITextField *)output direction:(UIPopoverArrowDirection) direction {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        self.view.frame = contentFrame;
        
        _selectedDate = selected;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setFrame:CGRectMake(0, 44, 300, 300)];
        
        if (![selected isEqualToString:@""])
            _datePicker.date = [dateFormatter dateFromString:_selectedDate];
        
        _datePicker.datePickerMode = UIDatePickerModeDate;
//        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_datePicker];
        
        _pickerTitle = _poptitle;
        _contentFrame = contentFrame;
        _delegate = delegate;
        _output = output;
        _direction = direction;
        
        UIDatePicker *datePicker=[[UIDatePicker alloc]init];//Date picker
        datePicker.frame=CGRectMake(0,44,320, 216);
        datePicker.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:datePicker];
        
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 5, 80, 30)];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doneButton];
        
//        UIViewController *popoverContent = [[UIViewController alloc] init];
//        popoverContent.view.frame = _contentFrame;
//        [popoverContent.view addSubview:datePicker];
        
//        _datePopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
//        [_datePopoverController setPopoverContentSize:_contentFrame.size animated:YES];
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) showPopoverPickerInView:(UIView *)_pView
{
//    [_datePopoverController presentPopoverFromRect: CGRectMake(_contentFrame.origin.x , _contentFrame.origin.y, 0, 0) inView:_pView permittedArrowDirections: _direction animated: NO];
//    [_pView addSubview:_datePicker];
    [_pView addSubview:self.view];
}

#pragma mark - DATE PICKER CHANGE
- (void) dateChanged:(id) sender
{
    NSDate * dateSelected = ((UIDatePicker *) sender).date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSLog(@"Date changed %@", dateSelected);
}

- (IBAction)doneClicked:(id)sender
{
    [_datePopoverController dismissPopoverAnimated:YES];
    
    [self.view removeFromSuperview];
}

@end
