//
//  DashboardTableViewCell.m
//  ReminderService
//
//  Created by TrungBQ on 11/21/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "DashboardTableViewCell.h"

@implementation DashboardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
/*
+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)initGradientLayer {
    CAGradientLayer *gLayer = (CAGradientLayer *)_bgView.layer;
    
    [gLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil]];
}
*/
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    CGRect appframe = [[UIScreen mainScreen] bounds];
    NSLog(@"Appframe %@", NSStringFromCGRect(appframe));
    
    _bgView.frame = CGRectMake(69, 0, self.frame.size.width - 70, self.frame.size.height - 6);
    _arrow.frame = CGRectMake(frame.size.width - 30, frame.size.height/2 - 15, 20, 30);
    
    _bgImageView.image = [UIImage imageNamed:_type];
}
/*
- (CAGradientLayer *)gradientLayer
{
    UIColor *topColor = [UIColor colorWithRed:1 green:0.92 blue:0.56 alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    
    return gradientLayer;
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
