//
//  CustomerCell.h
//  InclinIQ
//
//  Created by Gagan on 30/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UITextView *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblQualification;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeciality;
@property (strong, nonatomic) IBOutlet UILabel *lblDOB;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@end
