//
//  BrandMappingController.h
//  InclinIQ
//
//  Created by Gagan on 16/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultViewController.h"
@interface BrandMappingController : DefaultViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
     IBOutlet UILabel *lblTitleMain;
    IBOutlet UIView *viewMain;
    IBOutlet UIView *viewBack;
    BOOL isSlide;
    IBOutlet UITableView *tblView;
    IBOutlet UISearchBar *searchBarCustomers;
    IBOutlet UIView *viewTitle;
    
    NSArray *arrAlphabets;
    NSString *stringSearch;
    BOOL isFiltered;
    
    NSMutableArray *filteredTableData;
    NSMutableArray *arrSectionArray;
    NSMutableArray *arrIndexArray;
    NSMutableArray *arrData;
    
}
- (IBAction)btnTargetClicked:(UIButton *)sender;
- (IBAction)btnCustomersClicked:(UIButton *)sender;
- (IBAction)btnHomeButtonClicked:(UIButton *)sender;
- (IBAction)btnMenuClicked:(UIButton *)sender;



@end
