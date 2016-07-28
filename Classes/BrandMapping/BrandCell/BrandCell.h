//
//  BrandCell.h
//  InclinIQ
//
//  Created by Gagan on 16/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeciality;

@property (weak, nonatomic) IBOutlet UIButton *btnCell;
@property (weak, nonatomic) IBOutlet UILabel *lblTargetBrands;
@end
