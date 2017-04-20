//
//  BranchViewController.m
//  inline
//
//  Created by Matti Muehlemann on 2/1/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "BranchViewController.h"

@interface BranchViewController ()

@end

@implementation BranchViewController

@synthesize data;

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set posted to false
    posted = NO;
    
    // Image view with blur
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)];
    [imgV setImage:[UIImage imageWithData:data]];
    [self.view addSubview:imgV];
    
    UIVisualEffectView *v = [[UIVisualEffectView alloc] initWithFrame:imgV.frame];
    [v setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.view addSubview:v];
    
    // Post control
    UIBarButtonItem *btnFlex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:nil];

    UIButton *tmp = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmp addTarget:self action:@selector(postDelete) forControlEvents:UIControlEventTouchUpInside];
    [tmp setBackgroundImage:[UIImage imageNamed:@"post_done"] forState:UIControlStateNormal];
    [tmp.layer setMasksToBounds:NO];
    [tmp.layer setShadowColor:_C_BLUE.CGColor];
    [tmp.layer setShadowOpacity:0.5];
    [tmp.layer setShadowRadius:2];
    [tmp.layer setShadowOffset:CGSizeMake(0, 0)];
    [tmp setFrame:CGRectMake(0, 0, 33, 33)];

    UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithCustomView:tmp];
    
    UIToolbar *postControls = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _VW, 75)];
    [postControls setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [postControls setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    [postControls setItems:@[btnFlex, btnDelete]];
    [self.view addSubview:postControls];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, _VW - 100, 40)];
    [lbl setText:@"Please select a tag for your post!"];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setFont:[UIFont boldFlatFontOfSize:18]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lbl];
    
    int count = 6;
    
    // Branch has six options
    // 0 - all
    // 1 - fun    - yellow
    // 2 - social - blue
    // 3 - career - green
    // 4 - health - orange
    // 5 - love   - red
    // 6 - spirit - purple
    
    for (int i = 0; i < count; i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, ((_VH - (80 * count)) / 2) + (80 * i) + 15, _VW - 100, 60)];
        [btn addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:_C_BRANCHES[i]];
        [btn setTag:i + 1];
        [btn setTitle:[_BRANCHES[i + 1] uppercaseString] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldFlatFontOfSize:20]];
        [btn.layer setCornerRadius:5];
        [self.view addSubview:btn];
    }
}

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
 * Post the post to the server
 *
 * @p btn
 */
- (void)post:(UIButton *)btn
{
    if (!posted)
    {
        posted = YES;
        branch = (int)btn.tag;
        
        // Upload the screenshot to cloudinary
        CLCloudinary *cloudinary = [[CLCloudinary alloc] initWithUrl: @"cloudinary://976376474925555:dZR2plhjrOFE3WjGDCgtdGvcYno@dyisgpykn"];
        CLUploader *uploader = [[CLUploader alloc] init:cloudinary delegate:self];
        [uploader upload:self.data options:@{}];
    }
}

/**
 * Manages memory warnings
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Cloudinary Delegate

/**
 * Sucess of uploading
 *
 * @p result
 * @p context
 */
- (void)uploaderSuccess:(NSDictionary*)result context:(id)context
{
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"timeline/%@", [user objectForKey:@"_id"]];
    NSDictionary *params = @{@"url": [result objectForKey:@"secure_url"], @"branch": [NSNumber numberWithInt:branch]};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:_API(query) parameters:params progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);

        // Dismissing the edit view
        [self.navigationController popToRootViewControllerAnimated:NO];
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
 * Error of uploading
 *
 * @p core
 * @p context
 */
- (void)uploaderError:(NSString*)result code:(NSInteger)code context:(id)context
{
    NSLog(@"Upload error: %@, %ld", result, (long)code);
    
    // TODO: report the error
}

@end
