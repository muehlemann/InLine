//
//  SearchCell.m
//  inline
//
//  Created by Matti Muehlemann on 4/4/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

@synthesize handle, btn;

/**
 * The initializer function of a custom tableview cell
 *
 * @p style           The stile of the tableview cell
 * @p reuseIdentifier The reuse identifier of the tableview cell
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:_C_GRAY];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setSeparatorInset:UIEdgeInsetsZero];
        [self setLayoutMargins:UIEdgeInsetsZero];
        
        // BG with shadow
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 5, _VW - 10, 40)];
        [bg setBackgroundColor:[UIColor whiteColor]];
        [bg.layer setShadowColor:[UIColor blackColor].CGColor];
        [bg.layer setShadowOffset:CGSizeMake(0, 0)];
        [bg.layer setShadowRadius:0.5];
        [bg.layer setShadowOpacity:1];
        [self addSubview:bg];
        
        // Handle
        self.handle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, _VW - 30, 30)];
        [self.handle setFont:[UIFont flatFontOfSize:18]];
        [bg addSubview:self.handle];
        
        // Button
        self.btn = [[UIButton alloc] initWithFrame:CGRectMake(_VW - 115, 5, 100, 30)];
        [self.btn setTitleColor:_C_BLUE forState:UIControlStateNormal];
        [self.btn.titleLabel setFont:[UIFont flatFontOfSize:10]];
        [self.btn.titleLabel setNumberOfLines:2];
        [self.btn.layer setBorderColor:_C_BLUE.CGColor];
        [self.btn.layer setBorderWidth:1];
        [self.btn.layer setCornerRadius:2];
        [bg addSubview:self.btn];
    }
    
    return self;
}

/**
 * The method that runs when a cell is selected
 *
 * @p selected The state of selection
 * @p animated The state of animation
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
