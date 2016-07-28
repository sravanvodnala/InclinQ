//
//  fontProBoldCondenced.m
//  InclinIQ
//
//  Created by Gagan on 16/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "fontProBoldCondenced.h"

@implementation fontProBoldCondenced

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) awakeFromNib
{
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"MyriadPro-BoldCond" size: self.font.pointSize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
