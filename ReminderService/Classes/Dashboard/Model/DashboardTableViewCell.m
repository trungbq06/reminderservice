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

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)initGradientLayer {
    CAGradientLayer *gLayer = (CAGradientLayer *)_bgView.layer;
    
    [gLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil]];
}

- (void)layoutSubviews {
//    [self initGradientLayer];
}

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
