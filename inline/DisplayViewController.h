//
//  DisplayViewController.h
//  inline
//
//  Created by Matti Muehlemann on 1/31/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UIImageView+AFNetworking.h"

@interface DisplayViewController : UIViewController
{
    int index;
    UIImageView *imgView;
    UIPageControl *pageCount;
}

@property (nonatomic, retain) UITapGestureRecognizer *tap;
@property (nonatomic, retain) NSArray *timeline;
@property (nonatomic, retain) NSString *timeline_id;

@end
