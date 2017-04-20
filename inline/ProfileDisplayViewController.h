//
//  ProfileDisplayViewController.h
//  inline
//
//  Created by Matti Muehlemann on 3/10/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileDisplayViewController : UIViewController
{
    int index;
    UILabel *lblDate;
    UILabel *lblLike;
    UIImageView *imgView;
}

@property (atomic, retain) UITapGestureRecognizer *tap;
@property (nonatomic, retain) NSArray *timeline;
@property (nonatomic, retain) NSString *timeline_id;
@property (nonatomic, retain) NSNumber *startIndex;

@end
