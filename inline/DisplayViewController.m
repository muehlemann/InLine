//
//  DisplayViewController.m
//  inline
//
//  Created by Matti Muehlemann on 1/31/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController

@synthesize tap, timeline, timeline_id;

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
    index = 0;
    
    // Liked label
    UILabel *lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, _VH - 40, _VW, 40)];
    [lblInfo setFont:[UIFont boldFlatFontOfSize:20]];
    [lblInfo setTextAlignment:NSTextAlignmentCenter];
    [lblInfo setTextColor:[UIColor whiteColor]];
    [lblInfo setText:@"LIKED"];
    [self.view addSubview:lblInfo];
    
    // Image View
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)];
    [self setImageAtIndex:index];
    [self.view addSubview:imgView];
    
    // Add tap gesture recognizer
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:self.tap];
    
    // Add swipe gesture recognizer
    UISwipeGestureRecognizer *swipeU = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
    [swipeU setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeU];
    
    // Add swipe gesture recognizer
    UISwipeGestureRecognizer *swipeD = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(done)];
    [swipeD setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeD];
    
    // Add page controller
    pageCount = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _VH - 30, _VW, 30)];
    [pageCount setNumberOfPages:[timeline count]];
    [imgView addSubview:pageCount];
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
        [pageCount setCurrentPage:index];
        
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
    // Disable the tap recognizer
    [tap setEnabled:NO];
    [pageCount setHidden:YES];
    
    // Setup the blur view
    UIVisualEffectView *v = [[UIVisualEffectView alloc] initWithFrame:self.view.frame];
    [v setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [imgView addSubview:v];
    
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
    
    // STARTING NETWORK CODE //
    
    // Create the URL request
    NSURL *url = [NSURL URLWithString:[[timeline objectAtIndex:i] objectForKey:@"url"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:60];
    
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
        [pageCount setHidden:NO];
        [imgView setImageWithURL:filePath];
        
        // Send to the server that this is viewed
        [self viewed];
        
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
 * Lets the server record viewed
 *
 */
- (void)viewed
{
//    // Makes a url
//    NSString *url = [[timeline objectAtIndex:index] objectForKey:@"url"];
//    NSString *url_e = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
//    NSString *query = [NSString stringWithFormat:@"timeline/%@/post/%@/viewed", self.timeline_id, url_e];
//    
//    NSLog(@"%@", self.timeline_id);
//    
//    // Make params
//    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
//    NSDictionary *params = @{@"user_id" : [user objectForKey:@"_id"]};
//    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager POST:_API(query) parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
//    {
//        NSLog(@"%@", responseObject);
//    }
//    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
//    {
//        NSLog(@"error: %@", error);
//        [AFMInfoBanner showWithText:error.localizedDescription style:AFMInfoBannerStyleError andHideAfter:2.0];
//    }];
}

/**
 * Likes the post
 *
 */
- (void)like
{
    CGRect imgRect = imgView.frame;
    [UIView animateWithDuration:0.3
                     animations:^(void) {
                         [imgView setFrame:CGRectMake(0, -40, _VW, _VH)];
                     }];
    
    // Makes a url
    NSString *url = [[timeline objectAtIndex:index] objectForKey:@"url"];
    NSString *url_e = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *query = [NSString stringWithFormat:@"timeline/%@/post/%@/like", self.timeline_id, url_e];
    
    // Make params
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *params = @{@"user_id" : [user objectForKey:@"_id"]};
    
    // Make a server request to like a post
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:_API(query) parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);

        [UIView animateWithDuration:0.3
                              delay:0.5
                            options:kNilOptions
                         animations:^(void) {
                             [imgView setFrame:imgRect];
                         }
                         completion:nil];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        // Show Error TOAST
        NSDictionary *options = @{
                                  kCRToastTextKey : error.localizedDescription,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastFontKey : [UIFont flatFontOfSize:12]
                                  };
        
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
        
        NSLog(@"error: %@", error);
    }];
    
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
