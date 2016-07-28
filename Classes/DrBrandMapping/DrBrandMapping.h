//
//  DrBrandMapping.h
//  InclinIQ
//
//  Created by Gagan on 16/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
@interface DrBrandMapping : UIViewController<UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UIPopoverController *popoverController;
    
   IBOutlet UIView *viewTargettedBrands;
   IBOutlet UIView *viewBrands;
 
   IBOutlet UIButton *btnEdit;
   IBOutlet UILabel *lblBrands;

   CGRect frameTargettedBrands;
   CGRect frameBrands;
    
   IBOutlet UILabel *lblSpecialist;
   IBOutlet fontProCondensed *lblDrName;
   IBOutlet UITableView *tblViewDoctors;
   IBOutlet UISearchBar *searchBarDoctors;
    
   IBOutlet UIView *viewPopUp;
   NSArray *arrAlphabets;
   NSString *stringSearch;
   BOOL isFiltered;
    NSMutableArray * arrPreviousBrands;
    
    NSMutableArray *filteredTableData;
    NSMutableArray *arrSectionArray;
    NSMutableArray *arrIndexArray;
    NSMutableArray *arrData;
    
    
    NSMutableArray *arrTargettedBrands;
    NSMutableArray *arrBrands;
       
    NSString *strDrName;
    NSString *strSpecialist;
    int intDoctorid;
    __weak IBOutlet UIButton *btnSave;
    __weak IBOutlet UIButton *btnCancel;
    
    BOOL isEditable;

    CGRect tempRect;
    CGRect actualRect;
    UIView *viewTempBrands;
    UIView *viewTempTargettedBrands;
    
    drBrandCluster *selectedBrandCluster;
    BOOL isFirstTime;
}
- (IBAction)btnSaveClicked:(UIButton *)sender;
- (IBAction)btnCancelClicked:(UIButton *)sender;
- (IBAction)btnPopUpClicked:(UIButton *)sender;
- (IBAction)btnEditClicked:(UIButton *)sender;
- (IBAction)ntmBackClicked:(id)sender;
@end