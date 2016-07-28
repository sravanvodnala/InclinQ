//
//  Calander.h
//  InclinIQ
//
//  Created by Gagan on 21/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultViewController.h"
#import "SQLManager.h"

@interface Calander : DefaultViewController<UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableDictionary * dicHolidays;
    NSMutableDictionary * dicHolidaysName;
    NSMutableArray* arrLeavs;
    CalenderStruct * objSelectedCalender;
    STPDoctor *selectedSTP;
    IBOutlet UIView *viewBack;
    IBOutlet UIView *viewMain;
    BOOL isSlide;
    BOOL isFirstTime;
    
    IBOutlet UIView *viewTitle;
    
    IBOutlet UIView *view2;
    IBOutlet UIView *view1;
    //*************** Calander ******************//
    
    NSInteger widthCal, heightCal;
    
    UILabel *lblMonthName;
    //    UIButton *btnLeft;
    //    UIButton *btnRight;
    //    UIView *monthView;
    UIButton * selectedButton;
	
	NSInteger currentFirstDay,currentMonth,currentYear,currentLastDay,currentDayConstant,currentMonthConstant,currentYearConstant;
	NSString *selectedDate;
	NSString *currentConstantDate;
	NSInteger currentWeekDay;
	NSInteger currentDayRunning;
	NSString *frontView;
	NSDate *currentDate;
	
    NSMutableArray *arr_View1Buttons;
	NSMutableArray *arr_View2Buttons;
	
    NSMutableArray *arr_View1;
	NSMutableArray *arr_View2;
	
    UIButton *tempButton;
	NSInteger currentDateValue;
    
    CGRect frame0,frame1,frame2;
    IBOutlet UILabel *lblTitle;
    
    NSMutableArray *arrCalanderData;

    //*****************************//
    
    IBOutlet UIView *viewPopUp;
     IBOutlet UITableView *tblView;
     IBOutlet UISearchBar *searchBarCustomers;
     IBOutlet UIButton *btnDoneTblView;
     IBOutlet UILabel *lblStpName;
     IBOutlet UILabel *lblDateTbl;
    
    NSArray *arrAlphabets;
    NSString *stringSearch;
    BOOL isFiltered;
    
    NSMutableArray *filteredTableData;
    NSMutableArray *arrSectionArray;
    NSMutableArray *arrIndexArray;
    NSMutableArray *arrData;
    UIPopoverController *popoverController;
    NSString *stpNameOfCell;
    UIView *viewTempCalCell;
    
    
    IBOutlet UIButton *btnScheduleCallPopUpSub;
    __weak IBOutlet UIButton *btnDeviatelPopUp;
    __weak IBOutlet UIButton *btnScheduleCallPopUp;
    __weak IBOutlet UIButton *btnDonelPopUp;
    //************Sravan Start
    BOOL isPastDate;
    //************Sravan End
}
- (IBAction)btnStandardTourPlanClicked:(UIButton *)sender;


- (IBAction)btnScheduleCallClicked:(UIButton *)sender;
- (IBAction)btnMenuClicked:(UIButton *)sender;
- (IBAction)btnDoneTblViewClicked:(UIButton *)sender;

- (IBAction)onScheduleCall:(UIButton *)sender;
- (IBAction)onDeviate:(UIButton *)sender;
//*************** Calander ******************//
@property (strong, nonatomic) IBOutlet UIView *viewSelection;

@property (nonatomic,strong) IBOutlet UIView *selectionView;
-(void)designTheCalender;
-(void)setCalendar;
-(void)addButtons;
-(void)fillCalender:(NSInteger)month weekStarts:(NSInteger)weekday year:(NSInteger)year;
-(void)clearLabels;
-(NSString *)getMonth:(NSInteger)month;
-(NSInteger)getNumberofDays:(NSInteger)monthInt YearVlue:(NSInteger)yearInt;
-(void)getFirstDay:(NSInteger)month dayfirst:(NSInteger)firstday;
-(void)gotoNextMonth;
-(void)gotoPreviousMonth;
-(void)dateSelected:(id)sender;

@end
