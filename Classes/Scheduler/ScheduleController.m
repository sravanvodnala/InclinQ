//
//  ScheduleController.m
//  InclinIQ
//
//  Created by Gagan on 14/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "ScheduleController.h"
#import "Defines.h"
#import "WorkFlowCell.h"
#import "UIPopUPViewController.h"
#import "AppDelegate.h"
#import "SQLManager.h"

#define imgChecked @"checked-_ipad.png"
#define imgUnChecked @"uncheckednew_ipad.png"

@interface ScheduleController ()

@end

@implementation ScheduleController

@synthesize fromMTP,arrDoctors,currentDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrDoctors = [[NSMutableArray alloc]init];
    
    arrSectionArray = [[NSMutableArray alloc] init];
    arrIndexArray = [[NSMutableArray alloc] init];
    arrpopUpeDetailer = [[NSMutableArray alloc] init];
    arrpopUpDoctors = [[NSMutableArray alloc] init];
    arreDetailer = [[NSMutableArray alloc] init];
    
    datetimeview.font = fontMain(20.0);
    calltypeView.font = fontMain(20.0);
    customersview.font = fontMain(20.0);
    edetailerview.font = fontMain(20.0);
    callobjectiveview.font = fontMain(20.0);
    
    lblTitleMain.font = fontSub(30.0);
    unLIstedCustomerLbl.font = fontMain(20.0);
    addCustomerLbl.font = fontMain(20.0);
    unlistedDrNametextField.font = font_ProCond(20.0);
    unlistedDrSpecializationtextField.font = font_ProCond(20.0);;
    currentTime = @"00:00";
    if(!fromMTP)
        currentDate = @"00:00";
    intCallType = 202;
    
    filteredTableData = [[NSMutableArray alloc] init];
    
    arrAlphabets=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    [pickerDate setMinimumDate: [NSDate date]];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
   // arrpopUpDoctors = [objSQL getDoctor];
    arrpopUpeDetailer = [objSQL geteDetailors:1];
    
    //*****************Sravan Start
    btnDoneeDetailer.titleLabel.font = font_ProCond(20.0);
    btnCancelUnlistedDocPopUp.titleLabel.font = font_ProCond(20.0);
    btnDoneUnlistedDocPopUp.titleLabel.font = font_ProCond(20.0);
    
    CALayer * lbtn = [btnCancelUnlistedDocPopUp layer];
    [lbtn setMasksToBounds:YES];
    [lbtn setCornerRadius:10.0];
    
    lbtn = [btnDoneUnlistedDocPopUp layer];
    [lbtn setMasksToBounds:YES];
    [lbtn setCornerRadius:10.0];
    
    arrSpecialisations = [[NSMutableArray alloc] init];
    arrSpecialisations = [objSQL getSpecialisation];
    
    //*****************Sravan End
    
    
    self.title = @"Schedule Call";
    if(LessThanIOS7)
    {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:99/255.0 green:161/255.0 blue:255.0/255.0 alpha:.8f];
    }
    else
    {
        //        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:99/255.0 green:161/255.0 blue:255.0/255.0 alpha:.8f];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    UIImage *img;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //img = [UIImage imageNamed:@"back_btn.png"];
    // btn.frame = CGRectMake(0,0,20,25);
    btn.titleLabel.textColor = [UIColor blackColor];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *lefttBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = lefttBtn;
    
    textViewNotes = [[HPGrowingTextView alloc] init];
    textViewNotes.isScrollable = NO;
    textViewNotes.delegate =self;
    textViewNotes.minNumberOfLines = 4;
    textViewNotes.frame = CGRectMake(1, btnDoneTextView.frame.size.height + 1, viewTextViewNotes.frame.size.width - 1, viewTextViewNotes.frame.size.height- 1);
    textViewNotes.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    textViewNotes.font = font_ProCond(20.0);
    textViewNotes.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    textViewNotes.userInteractionEnabled = YES;
    textViewNotes.maxNumberOfLines = 5;
	textViewNotes.returnKeyType = UIReturnKeyNext;
	textViewNotes.delegate = self;
    textViewNotes.backgroundColor = [UIColor whiteColor];
    textViewNotes.placeholder = @"Enter Call Objectives";
    [viewTextViewNotes addSubview:textViewNotes];
    
    CALayer * l = [textViewNotes layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    //TODO : Add call note here
    textViewObjective = [[HPGrowingTextView alloc] init];
    textViewObjective.isScrollable = NO;
    textViewObjective.delegate =self;
    textViewObjective.minNumberOfLines = 4;
    //    textViewObjective.frame = CGRectMake(5, btnDoneTextView.frame.size.height + 10, viewAddNotesPOpUp.frame.size.width - 10, viewAddNotesPOpUp.frame.size.height - btnDoneTextView.frame.size.height - 6);
    textViewObjective.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    textViewObjective.font = font_ProCond(20.0);
    textViewObjective.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    textViewObjective.userInteractionEnabled = YES;
    textViewObjective.maxNumberOfLines = 3;
	textViewObjective.returnKeyType = UIReturnKeyNext;
	textViewObjective.delegate = self;
    textViewObjective.backgroundColor = [UIColor whiteColor];
    textViewObjective.placeholder = @"Enter Call Objectives";
    [self.view addSubview:textViewObjective];
    //  [viewAddNotesPOpUp addSubview:textViewObjective];
    
    //textViewObjective.text = objSCD.callNotes ;
    CALayer * l1 = [textViewObjective layer];
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:10.0];
    
    
    l = [btnDoneTextView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    l = [btnDoneUnlistedDr layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    l = [btnDoneeDetailer layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    [self getDesignCustomersView];
}
#pragma mark - Growing TWxtView Delegates
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    //    float diff = (growingTextView.frame.size.height - height);
    //
    //    CGRect r = view.frame;
    //    r.size.height -= diff;
    //    r.origin.y += diff;
    //    containerView.frame = r;
    //
    //    CGRect scrlFrame = scrlView.frame;
    //    scrlFrame.size.height += diff;
    //    scrlView.frame = scrlFrame;
    //
    //    r = viewTextViewBg.frame;
    //    r.size.height -= diff;
    //    //    r.origin.y -= diff;
    //    viewTextViewBg.frame = r;
}

#pragma mark TableView Delegate Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    view.backgroundColor =  [UIColor clearColor];
    
    
    if(tableView == tblDoctores)
    {
        if(section == 0)
        {
            UILabel *callType = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 80, 30)];
            callType.text = @"Call Type:";
            callType.font = fontMain(20.0);
            callType.backgroundColor = [UIColor clearColor];
            [view addSubview:callType];
            
            lblCallType = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 170, 30)];
            lblCallType.text = strCallType;
            lblCallType.font = fontSub(20.0);
            lblCallType.backgroundColor = [UIColor clearColor];
            [view addSubview:lblCallType];
            
            UILabel *Date = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 60, 30)];
            Date.text = @"Date :";
            Date.font = font_ProBoldCondensed(20.0);
            Date.backgroundColor = [UIColor clearColor];
            [view addSubview:Date];
            
            UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(300, 5, 200, 30)];
            lblDate.text = [NSString stringWithFormat:@"%@",currentDate];
            lblDate.font = font_ProCond(20.0);
            lblDate.backgroundColor = [UIColor clearColor];
            [view addSubview:lblDate];
            
            UILabel *Time = [[UILabel alloc] initWithFrame:CGRectMake(450, 5, 60, 30)];
            Time.text = @"Time :";
            Time.font = font_ProBoldCondensed(20.0);
            Time.backgroundColor = [UIColor clearColor];
            [view addSubview:Time];
            
            UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(500, 5, 200, 30)];
            lblTime.text =[NSString stringWithFormat:@"%@",currentTime];
            lblTime.font = font_ProCond(20.0);
            lblTime.backgroundColor = [UIColor clearColor];
            [view addSubview:lblTime];
            
            UILabel *lblDoctorsName = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 150, 30)];
            lblDoctorsName.text = @"Dr Name/s";
            lblDoctorsName.font = fontMain(20.0);
            lblDoctorsName.backgroundColor = [UIColor clearColor];
            [view addSubview:lblDoctorsName];
            
            UILabel *lblDoctorsSpecialization = [[UILabel alloc] initWithFrame:CGRectMake(350, 40, 150, 30)];
            lblDoctorsSpecialization.text = @"Specialisation";
            lblDoctorsSpecialization.font = fontMain(20.0);
            lblDoctorsSpecialization.backgroundColor = [UIColor clearColor];
            [view addSubview:lblDoctorsSpecialization];
        }
        else
        {
            UILabel *callType = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, tblDoctores.frame.size.width - 20, 30)];
            callType.text = @"Call Objective :";
            callType.font = fontMain(20.0);
            callType.backgroundColor = [UIColor clearColor];
            [view addSubview:callType];
        }
    }
    else if(tableView == tblEDetailers)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-eDetailers-40x40.png"]];
        img.frame = CGRectMake(10, 0, 40, 40);
        img.backgroundColor = [UIColor clearColor];
        [view addSubview:img];
        
        UILabel *lbleDetailer = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, tblEDetailers.frame.size.width-100, 40)];
        lbleDetailer.text = @"e-Detailers";
        lbleDetailer.textAlignment = NSTextAlignmentLeft;
        lbleDetailer.font = fontMain(20.0);
        lbleDetailer.backgroundColor = [UIColor clearColor];
        [view addSubview:lbleDetailer];
    }
    else if(tableView == tbleDetailerPopUp)
    {
        
    }
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    view.backgroundColor =  [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    
    if(tableView == tblDoctores)
    {
    }
    else if(tableView == tbleDetailerPopUp)
    {
        
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == tblDoctores)
    {
        if(section == 0)
            return 75.0;
        else
            return 40.0;
    }
    else if( tableView == tblEDetailers)
        return 40.0;
    else if(tableView == tbleDetailerPopUp || tableView == tblCustomers || tableView == tblViewSpecialisationPopUp)
        return 0.0f;
    
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblCustomers || tableView == tblViewSpecialisationPopUp)
        return 40.0;
    if(tableView == tblDoctores)
    {
        if(indexPath.section == 0)
            return 40.0;
        else
            return [Utils getHeightOfString:strCallObjective withFont:fontSub(22.0) withWidth:tblDoctores.frame.size.width-20]+10;
    }
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
    if(tableView == tblDoctores)
        return 2;
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblCustomers)
    {
        if(isFiltered)
            return [filteredTableData count];
        else
            return [[arrSectionArray objectAtIndex:section] count];
    }
    
    if(tableView == tblDoctores)
    {
        if(section == 0)
            return arrDoctors.count;
        else
            return 1;
    }
    if(tableView == tblEDetailers)
        return arreDetailer.count;
    
    if(tableView == tbleDetailerPopUp)
        return arrpopUpeDetailer.count;
    
    if(tableView == tblViewSpecialisationPopUp)
        return arrSpecialisations.count;
    
    return 0;
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
    else if(tableView == tblCustomers) //SearchBar
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
            [btn addTarget:self action:@selector(btnAddDoctorClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            cell.textLabel.font = fontSub(18.0);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 35, tblDoctores.frame.size.width, 5.0)];
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
    else  if(tableView == tblDoctores)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell == nil)
        {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            
            if(indexPath.section == 0)
            {
                
                doctorStuct *obj = [arrDoctors objectAtIndex:indexPath.row];
                
                UILabel *lblDoctorsName = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 300, 30)];
                lblDoctorsName.text = obj.fname;
                lblDoctorsName.font = fontSub(18.0);
                lblDoctorsName.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:lblDoctorsName];
                
                UILabel *lblDoctorsSpecialization = [[UILabel alloc] initWithFrame:CGRectMake(350, 5, 300, 30)];
                lblDoctorsSpecialization.text = obj.specializationName;
                lblDoctorsSpecialization.font = fontSub(18.0);
                lblDoctorsSpecialization.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:lblDoctorsSpecialization];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 35, tblDoctores.frame.size.width, 5.0)];
                view.backgroundColor =  [UIColor whiteColor];
                [cell.contentView addSubview:view];
            }
            else
            {
                CGFloat height  =  [Utils getHeightOfString:strCallObjective withFont:font_ProCond(20.0) withWidth:tblDoctores.frame.size.width-20];
                
                UILabel *lblCallObjective = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, tblDoctores.frame.size.width-20, height)];
                lblCallObjective.text = [Utils getNormalString:strCallObjective];
                lblCallObjective.font = font_ProCond(20.0);
                lblCallObjective.numberOfLines = 50;
                lblCallObjective.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:lblCallObjective];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if(tableView == tblEDetailers)
    {
        WorkFlowCell *cell = (WorkFlowCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WorkFlowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            
            eDetailor *objStructure = [arreDetailer objectAtIndex:indexPath.row];
            cell.btnCheckBox.hidden = YES;
            
            cell.versionnumber.font = fontMain(18.0);
            cell.noofslides.font = fontMain(18.0);
            cell.brandName.font = fontMain(18.0);
            
            cell.lblBrandName.font = fontSub(18.0);
            cell.lblNumberOFSlides.font = fontSub(18.0);
            cell.lblVersionNumber.font = fontSub(18.0);
            cell.imgView.image = [UIImage imageWithContentsOfFile:objStructure.imgPath];
            cell.lblBrandName.text = [NSString stringWithFormat:@"%@",objStructure.brandName];
            cell.lblNumberOFSlides.text = [NSString stringWithFormat:@"%d",objStructure.noOfSlides];
            cell.lblVersionNumber.text = [NSString stringWithFormat:@"%@",objStructure.versionNo];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
    else
    {
        static NSString *CellIdentifier = @"WorkFlowCell";
        WorkFlowCell *cell = (WorkFlowCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        eDetailor *objStructure = [arrpopUpeDetailer objectAtIndex:indexPath.row];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WorkFlowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            
            cell.btnCheckBox.hidden = NO;
            
            
            if(objStructure.isSelected)
                [cell.btnCheckBox setImage:[UIImage imageNamed:imgChecked] forState:UIControlStateNormal];
            else
                [cell.btnCheckBox setImage:[UIImage imageNamed:imgUnChecked] forState:UIControlStateNormal];
            
            [cell.btnCheckBox addTarget:self action:@selector(btneDetailerSelectionClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheckBox.tag = indexPath.row;
            
            cell.versionnumber.font = fontMain(18.0);
            cell.noofslides.font = fontMain(18.0);
            cell.brandName.font = fontMain(18.0);
            
            cell.lblBrandName.font = fontSub(18.0);
            cell.lblNumberOFSlides.font = fontSub(18.0);
            cell.lblVersionNumber.font = fontSub(18.0);
            cell.imgView.image = [UIImage imageWithContentsOfFile:objStructure.imgPath];
            
            cell.lblBrandName.text = [NSString stringWithFormat:@"%@",objStructure.brandName];
            cell.lblNumberOFSlides.text = [NSString stringWithFormat:@"%d",objStructure.noOfSlides];
            cell.lblVersionNumber.text = [NSString stringWithFormat:@"%@",objStructure.versionNo];
            
        }
        else
        {
            cell.btnCheckBox.tag = indexPath.row;
            
            if(objStructure.isSelected)
                [cell.btnCheckBox setImage:[UIImage imageNamed:imgChecked] forState:UIControlStateNormal];
            else
                [cell.btnCheckBox setImage:[UIImage imageNamed:imgUnChecked] forState:UIControlStateNormal];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView == tblViewSpecialisationPopUp)
    {
        specialisationStruct * objSpc = [arrSpecialisations objectAtIndex:indexPath.row];
        strSpecialisationPopUp = objSpc.name;
        [self removePopUpSpecialisations];
        unlistedDrSpecializationtextField.text = strSpecialisationPopUp;
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSideClicked:(UIButton *)sender
{
    [self btnPopUpClicked:sender];
    if(sender.tag == 101)
    {
        NSLog(@"Call Types");
    }
    if(sender.tag == 102)
    {
        NSLog(@"Date & Time");
    }
    if(sender.tag == 103)
    {
        NSLog(@"Customers");
    }
    if(sender.tag == 104)
    {
        NSLog(@"e-Detailers");
    }
    if(sender.tag == 105)
    {
        NSLog(@"Call Objectives");
    }
}
#pragma mark -  btnPopUpClicked
-(void)btnPopUpClicked:(UIButton *)sender
{
    UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:objViewController];
    
    UIView *viewPopOveriPad = [[UIView alloc] init];
    
    if(sender.tag == 101)
    {
        viewCallType.frame = CGRectMake(0, 0, viewCallType.frame.size.width, viewCallType.frame.size.height);
        viewPopOveriPad.frame = viewCallType.frame;
        [viewPopOveriPad addSubview:viewCallType];
        objViewController.view = viewPopOveriPad;
        [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
        
        [popoverController presentPopoverFromRect:[sender bounds]
                                           inView:sender
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                                         animated:YES];
        
    }
    if(sender.tag == 102)
    {
        viewPickerDate.frame = CGRectMake(0, 0, viewPickerDate.frame.size.width, viewPickerDate.frame.size.height);
        viewPopOveriPad.frame = viewPickerDate.frame;
        [viewPopOveriPad addSubview:viewPickerDate];
        objViewController.view = viewPopOveriPad;
        [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
        
        [popoverController presentPopoverFromRect:[sender bounds]
                                           inView:sender
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                                         animated:YES];
        
    }
    if(sender.tag == 103)
    {
        
        SQLManager *objSQl = [SQLManager sharedInstance];
        arrpopUpDoctors = [objSQl getDoctor:currentDate];
        [self getDesignCustomersView];
        
        viewCustomers.frame = CGRectMake(0, 0, viewCustomers.frame.size.width, viewCustomers.frame.size.height);
        viewPopOveriPad.frame = viewCustomers.frame;
        [viewPopOveriPad addSubview:viewCustomers];
        objViewController.view = viewPopOveriPad;
        [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
        
        [popoverController presentPopoverFromRect:[sender bounds]
                                           inView:sender
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                                         animated:YES];
        
        
    }
    if(sender.tag == 104)
    {
        
        if(arrpopUpeDetailer.count == 0)
        {
            UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"" message:@"Please download eDetailor" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        vieweDetailer.frame = CGRectMake(0, 0, vieweDetailer.frame.size.width, vieweDetailer.frame.size.height);
        viewPopOveriPad.frame = vieweDetailer.frame;
        [viewPopOveriPad addSubview:vieweDetailer];
        objViewController.view = viewPopOveriPad;
        [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
        
        [popoverController presentPopoverFromRect:[sender bounds]
                                           inView:sender
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                                         animated:YES];
        
    }
    
    if(sender.tag == 105)
    {
        viewTextViewNotes.frame = CGRectMake(0, 0, viewTextViewNotes.frame.size.width, viewTextViewNotes.frame.size.height);
        viewPopOveriPad.frame = viewTextViewNotes.frame;
        [viewPopOveriPad addSubview:viewTextViewNotes];
        
        objViewController.view = viewPopOveriPad;
        [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
        
        [popoverController presentPopoverFromRect:[sender bounds]
                                           inView:sender
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                                         animated:YES];
    }
}
-(void)removePopUp
{
    [popoverController dismissPopoverAnimated:YES];
}
#pragma mark - Customer/s
-(void)getDesignCustomersView
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
#pragma mark - Method For Button Clicked
-(void)btnAddeDetailerClicked:(UIButton *)sender
{
    NSInteger tagValue = sender.tag - 1000;
    NSLog(@"%d",tagValue);
}
-(void)btneDetailerSelectionClicked:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    NSLog(@"%d",arreDetailer.count);
    BOOL match = YES;
    
    eDetailor *objSeleDet = [arrpopUpeDetailer objectAtIndex:sender.tag];
    
    for(int i=0; i<arreDetailer.count; i++)
    {
        eDetailor *obj = [arreDetailer objectAtIndex:i];
        if(objSeleDet.Id == obj.Id)
        {
            match = NO;
            [arreDetailer removeObjectAtIndex:i];
        }
    }
    
    if(match)
    {
        for(int i=0; i<arrpopUpeDetailer.count; i++)
        {
            eDetailor *obj = [arrpopUpeDetailer objectAtIndex:i];
            if(objSeleDet.Id == obj.Id)
            {
                [arreDetailer addObject:obj];
                break;
            }
        }
    }
    
    if(objSeleDet.isSelected)
        objSeleDet.isSelected = NO;
    else
        objSeleDet.isSelected = YES;
    
    [tbleDetailerPopUp reloadData];
    
    
}
-(void)btnAddDoctorClicked:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    
    UIButton * btn = (UIButton *)sender;
    
    BOOL match = YES;
    
    doctorStuct *objDoctorsStruct = nil;
    
    int row = [btn.titleLabel.text intValue];
    int section = btn.imageView.tag;
    
    if(isFiltered)
        objDoctorsStruct = [filteredTableData objectAtIndex:row];
    else
        objDoctorsStruct = [[arrSectionArray objectAtIndex:section] objectAtIndex:row];
    
    for(int i=0; i<arrDoctors.count; i++)
    {
        doctorStuct *obj = [arrDoctors objectAtIndex:i];
        if(objDoctorsStruct.doctorId == obj.doctorId)
        {
            match = NO;
            [arrDoctors removeObjectAtIndex:i];
        }
    }
    
    selectedDoc = objDoctorsStruct;
    
    if(match)
    {
        SQLManager * objSQl =  [SQLManager sharedInstance];
        int isDrFromTempSchedule = [objSQl checkIfDoctorIsAleadyScheduledForDate:currentDate doctorId:objDoctorsStruct.doctorId];
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
            doctorStuct *obj = [arrpopUpDoctors objectAtIndex:i];
            if(objDoctorsStruct.doctorId == obj.doctorId)
            {
                [arrDoctors addObject:obj];
                break;
            }
        }
    }
    
    if(objDoctorsStruct.isSelected)
    {
        objDoctorsStruct.isSelected = NO;
    }
    else
        objDoctorsStruct.isSelected = YES;
    
    [tblCustomers reloadData];
    
}
-(void)btnClicked:(UIButton*)sender
{
    
}
- (IBAction)btnIndividualClicked:(UIButton *)sender
{
    [self removePopUp];
    if(arrDoctors.count == 0)
    {
        lblCallType.text = @"Individual Call";
        strCallType = @"Individual Call";
        intCallType = 1;
    }
    else if(arrDoctors.count >1)
    {
        lblCallType.text = @"Group Call";
        strCallType = @"Group Call";
        intCallType = 2;
    }
    else
    {
        lblCallType.text = @"Individual Call";
        strCallType = @"Individual Call";
        intCallType = 1;
    }
}

- (IBAction)btnGroupCallClicked:(UIButton *)sender
{
    [self removePopUp];
    if(arrDoctors.count == 0)
    {
        lblCallType.text = @"Group Call";
        strCallType = @"Group Call";
        intCallType = 2;
    }
    else if(arrDoctors.count >1)
    {
        lblCallType.text = @"Group Call";
        strCallType = @"Group Call";
        intCallType = 2;
    }
    else
    {
        lblCallType.text = @"Individual Call";
        strCallType = @"Individual Call";
        intCallType = 1;
    }
}

- (IBAction)btnPickerDoneClicked:(UIButton *)sender
{
    [self removePopUp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mma"];
    NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:pickerDate.date]];
    
    NSArray *arr = [strTime componentsSeparatedByString:@" "];
    
    currentTime = [arr objectAtIndex:1];
    currentDate = [arr objectAtIndex:0];
    [self performSelectorOnMainThread:@selector(reloadtblDoctors) withObject:nil waitUntilDone:YES];
}
- (BOOL)prefersStatusBarHidden NS_AVAILABLE_IOS(7_0)
{
    return YES;
}

- (IBAction)btnDoneTextViewClilcked:(UIButton *)sender
{
    strCallObjective = textViewNotes.text;
    [self removePopUp];
    [tblDoctores reloadData];
}

- (IBAction)btnSearchBarDoneClicked:(UIButton *)sender
{
    [self removePopUp];
}
-(void)btnBackClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnBackClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDonePopUpEDetailerClicked:(UIButton *)sender
{
    [self removePopUp];
    
    [self performSelectorOnMainThread:@selector(reloadtbleDetailers) withObject:nil waitUntilDone:YES];
    
}

- (IBAction)btnDoneTextFieldClicked:(UIButton *)sender
{
    [objPopOver dismissPopoverAnimated:YES];
    [popoverController dismissPopoverAnimated:NO];
}

- (IBAction)btnUnlistedDrClicked:(UIButton *)sender
{
    
    UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
    objPopOver = [[UIPopoverController alloc] initWithContentViewController:objViewController];
    
    UIView *viewPopOveriPad = [[UIView alloc] init];
    
    viewAddUnlistedDr.frame = CGRectMake(0, 0, viewAddUnlistedDr.frame.size.width, viewAddUnlistedDr.frame.size.height);
    viewPopOveriPad.frame = viewAddUnlistedDr.frame;
    [viewPopOveriPad addSubview:viewAddUnlistedDr];
    objViewController.view = viewPopOveriPad;
    [objPopOver setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
    
    [objPopOver presentPopoverFromRect:[btnAddCustomers bounds]
                                inView:btnAddCustomers
              permittedArrowDirections:UIPopoverArrowDirectionUp
                              animated:YES];
    
    
}

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
- (IBAction)btnUnlistedDrOKClicked:(UIButton *)sender
{
    //SAJIDA-BUGS
    doctorStuct *obj = [[doctorStuct alloc]init];
    obj.doctorId = 0;
    obj.fname = unlistedDrNametextField.text;
    obj.specializationName = unlistedDrSpecializationtextField.text;
    [arrDoctors addObject:obj];
    [tblDoctores reloadData];
    
    //[arrpopUpDoctors addObject:obj];
    [self removePopUpUnlistedDoctores];
    unlistedDrNametextField.text = @"";
    unlistedDrSpecializationtextField.text= @"";
    //SAJIDA-BUGS
    
}
- (IBAction)btnUnlistedDrCancleClicked:(UIButton *)sender
{
    [objPopOver dismissPopoverAnimated:YES];
}

-(void)ShowAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:statusMessage
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)btnAddCustomersClicked:(UIButton *)sender
{
    if(arrDoctors.count >1)
    {
        strCallType = @"Group Call";
        intCallType = 2;
    }
    else
    {
        strCallType = @"Individual Call";
        intCallType = 1;
    }
    
    lblCallType.text = strCallType;
    
    [self removePopUp];
    [self performSelectorOnMainThread:@selector(reloadtblDoctors) withObject:nil waitUntilDone:YES];
    
    
}
- (IBAction)btnCancelClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Schedule Call Click : /************/

- (IBAction)btnScheduleCallClicked:(UIButton *)sender
{
    [self removePopUp];
    
    if(intCallType == 202)
    {
        statusMessage = @"Please select Call type";
        [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    }
    
    else if([currentDate isEqualToString:@"00:00"] )
    {
        statusMessage = @"Please Select Date & Time";
        [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    }
    else if([textViewNotes.text isEqualToString:@""] || textViewNotes.text == nil)
    {
        statusMessage = @"Please add Call Objective";
        [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    }
    else if(arrDoctors.count<1)
    {
        statusMessage = @"Please Select Customers";
        [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    }
    else if(arreDetailer.count<1)
    {
        statusMessage = @"Please Select eDetailers";
        [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    }
    else
    {
        ScheduleCallDescription *objStruct = [[ScheduleCallDescription alloc] init];
        [objStruct initObject];
        [objStruct.arreDetailors addObjectsFromArray:arreDetailer];
        [objStruct.arrDoctors addObjectsFromArray:arrDoctors];
        objStruct.date = currentDate;
        objStruct.time = currentTime;
        objStruct.callObjective = textViewNotes.text;
        objStruct.callType = intCallType;
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * sid = [defaults objectForKey:@"scheduleId"];
        objStruct.ScheduleId = [sid intValue];
        [defaults setObject:[NSString stringWithFormat:@"%d",([sid intValue] + 1)] forKey:@"scheduleId"];
        [defaults synchronize];
        
        for(int i = 0; i<objStruct.arrDoctors.count; i++)
        {
            doctorStuct * objDr = [objStruct.arrDoctors objectAtIndex:i];
            objDr.ScheduleId = objStruct.ScheduleId;
        }
        
        for(int i = 0; i<objStruct.arreDetailors.count; i++)
        {
            eDetailor * objDr = [objStruct.arreDetailors objectAtIndex:i];
            objDr.ScheduleId = objStruct.ScheduleId;
        }
        
        SQLManager * objSQL = [SQLManager sharedInstance];
        [objSQL insertScheduleCall:objStruct];
        
        UIAlertView * obj = [[UIAlertView alloc]initWithTitle:@"ScheduleCall" message:@"Call added successfully!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        obj.tag = 1;
        [obj show];
        //        objStruct.arrPreviousHistory;
        //        objStruct.ScheduleId;
    }
}

-(void)addDoctorOnConfrimation
{
  
        for(int i=0; i<arrpopUpDoctors.count; i++)
        {
            doctorStuct *obj = [arrpopUpDoctors objectAtIndex:i];
            if(selectedDoc.doctorId == obj.doctorId)
            {
                [arrDoctors addObject:obj];
                break;
            }
        }
    
    SQLManager * objSQl = [SQLManager sharedInstance];
    [objSQl deleteScheduleDoctorIfAlreadySchedules:selectedDoc];
    if(selectedDoc.isSelected)
    {
        selectedDoc.isSelected = NO;
    }
    else
        selectedDoc.isSelected = YES;
    
    [tblCustomers reloadData];
   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        
        SQLManager * objSQL = [SQLManager sharedInstance];
        AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
        objDel.arrScheduleData = [objSQL getScheduleCallData];
        
        [self.navigationController popViewControllerAnimated:YES];
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
-(void)reloadtblDoctors
{
    [tblDoctores reloadData];
}
-(void)reloadtbleDetailers
{
    [tblEDetailers reloadData];
}
@end
