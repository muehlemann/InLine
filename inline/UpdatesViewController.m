//
//  UpdatesViewController.m
//  inline
//
//  Created by Matti Muehlemann on 11/10/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "UpdatesViewController.h"
#import "Constants.h"

@interface UpdatesViewController ()

@end

@implementation UpdatesViewController

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // View
    [self.view setBackgroundColor:_C_GRAY];
    
    // Add header
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _VW, 100)];
    [header setBackgroundColor:_C_BLUE];
    [self.view addSubview:header];
    
    // Handle label
    lbl_header = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, _VW - 60, 40)];
    [lbl_header setFont:[UIFont boldFlatFontOfSize:20]];
    [lbl_header setText:@"Updated at 10:31 AM"];
    [lbl_header setTextColor:[UIColor whiteColor]];
    [header addSubview:lbl_header];
    
    // Button update
    UIButton *btn_update = [[UIButton alloc] initWithFrame:CGRectMake(_VW - 70, 30, 40, 40)];
    [btn_update addTarget:self action:@selector(getTimeLines) forControlEvents:UIControlEventTouchUpInside];
    [btn_update setBackgroundImage:[UIImage imageNamed:@"tb_updates"] forState:UIControlStateNormal];
    [btn_update setTintColor:[UIColor whiteColor]];
    [header addSubview:btn_update];
    
    // TableView
    tbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, _VW, _VH - self.tabBarController.tabBar.frame.size.height - 100)];
    [tbl setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [tbl setBackgroundColor:[UIColor clearColor]];
    [tbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tbl setLayoutMargins:UIEdgeInsetsZero];
    [tbl setEmptyDataSetDelegate:self];
    [tbl setEmptyDataSetSource:self];
    [tbl setDelegate:self];
    [tbl setDataSource:self];
    [self.view addSubview:tbl];
    
    // Refresh control
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(getTimeLines) forControlEvents:UIControlEventValueChanged];
    [refresh setTintColor:[UIColor whiteColor]];
    [refresh setBackgroundColor:_C_BLUE];
    [tbl addSubview:refresh];
}

/**
 * View did appear
 *
 * @p animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    [self getTimeLines];
}

/**
 * Prepares for the segue
 *
 * @p segue
 * @p sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"updates-display"])
    {
        NSDictionary *d = [[NSDictionary alloc] initWithDictionary:sender];
        
        DisplayViewController *vc = [segue destinationViewController];
        [vc setTimeline_id:[d objectForKey:@"_id"]];
        [vc setTimeline:[d objectForKey:@"posts"]];
    }
}

/**
 * Gets the timelines from the server
 *
 */
- (void)getTimeLines
{
    // Update header
    [lbl_header setText:@"Updating..."];
    
    // Get all of the followers timeline
    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"timeline/%@/followees", [user objectForKey:@"_id"]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
        timelines = [[NSMutableArray alloc] initWithArray:responseObject];
        NSLog(@"%@", timelines);

        [tbl performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [refresh performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
        
        // Update header
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"hh:mm a"];
        
        [lbl_header setText:[NSString stringWithFormat:@"Updated at %@", [df stringFromDate:[NSDate date]]]];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
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

#pragma mark - UITableViewDelegate

/**
 * Numbers of Rows in Section
 *
 * @p tableView
 * @p section
 * @e NSIntiger
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timelines count];
}

/**
 * Height for row
 *
 * @p tableView
 * @p indexPath
 * @r CGFloat
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

/**
 * Cell for Row
 *
 * @p tableView
 * @p indexPath
 * @r UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *user = [[[timelines objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"handle"];
    NSArray *timeline = [[timelines objectAtIndex:indexPath.row] objectForKey:@"posts"];
    NSDictionary *post = [timeline firstObject];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[post objectForKey:@"date"] doubleValue] / 1000];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [format setDateFormat:@"MMM dd, YYYY hh:mma"];

//    static NSString *identifier = @"identifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setBackgroundColor:[UIColor clearColor]];
//    [cell setSeparatorInset:UIEdgeInsetsZero];
//    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    static NSString *identifier = @"identifier";
    TimelineCell *cell = (TimelineCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[TimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    [cell.img setImageWithURL:[NSURL URLWithString:[post objectForKey:@"url"]]];
    [cell.handle setText:[NSString stringWithFormat:@"@%@", user]];
    [cell.date setText:[format stringFromDate:date]];
    
//    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _VW - 20, 60)];
//    [img setImageWithURL:[NSURL URLWithString:[post objectForKey:@"url"]]];
//    [img setContentMode:UIViewContentModeScaleAspectFill];
//    [img.layer setMasksToBounds:YES];
//    [img.layer setCornerRadius:3];
//    [cell addSubview:img];
//
//    UILabel *lblUser = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, _VW - 30, 20)];
//    [lblUser setFont:[UIFont boldSystemFontOfSize:12]];
//    [lblUser setText:[NSString stringWithFormat:@"@%@", user]];
//    [lblUser setTextColor:[UIColor whiteColor]];
//    [img addSubview:lblUser];
//    
//    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, _VW - 30, 20)];
//    [lblDate setFont:[UIFont boldSystemFontOfSize:12]];
//    [lblDate setText:[format stringFromDate:date]];
//    [lblDate setTextColor:[UIColor whiteColor]];
//    [lblDate setTextAlignment:NSTextAlignmentRight];
//    [img addSubview:lblDate];
    
    return cell;
}

/**
 * Handles cell select
 *
 * @p tableView
 * @p indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *timeline = [timelines objectAtIndex:indexPath.row];
 
    // present new view here with timeline as arg
    [self performSegueWithIdentifier:@"updates-display" sender:timeline];
    
    
    // Deselect the cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DNZEmptyDataSetDelegate

/**
 * Returns a title
 *
 * @p scrollView
 * @r NSAttributedString
 */
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:@"No Updates" attributes:attributes];
}

/**
 * Returns a description
 *
 * @p scrollView
 * @r NSAttributedString
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Follow more people to see their posts";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
