//
//  CreateViewController.m
//  inline
//
//  Created by Matti Muehlemann on 12/23/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // View
    [self.view setBackgroundColor:_C_GRAY];
    [self.view addSubview:[self getColor]];
    [self.view addSubview:[self getCamera]];
}

/**
 * Switches the view from camera to color and vice versa
 *
 * @p   sender
 */
- (void)switchView:(UIButton *)sender
{
    if (camView.frame.origin.x == 0)
    {
        [UIView animateWithDuration:0.2 animations:^(void) {
            [camView setFrame:CGRectMake(- _VW, 0, _VW, _VH)];
            [colView setFrame:CGRectMake(0, 0, _VW, _VH)];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^(void) {
            [camView setFrame:CGRectMake(0, 0, _VW, _VH)];
            [colView setFrame:CGRectMake(_VW, 0, _VW, _VH)];
        }];
    }
}

/**
 * View did appear
 *
 * @p animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    // Set the color of the pickerPreviewView
    // [self setColor];
}

/**
 * Dismisses the view
 *
 */
- (void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - Camera Class Implementation

/**
 * Initializes the camera class
 *
 */
- (UIView *)getCamera
{
    camView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)];
    
    // Toolbar Items
    UIBarButtonItem *btn_flash = [self withAction:@selector(enableFlash:) imageName:@"post_flash_off"];
    UIBarButtonItem *btn_flip  = [self withAction:@selector(flipCamera) imageName:@"post_flip"];
    UIBarButtonItem *btn_flex  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *btn_done  = [self withAction:@selector(done) imageName:@"post_done"];
    
    // Toolbar
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 10, _VW, 60)];
    [bar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    [bar setItems:@[btn_flash, btn_flip, btn_flex, btn_done]];
    [camView addSubview:bar];
    
    // Init the camera class
    camera = [[Camera alloc] init];
    
    // Display video preview
    UIView *preview = [camera getFeed];
    [camView addSubview:preview];
    [camView sendSubviewToBack:preview];
    
    // Take Picture Button
    UIButton *btn_capture = [[UIButton alloc] initWithFrame:CGRectMake((_VW / 2) - 40, _VH - 95, 80, 80)];
    [btn_capture addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [btn_capture setBackgroundColor:[UIColor clearColor]];
    [btn_capture.layer setCornerRadius:40];
    [btn_capture.layer setBorderWidth:2];
    [btn_capture.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btn_capture.layer setMasksToBounds:NO];
    [btn_capture.layer setShadowColor:_C_BLUE.CGColor];
    [btn_capture.layer setShadowOpacity:0.5];
    [btn_capture.layer setShadowRadius:2];
    [btn_capture.layer setShadowOffset:CGSizeMake(0, 0)];
    [camView addSubview:btn_capture];
    
    UIButton *btn_col = [[UIButton alloc] initWithFrame:CGRectMake(_VW - 60, _VH - 55, 40, 40)];
    [btn_col addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    [btn_col setImage:[UIImage imageNamed:@"post_paint"] forState:UIControlStateNormal];
    [btn_col.layer setMasksToBounds:NO];
    [btn_col.layer setShadowColor:_C_BLUE.CGColor];
    [btn_col.layer setShadowOpacity:0.5];
    [btn_col.layer setShadowRadius:2];
    [btn_col.layer setShadowOffset:CGSizeMake(0, 0)];
    [camView addSubview:btn_col];
    
    // Adds a notification listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoWasTaken:) name:@"photo_taken" object:nil];
    
    return camView;
}

/**
 * Takes a picture form the photo output
 *
 */
- (void)takePicture
{
    [camera takePhoto];
}

/**
 * Triggered by a notification: Displays the picture taken
 *
 * @p notification
 */
- (void)photoWasTaken:(NSNotification *)notification
{    
    UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)];
    [postImageView setContentMode:UIViewContentModeScaleAspectFit];
    [postImageView setImage:[notification object]];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)];
    [v addSubview:postImageView];
    
    EditViewController *vc = [[EditViewController alloc] init];
    [vc setPost:v];
    
    [self.navigationController pushViewController:vc animated:NO];
}

/**
 * Enables the flash
 * 
 * @p sender
 */
- (void)enableFlash:(UIButton *)sender
{
    // Change the tag and the img
    [sender setTag:![sender tag]];
    UIImage *img = ([sender tag] ? [UIImage imageNamed:@"post_flash_on"] : [UIImage imageNamed:@"post_flash_off"]);
    [sender setBackgroundImage:img forState:UIControlStateNormal];
    
    [camera enableFlash];
}

/**
 * Flips the camera
 *
 */
- (void)flipCamera
{
    [camera flipCamera];
}

#pragma mark - Color Wheel Implementation

/**
 * Initializes the color wheel
 *
 */
- (UIView *)getColor
{
    colView = [[UIView alloc] initWithFrame:CGRectMake(_VW, 0, _VW, _VH)];
    [colView setBackgroundColor:[UIColor redColor]];
    
    // Toolbar Items
    // Bar hue
    barHUE = [[ColorPicker alloc] initWithFrame:CGRectMake(10, _VH - 50, _VW - 80, 30) ofType:UISliderTypeHue];
    [barHUE addTarget:self action:@selector(setColor:withEvent:) forControlEvents:UIControlEventValueChanged];
    [colView addSubview:barHUE];
    
    UIBarButtonItem *btn_slider = [[UIBarButtonItem alloc] initWithCustomView:barHUE];
    UIBarButtonItem *btn_flex   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *btn_done   = [self withAction:@selector(done) imageName:@"post_done"];
    
    
    // Toolbar
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 10, _VW, 60)];
    [bar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    [bar setItems:@[btn_slider, btn_flex, btn_done]];
    [colView addSubview:bar];
    
    UIButton *btn_cam = [[UIButton alloc] initWithFrame:CGRectMake(15, _VH - 55, 40, 40)];
    [btn_cam addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    [btn_cam setBackgroundColor:[UIColor clearColor]];
    [btn_cam setImage:[UIImage imageNamed:@"post_camera"] forState:UIControlStateNormal];
    [btn_cam.layer setMasksToBounds:NO];
    [btn_cam.layer setShadowColor:_C_BLUE.CGColor];
    [btn_cam.layer setShadowOpacity:0.5];
    [btn_cam.layer setShadowRadius:2];
    [btn_cam.layer setShadowOffset:CGSizeMake(0, 0)];
    [colView addSubview:btn_cam];
    
    return colView;
}

/**
 * Sets the color of the background based of of the slider values
 *
 */
- (void)setColor:(ColorPicker *)sender withEvent:(UIEvent*)e;
{
    [colView setBackgroundColor:[UIColor colorWithHue:barHUE.value saturation:1.0 brightness:1.0 alpha:1.00]];
    
    UITouch * touch = [e.allTouches anyObject];
    
    if (touch.phase == UITouchPhaseEnded)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)];
        [v setBackgroundColor:colView.backgroundColor];
        
        EditViewController *vc = [[EditViewController alloc] init];
        [vc setPost:v];
        
        [self.navigationController pushViewController:vc animated:NO];

    }
}

@end
