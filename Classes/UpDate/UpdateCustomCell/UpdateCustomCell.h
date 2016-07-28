//
//  UpdateCustomCell.h
//  InclinIQ
//
//  Created by Gagan on 30/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *btnDownload;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblVersion;
@property (strong, nonatomic) IBOutlet UILabel *lblClideCount;
@property (strong, nonatomic) IBOutlet UIProgressView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *lblPercantage;

//-(void)updateProgress : (float)value;


@end
