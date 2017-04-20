//
//  ProfileViewController.m
//  inline
//
//  Created by Matti Muehlemann on 11/10/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    index = 0;
    
    // View
    [self.view setBackgroundColor:_C_GRAY];
    
    // Scroll view
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _VW, 100)];
    [scroll setShowsHorizontalScrollIndicator:NO];
    [scroll setContentSize:CGSizeMake(_VW * 2, 100)];
    [scroll setBackgroundColor:_C_BLUE];
    [scroll setPagingEnabled:YES];
    [self.view addSubview:scroll];
    
    // PROFILE HEADER
    
    // Header
    header_profile = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _VW, 100)];
    [scroll addSubview:header_profile];
    
    // Handle label
    lbl_header = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, _VW - 60, 40)];
    [lbl_header setFont:[UIFont boldFlatFontOfSize:20]];
    [lbl_header setTextColor:[UIColor whiteColor]];
    [header_profile addSubview:lbl_header];
    
    // Email label
    lbl_email = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, _VW - 60, 20)];
    [lbl_email setFont:[UIFont flatFontOfSize:12]];
    [lbl_email setTextColor:[UIColor whiteColor]];
    [header_profile addSubview:lbl_email];
    
    // Edit user button
    UILabel *lbl_edit = [[UILabel alloc] initWithFrame:CGRectMake(30, 65, 100, 20)];
    [lbl_edit setText:@"Edit"];
    [lbl_edit setFont:[UIFont flatFontOfSize:10]];
    [lbl_edit setTextColor:[UIColor whiteColor]];
    [header_profile addSubview:lbl_edit];
    
    UIButton *btn_edit = [[UIButton alloc] initWithFrame:lbl_edit.frame];
    [btn_edit addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [header_profile addSubview:btn_edit];
    
    // Arrow
    UIButton *btn_arr_prof = [[UIButton alloc] initWithFrame:CGRectMake(_VW - 25, 40, 20, 20)];
    [btn_arr_prof addTarget:self action:@selector(flip:) forControlEvents:UIControlEventTouchUpInside];
    [btn_arr_prof setBackgroundImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [header_profile addSubview:btn_arr_prof];
    
    // STATISTICS HEADER
    
    // Header
    header_stats = [[UIView alloc] initWithFrame:CGRectMake(_VW, 0, _VW, 200)];
    [scroll addSubview:header_stats];
    
    // Statistics label
    UILabel* lbl_stats_title = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, _VW - 60, 40)];
    [lbl_stats_title setFont:[UIFont boldFlatFontOfSize:20]];
    [lbl_stats_title setTextColor:[UIColor whiteColor]];
    [lbl_stats_title setText:@"Statistics"];
    [header_stats addSubview:lbl_stats_title];
    
    // Email label
    UILabel *lbl_stats_subtitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, _VW - 60, 20)];
    [lbl_stats_subtitle setFont:[UIFont flatFontOfSize:12]];
    [lbl_stats_subtitle setTextColor:[UIColor whiteColor]];
    [lbl_stats_subtitle setText:@"Information about your posting habits"];
    [header_stats addSubview:lbl_stats_subtitle];
    
    // Edit user button
    UILabel *lbl_stats_txt = [[UILabel alloc] initWithFrame:CGRectMake(30, 65, 100, 20)];
    [lbl_stats_txt setText:@"Show more"];
    [lbl_stats_txt setFont:[UIFont flatFontOfSize:10]];
    [lbl_stats_txt setTextColor:[UIColor whiteColor]];
    [header_stats addSubview:lbl_stats_txt];
    
    UIButton *btn_stats = [[UIButton alloc] initWithFrame:lbl_stats_txt.frame];
    [btn_stats addTarget:self action:@selector(stats) forControlEvents:UIControlEventTouchUpInside];
    [header_stats addSubview:btn_stats];
    
    // Arrow
    UIButton *btn_arr_stats = [[UIButton alloc] initWithFrame:CGRectMake(5, 40, 20, 20)];
    [btn_arr_stats addTarget:self action:@selector(flip:) forControlEvents:UIControlEventTouchUpInside];
    [btn_arr_stats setBackgroundImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [btn_arr_stats setTag:1];
    [header_stats addSubview:btn_arr_stats];
    
    // BOTTOM VIEW

    // Date label
    lbl_date = [[UILabel alloc] initWithFrame:CGRectMake(30, 115, _VW - 60, 30)];
    [lbl_date setTextAlignment:NSTextAlignmentCenter];
    [lbl_date setFont:[UIFont flatFontOfSize:12]];
    [lbl_date setText:@"scroll to view timeline"];
    [self.view addSubview:lbl_date];
    
    // Slider
    IFGCircularSlider *slider = [[IFGCircularSlider alloc] initWithFrame:CGRectMake(40, 150, _VW - 80, _VW - 80)];
    [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [slider setFilledColor:_C_BLUE];
    [slider setUnfilledColor:[_C_BLUE colorWithAlphaComponent:0.5]];
    [slider setLineWidth:10];
    [slider setHandleType:CircularSliderHandleTypeBigCircle];
    [slider setHandleColor:[UIColor whiteColor]];
    [self.view addSubview:slider];
    
    // Storyview button
    img_story = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, _VW - 140, _VW - 140)];
    [img_story setContentMode:UIViewContentModeScaleAspectFill];
    [img_story.layer setMasksToBounds:YES];
    [img_story.layer setCornerRadius:(_VW - 140) / 2];
    [slider addSubview:img_story];
    
    UIButton *btn_story = [[UIButton alloc] initWithFrame:img_story.frame];
    [btn_story addTarget:self action:@selector(viewTimeline) forControlEvents:UIControlEventTouchUpInside];
    [slider addSubview:btn_story];
    
    UIButton *btn_post = [[UIButton alloc] initWithFrame:CGRectMake((_VW / 2) - 20, _VW + 120, 40, 40)];
    [btn_post addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [btn_post setBackgroundImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
    [btn_post setTintColor:[UIColor whiteColor]];
    [btn_post.layer setMasksToBounds:NO];
    [btn_post.layer setShadowColor:_C_BLUE.CGColor];
    [btn_post.layer setShadowOpacity:0.8];
    [btn_post.layer setShadowRadius:5];
    [btn_post.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.view addSubview:btn_post];
    
    UILabel *lbl_post = [[UILabel alloc] initWithFrame:CGRectMake(30, _VW + 170, _VW - 60, 20)];
    [lbl_post setTextAlignment:NSTextAlignmentCenter];
    [lbl_post setFont:[UIFont flatFontOfSize:10]];
    [lbl_post setText:@"tap to post"];
    [lbl_post setTextColor:_C_BLUE];
    [self.view addSubview:lbl_post];
}

/**
 * Curved slider
 *
 * @p sender
 */
- (void)slider:(IFGCircularSlider *)sender
{
    index = floor(timeline_size * (sender.currentValue / 100));

    // populate img_story
    NSDictionary *post = [[timeline objectForKey:@"posts"] objectAtIndex:index];
    [img_story setImageWithURL:[NSURL URLWithString:[post objectForKey:@"url"]]];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[post objectForKey:@"date"] doubleValue] / 1000];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM dd, yyyy"];
    
    [lbl_date setText:[[df stringFromDate:date] uppercaseString]];
}

/**
 * Presents edit user view
 *
 */
- (void)edit
{
    // present a new view here
    [self performSegueWithIdentifier:@"profile-edit" sender:nil];
}

/**
 * Switches scroll view
 *
 */
- (void)flip:(UIButton *)sender
{
    if ((long)sender.tag == 0)
        [scroll setContentOffset:CGPointMake(_VW, 0) animated:YES];
    else
        [scroll setContentOffset:CGPointMake(0, 0) animated:YES];

}

/**
 * Presents stats view
 *
 */
- (void)stats
{
    // present a new view here
    [self performSegueWithIdentifier:@"profile-stats" sender:nil];
}

/**
 * Presents post view
 *
 */
- (void)post
{
    [self performSegueWithIdentifier:@"profile-post" sender:nil];
}

/**
 * View did appear
 *
 * @p animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Update scroll view
    [scroll setContentOffset:CGPointMake(0, 0) animated:NO];
    
    // Update the information on the user
    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    [lbl_header setText:[NSString stringWithFormat:@"@%@", [user objectForKey:@"handle"]]];
    [lbl_email setText:[user objectForKey:@"email"]];
    
    [self getTimeline];
    
    [self.tabBarController.tabBar setHidden:NO];

}

/**
 * Prepares for the segue
 *
 * @p segue
 * @p sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender
{
    if ([segue.identifier isEqualToString:@"profile-display"])
    {
        [self.view sendSubviewToBack:img_story];
        
        ProfileDisplayViewController *vc = [segue destinationViewController];
        [vc setTimeline_id:[sender objectForKey:@"_id"]];
        [vc setTimeline:[sender objectForKey:@"posts"]];
        [vc setStartIndex:[NSNumber numberWithInt:index]];
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

#pragma mark - Timeline

/**
 * Updates the timline view on the main thread
 *
 */
- (void)updateTimelineView
{
    NSString *url = [[[timeline objectForKey:@"posts"] objectAtIndex:index] objectForKey:@"url"];
    [img_story setImageWithURL:[NSURL URLWithString:url]];
}

/**
 * Gets the users timeline
 *
 */
- (void)getTimeline
{
    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"timeline/%@", [user objectForKey:@"_id"]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
        timeline = [[NSDictionary alloc] initWithDictionary:responseObject copyItems:NO];
        timeline_size = (int)[[timeline objectForKey:@"posts"] count];
        
        // populate img_story
        // NSString *url = [[[timeline objectForKey:@"posts"] objectAtIndex:index] objectForKey:@"url"];
        // [img_story setImageWithURL:[NSURL URLWithString:url]];
        
        // Maybe do this on main thread
        [self performSelectorOnMainThread:@selector(updateTimelineView) withObject:nil waitUntilDone:NO];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"error: %@", error);
    }];
}

/**
 * Opens timeline display view
 *
 */
- (void)viewTimeline
{
    [self performSegueWithIdentifier:@"profile-display" sender:timeline];
}

@end
