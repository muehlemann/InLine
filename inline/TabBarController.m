//
//  TabBarController.m
//  inline
//
//  Created by Matti Muehlemann on 11/10/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "TabBarController.h"
#import "Constants.h"
#import "CreateViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the delegate
    [self.tabBarController setDelegate:self];
    [self setSelectedIndex:1];
    
    // Styelize tabbar
    [self.tabBar setItemPositioning:UITabBarItemPositioningCentered];
    [self.tabBar setTintColor:_C_BLUE];
    
    // Change icon position and add tag
    for (int i = 0; i < [self.tabBar items].count; i++) {
        [[self.tabBar items][i] setImageInsets:UIEdgeInsetsMake(7, 0, -7, 0)];
    }
    
    // get pending requests
    [self getPending];
}

/**
 * View did appear
 *
 * @p animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    // Check if first launch; if yes, present tutorial
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first_launch"])
    {
        // Change the flag
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"first_launch"];
        
        UIView *header1 = [[UIView alloc] initWithFrame:CGRectMake(25, 25, _VW - 50, _VW - 50)];
        
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, header1.frame.size.width - 100, header1.frame.size.height - 100)];
        [img1 setImage:[UIImage imageNamed:@"intro_app"]];
        [header1 addSubview:img1];
        
        MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)
                                                                           title:@"Welcome to InLine"
                                                                     description:@"InLine is a social network focused on user privacy that allows you to categorize the different relationships in your life.\n\nThis thesis project, developed by Matt Muehlemann, aims to fill the void of a social media platform that respects the users privacy and presents the user with a nonintrusive experience."
                                                                           image:nil
                                                                          header:header1];
        
        UIView *header2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _VW, 170)];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake((_VW - 150) / 2, 20, 150, 150)];
        [img2 setImage:[UIImage imageNamed:@"intro_search"]];
        [header2 addSubview:img2];
        
        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)
                                                                           title:@"Making Friends"
                                                                     description:@"In the connection tab, connect with other users on InLine and categorize them using branches.\n\nBranches are what makes InLine unique; by categorizing your social relationships you gain a better control of who can and cannot see the content you post."
                                                                           image:nil
                                                                          header:header2];
        
        UIView *header3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _VW, 170)];
        
        UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake((_VW - 150) / 2, 20, 150, 150)];
        [img3 setImage:[UIImage imageNamed:@"intro_updates"]];
        [header3 addSubview:img3];
        
        MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)
                                                                           title:@"What's Everyone Up To?"
                                                                     description:@"In the updates tab, see your friends latest updates.\n\nOnce you have chosen to view someones updates you can navigate their posts with ease. Tap right and left, to go forwards and backwards. Swipe up to like and swipe down to dismiss the timeline."
                                                                           image:nil
                                                                          header:header3];
        
        UIView *header4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _VW, 170)];
        
        UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake((_VW - 150) / 2, 20, 150, 150)];
        [img4 setImage:[UIImage imageNamed:@"intro_profile"]];
        [header4 addSubview:img4];
        
        MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, _VW, _VH)
                                                                           title:@"All About You!"
                                                                     description:@"In the profile tab, you can view your personal timeline, make posts, view statistics, and update your account information.\n\nEnjoy!"
                                                                           image:nil
                                                                          header:header4];
        
        MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [introductionView buildIntroductionWithPanels:@[panel1, panel2, panel3, panel4]];
        [introductionView setBackgroundColor:_C_BLUE];
//        [introductionView setDelegate:self];
        [self.view addSubview:introductionView];
    }
}

+ (void)showTutorial
{
    NSLog(@"hi");
}

/**
 * Indicates when an imte is selected
 *
 * @p tabBar
 * @p item
 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self getPending];
}

/**
 * Querries for pending requests
 *
 */
- (void)getPending
{
    // Get all pending requests
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@/followers/pending", [user objectForKey:@"_id"]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        int count = (int)[(NSArray *)responseObject count];
        if (count == 0)
            [[[self.tabBar items] objectAtIndex:0] setBadgeValue:nil];
        else
            [[[self.tabBar items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d", count]];
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
 * Manages memory warnings
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
