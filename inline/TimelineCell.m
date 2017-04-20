//
//  TimelineCell.m
//  inline
//
//  Created by Matti Muehlemann on 4/4/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "TimelineCell.h"

@implementation TimelineCell

@synthesize img, handle, date;

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
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 5, _VW - 10, 70)];
        [bg setBackgroundColor:[UIColor whiteColor]];
        [bg.layer setShadowColor:[UIColor blackColor].CGColor];
        [bg.layer setShadowOffset:CGSizeMake(0, 0)];
        [bg.layer setShadowRadius:0.5];
        [bg.layer setShadowOpacity:1];
        [self addSubview:bg];
    
        // Image
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _VW - 10, 70)];
        [self.img setContentMode:UIViewContentModeScaleAspectFill];
        [self.img.layer setMasksToBounds:YES];
        [bg addSubview:self.img];
        
        UIVisualEffectView *v = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 50, _VW - 10, 20)];
        [v setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [bg addSubview:v];
        
        // Handle
        self.handle = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _VW - 20, 20)];
        [self.handle setFont:[UIFont boldSystemFontOfSize:12]];
        [self.handle setTextColor:[UIColor whiteColor]];
        [v addSubview:self.handle];
        
        // Date
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _VW - 20, 20)];
        [self.date setFont:[UIFont boldSystemFontOfSize:12]];
        [self.date setTextColor:[UIColor whiteColor]];
        [self.date setTextAlignment:NSTextAlignmentRight];
        [v addSubview:self.date];
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
