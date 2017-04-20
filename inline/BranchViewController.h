//
//  BranchViewController.h
//  inline
//
//  Created by Matti Muehlemann on 2/1/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cloudinary/Cloudinary.h"
#import "Constants.h"

@interface BranchViewController : UIViewController <CLUploaderDelegate>
{
    bool posted;
    int branch;
}

@property (nonatomic, retain) NSData *data;

@end
