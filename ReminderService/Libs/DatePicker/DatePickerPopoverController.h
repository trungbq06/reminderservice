//
//  DatePickerPopoverController.h
//  ReminderService
//
//  Created by Mr Trung on 11/25/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerPopoverControllerDelegate <NSObject>

- (void) datePickerSelected:(NSString*)selectedStr output:(id)output;

@end

@interface DatePickerPopoverController : UIViewController

@property (nonatomic, retain) NSString *selectedDate;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, assign) UIPopoverArrowDirection direction;

@property (nonatomic) CGRect contentFrame;
@property (nonatomic, retain) UIPopoverController* datePopoverController;
@property (nonatomic, retain) id output;
@property (nonatomic, retain) NSString* pickerTitle;
@property (assign, nonatomic) NSObject <DatePickerPopoverControllerDelegate>* delegate;

- (id) initWithTitle:(NSString*)_poptitle
       selectedDate:(id)selected
        contentFrame:(CGRect)contentFrame
            delegate:(id)delegate
              output:(UITextField*)output
           direction:(UIPopoverArrowDirection) direction;

- (void) showPopoverPickerInView:(UIView*)_pView;

@end
