//
//  TimelineCell.h
//  inline
//
//  Created by Matti Muehlemann on 4/4/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface TimelineCell : UITableViewCell

@property (nonatomic, retain) UIImageView *img;
@property (nonatomic, retain) UILabel *handle;
@property (nonatomic, retain) UILabel *date;

@end
