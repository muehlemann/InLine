//
//  RequestsViewController.h
//  inline
//
//  Created by Matti Muehlemann on 11/16/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "RequestCell.h"

@interface RequestsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    UITableView *tbl;
    NSMutableArray *results;
}

@end
