//
//  ProfileEditViewController.m
//  inline
//
//  Created by Matti Muehlemann on 3/10/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "ProfileEditViewController.h"

@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

    // View
    [self.view setBackgroundColor:_C_BLUE];
    
    // Add a nav bar
    UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, _VW - 60, 40)];
    [lbl_title setFont:[UIFont boldFlatFontOfSize:22]];
    [lbl_title setTextAlignment:NSTextAlignmentLeft];
    [lbl_title setTextColor:_C_GRAY];
    [lbl_title setText:@"EDIT PROFILE"];
    [self.view addSubview:lbl_title];

    // Get user
    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *email = [user objectForKey:@"email"];
    
    int anchor_y = 100;
    
    // Email Textfield
    txt_email = [[UITextField alloc] initWithFrame:CGRectMake(30, anchor_y, _VW - 60, 40)];
    [txt_email setBackgroundColor:[UIColor whiteColor]];
    [txt_email setPlaceholder:@"email"];
    [txt_email setText:email];
    [txt_email setFont:[UIFont flatFontOfSize:16]];
    [txt_email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txt_email setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt_email.layer setCornerRadius:3];
    [txt_email.layer setBorderWidth:1];
    [txt_email.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00].CGColor];
    [self.view addSubview:txt_password_1];
    
    UIImageView *img_email = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
    [img_email setContentMode:UIViewContentModeScaleAspectFit];
    [img_email setImage:[UIImage imageNamed:@"txt_email"]];
    
    [txt_email setLeftViewMode:UITextFieldViewModeAlways];
    [txt_email setLeftView:img_email];
    [self.view addSubview:txt_email];
    
    // Password Textfield
    txt_password_1 = [[UITextField alloc] initWithFrame:CGRectMake(30, anchor_y + 50, _VW - 60, 40)];
    [txt_password_1 setBackgroundColor:[UIColor whiteColor]];
    [txt_password_1 setPlaceholder:@"old password"];
    [txt_password_1 setSecureTextEntry:YES];
    [txt_password_1 setFont:[UIFont flatFontOfSize:16]];
    [txt_password_1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txt_password_1 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt_password_1.layer setCornerRadius:3];
    [txt_password_1.layer setBorderWidth:1];
    [txt_password_1.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00].CGColor];
    [self.view addSubview:txt_password_1];
    
    UIImageView *img_pass_1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
    [img_pass_1 setContentMode:UIViewContentModeScaleAspectFit];
    [img_pass_1 setImage:[UIImage imageNamed:@"txt_pass"]];
    
    [txt_password_1 setLeftViewMode:UITextFieldViewModeAlways];
    [txt_password_1 setLeftView:img_pass_1];
    [self.view addSubview:txt_password_1];
    
    // Password Textfield
    txt_password_2 = [[UITextField alloc] initWithFrame:CGRectMake(30, anchor_y + 100, _VW - 60, 40)];
    [txt_password_2 setBackgroundColor:[UIColor whiteColor]];
    [txt_password_2 setPlaceholder:@"new password"];
    [txt_password_2 setSecureTextEntry:YES];
    [txt_password_2 setFont:[UIFont flatFontOfSize:16]];
    [txt_password_2 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txt_password_2 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt_password_2.layer setCornerRadius:3];
    [txt_password_2.layer setBorderWidth:1];
    [txt_password_2.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00].CGColor];
    
    UIImageView *img_pass_2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
    [img_pass_2 setContentMode:UIViewContentModeScaleAspectFit];
    [img_pass_2 setImage:[UIImage imageNamed:@"txt_pass"]];
    
    [txt_password_2 setLeftViewMode:UITextFieldViewModeAlways];
    [txt_password_2 setLeftView:img_pass_2];
    [self.view addSubview:txt_password_2];
    
    // Signup Button
    btn_one = [[UIButton alloc] initWithFrame:CGRectMake(30, anchor_y + 150, _VW - 60, 40)];
    [btn_one addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [btn_one setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_one setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn_one setTitle:@"Update" forState:UIControlStateNormal];
    [btn_one.titleLabel setFont:[UIFont flatFontOfSize:16]];
    [btn_one setBackgroundColor:[UIColor whiteColor]];
    [btn_one.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00].CGColor];
    [btn_one.layer setCornerRadius:3];
    [btn_one.layer setBorderWidth:1];
    [self.view addSubview:btn_one];
    
    btn_two = [[UIButton alloc] initWithFrame:CGRectMake(30, anchor_y + 200, _VW - 60, 40)];
    [btn_two addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [btn_two setTitle:@"or go back" forState:UIControlStateNormal];
    [btn_two setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_two.titleLabel setFont:[UIFont flatFontOfSize:14]];
    [self.view addSubview:btn_two];
}

/**
 * Manages memory warnings
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Submits new info for the user profile update
 *
 */
- (void)submit
{
    [txt_email resignFirstResponder];
    [txt_password_1 resignFirstResponder];
    [txt_password_2 resignFirstResponder];
    [btn_one setEnabled:NO];

    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *query = [NSString stringWithFormat:@"users/%@", [user objectForKey:@"_id"]];

    // Make params
    NSDictionary *params = @{@"password_old" : txt_password_1.text,
                             @"password_new" : txt_password_2.text,
                             @"email" : txt_email.text};

    // Update a profiles information
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager PUT:_API(query) parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
        
        // Update UI
        [txt_password_1 setText:@""];
        [txt_password_2 setText:@""];
        [btn_one setEnabled:YES];
        
        if ([responseObject objectForKey:@"user"])
        {
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
            
            // Save user
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"user"] forKey:@"user"];
            
            // dimiss
            [self dismiss];
        }
        else
        {
            // Show Error TOAST
            NSDictionary *options = @{
                                      kCRToastTextKey : [responseObject objectForKey:@"msg"],
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey : [UIColor redColor],
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                      kCRToastFontKey : [UIFont flatFontOfSize:12]
                                      };
            
            [CRToastManager showNotificationWithOptions:options completionBlock:nil];
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
 * Dismisses the view
 *
 */
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
