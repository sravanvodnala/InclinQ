//
//  HomeViewController.m
//  InclinIQ
//
//  Created by Gagan on 14/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "HomeViewController.h"
#import "ScheduleController.h"
#import "SQLManager.h"
#import "DoctorCallController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize arrData,isFirstTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    lblGoodMorning.font = font_ProCond(30.0);
    lblEmpName.font = font_ProCond(50.0);

    lblCurrentDate.font = font_ProCond(24.0);
    lblCurrentTime.font = font_ProCond(24.0);

    SQLManager * objSQL = [SQLManager sharedInstance];
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    objDel.arrScheduleData = [objSQL getScheduleCallData];
    
    arrData =  objDel.arrScheduleData;//[objSQL getScheduleCallData];
    
    lblEmpName.text = [objSQL getEmpName:[objDel.empId intValue]];
   
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    
    if(hour >= 0 && hour < 12)
        lblGoodMorning.text =  @"Good Morning";
    else if(hour >= 12 && hour < 17)
        lblGoodMorning.text = @"Good Afternoon";
    else if(hour >= 17)
        lblGoodMorning.text = @"Good Evening";
   
    isSlide = NO;
    
    
    
    self.navigationController.navigationBarHidden = YES;

    NSString *currentTime =  [self retrievTime];
    NSString *currentDate =  [self retrievDate];
    lblCurrentDate.text = currentDate;
    lblCurrentTime.text = currentTime;
 
    [self designBagroundView:viewBack];
    
    if(!isFirstTime)
    {
    viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
    isSlide = YES;
    
    [self btnMenuClicked:nil];
        isFirstTime = NO;
    }
   
    [self designCoverFlow];

    viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    viewMain.layer.shadowOpacity = 0.7f;
    viewMain.layer.shadowOffset = CGSizeMake(-5.0f,20.0f);
    viewMain.layer.shadowRadius = 10.0f;
    viewMain.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:viewMain.bounds];
    viewMain.layer.shadowPath = pathBtn.CGPath;

}
-(NSString *)retrievDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    return currentTime;
}
-(NSString *)retrievTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    return currentTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)btnRightClicked
{
    ScheduleController *objSchedule = [[ScheduleController alloc] initWithNibName:@"ScheduleController" bundle:nil];
    [self.navigationController pushViewController:objSchedule animated:YES];
    objSchedule = nil;
}
-(void)designCoverFlow
{
    for (UIView *v in scrlViewMain.subviews) {
        if ([v isKindOfClass:[UIView class]]) {
            [v removeFromSuperview];
        }
    }
    
    NSInteger xpos = 10, ypos = 0, width = 315, height = 355;
    for(int i=0; i<arrData.count; i++)
    {
        
        ScheduleCallDescription * objSC = [arrData objectAtIndex:i];
        
        xpos = i*(width+30);
        UIView *view = [[UIScrollView alloc] init];
        view.frame = CGRectMake(10+xpos, ypos, width+5, height+5);
        view.tag = i;
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor clearColor];
        [scrlViewMain addSubview:view];
        
        UIImageView *imgBg = [self createUIImageView:0 withYposition:0 withWidth:315 withHeight:355 withImageName:@"box-with-green-border-315x355.png" withTag:0];
        [view addSubview:imgBg];
        

        if(objSC.isCallCompleted == 0)
            imgBg.image = [UIImage imageNamed:@"box-with-orange-border-315x355.png"];
        else
            if(objSC.isCallCompleted == 1)
                imgBg.image = [UIImage imageNamed:@"box-with-green-border-315x355.png"];
        
        UIScrollView *scrlView = [[UIScrollView alloc] init];
        scrlView.frame = CGRectMake(1, 1, width-2, height-2);
        scrlView.clipsToBounds = YES;
        scrlView.backgroundColor = [UIColor clearColor];
        [view addSubview:scrlView];
        
        NSString * imageName = nil;
        
        if(objSC.isCallCompleted == 0)
        {
            if(objSC.callType == INDIVIDUAL_CALL)
                imageName = @"icon-single-call-orange-35x35.png";
            else
                 imageName = @"icon-group-call-orange-35x35.png";
        }
        else
            if(objSC.isCallCompleted == 1)
            {
                if(objSC.callType == INDIVIDUAL_CALL)
                    imageName = @"icon-single-call-green-35x35.png";
                else
                    imageName = @"icon-group-call-green-35x35.png";
              

            }
        UIImageView *imgDoctor = [self createUIImageView:10 withYposition:10 withWidth:35 withHeight:35 withImageName:imageName withTag:12];
        [scrlView addSubview:imgDoctor];
        
        NSString *strDocName = @"Dr. Name Doctors ";//[NSString stringWithFormat:@"%@",[arrDoctorsName objectAtIndex:i]];
        strDocName = [Utils getNormalString:strDocName];
        
        CGFloat widthLabel = scrlView.frame.size.width -imgDoctor.frame.size.width - imgDoctor.frame.origin.x - 20;
        
        
        NSString *strDoctor = [[NSString alloc] init];
        
        for(int i=0; i<objSC.arrDoctors.count; i++)
        {
            doctorStuct *objDoctors = [objSC.arrDoctors  objectAtIndex:i];
            NSString *strTemp = [NSString stringWithFormat:@"Dr. %@",objDoctors.fname];
            if(i == objSC.arrDoctors.count-1)
                strDoctor = [NSString stringWithFormat:@"%@ %@.",strDoctor,strTemp];
            else
                strDoctor = [NSString stringWithFormat:@"%@  %@,",strDoctor,strTemp];
        }
        CGFloat floatLabelHeight = [Utils getHeightOfString:strDoctor withFont:font_ProBoldCondensed(20.0) withWidth:widthLabel];
        

        UILabel *lblDocName = [self createUIlabel:imgDoctor.frame.size.width + imgDoctor.frame.origin.x + 10 withYposition:20 withWidth:widthLabel withHeight:floatLabelHeight withText:strDoctor withTag:10 withFont:font_ProBoldCondensed(20.0)];
        lblDocName.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0 ];
        [scrlView addSubview:lblDocName];
        
        CGFloat yposition = lblDocName.frame.size.height + lblDocName.frame.origin.x;

        strDocName = @"Brands to be detailed :";
        strDocName = [Utils getNormalString:strDocName];
        
        floatLabelHeight = [Utils getHeightOfString:strDocName withFont:font_ProCond(18) withWidth:scrlView.frame.size.width-20];
        
        UILabel *lblBrabdDetail = [self createUIlabel:10 withYposition:yposition withWidth:scrlView.frame.size.width-20 withHeight:floatLabelHeight withText:strDocName withTag:10 withFont:font_ProCond(18.0)];
        lblBrabdDetail.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0 ];
        [scrlView addSubview:lblBrabdDetail];
        
        yposition += floatLabelHeight;
        
        for(int j=0; j<objSC.arreDetailors.count; j++)
        {
            eDetailor * obj = [objSC.arreDetailors objectAtIndex:j];
            
            NSString *strBrandName = obj.brandName;
            strBrandName = [Utils getNormalString:strBrandName];
            floatLabelHeight = [Utils getHeightOfString:strBrandName withFont:font_ProCond(18.0) withWidth:scrlView.frame.size.width-20];
            
            UILabel *lblBrandName = [self createUIlabel:10 withYposition:yposition withWidth:scrlView.frame.size.width-20 withHeight:40 withText:strBrandName withTag:10 withFont:font_ProCond(18.0)];
            lblBrandName.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0 ];
            [scrlView addSubview:lblBrandName];
            
            yposition = yposition +floatLabelHeight + 10;
        }
        scrlView.contentSize = CGSizeMake(scrlView.contentSize.width, yposition + 20);
        
//        [self setShadowEffectForUIView:view];
       

        UIButton *btn = [self createUIButton:0 withYposition:0 withWidth:view.frame.size.width withHeight:view.frame.size.height withTitle:@"" withFontSize:0.0f withImageName:@""];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClickedinOnView:) forControlEvents:UIControlEventTouchUpInside];
        [scrlView addSubview:btn];
        
    }
    scrlViewMain.contentSize = CGSizeMake(xpos+width+40, scrlViewMain.contentSize.height);
}
-(void)btnClickedinOnView:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    
    isFirstTime = YES;
    ScheduleCallDescription * objSCD = [arrData objectAtIndex:sender.tag];
    DoctorCallController *objController = [[DoctorCallController alloc] initWithNibName:nil bundle:nil];
    
    objController.objSCD = objSCD;
    
    [self.navigationController pushViewController:objController animated:YES];
    objController = nil;
    
}

#pragma mark - MenuSlide Button

- (IBAction)btnOpenScheduler:(UIButton *)sender
{
    isFirstTime = YES;
    ScheduleController *objSchedule = [[ScheduleController alloc] initWithNibName:@"ScheduleController" bundle:nil];
    [self.navigationController pushViewController:objSchedule animated:YES];
    objSchedule = nil;

}

- (IBAction)btnTimeClicked:(UIButton *)sender
{
    NSString *currentTime =  [self retrievTime];
    NSString *currentDate =  [self retrievDate];
    lblCurrentDate.text = currentDate;
    lblCurrentTime.text = currentTime;
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

- (IBAction)btnLogoutClicked:(UIButton *)sender
{
    [self logOut];
}
@end
