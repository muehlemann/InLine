//
//  AppDelegate.m
//  inline
//
//  Created by Matti Muehlemann on 11/3/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

@interface AppDelegate()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Get the saved user
    NSDictionary *user = nil;//[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    // Check if the user exsists (local)
    if (user != NULL)
    {        
        NSString *query = [NSString stringWithFormat:@"users/%@", [user objectForKey:@"_id"]];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager GET:_API(query) parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject)
        {
            NSLog(@"%@", responseObject);
            
            if (![[responseObject objectForKey:@"user"] isEqualToString:@"{}"])
                [self loadView:@"main_view"];
            else
                [self loadView:@"signup_view"];
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
        {
            NSLog(@"error: %@", error);
            [self loadView:@"signup_view"];
        }];
    }
    else
    {
        [self loadView:@"signup_view"];
    }
    
    // Register for remote notifications if not yet.
    [self registerForRemoteNotifications];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma amrk - Other Methods

/**
 * Loads the specified view
 *
 * @p view
 */
- (void)loadView:(NSString *)view
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:view];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
}

#pragma mark - APNS Methods

/**
 * Register for push notifications
 *
 */
- (void)registerForRemoteNotifications
{
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error){
                                  if(!error) {
                                      // All is good and we are ready to register
                                      NSLog(@"(APNS) ready to reigster");
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                      NSLog(@"(APNS) reigstered");
                                  }
                              }];
    }
}

/**
 * Notification is delivered to a foreground app.
 *
 * @p   center
 * @P   notification
 * @p   compleationHandler
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog(@"User Info : %@", notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

/**
 * Which action was selected by the user for a given notification.
 *
 * @p   center
 * @P   notification
 * @p   compleationHandler
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSLog(@"User Info : %@", response.notification.request.content.userInfo);
    completionHandler();
}

/**
 * Did register for remote location
 *
 * @p   app
 * @P   deviceToken
 */
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Save the token
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
}

@end
