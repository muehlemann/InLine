//
//  RequestCell.m
//  inline
//
//  Created by Matti Muehlemann on 4/3/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "RequestCell.h"

@implementation RequestCell

@synthesize handle, request_date, branches, cancle, accept, request, stats;

/**
 * The initializer function of a custom tableview cell
 *
 * @param style           The stile of the tableview cell
 * @param reuseIdentifier The reuse identifier of the tableview cell
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
        
        self.stats = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, @0, @0, nil];

        // BG with shadow
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 5, _VW - 10, 150)];
        [bg setBackgroundColor:[UIColor whiteColor]];
        [bg.layer setShadowColor:[UIColor blackColor].CGColor];
        [bg.layer setShadowOffset:CGSizeMake(0, 0)];
        [bg.layer setShadowRadius:0.5];
        [bg.layer setShadowOpacity:1];
        [self addSubview:bg];

        // Handle
        self.handle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _VW - 30, 30)];
        [self.handle setFont:[UIFont boldFlatFontOfSize:18]];
        [bg addSubview:self.handle];
        
        // Request Date
        self.request_date = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, _VW - 30, 20)];
        [self.request_date setFont:[UIFont flatFontOfSize:14]];
        [bg addSubview:self.request_date];
        
        // Check Boxes
        for (int i = 0; i < 6; i++)
        {
            BEMCheckBox *box = [[BEMCheckBox alloc] initWithFrame:CGRectMake(10 + (40 * i), 60, 30, 30)];
            [box setTintColor:_C_BRANCHES[i]];
            [box setOnTintColor:_C_BRANCHES[i]];
            [box setOnFillColor:_C_BRANCHES[i]];
            [box setOnCheckColor:[UIColor whiteColor]];
            [box setDelegate:self];
            [box setTag:i];
            [bg addSubview:box];
        }
        
        // Branches
        self.branches = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, _VW - 30, 20)];
        [self.branches setFont:[UIFont flatFontOfSize:10]];
        [self.branches setTextColor:[UIColor lightGrayColor]];
        [self.branches setText:@"NONE"];
        [bg addSubview:self.branches];
        
        // Buttons
        CGFloat width = (bg.bounds.size.width - 30) / 3;
        
        self.cancle = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, width, 30)];
        [self.cancle setTitle:[@"Delete" uppercaseString] forState:UIControlStateNormal];
        [self.cancle setTitleColor:_C_BLUE forState:UIControlStateNormal];
        [self.cancle.titleLabel setFont:[UIFont flatFontOfSize:10]];
        [self.cancle.titleLabel setNumberOfLines:2];
        [self.cancle.layer setBorderColor:_C_BLUE.CGColor];
        [self.cancle.layer setBorderWidth:1];
        [self.cancle.layer setCornerRadius:2];
        [bg addSubview:self.cancle];
        
        self.accept = [[UIButton alloc] initWithFrame:CGRectMake(15 + width, 110, width, 30)];
        [self.accept setTitle:[@"Accept" uppercaseString] forState:UIControlStateNormal];
        [self.accept setTitleColor:_C_BLUE forState:UIControlStateNormal];
        [self.accept.titleLabel setFont:[UIFont flatFontOfSize:10]];
        [self.accept.titleLabel setNumberOfLines:2];
        [self.accept.layer setBorderColor:_C_BLUE.CGColor];
        [self.accept.layer setBorderWidth:1];
        [self.accept.layer setCornerRadius:2];
        [bg addSubview:self.accept];
        
        self.request = [[UIButton alloc] initWithFrame:CGRectMake(20 + (width * 2), 110, width, 30)];
        [self.request setTitle:[@"Accept & Request" uppercaseString] forState:UIControlStateNormal];
        [self.request setTitleColor:_C_BLUE forState:UIControlStateNormal];
        [self.request.titleLabel setFont:[UIFont flatFontOfSize:10]];
        [self.request.titleLabel setNumberOfLines:2];
        [self.request.layer setBorderColor:_C_BLUE.CGColor];
        [self.request.layer setBorderWidth:1];
        [self.request.layer setCornerRadius:2];
        [bg addSubview:self.request];
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

#pragma mark - BEMCheckBox Delegate

/**
 * Detect a box tap
 *
 * @p checkBox
 */
- (void)didTapCheckBox:(BEMCheckBox *)checkBox
{
    // Reset the view
    [self.accept.layer setBorderColor:_C_BLUE.CGColor];
    [self.accept setTitleColor:_C_BLUE forState:UIControlStateNormal];
    [self.request.layer setBorderColor:_C_BLUE.CGColor];
    [self.request setTitleColor:_C_BLUE forState:UIControlStateNormal];

    // Record stats
    [self.stats setObject:([checkBox on]) ? @1 : @0 atIndexedSubscript:checkBox.tag];

    // Get the string
    NSString *t = @"";
    BOOL flag1 = true;
    BOOL flag2 = true;
    for (int i = 0; i < [self.stats count]; i++){
        if ([[self.stats objectAtIndex:i] isEqual:@1]) {
            t = [NSString stringWithFormat:@"%@, %@", t, _BRANCHES[i+1]];
            flag1 = false;
        }
        else
            flag2 = false;
    }
    
    // Checks special cases: All or None selected
    if (flag1)
        t = @"NONE";
    else if (flag2)
        t = @"ALL";
    else
        t = [t substringFromIndex:2];
    
    [self.branches setText:t];
}

@end
