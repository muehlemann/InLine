//
//  ColorPicker.h
//  inline
//
//  Created by Matti Muehlemann on 1/17/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

typedef NS_ENUM(NSInteger, UISliderType) {
    UISliderTypeHue = 0,
    UISliderTypeBlackWhite,
};

@interface ColorPicker : UISlider

- (id)initWithFrame:(CGRect)frame ofType:(UISliderType)type;

@end
