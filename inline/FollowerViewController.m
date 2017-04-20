//
//  FollowerViewController.m
//  inline
//
//  Created by Matti Muehlemann on 11/10/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "FollowerViewController.h"

@interface FollowerViewController ()

@end

@implementation FollowerViewController

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
    [lbl_header setText:@"No pending requests"];
    [lbl_header setTextColor:[UIColor whiteColor]];
    [header addSubview:lbl_header];
    
    // Button requests
    btn_requests = [[UIButton alloc] initWithFrame:CGRectMake(_VW - 70, 30, 40, 40)];
    [btn_requests addTarget:self action:@selector(requests) forControlEvents:UIControlEventTouchUpInside];
    [btn_requests setBackgroundImage:[UIImage imageNamed:@"btn_notification_false"] forState:UIControlStateNormal];
    [btn_requests setTintColor:[UIColor darkGrayColor]];
    [btn_requests setEnabled:NO];
    [header addSubview:btn_requests];
    
    // Search bar
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, _VW, 45)];
    [search setPlaceholder:@"Search by handle"];
    [search setBarTintColor:[UIColor whiteColor]];
    [search setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [search setDelegate:self];
    [self.view addSubview:search];
    
    tbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 145, _VW, _VH - 145)];
    [tbl setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [tbl setBackgroundColor:[UIColor clearColor]];
    [tbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tbl setLayoutMargins:UIEdgeInsetsZero];
    [tbl setEmptyDataSetDelegate:self];
    [tbl setEmptyDataSetSource:self];
    [tbl setDelegate:self];
    [tbl setDataSource:self];
    [self.view addSubview:tbl];
    
    // Tap revognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tbl addGestureRecognizer:tap];
}

/**
 * Dismisses the keyboard on tap
 *
 */
- (void)dismissKeyboard
{
    [search resignFirstResponder];
}

/**
 * Loads the view when it appears.
 *
 * @p animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    
    // Get all pending requests
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@/followers/pending", [user objectForKey:@"_id"]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        unsigned long size = [(NSArray *)responseObject count];
        
        // Markes the pending request button appropriatley
        if (size > 0) {
            // Update the UI
            if (size == 1)
                [lbl_header setText:@"1 pending request"];
            else
                [lbl_header setText:[NSString stringWithFormat:@"%lu pending request", size]];

            [btn_requests setTintColor:[UIColor darkGrayColor]];
            [btn_requests setEnabled:YES];
        } else {
            // Update the UI
            [lbl_header setText:@"No pending requests"];
            [btn_requests setTintColor:[UIColor darkGrayColor]];
            [btn_requests setEnabled:NO];
            
            [self.tabBarItem setBadgeValue:0];
        }
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
 * Updates the table
 *
 */
- (void)updateTable
{
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    // Get all followees
    NSString *query = [NSString stringWithFormat:@"users/%@/followees", [user objectForKey:@"_id"]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        followees = [[NSMutableArray alloc] initWithArray:responseObject];
        [tbl performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
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
 * Presents the requests page
 *
 */
- (void)requests
{
    [self performSegueWithIdentifier:@"follower-requests" sender:nil];
}

/**
 * Manages memory warnings
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UISearchBarDelegate

/**
 * Text did change
 *
 * @p searchBar
 * @p searchText
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0)
    {
        // Makes a search query to the server
        NSUserDefaults *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSString *query = [NSString stringWithFormat:@"users/%@/find/%@", [user objectForKey:@"_id"], [searchText stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
        
        NSLog(@"%@", _API(query));
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            NSLog(@"%@", responseObject);
            if ([[responseObject objectForKey:@"msg"] isEqualToString:@"found"])
            {
                results = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"users"]];
            }
            else
            {
                results = [[NSMutableArray alloc] initWithObjects:@{@"handle": @"no user found"}, nil];
            }
            
            [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:YES];
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
            
            [tbl performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
            NSLog(@"error: %@", error);
        }];
    }
    else
    {
        // Clear the table and array
        results = [[NSMutableArray alloc] init];
        [tbl reloadData];
    }
}

/**
 * Dismisses the keyboard when the user hits the search button
 *
 * @p searchBar
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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
    return 45;
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
    static NSString *identifier = @"identifier";
    SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    // Handle
    NSString *handle = [NSString stringWithFormat:@"@%@", [results[indexPath.row] objectForKey:@"handle"]];
    [cell.handle setText:handle];

    NSLog(@"%@", results[indexPath.row]);
    
    if ([[results[indexPath.row] objectForKey:@"handle"] isEqualToString:@"no user found"])
    {
        [cell.handle setTextAlignment:NSTextAlignmentCenter];
        [cell.handle setText:[@"no users found" uppercaseString]];
        [cell.btn setHidden:YES];
    }
    else
    {
        [cell.handle setTextAlignment:NSTextAlignmentLeft];
        [cell.btn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn setTitle:[@"follow" uppercaseString] forState:UIControlStateNormal];
        [cell.btn setTag:indexPath.row];
        [cell.btn setHidden:NO];

        // Mark all followees
        if ([followees count] > 0) {
            for (int i = 0; i < [followees count]; i++)
            {
                if ([[followees[i] objectForKey:@"follower"] isEqualToString:[results[indexPath.row] objectForKey:@"_id"]])
                {
                    [cell.btn removeTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btn addTarget:self action:@selector(unfollow:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btn setTitle:[@"unfollow" uppercaseString] forState:UIControlStateNormal];
                    
                    NSLog(@"%@", followees[i]);
                }
            }
        }
    }

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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [search resignFirstResponder];
}

/**
 * Makes a request to follow
 *
 */
- (void)follow:(id)sender
{
    UIButton *b = (UIButton *)sender;
    NSLog(@"%ld", (long)[b tag]);
    NSLog(@"%@", [results[b.tag] objectForKey:@"_id"]);
    
    // Makes a follower request
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@/followers/request", [user objectForKey:@"_id"]];
    NSDictionary *params = @{@"follower_id" : [results[b.tag] objectForKey:@"_id"]};
    
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
        [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:YES];
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
 * Makes a request to unfollow
 *
 */
- (void)unfollow:(id)sender
{
    UIButton *b = (UIButton *)sender;
    NSLog(@"%ld", (long)[b tag]);
    NSLog(@"%@", [results[b.tag] objectForKey:@"_id"]);
    
    // Makes a follower request
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@/followers/delete", [user objectForKey:@"_id"]];
    NSDictionary *params = @{@"follower_id" : [results[b.tag] objectForKey:@"_id"]};
    
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
        [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:YES];
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
    return [[NSAttributedString alloc] initWithString:@"Search Followers" attributes:attributes];
}

/**
 * Returns a description
 *
 * @p scrollView
 * @r NSAttributedString
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Search for users by their handle. \nEx: @shrek";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
