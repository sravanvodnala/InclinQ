//
//  CustomCell.m
//  Filenet
//
//  Created by sravan.vodnala on 30/05/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize lblMain, imgView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
