//
//  WorkFlowCell.h
//  Filenet
//
//  Created by sravan.vodnala on 30/05/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkFlowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *versionnumber;
@property (weak, nonatomic) IBOutlet UILabel *noofslides;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (strong, nonatomic) IBOutlet UILabel *lblBrandName;
@property (strong, nonatomic) IBOutlet UILabel *lblNumberOFSlides;
@property (strong, nonatomic) IBOutlet UILabel *lblVersionNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@end
