//
//  Drawer.h
//  inline
//
//  Created by Matti Muehlemann on 1/20/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface TextView : UIView <UITextViewDelegate, UIGestureRecognizerDelegate>
{
    int keyboardHeight;
    UIVisualEffectView *background;
    UITextView *txtView;
    UIColor *col;
    
    CGFloat firstX;
    CGFloat firstY;
    CGFloat lastRotation;
}

- (id)init;
- (void)undo;
- (void)changeColor:(UIColor *)color;
- (void)makeTextBox;

@property (nonatomic, retain) NSMutableArray *textArray;

@end
