//
//  Calander.m
//  InclinIQ
//
//  Created by Gagan on 21/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "Calander.h"
#import "ScheduleController.h"
#import "UIPopUPViewController.h"
#import "StandardTourPlan.h"

#define tagSubView 534210
#define tagLblDate 534211
#define tagDoctorName 534212
#define tagCount 534213
#define tagColor 534214
#define tagBgImage 534215

#define imgSTPDateToday [UIImage imageNamed:@"today-or-selected-date-box-142x121.png"]
#define imgCellBgEmptyToday [UIImage imageNamed:@"today-or-selected-date-box-Resize-142x121.png"]

#define imgSTPDate [UIImage imageNamed:@"current-month-date-box-142x121.png"]
#define imgCellBgEmpty [UIImage imageNamed:@"calandercellBg-142x121.png"]

@interface Calander ()

@end

@implementation Calander

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self Initialize];
    isSlide = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    [self designBagroundView:viewBack];
    
    if(!isFirstTime)
    {
        viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
        isSlide = YES;
        
        [self btnMenuClicked:nil];
        isFirstTime = NO;
    }
    viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    viewMain.layer.shadowOpacity = 0.7f;
    viewMain.layer.shadowOffset = CGSizeMake(-5.0f,20.0f);
    viewMain.layer.shadowRadius = 10.0f;
    viewMain.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:viewMain.bounds];
    viewMain.layer.shadowPath = pathBtn.CGPath;
    
    
    
}

-(void)Initialize
{
    //*****************Sravan Start
    
    btnDeviatelPopUp.titleLabel.font = font_ProCond(20.0);
    btnScheduleCallPopUp.titleLabel.font = font_ProCond(20.0);
    btnScheduleCallPopUpSub.titleLabel.font = font_ProCond(20.0);
    btnDonelPopUp.titleLabel.font = font_ProCond(20.0);
    
    CALayer * lbtn = [btnDeviatelPopUp layer];
    [lbtn setMasksToBounds:YES];
    [lbtn setCornerRadius:10.0];
    
    lbtn = [btnScheduleCallPopUp layer];
    [lbtn setMasksToBounds:YES];
    [lbtn setCornerRadius:10.0];
    
    lbtn = [btnScheduleCallPopUpSub layer];
    [lbtn setMasksToBounds:YES];
    [lbtn setCornerRadius:10.0];
    //*****************Sravan End
    
    view1.clipsToBounds = YES;
    view2.clipsToBounds = YES;
    viewMain.clipsToBounds = YES;
    
    widthCal = view1.frame.size.width/7;
    heightCal = view1.frame.size.height/5;
    
    lblStpName.font = font_ProBoldCondensed(20.0);
    lblDateTbl.font = font_ProBoldCondensed(20.0);
    
    lblTitle.font = font_ProCond(30.0);
    self.title = @"Plan (Monthly Tour Plan)";
    NSArray *arrWeekNmaes = [[NSArray alloc]initWithObjects:@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT", nil];
    
    NSInteger xpos = 10, ypos = viewTitle.frame.origin.y + viewTitle.frame.size.height, width = widthCal, height = 45;
    
    UIView *viewWeek = [[UIView alloc] initWithFrame:CGRectMake(view1.frame.origin.x, ypos, view1.frame.size.width, 40)];
    viewWeek.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:viewWeek];
    
    xpos = 0;
    for(int i=0; i<arrWeekNmaes.count; i++)
    {
        xpos = i*width;
        
        UILabel *lblMonth = [self createUIlabel:xpos withYposition:5 withWidth:width  withHeight:viewWeek.frame.size.height withText:[NSString stringWithFormat:@"%@",[arrWeekNmaes objectAtIndex:i]] withTag:10 withFont:fontHelveticaBold_21];
        lblMonth.font = font_ProBoldCondensed(22.0);
        lblMonth.textColor = [UIColor colorWithRed:255/255.0 green:202/255.0 blue:54/255.0 alpha:1.0];
        lblMonth.shadowColor = [UIColor lightGrayColor];
        lblMonth.textAlignment = NSTextAlignmentCenter;
        [viewWeek addSubview:lblMonth];
        
    }
    ypos = viewWeek.frame.origin.y + viewWeek.frame.size.height;
    height += 2;
    UIButton *btnLeftCal = [self createUIButton:0 withYposition:height withWidth:40 withHeight:40 withTitle:@"" withFontSize:1 withImageName:@"left-arrow-40x40.png"];
    [btnLeftCal addTarget:self action:@selector(gotoPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:btnLeftCal];
    
    UIButton *btnRightCal = [self createUIButton:viewMain.frame.size.width-50 withYposition:height withWidth:40 withHeight:40 withTitle:@"" withFontSize:1 withImageName:@"right-arrow-40x40.png"];
    [btnRightCal addTarget:self action:@selector(gotoNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:btnRightCal];
    frame0 = CGRectMake(12, 95, 0, 608);
    frame1 = CGRectMake(12, 95, 1000, 608);
    frame2 = CGRectMake(1012, 95, 0, 608);
    
    arrCalanderData = [[NSMutableArray alloc] init];
    
    
    [self createHolidaysDic];
    [self designTheCalender];
    
    arrData = [[NSMutableArray alloc] init];
    arrSectionArray = [[NSMutableArray alloc] init];
    arrIndexArray = [[NSMutableArray alloc] init];
    filteredTableData = [[NSMutableArray alloc] init];
    arrAlphabets=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
}
#pragma mark - Holidays

-(void)createHolidaysDic
{
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrHolidays = [objSQL getHolidays];
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    arrLeavs = [objSQL getLeaveForEmployee:[objDel.empId intValue]];
    
    dicHolidays = [[NSMutableDictionary alloc]init];
    dicHolidaysName = [[NSMutableDictionary alloc]init];
    
    for(int i=0; i< arrHolidays.count; i++)
    {
        NSMutableDictionary * objDic =[arrHolidays objectAtIndex:i];
        
        NSString * date = [objDic valueForKey:@"date"];
        NSString * holName = [objDic valueForKey:@"holidayName"];
        
        NSArray *arrmain = [date componentsSeparatedByString:@"-"];
        
        NSString *strMonth = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:1]];
        NSString *strDate = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:2]];
        
        if([strMonth length]<2)
            strMonth = [NSString stringWithFormat:@"0%@",strMonth];
        
        if([strDate length]<2)
            strDate = [NSString stringWithFormat:@"0%@",strDate];
        
        date = [NSString stringWithFormat:@"%@-%@-%@",[arrmain objectAtIndex:0],strMonth,strDate];
        
        [dicHolidays setObject:@"1" forKey:date];
        [dicHolidaysName setObject:holName forKey:date];
        
    }
}
-(BOOL)checkForLeave :(NSString *)date
{
    NSArray *arrmain = [date componentsSeparatedByString:@"-"];
    
    NSString *strMonth = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:1]];
    NSString *strDate = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:2]];
    
    if([strMonth length]<2)
        strMonth = [NSString stringWithFormat:@"0%@",strMonth];
    
    if([strDate length]<2)
        strDate = [NSString stringWithFormat:@"0%@",strDate];
    
    date = [NSString stringWithFormat:@"%@-%@-%@",[arrmain objectAtIndex:0],strMonth,strDate];
    
    for(int i=0; i< arrLeavs.count; i++)
    {
        //        Leave *obj = [arrLeavs objectAtIndex:i];
        //        if([obj.startDate isEqualToString:date] || [obj.endDate isEqualToString:date])
        if([date isEqualToString:[arrLeavs objectAtIndex:i]])
            return YES;
    }
    return NO;
}
-(NSInteger)returnNumberOfDays:(NSString *)strStartDate withEndDate:(NSString *)strEndDate
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *startDate = [f dateFromString:strStartDate];
    
    NSLog(@"%@",startDate);
    NSDate *endDate = [f dateFromString:strEndDate];
    NSLog(@"%@",endDate);
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return components.day;
}
//- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)startDate withEndDate:(NSDate *)lastDate
//{
//    NSDate* enddate = lastDate;
//    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:startDate];
//    double secondsInMinute = 60;
//    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
//
//    if (secondsBetweenDates == 0)
//        return YES;
//    else if (secondsBetweenDates < 0)
//        return YES;
//    else
//        return NO;
//}
-(BOOL)checkForHoliday : (NSString *)date //2013-09-17 farmat
{
    NSArray *arrmain = [date componentsSeparatedByString:@"-"];
    
    NSString *strMonth = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:1]];
    NSString *strDate = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:2]];
    
    if([strMonth length]<2)
        strMonth = [NSString stringWithFormat:@"0%@",strMonth];
    
    if([strDate length]<2)
        strDate = [NSString stringWithFormat:@"0%@",strDate];
    
    date = [NSString stringWithFormat:@"%@-%@-%@",[arrmain objectAtIndex:0],strMonth,strDate];
    
    //date = [NSString stringWithFormat:@"%@ 12:00:00.00",date]; //""//""//""//""//""//   Date Format--Sravan
    
    
    NSString * isHoliday = [dicHolidays objectForKey:date];
    
    if((isHoliday == nil) || ([isHoliday isEqualToString:@""]))
        return NO;
    else
        return YES;
}

- (BOOL)prefersStatusBarHidden NS_AVAILABLE_IOS(7_0)
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    isFirstTime = YES;
    isSlide = YES;
    [self btnMenuClicked:nil];
}
#pragma mark - Calander Methods---

-(void)designTheCalender
{
	arr_View1Buttons = [[NSMutableArray alloc] init];
	arr_View2Buttons = [[NSMutableArray alloc] init];
	
	arr_View1= [[NSMutableArray alloc] init];
	arr_View2= [[NSMutableArray alloc] init];
	
    [self setCalendar];
    
    [view1 setFrame:frame1];
	[view2 setFrame:frame2];
    
	[self addButtons];
	
    frontView = @"view2";
	
    [self fillCalender:currentMonth weekStarts:currentFirstDay year:currentYear];
	
    frontView = @"view1";
    
	[self fillCalender:currentMonth weekStarts:currentFirstDay year:currentYear];
    
    
    lblTitle.text = [NSString stringWithFormat:@"Plan ( %@ %i )",[self getMonth:currentMonth],currentYear];
}
-(void)setCalendar
{
	currentDate=[NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps=[gregorian components:( NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekCalendarUnit) fromDate:currentDate];
	NSInteger weekdayInteger=[comps weekday];
	currentMonth=[comps month];
	currentYear=[comps year];
	NSString *dateString=[[NSString stringWithFormat:@"%@",currentDate] substringToIndex:10];
    NSArray *array= [dateString componentsSeparatedByString:@"-"];
	NSInteger currentDay=[[array objectAtIndex:2] intValue];
	currentMonthConstant=currentMonth;
	currentYearConstant=currentYear;
	currentDayConstant=currentDay;
	currentConstantDate=[NSString stringWithFormat:@"%d/%d/%d",currentDayConstant,currentMonthConstant,currentYearConstant];
    
    currentFirstDay=((8+weekdayInteger-(currentDay%7))%7);
	if(currentFirstDay==0)
		currentFirstDay=7;
	
	NSDateFormatter *dfWeekDay = [[NSDateFormatter alloc] init];
	[dfWeekDay setDateFormat:@"e"];
	currentWeekDay = [[dfWeekDay stringForObjectValue:[NSDate date]]intValue];
	[dfWeekDay setDateFormat:@"d"];
	currentDayRunning = [[dfWeekDay stringForObjectValue:[NSDate date]]intValue];
	
	lblTitle.text = [NSString stringWithFormat:@"Plan ( %@ %i %i )",[self getMonth:currentMonth],currentDayRunning,currentYear];
}
-(void)addButtons
{
    for(UIView *view in view1.subviews)
    {
        [view removeFromSuperview];
    }
    for(UIButton *btn in view1.subviews)
    {
        [btn removeFromSuperview];
    }
    for(UIView *view in view2.subviews)
    {
        [view removeFromSuperview];
    }
    for(UIButton *btn in view2.subviews)
    {
        [btn removeFromSuperview];
    }
    
	CGFloat orgx=0,orgy=1;
	for (int i=0; i<35; i++)
	{
		UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
		button.userInteractionEnabled = FALSE;
		[button setBackgroundColor:[UIColor clearColor]];
		[button addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchDown];
		[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
		button.frame=CGRectMake(orgx, orgy, widthCal, heightCal);
        button.clipsToBounds = YES;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPress:)];
        lpgr.minimumPressDuration = 1.0f;
        //lpgr.allowableMovement = 100.0f;
        [button addGestureRecognizer:lpgr];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(orgx, orgy, widthCal, heightCal);
		view.clipsToBounds = YES;
        orgx+=widthCal;
		if((i+1)%7==0)
		{
			orgy+=heightCal;
			orgx=0;
		}
		
        [view1 addSubview:view];
        [self designCalander:i withDrName:@"" withDate:nil withView:view];
		
        [view1 addSubview:button];
		[arr_View1Buttons addObject:button];
		[arr_View1 addObject:view];
	}
	orgx=0;
	orgy=1;
	for (int i=0; i<35; i++)
	{
		UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
		button.userInteractionEnabled = FALSE;
		[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[button setBackgroundColor:[UIColor clearColor]];
		[button addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchDown];
		button.frame=CGRectMake(orgx, orgy, widthCal, heightCal);
        button.clipsToBounds = YES;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPress:)];
        lpgr.minimumPressDuration = 1.0f;
        lpgr.allowableMovement = 100.0f;
        [button addGestureRecognizer:lpgr];
        
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(orgx, orgy, widthCal, heightCal);
        view.clipsToBounds = YES;
        
		orgx+=widthCal;
		if((i+1)%7==0)
		{
			orgy+=heightCal;
			orgx=0;
		}
        [view2 addSubview:view];
        
        [self designCalander:i withDrName:@"" withDate:nil withView:view];
        
		[view2 addSubview:button];
		[arr_View2Buttons addObject:button];
		[arr_View2 addObject:view];
	}
}

/*--------------------------------------------------------------------------------
 Fill calendar date element
 --------------------------------------------------------------------------------*/
-(void)fillCalender:(NSInteger)month weekStarts:(NSInteger)weekday year:(NSInteger)year
{
	[tempButton removeFromSuperview];
	
    [self clearLabels];
	
    currentMonth=month;
	currentYear=year;
	currentFirstDay=weekday;
	
    NSInteger numberOfDays=[self getNumberofDays:month YearVlue:year];
	currentLastDay=(currentFirstDay+numberOfDays-1)%7;
	if(currentLastDay==0)
		currentLastDay=7;
	
    NSString *monthName=[self getMonth:month];
	NSInteger grid=(weekday-1);
	
	lblTitle.text=[NSString stringWithFormat:@"Plan ( %@ %ld )",monthName,(long)year];
    
    if(arrCalanderData.count > 0)
        [arrCalanderData removeAllObjects];
    
    SQLManager *objSQL = [SQLManager sharedInstance];
    arrCalanderData = [objSQL getCalenderData:month year:year];
    
    
    UIButton *temp;
    UIView *tempView;
	for(int i=1;i<=numberOfDays;i++)
	{
		if([frontView isEqualToString:@"view1"])
        {
			temp=[arr_View1Buttons objectAtIndex:grid];
			tempView=[arr_View1 objectAtIndex:grid];
        }
		else
        {
			temp= [arr_View2Buttons objectAtIndex:grid];
			tempView= [arr_View2 objectAtIndex:grid];
        }
		[temp setUserInteractionEnabled:TRUE];
		[temp setTitle:[NSString stringWithFormat:@"%i",i] forState:UIControlStateNormal];
        [temp setBackgroundImage:nil forState:UIControlStateNormal];
        [temp setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
		[temp setBackgroundColor:[UIColor clearColor]];
        
        UIView *viewSub=(UIView *)[tempView viewWithTag:tagSubView];
        viewSub.hidden = NO;
        
        UILabel *lblDoctorName=(UILabel *)[viewSub viewWithTag:tagDoctorName];
        UILabel *lblCount=(UILabel *)[viewSub viewWithTag:tagCount];
        
        UILabel *templabelDate=(UILabel *)[viewSub viewWithTag:tagLblDate];
        templabelDate.text = [NSString stringWithFormat:@"%i",i];
        
        UIImageView *temImageview=(UIImageView *)[viewSub viewWithTag:tagBgImage];
        UIImageView *temImageviewColor=(UIImageView *)[viewSub viewWithTag:tagColor];
        
        NSString *date = [NSString stringWithFormat:@"%d-%d-%@",currentYear,currentMonth,templabelDate.text];
        NSString *dateString =[NSString stringWithFormat:@"%@-%d-%d",templabelDate.text,currentMonth,currentYear];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:dateString];
        int dayInt = [[[NSCalendar currentCalendar] components: NSWeekdayCalendarUnit fromDate: dateFromString] weekday];
        
        //""//""//""//""//""//""//""//""//""//""//""//""//""//""//
        NSString *CelllDate,*ObjlDate;
        
        NSArray *arrmain = [date componentsSeparatedByString:@"-"];
        
        NSString *strMonth = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:1]];
        NSString *strDate = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:2]];
        
        if([strMonth length]<2)
            strMonth = [NSString stringWithFormat:@"0%@",strMonth];
        
        if([strDate length]<2)
            strDate = [NSString stringWithFormat:@"0%@",strDate];
        
        CelllDate = [NSString stringWithFormat:@"%@-%@-%@",[arrmain objectAtIndex:0],strMonth,strDate];
        
        CalenderStruct * objCal;
        
        for(int l=0; l<arrCalanderData.count;l++)
        {
            objCal = [arrCalanderData objectAtIndex:l];
            
            NSArray *arrCelllDate = [CelllDate componentsSeparatedByString:@" "];
            CelllDate = [NSString stringWithFormat:@"%@",[arrCelllDate objectAtIndex:0]];
            
            NSArray *arrObjlDate = [objCal.date componentsSeparatedByString:@" "];
            ObjlDate = [NSString stringWithFormat:@"%@",[arrObjlDate objectAtIndex:0]];
            
            if([CelllDate isEqualToString:ObjlDate])
            {
                lblDoctorName.text = objCal.FWPName;
                lblCount.text =  [NSString stringWithFormat:@"%d",objCal.executedCount];
                break;
            }
            else
            {
                objCal=nil;
            }
        }
        //""//""//""//""//""//""//""//""//""//""//""//""//""//""//""//""//
        
        CGFloat heightLbl = [Utils getHeightOfString:lblDoctorName.text withFont:lblDoctorName.font withWidth:lblDoctorName.frame.size.width];
        lblDoctorName.frame = CGRectMake(lblDoctorName.frame.origin.x, lblDoctorName.frame.origin.y, lblDoctorName.frame.size.width, MAX(lblDoctorName.frame.size.height, heightLbl));
        
#pragma mark - Fill Calander Data
        
		
        
        /***************   Current Day  *****************/
        tempView.backgroundColor = [UIColor clearColor];
        
		if(currentDayConstant == i && currentMonthConstant == currentMonth && currentYearConstant == currentYear)
		{
            if(objCal.FWPName == nil || [objCal.FWPName isEqualToString:@""])
            {
                temImageview.image = imgCellBgEmptyToday;
                lblDoctorName.hidden = YES;
                lblCount.hidden = YES;
                temImageviewColor.hidden = YES;
            }
            else
            {
                temImageview.image = imgSTPDateToday;
                lblDoctorName.hidden = NO;
                lblCount.hidden = NO;
                temImageviewColor.hidden = NO;
            }
		}
		else
		{
            if(objCal.FWPName == nil || [objCal.FWPName isEqualToString:@""])
            {
                temImageview.image = imgCellBgEmpty;
                lblDoctorName.hidden = YES;
                lblCount.hidden = YES;
                temImageviewColor.hidden = YES;
            }
            else
            {
                temImageview.image = imgSTPDate;
                lblDoctorName.hidden = NO;
                lblCount.hidden = NO;
                temImageviewColor.hidden = NO;
            }
		}
        
        templabelDate.textColor = ColorNormal;
        
        if([self checkForHoliday:date] || dayInt == 1 || [self checkForLeave:date])
        {
            templabelDate.textColor = [UIColor redColor];
        }
        if([self checkForHoliday:date])
        {
            if(currentDayConstant == i && currentMonthConstant == currentMonth && currentYearConstant == currentYear)
                temImageview.image = imgCellBgEmptyToday;
            else
                temImageview.image = imgCellBgEmpty;
            
            
            lblDoctorName.hidden = NO;
            lblDoctorName.text = [NSString stringWithFormat:@"%@",[dicHolidaysName objectForKey:CelllDate]];
            heightLbl = [Utils getHeightOfString:lblDoctorName.text withFont:lblDoctorName.font withWidth:lblDoctorName.frame.size.width];
            lblDoctorName.frame = CGRectMake(lblDoctorName.frame.origin.x, lblDoctorName.frame.origin.y, lblDoctorName.frame.size.width, MAX(lblDoctorName.frame.size.height, heightLbl));
            lblDoctorName.textColor = [UIColor redColor];
            lblCount.hidden = YES;
            temImageviewColor.hidden = YES;
        }
        if([self checkForLeave:date])
        {
            if(currentDayConstant == i && currentMonthConstant == currentMonth && currentYearConstant == currentYear)
                temImageview.image = imgCellBgEmptyToday;
            else
                temImageview.image = imgCellBgEmpty;
            
            lblDoctorName.text = @"Leave";
            lblDoctorName.textColor = [UIColor redColor];
            lblDoctorName.hidden = NO;
            lblCount.hidden = YES;
            temImageviewColor.hidden = YES;
        }
        
		[temp setTag:i];
        
        [temp setBackgroundColor:[UIColor clearColor]];
		
		grid++;
		if(grid==35)
			grid=0;
	}
}
#pragma mark -
#pragma mark - clear labels
/*--------------------------------------------------------------------------------
 clear labels
 --------------------------------------------------------------------------------*/
-(void)clearLabels
{
	UIButton *temp;
	if([frontView isEqualToString:@"view2"])
	{
		for(int i = 0 ; i< [arr_View2Buttons count]; i++)
		{
			temp = (UIButton *)[arr_View2Buttons objectAtIndex:i];
			[temp setTitle:@"" forState:UIControlStateNormal];
			[temp setBackgroundColor:[UIColor clearColor]];
			[temp setUserInteractionEnabled:FALSE];
            //            UILabel *templabel=(UILabel *)[temp viewWithTag:111];
            //			[templabel removeFromSuperview];
		}
	}
	else
	{
		for(int i = 0 ; i< [arr_View1Buttons count]; i++)
		{
			temp = (UIButton *)[arr_View1Buttons objectAtIndex:i];
			[temp setTitle:@"" forState:UIControlStateNormal];
			[temp setBackgroundColor:[UIColor clearColor]];
			[temp setUserInteractionEnabled:FALSE];
            //            [[temp viewWithTag:111] removeFromSuperview];
		}
	}
	UIView *tempView;
	if([frontView isEqualToString:@"view2"])
	{
		for(int i = 0 ; i< [arr_View2 count]; i++)
		{
			tempView = (UIButton *)[arr_View2 objectAtIndex:i];
			[tempView setBackgroundColor:[UIColor clearColor]];
			[tempView setUserInteractionEnabled:FALSE];
            
            UIView *viewSub=(UIView *)[tempView viewWithTag:tagSubView];
            viewSub.hidden = YES;
            
		}
	}
	else
	{
		for(int i = 0 ; i< [arr_View1 count]; i++)
		{
			tempView = (UIButton *)[arr_View1 objectAtIndex:i];
			[tempView setBackgroundColor:[UIColor clearColor]];
			[tempView setUserInteractionEnabled:FALSE];
            
            UIView *viewSub=(UIView *)[tempView viewWithTag:tagSubView];
            viewSub.hidden = YES;
		}
	}
}

-(NSString *)getMonth:(NSInteger)month
{
	switch (month) {
		case 1:
			return @"January";
		case 2:
			return @"February";
		case 3:
			return @"March";
		case 4:
			return @"April";
		case 5:
			return @"May";
		case 6:
			return @"June";
		case 7:
			return @"July";
		case 8:
			return @"August";
		case 9:
			return @"September";
		case 10:
			return @"October";
		case 11:
			return @"November";
		case 12:
			return @"December";
	}
	return @"";
}

-(NSInteger)getNumberofDays:(NSInteger)monthInt YearVlue:(NSInteger)yearInt
{
	BOOL isLeap=NO;
	if(((yearInt%400)==0)||(((yearInt%4)==0)&&((yearInt%100!=0))))
		isLeap=YES;
	
	switch (monthInt)
    {
		case 1:
			return 31;
		case 2:
			if(isLeap==YES)
				return 29;
			
			return 28;
		case 3:
			return 31;
		case 4:
			return 30;
		case 5:
			return 31;
		case 6:
			return 30;
		case 7:
			return 31;
		case 8:
			return 31;
		case 9:
			return 30;
		case 10:
			return 31;
		case 11:
			return 30;
		case 12:
			return 31;
	}
	return 0;
}
/*--------------------------------------------------------------------------------
 get first day
 --------------------------------------------------------------------------------*/
-(void)getFirstDay:(NSInteger)month dayfirst:(NSInteger)firstday
{
	NSInteger daysinMonth=[self getNumberofDays:month YearVlue:currentYear];
	firstday=firstday-1;
	currentFirstDay=(8+firstday-(daysinMonth%7))%7;
	if(currentFirstDay==0)
		currentFirstDay=7;
}


/*-----------day Navigation Event-----------*/
-(IBAction)dayNavigationEvent:(id)sender
{
	currentDateValue=0;
	if([sender tag] == 101)
		[self gotoPreviousMonth];
	else if([sender tag]==102)
		[self gotoNextMonth];
}
/*--------------------------------------------------------------------------------
 Goto next month
 --------------------------------------------------------------------------------*/
-(void)gotoNextMonth
{
    //    if (isChangeDateClicked || isEditClicked)
    //    {
    //        UIButton *btnPrevMonth = (UIButton *)[self.view viewWithTag:101];
    //        btnPrevMonth.enabled = YES;
    //    }
	
	currentMonth++;
	if(currentMonth==13)
	{
        currentYear++;
	    currentMonth=1;
	}
	if(currentLastDay==7)
		currentLastDay=0;
	currentFirstDay=currentLastDay+1;
	
	if([frontView isEqualToString:@"view1"])
		frontView = @"view2";
	else
		frontView = @"view1";
	
	[self fillCalender:currentMonth weekStarts:currentFirstDay year:currentYear];
	
	if([frontView isEqualToString:@"view2"])
	{
		[view2 setFrame:frame2];
		[self.view bringSubviewToFront:view2];
	}
	else
	{
		[view1 setFrame:frame2];
		[self.view bringSubviewToFront:view1];
	}
	
	[self.view bringSubviewToFront:btnRight];
	[self.view bringSubviewToFront:btnLeft];
	
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration: 0.5];
	
	if([frontView isEqualToString:@"view2"])
	{
		[view2 setFrame:frame1];
		[view1 setFrame:frame0];
	}
	else
	{
		[view1 setFrame:frame1];
		[view2 setFrame:frame0];
	}
	
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}
/*--------------------------------------------------------------------------------
 goto Previous Month
 --------------------------------------------------------------------------------*/
-(void)gotoPreviousMonth
{
	currentMonth--;
	if(currentMonth==0)
	{
		currentMonth=12;
		currentYear--;
	}
	[self getFirstDay:currentMonth dayfirst:currentFirstDay];
	
	if([frontView isEqualToString:@"view1"])
		frontView = @"view2";
	else
		frontView = @"view1";
	
	[self fillCalender:currentMonth weekStarts:currentFirstDay year:currentYear];
	
	if([frontView isEqualToString:@"view2"])
		[view2 setFrame:frame0];
	else
		[view1 setFrame:frame0];
	
	[self.view bringSubviewToFront:btnRight];
	[self.view bringSubviewToFront:btnLeft];
	
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration: 0.5];
	if([frontView isEqualToString:@"view2"])
	{
		[view2 setFrame:frame1];
		[view1 setFrame:frame2];
	}
	else
	{
		[view2 setFrame:frame2];
		[view1 setFrame:frame1];
	}
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}
#pragma mark - Date Selected
//- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
//{
////    if ([sender isEqual:lpgr])
////    {
//        if (sender.state == UIGestureRecognizerStateBegan)
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Gestures" message:@"Long Gesture Detected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertView show];
//        }
////    }
//}
-(void)dateSelected:(UIButton *)btn
{
    NSLog(@"%d",btn.tag);
    NSLog(@"%@",btn.titleLabel.text);
    
    if(arrData.count)
        [arrData removeAllObjects];
    
    SQLManager *objSQL = [SQLManager sharedInstance];
    arrData = [objSQL getSTPListForDeviation];
    [self getDataForSearch];
    
	currentDateValue=[[btn currentTitle] integerValue];
    NSString *strDate = [NSString stringWithFormat:@"%d-%d-%d",currentDateValue,currentMonth,currentYear];
    lblDateTbl.text = [NSString stringWithFormat:@"%@",strDate];
    
    NSMutableArray *arrTemp = nil;
    
    if([frontView isEqualToString:@"view1"])
		arrTemp = (NSMutableArray *) arr_View1;
	else
		arrTemp = (NSMutableArray *) arr_View2;
    
    for(int i=0; i<arrTemp.count; i++)
    {
        UIView *view = (UIView *)[arrTemp objectAtIndex:i];
        
        UIView *viewSub=(UIView *)[view viewWithTag:tagSubView];
        
        UILabel *lblDoctorName=(UILabel *)[viewSub viewWithTag:tagLblDate];
        if([lblDoctorName.text isEqualToString:[btn currentTitle]])
        {
            viewTempCalCell = (UIView *) view;
        }
    }
    
    selectedButton = btn;
}

-  (void)LongPress:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
    }
    else if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"UIGestureRecognizerStateBegan.");
        NSLog(@"%@",lblDateTbl.text);
        
        NSArray *arrmTemp = [lblDateTbl.text componentsSeparatedByString:@"-"];
        
        NSString *strDate = [NSString stringWithFormat:@"%@-%@-%@",[arrmTemp objectAtIndex:2],[arrmTemp objectAtIndex:1],[arrmTemp objectAtIndex:0]];
        NSDate *today = [NSDate date];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:today];
        
        NSLog(@"%@   %@",dateString, strDate);
        
        NSDate * newDate = [dateFormatter dateFromString:strDate];
        
        NSComparisonResult result = [today compare:newDate];
        
        if(result == NSOrderedSame)
        {
            NSLog(@"To Day");
        }
        else if(result==NSOrderedAscending)
        {
            NSLog(@"Future Date");
        }
        else if(result==NSOrderedDescending)
        {
            if([dateString isEqualToString:strDate])
                NSLog(@"To Day");
            NSLog(@"Past Date");
            
        }
        
        if(result==NSOrderedDescending)
        {
            if([dateString isEqualToString:strDate])
            {
                SQLManager *objSQL = [SQLManager sharedInstance];
                if([objSQL checkForDeviationForCurrentDate])
                {
                    [self performSelectorOnMainThread:@selector(callSelectPopoverSub:) withObject:selectedButton waitUntilDone:YES];
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(callSelectPopover:) withObject:selectedButton waitUntilDone:YES];
                }
            }
        }
        else if(result==NSOrderedAscending)
        {
            [self performSelectorOnMainThread:@selector(callSelectPopover:) withObject:selectedButton waitUntilDone:YES];
        }
        else if([dateString isEqualToString:strDate])
        {
            SQLManager *objSQL = [SQLManager sharedInstance];
            if([objSQL checkForDeviationForCurrentDate])
            {
                [self performSelectorOnMainThread:@selector(callSelectPopoverSub:) withObject:selectedButton waitUntilDone:YES];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(callSelectPopover:) withObject:selectedButton waitUntilDone:YES];
            }
        }
        
        
        //checkForDeviationForCurrentDate
    }
}

- (IBAction)onScheduleCall:(UIButton *)sender
{
    [popoverController dismissPopoverAnimated:YES];
    [self btnScheduleCallClicked:sender];
}
- (IBAction)onDeviate:(UIButton *)sender
{
    [popoverController dismissPopoverAnimated:YES];
    [self callPopOver:sender];
}
-(void)callSelectPopover:(UIButton *)btn
{
    UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:objViewController];
    
    UIView *viewPopOveriPad = [[UIView alloc] init];
    self.selectionView.frame = CGRectMake(0, 0, self.selectionView.frame.size.width, self.selectionView.frame.size.height);
    viewPopOveriPad.frame = self.selectionView.frame;
    [viewPopOveriPad addSubview:self.selectionView];
    objViewController.view = viewPopOveriPad;
    [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
    
    [popoverController presentPopoverFromRect:[btn bounds]
                                       inView:btn
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
    
}
-(void)callSelectPopoverSub:(UIButton *)btn
{
    UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:objViewController];
    
    UIView *viewPopOveriPad = [[UIView alloc] init];
    self.viewSelection.frame = CGRectMake(0, 0, self.viewSelection.frame.size.width, self.viewSelection.frame.size.height);
    viewPopOveriPad.frame = self.viewSelection.frame;
    [viewPopOveriPad addSubview:self.viewSelection];
    objViewController.view = viewPopOveriPad;
    [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
    
    [popoverController presentPopoverFromRect:[btn bounds]
                                       inView:btn
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
    
}
-(void)callPopOver:(UIButton *)btn
{
    UIPopUPViewController *objViewController = [[UIPopUPViewController alloc] initWithNibName:nil bundle:nil];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:objViewController];
    
    UIView *viewPopOveriPad = [[UIView alloc] init];
    viewPopUp.frame = CGRectMake(0, 0, viewPopUp.frame.size.width, viewPopUp.frame.size.height);
    viewPopOveriPad.frame = viewPopUp.frame;
    [viewPopOveriPad addSubview:viewPopUp];
    objViewController.view = viewPopOveriPad;
    [popoverController setPopoverContentSize:CGSizeMake(viewPopOveriPad.frame.size.width, viewPopOveriPad.frame.size.height)];
    
    [popoverController presentPopoverFromRect:[btn bounds]
                                       inView:btn
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
    
}

//SAJIDA - Updated this funtion for release
-(void)designCalander:(NSInteger)tagValue withDrName:(NSString *)DrName withDate:(NSString *)date withView:(UIView *)view
{
    view.tag  = tagValue;
    
    NSInteger ypos = 5;
    
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(2, 2, view.frame.size.width-4, view.frame.size.height-4)];
    viewBg.backgroundColor = [UIColor clearColor];
    viewBg.tag = tagSubView;
    viewBg.clipsToBounds = YES;
    [view addSubview:viewBg];
    
    UIImageView *imgBg= [self createUIImageView:0 withYposition:0 withWidth:viewBg.frame.size.width withHeight:viewBg.frame.size.height  withImageName:@"" withTag:tagBgImage];
    imgBg.image = imgCellBgEmpty;
    imgBg.clipsToBounds = YES;
    [viewBg addSubview:imgBg];
    
    UILabel *lblDate = [self createUIlabel:5 withYposition:ypos withWidth:30 withHeight:30 withText:date withTag:0 withFont:fontHelvetica_18];
    lblDate.textColor = ColorNormal;
    lblDate.clipsToBounds = YES;
    lblDate.tag = tagLblDate;
    lblDate.font = font_ProCond(30.0);
    lblDate.text = [NSString stringWithFormat:@"%d",tagValue];
    [viewBg addSubview:lblDate];
    
    UILabel *lblName = [self createUIlabel:45 withYposition:ypos withWidth:85 withHeight:25 withText:DrName withTag:0 withFont:font_ProCond(25.0)];
    lblName.textColor = [UIColor darkGrayColor];
    lblName.tag = tagDoctorName;
    lblName.numberOfLines = 5;
    lblName.clipsToBounds = YES;
    lblName.textAlignment = NSTextAlignmentRight;
    [viewBg addSubview:lblName];
    
    ypos += lblName.frame.size.height + 2;
    
    UIImageView *imgGreen = [self createUIImageView:50 withYposition:85 withWidth:28 withHeight:28 withImageName:@"urlYelloNew" withTag:tagColor];
    imgGreen.backgroundColor = [UIColor clearColor];
    imgGreen.clipsToBounds = YES;
    [viewBg addSubview:imgGreen];
    
    //    CALayer *l = [imgGreen layer];
    //    [l setMasksToBounds:YES];
    //    [l setCornerRadius:15.0];
    
    UILabel *lblCount = [self createUIlabel:0 withYposition:0 withWidth:imgGreen.frame.size.width withHeight:imgGreen.frame.size.height withText:@"" withTag:tagCount withFont:font_ProCond(18.0)];
    lblCount.clipsToBounds = YES;
    lblCount.tag = tagCount;
    lblCount.textAlignment = NSTextAlignmentCenter;
    lblCount.textColor = ColorNormal;
    [imgGreen addSubview:lblCount];
}
- (IBAction)btnStandardTourPlanClicked:(UIButton *)sender
{
    StandardTourPlan *objStandardTourPlan = [[StandardTourPlan alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:objStandardTourPlan animated:YES];
    objStandardTourPlan = nil;
}

- (IBAction)btnScheduleCallClicked:(UIButton *)sender
{
    ScheduleController *objSchedule = [[ScheduleController alloc] initWithNibName:@"ScheduleController" bundle:nil];
    objSchedule.fromMTP = YES;
    objSchedule.arrDoctors = objSelectedCalender.arrDrs;
    objSchedule.currentDate = objSelectedCalender.date;
    [self.navigationController pushViewController:objSchedule animated:YES];
    objSchedule = nil;
}
- (IBAction)btnMenuClicked:(UIButton *)sender
{
    [UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:0.5];
    if(isSlide)
    {
        viewMain.frame = CGRectMake(0, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
        isSlide = NO;
    }
    else
    {
        viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
        isSlide = YES;
    }
    [UIView commitAnimations];
}

- (IBAction)btnDoneTblViewClicked:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                          
                                                    message:@"Are you sure you want to deviate from your plan?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.tag = 10;
    
    [alert show];
    //0-----
}
#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        
        if (buttonIndex == 1)
        {
            SQLManager * objSQl = [SQLManager sharedInstance];
            NSString * date,*month = nil;
            
            if(currentDateValue < 10)
                date = [NSString stringWithFormat:@"0%ld",(long)currentDateValue];
            else
                date = [NSString stringWithFormat:@"%ld",(long)currentDateValue];
            
            if(currentMonth < 10)
                month = [NSString stringWithFormat:@"0%ld",(long)currentMonth];
            else
                month = [NSString stringWithFormat:@"%ld",(long)currentMonth];
            
            NSString *strDate = [NSString stringWithFormat:@"%d-%@-%@",currentYear,month,date];
            [objSQl updateDeviation:strDate STPDId:selectedSTP.Id];
            [self removePopUp];
        }
    }
}
-(void)removePopUp
{
    [popoverController dismissPopoverAnimated:YES];
}

-(void )createLineView:(CGFloat )xpos withYposition:(CGFloat)ypos withWidth:(CGFloat )width withHeight:(CGFloat)height withIViewName:(UIView *)viewName
{
    UIView *viewColorBgDown= [[UIView alloc] initWithFrame:CGRectMake(xpos, ypos,width,height)];
    viewColorBgDown.backgroundColor = [UIColor grayColor];
    viewColorBgDown.alpha = 0.5;
    viewColorBgDown.clipsToBounds = YES;
    [viewName addSubview:viewColorBgDown];
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
        
        for (int i=0; i<[arrData count];i++)
        {
            STPDoctor *obj = [arrData objectAtIndex:i];
            NSRange descriptionRange = [obj.drName rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:[arrData objectAtIndex:i]];
            }
        }
    }
    
    [tblView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark -
#pragma mark TableView Delegates
#pragma mark TableView Delegate Methods
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
//    view.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
//
//    NSArray *arr = [NSArray arrayWithObjects:@"Name",@"Target",@"Speciality",@"Account",@"Address",@"Last call", nil];
//    for(int i=0; i<arr.count; i++)
//    {
//        UILabel *lbl = [[UILabel alloc] init];
//        if(i==0)
//            lbl.frame = CGRectMake(0, 0, 200, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(205, 0, 40, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(320, 0, 150, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(480, 0, 150, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(655, 0, 250, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(915, 0, 90, 44);
//        lbl.tag = i;
//        lbl.textAlignment = NSTextAlignmentLeft;
//        lbl.text = [arr objectAtIndex:i];
//        lbl.backgroundColor = [UIColor clearColor];
//        lbl.font = fontHelveticaBold_15;
//        [view addSubview:lbl];
//    }
//    return view;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    view.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isFiltered)
        return 1;
    else
        return [arrSectionArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered)
        return [filteredTableData count];
    else
        return [[arrSectionArray objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    STPDoctor *objDoctorsStruct = nil;
    
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, tblView.frame.size.height-3, cell.contentView.frame.size.width, 3)];
        view.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:view];
        
        cell.textLabel.font = font_ProCond(20.0);
        cell.textLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
    }
    if(indexPath.row %2 == 0)
        cell.contentView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    else
        cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    cell.textLabel.text = objDoctorsStruct.drName;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    STPDoctor *objDoctorsStruct = nil;
    
    if(isFiltered)
        objDoctorsStruct = [filteredTableData objectAtIndex:indexPath.row];
    else
        objDoctorsStruct = [[arrSectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    selectedSTP = objDoctorsStruct;
    
    UIView *viewSub=(UIView *)[viewTempCalCell viewWithTag:tagSubView];
    viewSub.hidden = NO;
    
    UILabel *lblDoctorName=(UILabel *)[viewSub viewWithTag:tagDoctorName];
    lblDoctorName.text = objDoctorsStruct.drName;
    lblStpName.text = objDoctorsStruct.drName;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(isFiltered)
        return 0;
    else
        return arrIndexArray;
}
#pragma mark - Tableview - Search Bar
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
    if(isFiltered)
        return 0;
    else
        return [arrIndexArray indexOfObject:title];
}
/*-(void)btnSTPClicked:(UIButton *)sender
 {
 NSLog(@"%d",sender.tag);
 
 UIButton * btn = (UIButton *)sender;
 
 STPDoctor *objDoctorsStruct = nil;
 
 int row = [btn.titleLabel.text intValue];
 int section = btn.imageView.tag;
 
 if(isFiltered)
 {
 objDoctorsStruct = [filteredTableData objectAtIndex:row];
 
 for(int i=0; i<filteredTableData.count; i++)
 {
 STPDoctor *obj = [filteredTableData objectAtIndex:i];
 if(objDoctorsStruct.Id == obj.Id)
 {
 //                if(objDoctorsStruct.isSelected)
 //                {
 //                    objDoctorsStruct.isSelected = NO;
 //                }
 //                else
 objDoctorsStruct.isSelected = YES;
 selectedSTP = objDoctorsStruct;
 }
 else
 {
 objDoctorsStruct.isSelected = NO;
 }
 }
 }
 else
 {
 objDoctorsStruct = [[arrSectionArray objectAtIndex:section] objectAtIndex:row];
 
 for(int Count=0; Count<arrSectionArray.count; Count++)
 {
 NSMutableArray *array = [arrSectionArray objectAtIndex:Count];
 for(int i=0; i<array.count; i++)
 {
 STPDoctor *obj = [array objectAtIndex:i];
 
 if(objDoctorsStruct.Id == obj.Id)
 {
 objDoctorsStruct.isSelected = YES;
 selectedSTP = objDoctorsStruct;
 }
 else
 {
 objDoctorsStruct.isSelected = NO;
 }
 }
 }
 }
 [tblView reloadData];
 
 }*/

-(void)getDataForSearch
{
    for(int i = 0; i<[arrAlphabets count];i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int x=0;x<[arrData count];x++)
        {
            STPDoctor *objDocStruct = [arrData objectAtIndex:x];
            
            NSString *myString = objDocStruct.drName;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            
            if( [ichar isEqualToString:[arrAlphabets objectAtIndex:i]])
            {
                NSLog(@"%@", myString);
                [array addObject:objDocStruct];
            }
        }
        if([array count])
        {
            STPDoctor *objDocStructSub = [array objectAtIndex:0];
            
            NSString *myString = objDocStructSub.drName;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            [arrIndexArray addObject:ichar];
            [arrSectionArray addObject:array];
        }
        array = nil;
    }
    NSLog(@"%@",[arrSectionArray description]);
    NSLog(@"%d",[arrSectionArray count]);
    
    
}

@end
