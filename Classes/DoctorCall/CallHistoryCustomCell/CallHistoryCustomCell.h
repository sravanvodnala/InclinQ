//
//  CallHistoryCustomCell.h
//  InclinIQ
//
//  Created by Gagan on 28/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallHistoryCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblBrandDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblCallNotes;
@property (weak, nonatomic) IBOutlet UILabel *callDate;
@property (weak, nonatomic) IBOutlet UILabel *brandDetailed;
@property (weak, nonatomic) IBOutlet UILabel *callNotes;


@end
