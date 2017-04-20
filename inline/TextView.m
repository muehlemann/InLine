//
//  Drawer.m
//  inline
//
//  Created by Matti Muehlemann on 1/20/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "TextView.h"

@implementation TextView

@synthesize textArray;

/**
 * Initializes the class
 *
 * @return self
 */
- (id)init
{
    self = [super init];
    if (self)
    {
        // Configure things here
        [self setFrame:CGRectMake(0, 0, _VW, _VH)];
        self.textArray = [[NSMutableArray alloc] init];
        
        background = [[UIVisualEffectView alloc] initWithFrame:self.frame];
        [background setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [background setAlpha:0.0];
        [self addSubview:background];;
        col = [UIColor redColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeTextBox)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

/**
 * Undo
 *
 * @p sender
 */
- (void)undo
{    
    if ([self.textArray count] > 0) {
        UITextView *v = (UITextView *)[self.textArray lastObject];
        [v removeFromSuperview];
        v = nil;
        [self.textArray removeLastObject];
    }
}

/**
 * Change color
 *
 * @p color
 */
- (void)changeColor:(UIColor *)color
{
    col = color;
    [txtView setTextColor:col];
}

/**
 * Makes a textbox on screen
 *
 */
- (void)makeTextBox
{
    if ([txtView isFirstResponder])
    {
        [txtView resignFirstResponder];
    }
    else
    {
        // Update the background
        [self bringSubviewToFront:background];
        [background setAlpha:1.0];
        
        txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, _VH - keyboardHeight - 200, _VW - 20, 60)];
        [txtView setFont:[UIFont boldFlatFontOfSize:30]];
        [txtView setTextColor:col];
        [txtView setTextAlignment:NSTextAlignmentCenter];
        [txtView setBackgroundColor:[UIColor clearColor]];
        [txtView setAutocorrectionType:UITextAutocorrectionTypeNo];
        [txtView setScrollEnabled:NO];
        [txtView becomeFirstResponder];
        [txtView setDelegate:self];
        [self addSubview:txtView];
        
        // Add gesture recognizers
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [txtView addGestureRecognizer:panRecognizer];
        
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        [rotationRecognizer setDelegate:self];
        [txtView addGestureRecognizer:rotationRecognizer];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        [pinchRecognizer setDelegate:self];
        [txtView addGestureRecognizer:pinchRecognizer];
    }
}

/**
 * Keyboard did show
 *
 * @p notification
 */
- (void)keyboardDidShow:(NSNotification *)notification
{
    keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
}

/**
 * Textview did begin editing
 *
 * @p textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGSize size =  [txtView sizeThatFits:CGSizeMake(_VW - 20, FLT_MAX)];
    [txtView setFrame:CGRectMake(0, _VH - keyboardHeight - size.height - 200, _VW - 20, size.height)];
}

/**
 * Textview did change editing
 *
 * @p textView
 */
- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [txtView sizeThatFits:CGSizeMake(_VW - 20, FLT_MAX)];
    [txtView setFrame:CGRectMake(0, _VH - keyboardHeight - size.height - 200, _VW - 20, size.height)];
}
/**
 * Textview did end editing
 *
 * @p textView
 */
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [background setAlpha:0.0];
    
    UITextView *v = txtView;
    [v setAutocorrectionType:UITextAutocorrectionTypeNo];
    [v setUserInteractionEnabled:YES];
    [v setSelectable:NO];
    [v setEditable:NO];

    txtView = nil;
    
    if (textView.text.length > 0) {
        [self.textArray addObject:v];
    }
}

/**
 * Move gesture
 *
 * @p sender
 */
- (void)move:(UIPanGestureRecognizer *)sender
{
    [self bringSubviewToFront:[sender view]];
    CGPoint translatedPoint = [sender translationInView:self];
    
    if([sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        CGFloat finalX = translatedPoint.x + (0 * [sender velocityInView:txtView].x);
        CGFloat finalY = translatedPoint.y + (0 * [sender velocityInView:txtView].y);
        
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
    }
}

/**
 * Scale gesture
 *
 * @p sender
 */
- (void)scale:(UIPinchGestureRecognizer *)sender
{
    [txtView resignFirstResponder];
    
    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
        [sender view].transform = CGAffineTransformScale([[sender view] transform], [sender scale], [sender scale]);
        [sender setScale:1];
    }
}

/**
 * Rotate gesture
 *
 * @p sender
 */
-(void)rotate:(UIRotationGestureRecognizer *)sender
{
    [txtView resignFirstResponder];

    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
        [sender view].transform = CGAffineTransformRotate([[sender view] transform], [sender rotation]);
        [sender setRotation:0];
    }
}

@end
