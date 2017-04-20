//
//  StatisticsViewController.h
//  inline
//
//  Created by Matti Muehlemann on 1/28/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PNChart.h"

@interface StatisticsViewController : UIViewController <PNChartDelegate>
{
    PNPieChart *pie;
    UILabel *lbl;
}

@end
