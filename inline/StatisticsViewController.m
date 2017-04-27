//
//  StatisticsViewController.m
//  inline
//
//  Created by Matti Muehlemann on 1/28/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // View
    [self.view setBackgroundColor:_C_BLUE];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, _VW - 60, 50)];
    [lbl setFont:[UIFont boldFlatFontOfSize:30]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lbl];
    
    UIButton *btn_done = [[UIButton alloc] initWithFrame:CGRectMake(30, _VH - 80, _VW - 60, 40)];
    [btn_done addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [btn_done setTitle:@"go back" forState:UIControlStateNormal];
    [btn_done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_done.titleLabel setFont:[UIFont flatFontOfSize:14]];
    [self.view addSubview:btn_done];
}

/**
 * Dismisses the view
 *
 */
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Loads the view when it appears.
 *
 * @p animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    // Clear the label
    [lbl setText:@""];
    
    // Get the users timeline
    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"timeline/%@/statistics", [user objectForKey:@"_id"]];
    
    // Makes a server request for users posting statistics
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:responseObject];
        
        NSDictionary *stats = [[NSDictionary alloc] initWithDictionary:[self getPieValues:dict] copyItems:NO];
        
        pie = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, _VW - 60, _VW - 60) items:[stats allValues]];
        [pie setDelegate:self];
        [pie setCenter:self.view.center];
        [self.view addSubview:pie];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"error: %@", error);
    }];
}

/**
 * Unloads the view when it disappears.
 *
 * @p animated
 */
- (void)viewDidDisappear:(BOOL)animated
{
    [pie removeFromSuperview];
}

/**
 * Manages memory warnings
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - PNChartDelegate

/**
 * Changes a lable based on selected slice
 *
 * @p pieIndex
 */
- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex
{
    // Changes a lable based on selected pie-chart slice
    for (int i = 0; i < [_C_BRANCHES count]; i++) {
    
        PNPieChartDataItem *slice = pie.items[pieIndex];
        if ([slice.color isEqual:_C_BRANCHES[i]]) {
            [lbl setText:_BRANCHES[i + 1]];
            [lbl setTextColor:_C_BRANCHES[i]];
        }
    }
}

/**
 * Returns all pie chart elements
 *
 * @p dict
 * @r array
 */
- (NSDictionary *)getPieValues:(NSDictionary *)dict
{
    // Object to hold all piechart values
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];

    for (NSString *key in dict)
    {
        // Choses appropriate color for pie slice type
        if ([dict objectForKey:key])
        {
            UIColor *col;
            
            if ([key isEqualToString:@"fun"])
                col = _C_BRANCHES[0];
            else if ([key isEqualToString:@"social"])
                col = _C_BRANCHES[1];
            else if ([key isEqualToString:@"career"])
                col = _C_BRANCHES[2];
            else if ([key isEqualToString:@"health"])
                col = _C_BRANCHES[3];
            else if ([key isEqualToString:@"love"])
                col = _C_BRANCHES[4];
            else if ([key isEqualToString:@"spirit"])
                col = _C_BRANCHES[5];
            
            // Build pie slice
            PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:[[dict objectForKey:key] floatValue] color:col];
            [d setObject:item forKey:key];
        }
    }
    
    return d;
}

@end
