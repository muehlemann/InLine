//
//  LoadViewController.m
//  inline
//
//  Created by Matti Muehlemann on 12/21/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "LoadViewController.h"
#import "Constants.h"

@interface LoadViewController ()

@end

@implementation LoadViewController

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add a title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, (_VH / 2) - 40, _VW - 20, 40)];
    [lblTitle setText:@"InLine"];
    [lblTitle setFont:[UIFont boldFlatFontOfSize:24]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:_C_BLUE];
    [self.view addSubview:lblTitle];
    
    // Add a subtitle
    UILabel *lblSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, (_VH / 2) - 5, _VW - 20, 40)];
    [lblSubtitle setText:@"LOADING"];
    [lblSubtitle setFont:[UIFont boldFlatFontOfSize:12]];
    [lblSubtitle setTextAlignment:NSTextAlignmentCenter];
    [lblSubtitle setTextColor:_C_BLUE];
    [self.view addSubview:lblSubtitle];
    
    // Create a shape
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.view.bounds];
    [shapeLayer setPosition:self.view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[_C_BLUE CGColor]];
    [shapeLayer setLineWidth:5.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:5],nil]];
    
    // Create a path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, _VH / 2);
    CGPathAddLineToPoint(path, NULL, _VW, _VH / 2);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // Create an animation
    CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
    [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
    [dashAnimation setDuration:0.75f];
    [dashAnimation setRepeatCount:10000];
    
    [shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
    
    [[self.view layer] addSublayer:shapeLayer];
}

/**
 * Manages memory warnings
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
