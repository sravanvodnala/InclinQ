//
//  ScheduleController.h
//  InclinIQ
//
//  Created by Gagan on 14/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

#import "Structures.h"
@interface ScheduleController : UIViewController<UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,HPGrowingTextViewDelegate,UIAlertViewDelegate>
{
    NSString *statusMessage;
     IBOutlet UITableView *tblEDetailers;
     IBOutlet UITableView *tblDoctores;
    UIPopoverController *popoverController;
    UIPopoverController *objPopOver;

    IBOutlet UIView *viewPickerDate;
     IBOutlet UIButton *btnPickerDone;
    IBOutlet UIView *viewCallType;
    HPGrowingTextView *textViewNotes;
    IBOutlet UIView *viewTextViewNotes;
     IBOutlet UIButton *btnDoneTextView;
    
     IBOutlet UIButton *btnScheduleCall;
     IBOutlet UIButton *btnCancel;
    
     IBOutlet UILabel *datetimeview;
     IBOutlet UILabel *calltypeView;
     IBOutlet UILabel *customersview;
     IBOutlet UILabel *edetailerview;
     IBOutlet UILabel *callobjectiveview;
    /**********  Customer/s  ***********/
    IBOutlet UIView *viewCustomers;
    NSArray *arrAlphabets;
    NSString *stringSearch;
    BOOL isFiltered;

    NSMutableArray *arrpopUpDoctors;
    
    NSMutableArray *filteredTableData;
    NSMutableArray *arrSectionArray;
    NSMutableArray *arrIndexArray;

     IBOutlet UITableView *tblCustomers;
     IBOutlet UISearchBar *searchBarCustomers;
     IBOutlet UIButton *btnSearchBarDone;
    
     IBOutlet UIButton *btnAddCustomers;
    
     IBOutlet UIButton *btnDoneUnlistedDr;
     IBOutlet UIButton *btnUnlistedDr;
    IBOutlet UIView *viewAddUnlistedDr;
    /************************************************/
    
    /**********  Call Type/s  ***********/
     IBOutlet UIButton *btnGroupCall;
     IBOutlet UIButton *btnIndividualCall;
     UILabel *lblCallType;
    NSString *strCallType;
    NSInteger intCallType;
    /************************************************/
   
    /**********  Date & Time  ***********/
    NSString *currentTime;
   
    /************************************************/
   
    /**********  Call Objective  ***********/
    NSString *strCallObjective;
    /************************************************/
  
    /**********  e-Detailer  ***********/
    IBOutlet UIView *vieweDetailer;
     IBOutlet UIButton *btnDoneeDetailer;
     IBOutlet UITableView *tbleDetailerPopUp;
    NSMutableArray *arrpopUpeDetailer;
    NSMutableArray *arreDetailer;
    /************************************************/

     IBOutlet UIDatePicker *pickerDate;
     IBOutlet UITextField *unlistedDrNametextField;
     IBOutlet UITextField *unlistedDrSpecializationtextField;

    HPGrowingTextView *textViewObjective;
    
     IBOutlet UILabel *lblTitleMain;
     IBOutlet UILabel *unLIstedCustomerLbl;
     IBOutlet UILabel *addCustomerLbl;
    
    //************Sravan Start
    UIPopoverController *objPopOverSpecialisation;
    NSMutableArray *arrSpecialisations;
    NSString *strSpecialisationPopUp;
    BOOL isSpecialisation;
    
    IBOutlet UIView *viewSpecialisationPopOver;
    
    __weak IBOutlet UIButton *btnviewPopOverDone;
    __weak IBOutlet UITableView *tblViewSpecialisationPopUp;
    
    
    __weak IBOutlet UIButton *btnCancelUnlistedDocPopUp;
    __weak IBOutlet UIButton *btnDoneUnlistedDocPopUp;
    
    doctorStuct *selectedDoc;
    //*****************Sravan End
}
- (IBAction)btnAddSpecialisationClicked:(UIButton *)sender;
- (IBAction)btnDoneSpecialisationPopUpClicked:(UIButton *)sender;
- (IBAction)btnUnlistedDrOKClicked:(UIButton *)sender;
- (IBAction)btnUnlistedDrCancleClicked:(UIButton *)sender;
- (IBAction)btnBackClicked:(UIButton *)sender;
- (IBAction)btnDonePopUpEDetailerClicked:(UIButton *)sender;
- (IBAction)btnDoneTextFieldClicked:(UIButton *)sender;
- (IBAction)btnUnlistedDrClicked:(UIButton *)sender;
- (IBAction)btnAddCustomersClicked:(UIButton *)sender;
- (IBAction)btnCancelClicked:(UIButton *)sender;
- (IBAction)btnScheduleCallClicked:(UIButton *)sender;
- (IBAction)btnSideClicked:(UIButton *)sender;
//@property (strong, nonatomic) IBOutlet UIButton *btnScheduleCallClicked;
//@property (strong, nonatomic) IBOutlet UIButton *btnCancelClicked;
- (IBAction)btnIndividualClicked:(UIButton *)sender;

- (IBAction)btnGroupCallClicked:(UIButton *)sender;
- (IBAction)btnPickerDoneClicked:(UIButton *)sender;
- (IBAction)btnDoneTextViewClilcked:(UIButton *)sender;
- (IBAction)btnSearchBarDoneClicked:(UIButton *)sender;

@property (atomic) BOOL fromMTP;
@property (nonatomic,strong) NSMutableArray *arrDoctors;
@property (nonatomic,strong) NSString *currentDate;

@end
