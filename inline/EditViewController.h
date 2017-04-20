//
//  EditViewController.h
//  inline
//
//  Created by Matti Muehlemann on 1/18/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorPicker.h"
#import "ACEDrawingView.h"
#import "INTULocationManager.h"
#import "Cloudinary/Cloudinary.h"
#import "TextView.h"
#import "BranchViewController.h"

@interface EditViewController : UIViewController <CLUploaderDelegate, UITextViewDelegate>
{
    // Navigation Items
    ColorPicker *slider;
    NSArray *arrBtnDefault;
    NSArray *arrBtnDraw;
    NSArray *arrBtnText;
    UIToolbar *postControls;
    
    UITapGestureRecognizer *tap;
    
    UILabel *lblLocation;
    UILabel *lblHandle;
    ACEDrawingView *viewDraw;
    TextView *viewText;
}

@property (nonatomic, retain) UIView *post;

@end
