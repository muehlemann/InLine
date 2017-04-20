//
//  Constants.h
//  inline
//
//  Created by Matti Muehlemann on 11/4/16.
//  Copyright © 2016 Matt Mühlemann. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import <FlatUIKit/FlatUIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <CRToast/CRToast.h>

#define _VW         [UIScreen mainScreen].bounds.size.width
#define _VH         [UIScreen mainScreen].bounds.size.height

#define _API(r)     [NSString stringWithFormat:@"https://ec-thesis.herokuapp.com/api/%@", r]
//#define _API(r)     [NSString stringWithFormat:@"http://localhost:8080/api/%@", r]
//#define _API(r)     [NSString stringWithFormat:@"http://10.128.139.185:8080/api/%@", r]

#define _C_GRAY     [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]
#define _C_BLUE     [UIColor colorWithRed:0.20 green:0.27 blue:0.40 alpha:1.00]

// Branchs have six options
// 0 - all
// 1 - Fun              - yellow
// 2 - Freinds & Family - blue
// 3 - Work Life        - green
// 4 - Food & Fitness   - orange
// 5 - Love             - red
// 6 - Mind & Spirit    - purple

#define _BRANCHES   [[NSArray alloc] initWithObjects:@"ALL", @"FUN", @"FRIENDS & FAMILY", @"WORK LIFE", @"FOOD & FITNESS", @"LOVE", @"MIND & SPIRIT", nil]

#define _C_Y        [UIColor colorWithRed:0.95 green:0.77 blue:0.06 alpha:1.00]
#define _C_R        [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1.00]
#define _C_G        [UIColor colorWithRed:0.18 green:0.80 blue:0.44 alpha:1.00]
#define _C_B        [UIColor colorWithRed:0.20 green:0.60 blue:0.86 alpha:1.00]
#define _C_O        [UIColor colorWithRed:0.90 green:0.49 blue:0.13 alpha:1.00]
#define _C_P        [UIColor colorWithRed:0.61 green:0.35 blue:0.71 alpha:1.00]
#define _C_BRANCHES @[_C_Y, _C_B, _C_G, _C_O, _C_R, _C_P]

#define _ERR_T      1.0


// PUSH NOTIFICATIONS
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#endif /* Constants_h */
