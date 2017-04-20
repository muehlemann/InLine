//
//  FollowerViewController.h
//  inline
//
//  Created by Matti Muehlemann on 11/10/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SearchCell.h"

@interface FollowerViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    UILabel *lbl_header;
    UIButton *btn_requests;
    UISearchBar *search;
    UITableView *tbl;
    NSMutableArray *followees;
    NSMutableArray *results;
}

@end
