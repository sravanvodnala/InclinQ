//
//  CallHistoryCustomCell.m
//  InclinIQ
//
//  Created by Gagan on 28/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "CallHistoryCustomCell.h"

@implementation CallHistoryCustomCell
@synthesize lblDate;
@synthesize lblBrandDetail;
@synthesize lblCallNotes;
@synthesize callNotes;
@synthesize callDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
