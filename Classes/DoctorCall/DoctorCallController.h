//
//  DoctorCallController.h
//  InclinIQ
//
//  Created by Gagan on 28/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "HPGrowingTextView.h"
#import "eDetailerSlideShow.h"

@interface DoctorCallController : UIViewController<UIPopoverControllerDelegate,HPGrowingTextViewDelegate,UIAlertViewDelegate,eDetailerSlideShowDelegate>
{
    BOOL isDetailingDone;
     IBOutlet UILabel *lblTitleMEnu;
    HPGrowingTextView *textViewNotes;
     IBOutlet UIButton *btnDoneTextView;
    IBOutlet UIButton *btnBack;;
    UIPopoverController *popoverController;
    UIPopoverController *objPopOver;

     IBOutlet UITableView *tblCallHistory;
     IBOutlet UITableView *tbleDetailers;
     IBOutlet UITableView *tblDoctors;
    
   // NSMutableArray *arrDoctors;
    NSMutableArray *arrCallHistory;
    NSMutableArray *arreDetailers;
    
    ScheduleCallDescription * objSCD;
    
    IBOutlet UIView *viewAddDoctorPopUp;
    IBOutlet UIView *viewAddNotesPOpUp;
    
     IBOutlet UIButton *btnDoneAddDoctor;
    
    /**********  Customer/s  ***********/
    
    NSArray *arrAlphabets;
    NSString *stringSearch;
    BOOL isFiltered;
    
    NSMutableArray *filteredTableData;
    NSMutableArray *arrSectionArray;
    NSMutableArray *arrIndexArray;
    NSMutableArray *arrpopUpDoctors;

    IBOutlet UIView *viewCustomers;
    IBOutlet UITableView *tblCustomers;
    IBOutlet UISearchBar *searchBarCustomers;
    IBOutlet UIButton *btnAddCustomers;
    IBOutlet UIView *viewAddUnlistedDr;
   
    //************Sravan Start
    UIPopoverController *objPopOverSpecialisation;
    NSMutableArray *arrSpecialisations;
    NSString *strSpecialisationPopUp;
    BOOL isSpecialisation;
    
    IBOutlet UIView *viewSpecialisationPopOver;
    
    __weak IBOutlet UIButton *btnviewPopOverDone;
    __weak IBOutlet UITableView *tblViewSpecialisationPopUp;
    doctorStuct *selectedDoc;
    int isDrFromTempSchedule; 
    //************Sravan End

}
- (IBAction)btnDoneSpecialisationPopUpClicked:(UIButton *)sender;
- (IBAction)btnAddSpecialisationClicked:(UIButton *)sender;  //************Sravan

- (IBAction)btnAddUnlistedCustomersClicked:(UIButton *)sender;
- (IBAction)btnAddCustomersClicked:(UIButton *)sender;
- (IBAction)btnCancelClicked:(UIButton *)sender;
- (IBAction)btnDoneAddDoctorClicked:(UIButton *)sender;
- (IBAction)btnNotesDoneClicked:(UIButton *)sender;
- (IBAction)btnAddDoctorClicked:(UIButton *)sender;
- (IBAction)btnCallNotesClicked:(UIButton *)sender;
- (IBAction)btnBackClicekd:(UIButton *)sender;
- (IBAction)btnCallCompletedClicked:(UIButton *)sender;
@property (nonatomic,strong) ScheduleCallDescription * objSCD;

@property (nonatomic,strong) IBOutlet UITextField *txtDrName;
@property (nonatomic,strong) IBOutlet UITextField *txtSpecialization;

@property (nonatomic,strong) IBOutlet UIButton *btnAddDr;
@property (nonatomic,strong) IBOutlet UIButton *btnCallCompleted;
@property (nonatomic,strong) IBOutlet UIButton *btnCallNotes;
@end
