//
//  DoctorCallController.m
//  InclinIQ
//
//  Created by Gagan on 28/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "DoctorCallController.h"
#import "Defines.h"
#import "WorkFlowCell.h"
#import "CallHistoryCustomCell.h"
#import "DoctersCustomCell.h"
#import "UIPopUPViewController.h"
#import "SQLManager.h"
#import "eDetailorPreviewViewController.h"
#import "AppDelegate.h"
#import "eDetailerSlideShow.h"

#define imgChecked @"checked-_ipad.png"
#define imgUnChecked @"uncheckednew_ipad.png"

@interface DoctorCallController ()

@end

@implementation DoctorCallController
@synthesize objSCD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        objSCD = [[ScheduleCallDescription alloc]init];
        [objSCD initObject];
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
//    if(isDetailingDone)
//    {
//        btnBack.hidden = YES;
//    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navigationController.navigationBarHidden = YES;

    
    arrCallHistory = [[NSMutableArray alloc] init];
    arreDetailers = [[NSMutableArray alloc] init];
    arreDetailers = objSCD.arreDetailors;
    arrCallHistory = objSCD.arrPreviousHistory;
    
    arrpopUpDoctors = [[NSMutableArray alloc] init];
    arrSectionArray = [[NSMutableArray alloc] init];
    arrIndexArray = [[NSMutableArray alloc] init];
    filteredTableData = [[NSMutableArray alloc] init];
    arrAlphabets=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    SQLManager *objSQl = [SQLManager sharedInstance];
    arrpopUpDoctors = [objSQl getDoctor:objSCD.date];
    arrpopUpDoctors = [self removedAlreadySCheduledDrs];
    [self getDataForSearch];

    
      //************Sravan Start
    arrSpecialisations = [[NSMutableArray alloc] init];
    arrSpecialisations = [objSQl getSpecialisation];
    
    self.txtDrName.font = font_ProCond(20.0);
    self.txtSpecialization.font = font_ProCond(20.0);
      //************Sravan End
    textViewNotes = [[HPGrowingTextView alloc] init];
    textViewNotes.isScrollable = NO;
    textViewNotes.delegate =self;
    textViewNotes.minNumberOfLines = 4;
    textViewNotes.frame = CGRectMake(5, btnDoneTextView.frame.size.height + 10, viewAddNotesPOpUp.frame.size.width - 10, viewAddNotesPOpUp.frame.size.height - btnDoneTextView.frame.size.height - 6);
    textViewNotes.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    textViewNotes.font = font_ProCond(20.0);
    textViewNotes.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    textViewNotes.userInteractionEnabled = YES;
    textViewNotes.maxNumberOfLines = 3;
	textViewNotes.returnKeyType = UIReturnKeyNext;
	textViewNotes.delegate = self;
    textViewNotes.backgroundColor = [UIColor whiteColor];
    textViewNotes.placeholder = @"Enter Call Objectives";
    [viewAddNotesPOpUp addSubview:textViewNotes];
    
    textViewNotes.text = objSCD.callNotes ;
    CALayer * l = [textViewNotes layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];

    [self setCurveLayer:btnDoneTextView];
    [self setCurveLayer:btnDoneAddDoctor];
    
    if(objSCD.isCallCompleted)
    {
        self.btnAddDr.enabled = NO;
        self.btnCallCompleted.enabled = NO;
        self.btnCallNotes.enabled = NO;
    }
}

-(NSMutableArray *)removedAlreadySCheduledDrs
{
    NSMutableArray * temp = [[NSMutableArray alloc]initWithArray:arrpopUpDoctors];
    
    BOOL bFound;
    for(int i=0; i < temp.count; i++)
    {
        bFound = NO;
        doctorStuct * objDr1 = [temp objectAtIndex:i];
        for(int j=0; j < objSCD.arrDoctors.count; j++)
        {
            doctorStuct * objDr2 = [objSCD.arrDoctors objectAtIndex:j];
            
            if(objDr1.doctorId == objDr2.doctorId)
            {
                bFound = YES;
                break;
            }
        }
        
        if(bFound)
        {
            doctorStuct * objDr1 = [arrpopUpDoctors objectAtIndex:i];
            objDr1.isSelected = YES;
            
        }
    }
    
    return arrpopUpDoctors;
}

-(void)getDataForSearch
{
    for(int i = 0; i<[arrAlphabets count];i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int x=0;x<[arrpopUpDoctors count];x++)
        {
            doctorStuct *objDocStruct = [arrpopUpDoctors objectAtIndex:x];
            
            NSString *myString = objDocStruct.fname;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            
            if( [ichar isEqualToString:[arrAlphabets objectAtIndex:i]])
            {
                NSLog(@"%@", myString);
                [array addObject:objDocStruct];
            }
        }
        if([array count])
        {
            doctorStuct *objDocStructSub = [array objectAtIndex:0];
            
            NSString *myString = objDocStructSub.fname;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            [arrIndexArray addObject:ichar];
            [arrSectionArray addObject:array];
        }
        array = nil;
    }
    NSLog(@"%@",[arrSectionArray description]);
    NSLog(@"%d",[arrSectionArray count]);
    

}
//************Sravan Start
#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtSpecialization)
    {
        [textField resignFirstResponder];
    }
    return  YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//************Sravan End
#pragma mark - SearchBar Delegate methods
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    stringSearch = text;
    if(text.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        
        if([filteredTableData count])
            [filteredTableData removeAllObjects];
        
        NSLog(@"%@",[filteredTableData description]);
        
        for (int i=0; i<[arrpopUpDoctors count];i++)
        {
            doctorStuct *obj = [arrpopUpDoctors objectAtIndex:i];
            NSRange descriptionRange = [obj.fname rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:[arrpopUpDoctors objectAtIndex:i]];
            }
        }
    }
    [tblCustomers reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Growing TWxtView Delegates
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark TableView Delegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    view.backgroundColor =    [UIColor clearColor];
//[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];

    if(tableView == tblDoctors)
        return view;
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    imgLogo.backgroundColor = [UIColor clearColor];
    [view addSubview:imgLogo];
    
    UILabel *lbleDetailer = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 320, 40)];
    lbleDetailer.textAlignment = NSTextAlignmentLeft;
    lbleDetailer.font = font_ProBoldCondensed(20.0);
    lbleDetailer.backgroundColor = [UIColor clearColor];
    [view addSubview:lbleDetailer];
    
    if(tableView == tbleDetailers)
    {
        imgLogo.image = [UIImage imageNamed:@"icon-eDetailers-30x30.png"];
        lbleDetailer.text = @"e-Detailers";
    }
    if(tableView == tblCallHistory)
    {
        imgLogo.frame = CGRectMake(0, 0, 40, 40);
        imgLogo.image = [UIImage imageNamed:@"icon-call-history-50x50.png"];
        lbleDetailer.text = @"Call History";
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == tblDoctors || tableView == tblCustomers || tableView == tblViewSpecialisationPopUp)
        return 0.0;

    return 40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblCallHistory)
        return [self getrowHeightForCallNotes:indexPath.row];
    if(tableView == tblDoctors)
        return [self getrowHeightForDoctors:indexPath.row];
    if(tableView == tblCustomers || tableView == tblViewSpecialisationPopUp)
        return 40.0;
    return 120.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == tblCustomers)
    {
        if(isFiltered)
            return 1;
        else
            return [arrSectionArray count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblDoctors)
        return 1;
    
    if(tableView == tbleDetailers)
        return arreDetailers.count;

    if(tableView == tblCallHistory)
        return arrCallHistory.count;
   
    if(tableView == tblViewSpecialisationPopUp)
        return arrSpecialisations.count;
        
    if(tableView == tblCustomers)
    {
        if(isFiltered)
            return [filteredTableData count];
        else
            return [[arrSectionArray objectAtIndex:section] count];
    }
    
    return 0.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if(tableView == tblViewSpecialisationPopUp)
     {
         static NSString *CellIdentifier = @"Cell";
         UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         
        specialisationStruct * objSpc  = [arrSpecialisations objectAtIndex:indexPath.row];
         if (cell == nil)
         {
             cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
             cell.textLabel.font = fontSub(18.0);
             UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 35, tblCustomers.frame.size.width, 5.0)];
             view.backgroundColor =  [UIColor whiteColor];
             [cell.contentView addSubview:view];
         }
         
         cell.textLabel.text = objSpc.name;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
         return cell;
     }
    
    else if(tableView == tbleDetailers)
    {
        WorkFlowCell *cell = (WorkFlowCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WorkFlowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];

            eDetailor *objStructure = [arreDetailers objectAtIndex:indexPath.row];
            cell.btnCheckBox.hidden = YES;
//            cell.versionnumber.font = fontMain(18.0);
//            cell.noofslides.font = fontMain(18.0);
//            cell.brandName.font = fontMain(18.0);
//            
//            cell.lblBrandName.font = fontSub(18.0);
//            cell.lblNumberOFSlides.font = fontSub(18.0);
//            cell.lblVersionNumber.font = fontSub(18.0);
            cell.imgView.image = [UIImage imageWithContentsOfFile:objStructure.imgPath];
            cell.lblBrandName.text = [NSString stringWithFormat:@"%@",objStructure.brandName];
            cell.lblNumberOFSlides.text = [NSString stringWithFormat:@"%d",objStructure.noOfSlides];
            cell.lblVersionNumber.text = [NSString stringWithFormat:@"%@",objStructure.versionNo];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
    else if(tableView == tblCallHistory)
    {
        CallHistoryCustomCell *cell = (CallHistoryCustomCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CallHistoryCustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
           
            CallDetailHistory *obj = [arrCallHistory objectAtIndex:indexPath.row];

            NSString *strBrands = obj.BrandNames;
            
            CGFloat heightOfBrand, heightOfCallNotes, cellHeight;
            
            heightOfBrand = [Utils getHeightOfString:strBrands withFont:fontSub(18.0) withWidth:352];
            heightOfCallNotes = [Utils getHeightOfString:obj.CallDetails withFont:fontSub(18.0) withWidth:352];
            
            cell.lblDate.text = obj.Date;
            cell.lblBrandDetail.text = strBrands;
            cell.lblCallNotes.text = obj.CallDetails;
            
//            cell.lblDate.font = fontSub(18.0);
//            cell.lblBrandDetail.font = fontSub(18.0);
//            cell.lblCallNotes.font = fontSub(18.0);
//          
//            cell.callDate.font = fontMain(18.0);
//            cell.brandDetailed.font = fontMain(18.0);
//            cell.callNotes.font = fontMain(18.0);
//            
            cell.lblBrandDetail.frame = CGRectMake(cell.lblBrandDetail.frame.origin.x, cell.lblBrandDetail.frame.origin.y, cell.lblBrandDetail.frame.size.width, heightOfBrand);

            cellHeight = cell.lblBrandDetail.frame.origin.y +  cell.lblBrandDetail.frame.size.height + 5;
            
           cell.callNotes.frame = CGRectMake(cell.callNotes.frame.origin.x, cellHeight, cell.callNotes.frame.size.width, cell.callNotes.frame.size.height);
           
            cellHeight = cell.callNotes.frame.origin.y +  cell.callNotes.frame.size.height + 5;

            cell.lblCallNotes.frame = CGRectMake(cell.lblCallNotes.frame.origin.x, cellHeight, cell.lblCallNotes.frame.size.width, heightOfCallNotes);
           
            cellHeight = cell.lblCallNotes.frame.origin.y +  cell.lblCallNotes.frame.size.height + 5;

            cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, cellHeight);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
    else if(tableView == tblCustomers)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UIButton *btn = nil;
        
        doctorStuct *objDoctorsStruct = nil;
        
        if(isFiltered)
        {
            objDoctorsStruct = [filteredTableData objectAtIndex:indexPath.row];
            
        }
        else
        {
            objDoctorsStruct = [[arrSectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
        }
        
        if (cell == nil)
        {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(tblCustomers.frame.size.width - 60, 2, 30, 30);
            btn.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
            btn.imageView.tag = indexPath.section;
            [btn setImage:[UIImage imageNamed:imgUnChecked] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = 1;
            [btn addTarget:self action:@selector(btnAddCustomerClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.textLabel.font = fontSub(18.0);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 35, tblCustomers.frame.size.width, 5.0)];
            view.backgroundColor =  [UIColor whiteColor];
            [cell.contentView addSubview:view];
        }
        else
        {
            btn = (UIButton *)[cell.contentView viewWithTag:1];
            btn.imageView.tag = indexPath.section;
            btn.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
            
        }
        
        
        cell.textLabel.text = objDoctorsStruct.fname;
        
        if(objDoctorsStruct.isSelected)
            [btn setImage:[UIImage imageNamed:imgChecked] forState:UIControlStateNormal];
        else
            [btn setImage:[UIImage imageNamed:imgUnChecked] forState:UIControlStateNormal];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        DoctersCustomCell *cell = (DoctersCustomCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DoctersCustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            NSString *strBrands = [[NSString alloc] init];
            for(int i=0; i<objSCD.arrDoctors.count; i++)
            {
                doctorStuct *obj = [objSCD.arrDoctors objectAtIndex:i];
                NSString *strTemp = [NSString stringWithFormat:@"Dr. %@ - %@",obj.fname,obj.specializationName];
                if(i == objSCD.arrDoctors.count-1)
                    strBrands = [NSString stringWithFormat:@"%@ %@.",strBrands,strTemp];
                else
                strBrands = [NSString stringWithFormat:@"%@ %@,",strBrands,strTemp];
            }
            CGFloat heightOfDoctors, heightOfCallNotes, cellHeight;
            
            heightOfDoctors = [Utils getHeightOfString:strBrands withFont:font_ProCond(18.0) withWidth:520]+20;
            heightOfCallNotes = [Utils getHeightOfString:objSCD.callObjective withFont:font_ProCond(18.0) withWidth:520]+20;
            
            cell.lblDoctorName.text = strBrands;
            cell.lblCallObjective.text = objSCD.callObjective;
            
            cell.lblDoctorName.frame = CGRectMake(cell.lblDoctorName.frame.origin.x, cell.lblDoctorName.frame.origin.y, cell.lblDoctorName.frame.size.width, heightOfDoctors);
           
            if(heightOfDoctors>25)
                cellHeight =  cell.lblDoctorName.frame.origin.y + cell.lblDoctorName.frame.size.height  ;
            else
                cellHeight = cell.callObjective.frame.origin.y;
            
            cell.callObjective.frame = CGRectMake(cell.callObjective.frame.origin.x, cellHeight, cell.callObjective.frame.size.width, cell.callObjective.frame.size.height);

            cellHeight =  cell.callObjective.frame.origin.y + cell.callObjective.frame.size.height  ;

            cell.lblCallObjective.frame = CGRectMake(cell.lblCallObjective.frame.origin.x, cellHeight, cell.lblCallObjective.frame.size.width, heightOfCallNotes);

            cellHeight =  cell.lblCallObjective.frame.origin.y + cell.lblCallObjective.frame.size.height  ;

            cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, cellHeight);
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
     if(tableView == tbleDetailers)
     {
    
         if(objSCD.isCallCompleted == NO)
         {
             eDetailor *objeDet = [arreDetailers objectAtIndex:indexPath.row];
             SQLManager * objSQL = [SQLManager sharedInstance];
           
             if([objSQL isDownloadedeDetailor :objeDet.Id] == YES)
             {
                 eDetailerSlideShow *objController = [[eDetailerSlideShow alloc] initWithNibName:nil bundle:nil];
                 objController.delegate = self;
                 [self.navigationController pushViewController:objController animated:YES];
                 objController.captureTime = YES;
                 
                 objeDet.isDetailed = YES;
                 if(objSCD.arrDoctors.count > 1)
                     
                 {
                    NSMutableArray * arreDet = [objSQL geteDetailerDataForPrew:YES];
                     for(int i=0; i < arreDet.count; i++)
                     {
                         eDetailor * objDet = [arreDet objectAtIndex:i];
                         if(objeDet.Id == objeDet.Id)
                         {
                            // int scheduleContentId = objeDet.scheduleContentId;
                             
                             objeDet = objDet;
                             objeDet.scheduleContentId = objeDet.Id;
                             //objeDet.scheduleContentId = objSCD.ScheduleId;
                             break;
                         }
                     }
                 }
                 
                 objController.currenteDetailor =  objeDet;
                 objController.currentScheduleContentId = objSCD.ScheduleId;//objeDet.scheduleContentId;
                 objController.currentScheduleId = objSCD.ScheduleId;
                 objController.isFromTempTables = objSCD.StandardTourPlanDayId;
                 objController = nil;
                 
                 //eDetailorId:(int)eDetId time:(NSString *)strTime table:(int)type;
                 
                 [objSQL updateStartTimeInScheduleContentForScheduleId:objSCD.ScheduleId eDetailorId:objeDet.Id time:[Utils getCurrentDateTime] table:objSCD.StandardTourPlanDayId];
                // isDetailingDone = YES;
             }
             else
             {
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please download the Brand to continue... " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
                 return;
             }
         }
         
     }
     else if(tableView == tblViewSpecialisationPopUp)
     {
         specialisationStruct * objSpc = [arrSpecialisations objectAtIndex:indexPath.row];
         strSpecialisationPopUp = objSpc.name;
         [self removePopUpSpecialisations];
         self.txtSpecialization.text = strSpecialisationPopUp;
     }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    view.backgroundColor =  [UIColor clearColor];
    return view;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == tblCustomers)
    {
        if(isFiltered)
            return 0;
        else
            return arrIndexArray;
    }
    return nil;
}
#pragma mark - Search Bar
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(isFiltered)
        return stringSearch;
    else
    {
        return [arrIndexArray objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(tableView == tblCustomers)
    {
        
        if(isFiltered)
            return 0;
        else
            return [arrIndexArray indexOfObject:title];
    }
    return 0;
}


-(CGFloat)getrowHeightForCallNotes:(NSInteger)indexPath
{
    CallDetailHistory *obj = [arrCallHistory objectAtIndex:indexPath];
    
    NSString *strBrands = [[NSString alloc] init];
    
    strBrands = obj.BrandNames;
    CGFloat heightOfBrand, heightOfCallNotes;
    
    heightOfBrand = [Utils getHeightOfString:strBrands withFont:fontHelvetica_15 withWidth:352];
    heightOfCallNotes = [Utils getHeightOfString:obj.CallDetails withFont:fontHelvetica_15 withWidth:352];
    
    if(heightOfBrand>25)
        heightOfBrand = MAX(heightOfBrand, 25);
    
    if(heightOfCallNotes>25)
        heightOfCallNotes = MAX(heightOfCallNotes, 25);

    return heightOfBrand + heightOfCallNotes + 120;
}
-(CGFloat)getrowHeightForDoctors:(NSInteger)indexPath
{
    NSString *strBrands = [[NSString alloc] init];
    for(int i=0; i<objSCD.arrDoctors.count; i++)
    {
        doctorStuct *obj = [objSCD.arrDoctors objectAtIndex:i];
        NSString *strTemp = [NSString stringWithFormat:@"%@ %@",obj.fname,obj.lname];
        strBrands = [NSString stringWithFormat:@"%@, %@",strBrands,strTemp];
    }
    
    CGFloat heightOfDoctors, heightOfCallNotes;
    
    heightOfDoctors = [Utils getHeightOfString:strBrands withFont:fontSub(20.0) withWidth:520]+20;
    heightOfCallNotes = [Utils getHeightOfString:objSCD.callObjective withFont:fontSub(20.0) withWidth:520]+20;
    
    if(heightOfDoctors>25)
        heightOfDoctors = MAX(heightOfDoctors, 25);
   
    if(heightOfCallNotes>25)
        heightOfCallNotes = MAX(heightOfCallNotes, 25);
    
        return heightOfDoctors + heightOfCallNotes + 100;

}
-(void)setCurveLayer:(UIView *)view
{
    CALayer * l = [view layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:8.0];
}

#pragma mark - slideShow delegate
-(void)slideShowCompleted:(NSMutableArray *)arrSlides eDetId: (NSString *)eId;
{
    for(int i = 0; i < objSCD.arreDetailors.count ; i++)
    {
        eDetailor * objDet = [objSCD.arreDetailors objectAtIndex:i];
        if(objDet.Id == [eId intValue])
        {
            objDet.arrSlides = arrSlides;
            break;
        }
    }
    
    
}
#pragma mark - PopOevr
 //************Sravan Start
-(void)removePopUpUnlistedDoctores
{
    [objPopOver dismissPopoverAnimated:YES];
}
-(void)removePopUpSpecialisations
{
    [objPopOverSpecialisation dismissPopoverAnimated:YES];
}


- (IBAction)btnDoneSpecialisationPopUpClicked:(UIButton *)sender
{
}

- (IBAction)btnAddSpecialisationClicked:(UIButton *)sender
{
    UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
    objPopOverSpecialisation = [[UIPopoverController alloc] initWithContentViewController:objViewController];
    
    UIView *viewPopOveriPad = [[UIView alloc] init];
    
    
    viewSpecialisationPopOver.frame = CGRectMake(0, 0, viewSpecialisationPopOver.frame.size.width, viewSpecialisationPopOver.frame.size.height);
    viewPopOveriPad.frame = viewSpecialisationPopOver.frame;
    [viewPopOveriPad addSubview:viewSpecialisationPopOver];
    
    objViewController.view = viewPopOveriPad;
    [objPopOverSpecialisation setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
    
    [objPopOverSpecialisation presentPopoverFromRect:[sender bounds]
                                inView:sender
              permittedArrowDirections:UIPopoverArrowDirectionRight
                              animated:YES];
}
 //************Sravan End
- (IBAction)btnAddUnlistedCustomersClicked:(UIButton *)sender
{
     UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
     objPopOver = [[UIPopoverController alloc] initWithContentViewController:objViewController];
 
     UIView *viewPopOveriPad = [[UIView alloc] init];
 
 
     viewAddDoctorPopUp.frame = CGRectMake(0, 0, viewAddDoctorPopUp.frame.size.width, viewAddDoctorPopUp.frame.size.height);
     viewPopOveriPad.frame = viewAddDoctorPopUp.frame;
     [viewPopOveriPad addSubview:viewAddDoctorPopUp];
 
     objViewController.view = viewPopOveriPad;
     [objPopOver setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
 
     [objPopOver presentPopoverFromRect:[sender bounds]
                                        inView:sender
                      permittedArrowDirections:UIPopoverArrowDirectionDown
                                      animated:YES];
}

- (IBAction)btnAddCustomersClicked:(UIButton *)sender
{
    [self removePopUp];
    [tblDoctors reloadData];
}

- (IBAction)btnCancelClicked:(UIButton *)sender
{
//    if(isDetailingDone == YES)
//    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to cancel the call? All your data will be lost" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
//        alert.tag = 3;
//        [alert show];
//    }
//    else
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    objDel.arrScheduleData = [objSQL getScheduleCallData];
    
        [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnDoneAddDoctorClicked:(UIButton *)sender
{
    doctorStuct * objDr = [[doctorStuct alloc]init];
    objDr.doctorId = 0;
    objDr.fname = self.txtDrName.text;
    objDr.specializationName = self.txtSpecialization.text;
    
    doctorStuct * objDr1 = [[doctorStuct alloc]init];
    objDr1 = objDr;
    
    if (objSCD.StandardTourPlanDayId == 1)
        objDr1.isSchInsert = 1;
    else
        objDr1.isSchInsert = 0;
    
    objDr1.scheduleId = objSCD.ScheduleId;
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    [objSQL insertIntoSchuleCall:objDr1];
    [objSCD.arrDoctors addObject:objDr];
    objSCD.callType = GROUP_CALL;
    [tblDoctors reloadData];
    [self removePopUpUnlistedDoctores];
    
    
}

- (IBAction)btnNotesDoneClicked:(UIButton *)sender
{
    objSCD.callNotes = textViewNotes.text;
    [self removePopUp];
}

- (IBAction)btnAddDoctorClicked:(UIButton *)sender
{
    UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:objViewController];
    
    UIView *viewPopOveriPad = [[UIView alloc] init];
    
    viewCustomers.frame = CGRectMake(0, 0, viewCustomers.frame.size.width, viewCustomers.frame.size.height);
    viewPopOveriPad.frame = viewCustomers.frame;
    [viewPopOveriPad addSubview:viewCustomers];
    objViewController.view = viewPopOveriPad;
    [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
    
    [popoverController presentPopoverFromRect:[sender bounds]
                                       inView:sender
                     permittedArrowDirections:UIPopoverArrowDirectionDown
                                     animated:YES];
    

}
-(void)btnAddCustomerClicked:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    
    UIButton * btn = (UIButton *)sender;
     SQLManager * objSQL = [SQLManager sharedInstance];
    BOOL match = YES;
    
    doctorStuct *objDoctorsStruct = nil;
    
    int row = [btn.titleLabel.text intValue];
    int section = btn.imageView.tag;
    
    if(isFiltered)
        objDoctorsStruct = [filteredTableData objectAtIndex:row];
    else
        objDoctorsStruct = [[arrSectionArray objectAtIndex:section] objectAtIndex:row];
    
    selectedDoc = objDoctorsStruct;
    
    doctorStuct *obj;
    
    for(int i=0; i<objSCD.arrDoctors.count; i++)
    {
        obj = [objSCD.arrDoctors objectAtIndex:i];
        if(objDoctorsStruct.doctorId == obj.doctorId)
        {
            match = NO;
            [objSCD.arrDoctors removeObjectAtIndex:i];
        }
    }
    
    
    if(match)
    {
        isDrFromTempSchedule = [objSQL checkIfDoctorIsAleadyScheduledForDate:objSCD.date doctorId:objDoctorsStruct.doctorId];
        if(isDrFromTempSchedule == 1 || isDrFromTempSchedule == 2)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"This doctor is already scheduled for selected date. Do you still want to Add?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            alert.tag = 4;
            [alert show];
            return;
        }
    }
    
    if(match)
    {
        for(int i=0; i<arrpopUpDoctors.count; i++)
        {
            obj = [arrpopUpDoctors objectAtIndex:i];
            if(objDoctorsStruct.doctorId == obj.doctorId)
            {
                [objSCD.arrDoctors addObject:obj];
                break;
            }
        }
    }
    
    doctorStuct * objDr1 = [[doctorStuct alloc]init];
    objDr1 = obj;
    
    if (objSCD.StandardTourPlanDayId == 1)
        objDr1.isSchInsert = 1;
    else
        objDr1.isSchInsert = 0;
    
    objDr1.scheduleId = objSCD.ScheduleId;
    
    
    if(match)
    {
        [objSQL insertIntoSchuleCall:objDr1];
    }
    else
        [objSQL DeleteFromSchuleCall:objDr1];
    
    if(objDoctorsStruct.isSelected)
    {
        objDoctorsStruct.isSelected = NO;
    }
    else
        objDoctorsStruct.isSelected = YES;
    
    [tblCustomers reloadData];
    [tblDoctors reloadData];
}

-(void)addDoctorOnConfrimation
{
    doctorStuct *obj = nil;
    
    for(int i=0; i<arrpopUpDoctors.count; i++)
        {
            obj = [arrpopUpDoctors objectAtIndex:i];
            if(selectedDoc.doctorId == obj.doctorId)
            {
                [objSCD.arrDoctors addObject:selectedDoc];
                break;
            }
        }
   
    
    doctorStuct * objDr1 = [[doctorStuct alloc]init];
    objDr1 = obj;
    
    if (objSCD.StandardTourPlanDayId == 1)
        objDr1.isSchInsert = 1;
    else
        objDr1.isSchInsert = 0;
    
    objDr1.scheduleId = objSCD.ScheduleId;
    
    SQLManager * objSQL = [SQLManager sharedInstance];
  
    
    [objSQL deleteScheduleDoctorIfAlreadySchedules:objDr1];
    
      [objSQL insertIntoSchuleCall:objDr1];
    
    if(selectedDoc.isSelected)
    {
        selectedDoc.isSelected = NO;
    }
    else
        selectedDoc.isSelected = YES;
    
    [tblCustomers reloadData];
    [tblDoctors reloadData];
}

- (BOOL)prefersStatusBarHidden NS_AVAILABLE_IOS(7_0)
{
    return YES;
}


- (IBAction)btnCallNotesClicked:(UIButton *)sender
{
    UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:objViewController];
    
    UIView *viewPopOveriPad = [[UIView alloc] init];
    

    viewAddNotesPOpUp.frame = CGRectMake(0, 0, viewAddNotesPOpUp.frame.size.width, viewAddNotesPOpUp.frame.size.height);
    viewPopOveriPad.frame = viewAddNotesPOpUp.frame;
    [viewPopOveriPad addSubview:viewAddNotesPOpUp];
    
    objViewController.view = viewPopOveriPad;
    [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
    
    [popoverController presentPopoverFromRect:[sender bounds]
                                       inView:sender
                     permittedArrowDirections:UIPopoverArrowDirectionDown
                                     animated:YES];
}
-(void)removePopUp
{
    [popoverController dismissPopoverAnimated:YES];
}
- (IBAction)btnBackClicekd:(UIButton *)sender
{
    SQLManager * objSQL = [SQLManager sharedInstance];
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    objDel.arrScheduleData = [objSQL getScheduleCallData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCallCompletedClicked:(UIButton *)sender
{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to complete the call?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alert.tag = 2;
    [alert show];
}

-(void)addCallCompleted
{
    callCompleted *objCC = [[callCompleted alloc]init];
    [objCC initObject];
    objCC.needToInsert = NO;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    objCC.Id = [objSQL checkForCallCompletedEntry];
    
    if(objCC.Id == -1)
    {
        objCC.needToInsert = YES;
    NSString * sid1 = [defaults objectForKey:@"callReportId"];
    objCC.Id = [sid1 intValue];
    [defaults setObject:[NSString stringWithFormat:@"%d",([sid1 intValue] + 1)] forKey:@"callReportId"];
    [defaults synchronize];
      
    }
    
    objCC.ScheduleCallDescriptionId = objSCD.ScheduleId;
    objCC.CallReportDate =  [Utils getCurrentDate];

    if(objSCD.StandardTourPlanDayId == 0)
        objCC.isFromMTP = 0;
    else
        objCC.isFromMTP = 1;

    
    NSMutableArray * arrDoctors = [objSQL getDoctorForSchedule:objSCD.ScheduleId tempTable:objSCD.StandardTourPlanDayId];
   NSString * brandNames = [[NSString alloc]init];
    
    //Add CallReportVisitDetail
    for(int i =0 ; i< arrDoctors.count; i++)
    {
        doctorStuct * objDr = [arrDoctors objectAtIndex:i];
        CallReportVisitDetail * objCRVD = [[CallReportVisitDetail alloc]init];
        
        NSString * sid1 = [defaults objectForKey:@"CallReportVisitDetailId"];
        objCRVD.Id = [sid1 intValue];
        [defaults setObject:[NSString stringWithFormat:@"%d",([sid1 intValue] + 1)] forKey:@"CallReportVisitDetailId"];
        [defaults synchronize];
        
        objCRVD.DoctorId = objDr.doctorId;
        objCRVD.CallReportId = objCC.Id;
        objCRVD.VisitName = objDr.fname;
        objCRVD.Time = [Utils getCurrentTime];
        objCRVD.Remarks = objSCD.callNotes;
        
        objCC.DoctId = objCRVD.DoctorId;
        objCC.StandardTourPlanDayId = objSCD.StandardTourPlanDayId;
        
        [objCC.arrCallReportVisitDetail addObject:objCRVD];
        
        //Add CallReportVisitDetail
        //Add CallReportVisitDetail
       
        
      //  -(NSMutableArray *)geteDetailorForSchedule :(int)scheduleId tempTable:(int )tempTbl
        NSMutableArray * arreDetailors = [objSQL geteDetailorForSchedule:objSCD.ScheduleId tempTable:objSCD.StandardTourPlanDayId];
        
        for(int i =0 ; i<arreDetailors.count; i++)
        {
            
            eDetailor * objDr = [arreDetailors objectAtIndex:i];
            
//            if(objDr.isDetailed == NO)
//                break;
//            
            CallReportBrandDetail * objCRBD = [[CallReportBrandDetail alloc]init];
            
            NSString * sid1 = [defaults objectForKey:@"CallReportBrandDetailId"];
            objCRBD.Id = [sid1 intValue];
            [defaults setObject:[NSString stringWithFormat:@"%d",([sid1 intValue] + 1)] forKey:@"CallReportBrandDetailId"];
            [defaults synchronize];
            
            objCRBD.CallReportVisitDetailId = objCRVD.Id;
            objCRBD.BrandClusterId = objDr.brandId;
            objCRBD.timeSpent = objCRBD.timeSpent; //TODO
            objCRBD.StartTime = objDr.starttime;
            //brandNames = [NSString stringWithFormat:@"%@, %@",brandNames,objDr.brandName];
            
            NSString *strTemp = objDr.brandName;
            if(i == arreDetailors.count-1)
                brandNames = [NSString stringWithFormat:@"%@ %@.",brandNames,strTemp];
            else
                brandNames = [NSString stringWithFormat:@"%@  %@,",brandNames,strTemp];
            
            
            
            
            [objCC.arrCallReportBrandDetail addObject:objCRBD];
            
            
             NSMutableArray * arrSlides = [objSQL geteSlideeDetailorForSchedule:objSCD.ScheduleId eDetailorId:objDr.Id];
            
            for(int j =0; j < arrSlides.count; j++)
            {
                eDetailorSlide * objDS = [arrSlides objectAtIndex:j];
                CallReportBrandSlideDetail * objCRBSD  = [[CallReportBrandSlideDetail alloc]init];
                NSString * sid1 = [defaults objectForKey:@"CallReportBrandSlideDetail"];
                objCRBSD.Id = [sid1 intValue];
                [defaults setObject:[NSString stringWithFormat:@"%d",([sid1 intValue] + 1)] forKey:@"CallReportBrandSlideDetail"];
                [defaults synchronize];
                
                objCRBSD.CallReportBrandDetailId = objCRBD.Id ;
                objCRBSD.SlideNo = objDS.slideNo;
                objCRBSD.StartTime = objDS.StartTime;
                objCRBSD.EndTime = objDS.EndTime;
                
                
                
                [objCC.arrCallReportBrandSlideDetail addObject:objCRBSD];
                
            }
            
        }
    }
        if(arrDoctors.count == 1) // insert only for Single call
        {
            CallDetailHistory * objCRH = [[CallDetailHistory alloc]init];
            AppDelegate *objDel = [[UIApplication sharedApplication]delegate];
            objCRH.DoctorId = objCC.DoctId ;
            objCRH.EmployeeVersion = [objDel.empVersion intValue];
            objCRH.EmployeeId = [objDel.empId intValue];
            if([textViewNotes.text isEqualToString:@""])
                objCRH.CallDetails = @"No Call Notes";
            else
                objCRH.CallDetails = textViewNotes.text;
            
            objCRH.BrandNames = brandNames;
            
            [objCC.arrCallRecordHistory addObject:objCRH];
        }
        
    

    //SQLManager * objSQL = [SQLManager sharedInstance];
    [objSQL insertCallCompleted:objCC];
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    objDel.arrScheduleData = [objSQL getScheduleCallData];
    
    UIAlertView * objalert = [[UIAlertView alloc]initWithTitle:@"Call Completed" message:@"Your call completed successfully !!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    objalert.tag = 1;
    [objalert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
       [self.navigationController popViewControllerAnimated:YES];
    else
        if(alertView.tag == 2)
        {
            if(buttonIndex == 0)
            {
                [self addCallCompleted];
                
                SQLManager * objSQL = [SQLManager sharedInstance];
                AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
                objDel.arrScheduleData = [objSQL getScheduleCallData];
            }
        }
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag == 4)
    {
        if(buttonIndex == 0)
        {
            [self addDoctorOnConfrimation];
        }
        else
            if(buttonIndex == 1)
            {
               
            }
    }

        
    
}
@end
