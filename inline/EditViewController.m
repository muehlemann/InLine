//
//  EditViewController.m
//  inline
//
//  Created by Matti Muehlemann on 1/18/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

@synthesize post;

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the post as the abckground (subview)
    [self.view addSubview:self.post];
    
    // Adding the post controls to the view
    slider = [[ColorPicker alloc] initWithFrame:CGRectMake(0, 0, _VW - 120, 30) ofType:UISliderTypeHue];
    [slider addTarget:self action:@selector(postPenColor:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *btnText     = [self withAction:@selector(postText) imageName:@"post_text"];
    UIBarButtonItem *btnDraw     = [self withAction:@selector(postDraw) imageName:@"post_pencil"];
    UIBarButtonItem *btnLocation = [self withAction:@selector(postLocation) imageName:@"post_location"];
    UIBarButtonItem *btnSlider   = [[UIBarButtonItem alloc] initWithCustomView:slider];
    UIBarButtonItem *btnUndo     = [self withAction:@selector(postUndo) imageName:@"post_undo"];
    UIBarButtonItem *btnFlex     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:nil];
    UIBarButtonItem *btnDelete   = [self withAction:@selector(postDelete) imageName:@"post_done"];
    UIBarButtonItem *btnNext     = [self withAction:@selector(postNext) imageName:@"post_next"];
    
    // Button arrays
    arrBtnDefault = @[btnText, btnDraw, btnLocation, btnFlex, btnDelete, btnNext];
    arrBtnDraw    = @[btnDraw, btnSlider, btnUndo];
    arrBtnText    = @[btnText, btnSlider, btnUndo];
    
    // Post controls
    postControls = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _VW, 75)];
    [postControls setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [postControls setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    [postControls setItems:@[btnText, btnDraw, btnLocation, btnFlex, btnDelete, btnNext]];
    [self.view addSubview:postControls];
    
    // Setting up the drawing view
    viewDraw = [[ACEDrawingView alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)];
    [viewDraw setLineColor:[UIColor redColor]];
    [viewDraw setLineWidth:7.0];
    [viewDraw setDrawTool:ACEDrawingToolTypePen];
    [viewDraw setUserInteractionEnabled:NO];
    [self.post addSubview:viewDraw];
    
    // Setting up the text view
    viewText = [[TextView alloc] init];
    [viewText setUserInteractionEnabled:NO];
    [self.post addSubview:viewText];
}

/**
 * When the view did appear
 *
 * @p animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    [postControls setHidden:NO];
}

/**
 * Manages memory warnings
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Factory Functions

/**
 * Creates a bar button with border
 *
 */
- (UIBarButtonItem *)withAction:(SEL)action imageName:(NSString *)name
{
    UIButton *tmp = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmp addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [tmp setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [tmp.layer setMasksToBounds:NO];
    [tmp.layer setShadowColor:_C_BLUE.CGColor];
    [tmp.layer setShadowOpacity:0.5];
    [tmp.layer setShadowRadius:2];
    [tmp.layer setShadowOffset:CGSizeMake(0, 0)];
    [tmp setFrame:CGRectMake(0, 0, 33, 33)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:tmp];
}

#pragma mark - Post Controls

/**
 * Deletes the post
 *
 */
- (void)postDelete
{
    // Dismissing the edit view
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 * Allows for adding text
 *
 */
- (void)postText
{
    if ([viewText isUserInteractionEnabled]) {
        [viewText setUserInteractionEnabled:NO];
        [postControls setItems:arrBtnDefault];
    } else {
        [viewText setUserInteractionEnabled:YES];
        [postControls setItems:arrBtnText];
        [viewText makeTextBox];
    }
}

/**
 * Allows for drawing
 *
 */
- (void)postDraw
{
    if ([viewDraw isUserInteractionEnabled]) {
        [viewDraw setUserInteractionEnabled:NO];
        [postControls setItems:arrBtnDefault];
    } else {
        [viewDraw setUserInteractionEnabled:YES];
        [postControls setItems:arrBtnDraw];
    }
}

/**
 * Sets the color for the drawing tool
 *
 * @p picker
 */
- (void)postPenColor:(ColorPicker *)picker
{
    [viewDraw setLineColor:[UIColor colorWithHue:picker.value saturation:1.0 brightness:1.0 alpha:1.0]];
    [viewText changeColor:[UIColor colorWithHue:picker.value saturation:1.0 brightness:1.0 alpha:1.0]];
}

/**
 * Undoes drawing steps
 *
 */
- (void)postUndo
{
    if ([viewDraw isUserInteractionEnabled]) {
        if ([viewDraw canUndo])
            [viewDraw undoLatestStep];
    } else if ([viewText isUserInteractionEnabled]) {
        [viewText undo];
    }
}

/**
 * Allows for adding the location
 *
 */
- (void)postLocation
{
    if (lblLocation == nil)
    {
        INTULocationManager *locMgr = [INTULocationManager sharedInstance];
        [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:5.0 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
            
            if (status == INTULocationStatusSuccess)
            {
                NSLog(@"%@", currentLocation);
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                    NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                    if (error == nil && [placemarks count] > 0)
                    {
                        CLPlacemark *placemark = [placemarks lastObject];
                        
                        lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(0, _VH - 30, _VW, 30)];
                        [lblLocation setFont:[UIFont boldFlatFontOfSize:15]];
                        [lblLocation setTextColor:[UIColor whiteColor]];
                        [lblLocation setText:[NSString stringWithFormat:@"  %@, %@ - %@", placemark.locality, placemark.administrativeArea, placemark.country]];
                        [self.post addSubview:lblLocation];
                    }
                    else
                    {
                        NSLog(@"%@", error.debugDescription);
                        // TODO: display error
                    }
                }];
                
            }
            //        else if (status == INTULocationStatusTimedOut)
            //            // TODO: display error
            //        else
            //            // TODO: display error
        }];
    }
    else
    {
        [lblLocation removeFromSuperview];
        lblLocation = nil;
    }
}

/**
 * Captures the post and passes it to the next view
 *
 */
- (void)postNext
{
    // Hide the navigation bar form the post content
    [postControls setHidden:YES];
    
    // Take a high res screenshot
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
        
    BranchViewController *vc = [[BranchViewController alloc] init];
    [vc setData:imageData];
    
    [self.navigationController pushViewController:vc animated:NO];
}

@end
