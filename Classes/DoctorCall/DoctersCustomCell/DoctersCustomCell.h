//
//  DoctersCustomCell.h
//  InclinIQ
//
//  Created by Gagan on 28/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctersCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *callObjective;
@property (weak, nonatomic) IBOutlet UILabel *DrName;
@property (strong, nonatomic) IBOutlet UILabel *lblDoctorName;
@property (strong, nonatomic) IBOutlet UILabel *lblCallObjective;

@end
