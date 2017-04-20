//
//  ProfileDisplayViewController.m
//  inline
//
//  Created by Matti Muehlemann on 3/10/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "ProfileDisplayViewController.h"

@interface ProfileDisplayViewController ()

@end

@implementation ProfileDisplayViewController

@synthesize tap, timeline, timeline_id, startIndex;

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set background color
    [self.view setBackgroundColor:_C_BLUE];
    
    // Set index
    index = [startIndex intValue];
    
    // Liked label
    lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, _VH - 65, _VW, 40)];
    [lblDate setFont:[UIFont boldFlatFontOfSize:15]];
    [lblDate setTextAlignment:NSTextAlignmentCenter];
    [lblDate setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lblDate];

    lblLike = [[UILabel alloc] initWithFrame:CGRectMake(0, _VH - 45, _VW, 40)];
    [lblLike setFont:[UIFont boldFlatFontOfSize:10]];
    [lblLike setTextAlignment:NSTextAlignmentCenter];
    [lblLike setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lblLike];
    
    // Image View
    float scale = 1.2;
    int border = (_VW - (_VW / scale)) / 2;
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(border, border, _VW / scale, _VH / scale)];
    [imgView.layer setCornerRadius:5];
    [imgView.layer setMasksToBounds:YES];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self setImageAtIndex:index];
    [self.view addSubview:imgView];
    
    // Add tap gesture recognizer
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:self.tap];
    
    // Add swipe gesture recognizer
    UISwipeGestureRecognizer *swipeD = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(done)];
    [swipeD setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeD];
}


/**
 * Allows for the navigating of views
 *
 * @p recognizer
 */
- (void)tap:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateRecognized)
    {
        CGPoint point = [recognizer locationInView:recognizer.view];
        if (point.x < (_VW * 0.5))
            index--;
        else
            index++;
        
        NSLog(@"%d", index);
        
        // Check if end of timeline
        if ([self.timeline count] == index || -1 == index)
            [self done];
        else
            [self setImageAtIndex:index];
    }
}

/**
 * Set the image at a certain index
 *
 * @p i
 */
- (void)setImageAtIndex:(int)i
{
    NSDictionary *post = [timeline objectAtIndex:i];
    
    // Set background color
    UIColor *bCol;
    switch ([[post objectForKey:@"branch"] intValue]) {
        case -1:
            bCol = _C_BLUE;
            break;
        case 1:
            bCol = _C_Y;
            break;
        case 2:
            bCol = _C_B;
            break;
        case 3:
            bCol = _C_G;
            break;
        case 4:
            bCol = _C_O;
            break;
        case 5:
            bCol = _C_R;
            break;
        case 6:
            bCol = _C_P;
            break;
        default:
            break;
    }
    
    [self.view setBackgroundColor:bCol];
    
    // Disable the tap recognizer
    [tap setEnabled:NO];
    
    // Setup the blur view
    UIVisualEffectView *v = [[UIVisualEffectView alloc] initWithFrame:self.view.frame];
    [v setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self.view addSubview:v];
    
    // Setup the label view
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(70, (_VH * 0.5) - 40, _VW - 140, 40)];
    [l setFont:[UIFont boldFlatFontOfSize:18]];
    [l setTextAlignment:NSTextAlignmentCenter];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:@"0%"];
    [v addSubview:l];
    
    // Setup the progress view
    UIProgressView *p = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [p setFrame:CGRectMake(70, _VH * 0.5, _VW - 140, 5)];
    [p setTintColor:_C_BLUE];
    [v addSubview:p];
    
    // Set liked and date label
    unsigned long likes = [(NSArray *)[post objectForKey:@"like"] count];
    if (likes > 1)
        [lblLike setText:[NSString stringWithFormat:@"%lu LIKES", likes]];
    else if (likes == 1)
        [lblLike setText:[NSString stringWithFormat:@"%lu LIKE", likes]];
    else
        [lblLike setText:@""];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[post objectForKey:@"date"] doubleValue] / 1000];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd, yyyy"];
    [lblDate setText:[df stringFromDate:date]];

    // STARTING NETWORK CODE //
    
    // Create the URL request
    NSURL *url = [NSURL URLWithString:[post objectForKey:@"url"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // Configure the session and session manager
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // Set up the session download task
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // On thread update progress
        dispatch_async(dispatch_get_main_queue(), ^{
            [p setProgress:downloadProgress.fractionCompleted];
            [l setText:[NSString stringWithFormat:@"%d%%", (int)(downloadProgress.fractionCompleted * 100)]];
        });
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        // Return the destination URL
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        // Handle compleation
        [tap setEnabled:YES];
        [imgView setImageWithURL:filePath];
        
        // Send to the server that this is viewed
        [UIView animateWithDuration:0.3
                         animations:^(void) {
                             [v setAlpha:0.0];
                         }
                         completion:^(BOOL finished) {
                             [l removeFromSuperview];
                             [p removeFromSuperview];
                             [v removeFromSuperview];
                         }];
        
        
    }];
    
    [downloadTask resume];
    
    // ENDING NETWORK CODE //
    
}

/**
 * Dismisses the view
 *
 */
- (void)done
{
    // Dismiss view
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

@end
