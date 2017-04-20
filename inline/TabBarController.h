//
//  TabBarController.h
//  inline
//
//  Created by Matti Muehlemann on 11/10/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MYBlurIntroductionView/MYBlurIntroductionView.h>

@interface TabBarController : UITabBarController <UITabBarControllerDelegate>
{
    UIView *tabIndicatorView;
}

+ (void)showTutorial;

@end
