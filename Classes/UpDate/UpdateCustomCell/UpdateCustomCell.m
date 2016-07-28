//
//  UpdateCustomCell.m
//  InclinIQ
//
//  Created by Gagan on 30/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "UpdateCustomCell.h"

@implementation UpdateCustomCell
@synthesize imgView;
@synthesize btnDownload;
@synthesize lblTitle;
@synthesize activityIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//-(void)updateProgress : (float)value
//{
//   // self.activityIndicator.progress = value;
//    
//    [self.activityIndicator setProgress:(float)value];
// 
//    [self bringSubviewToFront:self.activityIndicator];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
