//
//  RequestsViewController.m
//  inline
//
//  Created by Matti Muehlemann on 11/16/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "RequestsViewController.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController

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
    UILabel *lbl_header = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, _VW - 60, 40)];
    [lbl_header setFont:[UIFont boldFlatFontOfSize:20]];
    [lbl_header setText:@"Pending requests"];
    [lbl_header setTextColor:[UIColor whiteColor]];
    [header addSubview:lbl_header];
    
    // Button requests
    UIButton *btn_requests = [[UIButton alloc] initWithFrame:CGRectMake(_VW - 70, 30, 40, 40)];
    [btn_requests addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [btn_requests setBackgroundImage:[UIImage imageNamed:@"post_done"] forState:UIControlStateNormal];
    [btn_requests setTintColor:[UIColor whiteColor]];
    [header addSubview:btn_requests];
    
    // Add a table
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
}

/**
 * Loads the view when it appears.
 *
 * @p animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    [self pending];
}

/**
 * Gets all of the pending followers
 *
 */
- (void)pending
{
    // Get pending requests
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@/followers/pending", [user objectForKey:@"_id"]];
    
    // Make a server request to get the pending
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
        results = [[NSMutableArray alloc] initWithArray:(NSArray *)responseObject];
        [tbl reloadData];
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
    return [results count];
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
    return 155;
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
    // Init custom cell class
    static NSString *identifier = @"identifier";
    RequestCell *cell = (RequestCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[RequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    NSLog(@"%@", [results[indexPath.row] objectForKey:@"followee"]);
    
    // Handle
    NSString *handle = [NSString stringWithFormat:@"@%@", [[results[indexPath.row] objectForKey:@"followee"] objectForKey:@"handle"]];
    [cell.handle setText:handle];
    
    // Date
    NSString *raw_date = [results[indexPath.row] objectForKey:@"date"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[raw_date doubleValue] / 1000];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd, yyyy"];
    [cell.request_date setText:[NSString stringWithFormat:@"Requested on %@", [df stringFromDate:date]]];
    
    // Buttons
    [cell.cancle  addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cell.accept  addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    [cell.request addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchUpInside];
    
    // Data
    NSLog(@"%@", [results objectAtIndex:indexPath.row]);
    
    [cell setFollower_id:[[results[indexPath.row] objectForKey:@"followee"] objectForKey:@"_id"]];

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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"%@", [results objectAtIndex:indexPath.row]);
}

/**
 * Deneys the follower request
 *
 */
- (void)cancel:(id)sender
{
    NSLog(@"delete request");
    UIButton *b = (UIButton *)sender;
    
    // Get the cell
    RequestCell *cell = (RequestCell *)b.superview.superview;
    
    // Delete the request
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@/followers/request", [user objectForKey:@"_id"]];
    NSDictionary *params = @{@"follower_id" : cell.follower_id};
    
    // Make a server request to delete a request
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager DELETE:_API(query) parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
        
        // Show Success TOAST
        NSDictionary *options = @{
                                  kCRToastTextKey : [responseObject objectForKey:@"msg"],
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor whiteColor],
                                  kCRToastTextColorKey : _C_BLUE,
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastFontKey : [UIFont flatFontOfSize:12]
                                  };
         
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
         
        // Update table
        [self performSelectorOnMainThread:@selector(pending) withObject:nil waitUntilDone:YES];
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
 * Accepts the follower request
 *
 */
- (void)accept:(id)sender
{
    NSLog(@"accept request");
    UIButton *b = (UIButton *)sender;
    
    // Accept here
    RequestCell *cell = (RequestCell *)b.superview.superview;
    NSMutableArray *branches = [[NSMutableArray alloc] init];

    NSLog(@"%@", cell.branches.text);
    
    if ([cell.branches.text isEqualToString:@"NONE"]) {
        
        // Update the view
        [cell.accept.layer setBorderColor:[UIColor redColor].CGColor];
        [cell.accept setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    } else if ([cell.branches.text isEqualToString:@"ALL"]) {
        
        // Submit all branches
        [self accept:@[@0, @1, @2, @3, @4, @5, @6] forUser:cell.follower_id];
        
    } else {
        
        // Submit the branches that have been selected
        for (int i = 0; i < [cell.stats count]; i++) {
            if ([[cell.stats objectAtIndex:i] isEqual:@1])
                [branches addObject:[NSNumber numberWithInt:i]];
        }
        
        [self accept:branches forUser:cell.follower_id];
    }
}

/**
 * Accepts the follower request
 *
 */
- (void)request:(id)sender
{
    NSLog(@"accept and request");
    UIButton *b = (UIButton *)sender;
    
    // Accept here
    RequestCell *cell = (RequestCell *)b.superview.superview;
    NSMutableArray *branches = [[NSMutableArray alloc] init];
    
    if ([cell.branches.text isEqualToString:@"NONE"]) {
        
        // Update the view
        [cell.request.layer setBorderColor:[UIColor redColor].CGColor];
        [cell.request setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    } else if ([cell.branches.text isEqualToString:@"ALL"]) {
        
        // Submit all branches and request
        [self accept:@[@0, @1, @2, @3, @4, @5, @6] forUser:cell.follower_id];
        [self requestForUser:cell.follower_id];
        
    } else {
        
        // Get branch numbers
        for (int i = 0; i < [cell.stats count]; i++) {
            if ([[cell.stats objectAtIndex:i] isEqual:@1])
                [branches addObject:[NSNumber numberWithInt:i]];
        }
        
        // Submit selected branches and request
        [self accept:branches forUser:cell.follower_id];
        [self requestForUser:cell.follower_id];
    }
    
}

/**
 * Accepts a request
 *
 * @p arr
 * @p userId
 */
- (void)accept:(NSArray *)arr forUser:(NSString *)userId
{
    // Update follower connection
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@/followers/request", [user objectForKey:@"_id"]];
    NSDictionary *params = @{@"follower_id" : userId, @"branches" : arr};
    
    // Make a server request to accept a follower request
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager PUT:_API(query) parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
        
        // Show Success TOAST
        NSDictionary *options = @{
                                  kCRToastTextKey : @"Accepted Request",
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor whiteColor],
                                  kCRToastTextColorKey : _C_BLUE,
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastFontKey : [UIFont flatFontOfSize:12]
                                  };
         
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
         
        // Querry for pending requests
        [self pending];
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
 * Sends a request
 *
 * @p userId
 */
- (void)requestForUser:(NSString *)userId
{
    // Makes a follower request
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@/followers/request", [user objectForKey:@"_id"]];
    NSDictionary *params = @{@"follower_id" : userId};
    
    // Make a server request for a follower request
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:_API(query) parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
        
        // Show Success TOAST
        NSDictionary *options = @{
                                  kCRToastTextKey : [responseObject objectForKey:@"msg"],
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor whiteColor],
                                  kCRToastTextColorKey : _C_BLUE,
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastFontKey : [UIFont flatFontOfSize:12]
                                  };
         
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
         
        // Update table
        [self performSelectorOnMainThread:@selector(pending) withObject:nil waitUntilDone:YES];
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
    return [[NSAttributedString alloc] initWithString:@"No Current Requests" attributes:attributes];
}

/**
 * Returns a description
 *
 * @p scrollView
 * @r NSAttributedString
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Pending follower requests will show up here";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
