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
        _selectedDate = selected;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 300, 300)];
        _datePicker.date = [dateFormatter dateFromString:_selectedDate];
        [self.view addSubview:_datePicker];
        
        _pickerTitle = _poptitle;
        _contentFrame = contentFrame;
        _delegate = delegate;
        _output = output;
        _direction = direction;
        
    }
    
    return self;
}

- (void) showPopoverPickerInView:(UIView *)_view
{
    CGRect _frame = self.contentFrame;
    _frame.origin.x = 0;
    _frame.origin.y = 0;
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 5, 40, 30)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    _datePopoverController = [[UIPopoverController alloc] initWithContentViewController:self];
    [_datePopoverController setPopoverContentSize:_contentFrame.size animated:YES];
    [_datePopoverController presentPopoverFromRect: CGRectMake(_contentFrame.origin.x , _contentFrame.origin.y, 0, 0) inView:self.view permittedArrowDirections: _direction animated: YES];
}

#pragma mark - DONE CLICKED
- (IBAction)doneClicked:(id)sender
{
    
}

@end
