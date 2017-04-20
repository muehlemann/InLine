//
//  UpdatesViewController.h
//  inline
//
//  Created by Matti Muehlemann on 11/10/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UIImageView+AFNetworking.h"
#import "DisplayViewController.h"
#import "TimelineCell.h"

@interface UpdatesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    UIRefreshControl *refresh;
    UILabel *lbl_header;
    UITableView *tbl;
    NSMutableArray *timelines;
}

@end
