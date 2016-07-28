//
//  eDetailerController.h
//  InclinIQ
//
//  Created by Gagan on 29/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultViewController.h"
@interface eDetailerController : DefaultViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    
    IBOutlet UIView *viewMain;
    BOOL isSlide;
     IBOutlet UIView *viewBack;

     IBOutlet UISearchBar *searchBarCustomers;
     IBOutlet UITableView *tblViewSearch;
     IBOutlet UITableView *tblPreview;
    NSArray *arrAlphabets;
    NSString *stringSearch;
    BOOL isFiltered;
  
    NSMutableArray *filteredTableData;
    NSMutableArray *arrSectionArray;
    NSMutableArray *arrIndexArray;
    NSMutableArray *arrData;
    NSMutableArray *arrDetailers;
}
- (IBAction)btnPreviewClicked:(UIButton *)sender;
- (IBAction)btnMenuClicked:(UIButton *)sender;

@property (nonatomic,strong)  eDetailor *currenteDetailor;
@end
