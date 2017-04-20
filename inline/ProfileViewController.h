//
//  ProfileViewController.h
//  inline
//
//  Created by Matti Muehlemann on 11/10/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDisplayViewController.h"
#import "UIImageView+AFNetworking.h"
#import "IFGCircularSlider.h"

@interface ProfileViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *scroll;
    
    // Profile
    UIView *header_profile;
    UILabel *lbl_header;
    UILabel *lbl_email;
    
    // Statistics
    UIView *header_stats;
    
    // Bottom view
    NSDictionary *timeline;
    UIImageView *img_story;
    int index;
    int timeline_size;
    UILabel *lbl_date;
}

@end
