//
//  CreateViewController.h
//  inline
//
//  Created by Matti Muehlemann on 12/23/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Camera.h"
#import "ColorPicker.h"
#import "EditViewController.h"

@interface CreateViewController : UIViewController
{    
    // Camera
    Camera *camera;

    UIView *camView;
    UIView *colView;
    
    // Color Wheel
    UISlider *barHUE;
    UISlider *barBW;
}

@end
