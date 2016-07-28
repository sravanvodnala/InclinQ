//
//  HomeViewController.h
//  InclinIQ
//
//  Created by Gagan on 14/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultViewController.h"
@interface HomeViewController : DefaultViewController
{
    
    
    IBOutlet UIScrollView *scrlViewMain;
    
    NSArray *arrDoctorsName;
    NSArray *arrBrandsName;
    NSArray *arrBrandName;
    
     IBOutlet UILabel *lblCurrentDate;
    
     IBOutlet UILabel *lblEmpName;
     IBOutlet UILabel *lblCurrentTime;
     IBOutlet UILabel *lblGoodMorning;
    
    IBOutlet UIView *viewLine;
    IBOutlet UIView *viewBack;
    IBOutlet UIView *viewMain;
    
    BOOL isSlide;
    
}
@property (atomic) BOOL isFirstTime;
@property (nonatomic,strong) NSMutableArray * arrData;
- (IBAction)btnTimeClicked:(UIButton *)sender;
- (IBAction)btnMenuClicked:(UIButton *)sender;
- (IBAction)btnLogoutClicked:(UIButton *)sender;
- (IBAction)btnOpenScheduler:(UIButton *)sender;
@end
