//
//  StandardTourPlan.h
//  InclinIQ
//
//  Created by Gagan on 20/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandardTourPlan : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
     IBOutlet UITableView *tblSTP;
     IBOutlet UITableView *tblDoctores;
     IBOutlet UISearchBar *searchBar;
    NSArray *arrAlphabets;
    NSString *stringSearch;
    BOOL isFiltered;
    
    NSMutableArray *filteredTableData;
    NSMutableArray *arrSectionArray;
    NSMutableArray *arrIndexArray;
    NSMutableArray *arrData;
    
    NSMutableArray *arrDoctors;
    NSString *strSTPName;
    NSInteger intDoctorid;
    BOOL isDraged;
    BOOL isFirstTime;
}
- (IBAction)btnBackClicked:(UIButton *)sender;

@end
