//
//  ColorPicker.m
//  inline
//
//  Created by Matti Muehlemann on 1/17/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "ColorPicker.h"

@implementation ColorPicker

/**
 * Initializes the custom slider
 *
 * @p frame
 * @p type
 * @return self
 */
- (id)initWithFrame:(CGRect)frame ofType:(UISliderType)type {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *img;
        if (type == UISliderTypeHue)
            img = [UIImage imageNamed:@"slider_barColor"];
        else
            img = [UIImage imageNamed:@"slider_barBW"];
        
        // create a slider mask view (as image)
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (frame.size.height * 0.5) - 15, frame.size.width, 30)];
        [imgView.layer setMasksToBounds:YES];
        [imgView.layer setCornerRadius:15];
        [imgView.layer setBorderWidth:1];
        [imgView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imgView setImage:img];
        [self addSubview:imgView];
        
        UIImage *sliderMinimum = [[UIImage imageNamed:@"place_holder"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        UIImage *sliderMaximum = [[UIImage imageNamed:@"place_holder"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        
        // Style the slider
        [self setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [self setFrame:frame];
        
        [self setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
        [self setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
    
    }
    return self;
}

@end
