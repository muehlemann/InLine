//
//  SignUpViewController.m
//  inline
//
//  Created by Matti Muehlemann on 11/9/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "SignUpViewController.h"
#import "Constants.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

/**
 * Sets up and initializes the view.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // View
    [self.view setBackgroundColor:_C_BLUE];

    UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, _VW - 60, 40)];
    [lbl_title setFont:[UIFont flatFontOfSize:22]];
    [lbl_title setTextAlignment:NSTextAlignmentLeft];
    [lbl_title setTextColor:_C_GRAY];
    [lbl_title setText:@"REGISTER"];
    [self.view addSubview:lbl_title];

    int anchor_y = 100;
    
    // Username Textfield
    txt_email = [[UITextField alloc] initWithFrame:CGRectMake(30, anchor_y, _VW - 60, 40)];
    [txt_email setBackgroundColor:[UIColor whiteColor]];
    [txt_email setPlaceholder:@"email"];
    [txt_email setFont:[UIFont flatFontOfSize:16]];
    [txt_email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txt_email setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt_email.layer setCornerRadius:3];
    [txt_email.layer setBorderWidth:1];
    [txt_email.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00].CGColor];
    
    UIImageView *img_email = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
    [img_email setContentMode:UIViewContentModeScaleAspectFit];
    [img_email setImage:[UIImage imageNamed:@"txt_email"]];
    
    [txt_email setLeftViewMode:UITextFieldViewModeAlways];
    [txt_email setLeftView:img_email];
    [self.view addSubview:txt_email];

    // Handle Textfield
    txt_handle = [[UITextField alloc] initWithFrame:CGRectMake(30, anchor_y + 50, _VW - 60, 40)];
    [txt_handle setBackgroundColor:[UIColor whiteColor]];
    [txt_handle setPlaceholder:@"handle"];
    [txt_handle setFont:[UIFont flatFontOfSize:16]];
    [txt_handle setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txt_handle setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt_handle.layer setCornerRadius:3];
    [txt_handle.layer setBorderWidth:1];
    [txt_handle.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00].CGColor];

    UIImageView *img_handle = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
    [img_handle setContentMode:UIViewContentModeScaleAspectFit];
    [img_handle setImage:[UIImage imageNamed:@"txt_handle"]];
    
    [txt_handle setLeftViewMode:UITextFieldViewModeAlways];
    [txt_handle setLeftView:img_handle];
    [self.view addSubview:txt_handle];
    
    // Password Textfield
    txt_password = [[UITextField alloc] initWithFrame:CGRectMake(30, anchor_y + 100, _VW - 60, 40)];
    [txt_password setBackgroundColor:[UIColor whiteColor]];
    [txt_password setPlaceholder:@"password"];
    [txt_password setFont:[UIFont flatFontOfSize:16]];
    [txt_password setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txt_password setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt_password.layer setCornerRadius:3];
    [txt_password.layer setBorderWidth:1];
    [txt_password.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00].CGColor];
    [txt_password.layer setMasksToBounds:YES];
    [txt_password setSecureTextEntry:YES];
    
    UIImageView *img_pass = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
    [img_pass setContentMode:UIViewContentModeScaleAspectFit];
    [img_pass setImage:[UIImage imageNamed:@"txt_pass"]];
    
    [txt_password setLeftViewMode:UITextFieldViewModeAlways];
    [txt_password setLeftView:img_pass];
    [self.view addSubview:txt_password];
    
    // Signup Button
    btn_one = [[UIButton alloc] initWithFrame:CGRectMake(30, anchor_y + 150, _VW - 60, 40)];
    [btn_one addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    [btn_one setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_one setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn_one setTitle:@"Register" forState:UIControlStateNormal];
    [btn_one.titleLabel setFont:[UIFont flatFontOfSize:16]];
    [btn_one setBackgroundColor:[UIColor whiteColor]];
    [btn_one.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00].CGColor];
    [btn_one.layer setCornerRadius:3];
    [btn_one.layer setBorderWidth:1];
    [self.view addSubview:btn_one];
    
    btn_two = [[UIButton alloc] initWithFrame:CGRectMake(30, anchor_y + 200, _VW - 60, 40)];
    [btn_two addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchUpInside];
    [btn_two setTitle:@"or sign in here" forState:UIControlStateNormal];
    [btn_two setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_two.titleLabel setFont:[UIFont flatFontOfSize:14]];
    [self.view addSubview:btn_two];
}

/**
 * Signs up the user
 *
 */
- (void)signup
{
    // Disable the responder and disable the button
    [txt_email resignFirstResponder];
    [txt_handle resignFirstResponder];
    [txt_password resignFirstResponder];
    [btn_one setEnabled:NO];

    NSString *handle   = txt_handle.text;
    NSString *email    = txt_email.text;
    NSString *password = txt_password.text;
    NSString *token    = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    // Check if token exsists
    if (token == NULL){
        NSLog(@"%@", token);
        token = @"";
    }
    
    // Check if all information is provided
    if ([handle isEqualToString:@""] || [email isEqualToString:@""] || [password isEqualToString:@""])
    {
        // Show Error TOAST
        NSDictionary *options = @{
                                  kCRToastTextKey : @"Please fill all fields.",
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastFontKey : [UIFont flatFontOfSize:12]
                                  };
    
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
        
        // Enable button again
        [btn_one setEnabled:YES];
    }
    else
    {
        NSDictionary *params = @{@"handle"   : handle,
                                 @"email"    : email,
                                 @"password" : password,
                                 @"token"    : token};
        
        // Make server request to register a user
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager POST:_API(@"users/") parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            NSLog(@"%@", responseObject);
            
            // Update UI
            [btn_one setEnabled:YES];
        
            if ([[responseObject objectForKey:@"msg"] isEqualToString:@"user created"])
            {                
                // Show Success TOAST
                NSDictionary *options = @{
                                          kCRToastTextKey : @"Account Created",
                                          kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                          kCRToastBackgroundColorKey : [UIColor whiteColor],
                                          kCRToastTextColorKey : _C_BLUE,
                                          kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                          kCRToastFontKey : [UIFont flatFontOfSize:12]
                                          };
                
                [CRToastManager showNotificationWithOptions:options completionBlock:nil];
                
                // Save to defaults
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[responseObject objectForKey:@"user"] forKey:@"user"];
                
                // Show new view
                [self performSegueWithIdentifier:@"signup-main" sender:self];
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
}

/**
 * Present sign in view
 *
 */
- (void)signin
{
    NSLog(@"sign in");
    [self performSegueWithIdentifier:@"signin" sender:self];
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
