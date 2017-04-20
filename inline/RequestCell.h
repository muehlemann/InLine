//
//  RequestCell.h
//  inline
//
//  Created by Matti Muehlemann on 4/3/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "BEMCheckBox.h"

@interface RequestCell : UITableViewCell <BEMCheckBoxDelegate>

@property (nonatomic, retain) UILabel *handle;
@property (nonatomic, retain) UILabel *request_date;
@property (nonatomic, retain) UILabel *branches;
@property (nonatomic, retain) UIButton *cancle;
@property (nonatomic, retain) UIButton *accept;
@property (nonatomic, retain) UIButton *request;
@property (nonatomic, retain) NSMutableArray *stats;
@property (nonatomic, retain) NSString *follower_id;

@end
