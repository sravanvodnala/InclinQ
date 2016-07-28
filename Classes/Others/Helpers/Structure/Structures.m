//
//  Structures.m
//  InclinIQ
//
//  Created by Gagan on 08/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "Structures.h"

//Request

@implementation WebViewStruct
@end

@implementation loginRequestStruct
@synthesize userName,password;
@end

@implementation timerStruct
@end

@implementation  doctorStuct
@synthesize fname,lname,specializationId,specializationName,doctorId;
@end


@implementation BrandClust
@end

@implementation drBrandCluster
-(void)initObj
{
    self.arrBrands = [[NSMutableArray alloc]init];
}
@end


@implementation specialisationStruct
@synthesize abbrevation, name,Id;
@end

@implementation  eDetailor
@synthesize brandName,noOfSlides,versionNo,Id;
-(void)initObject
{
    self.arrSlides = [[NSMutableArray alloc]init];
}
@end

@implementation schedule
@synthesize datetime,ActionBy,ActionDate,CallObjective,CallType;
@end

@implementation ScheduleCall
@end

@implementation ScheduleContent
@end

@implementation STPD
-(void)initObject
{
    self.arrDoctors = [[NSMutableArray alloc]init];
}
@end
@implementation STPDoctor
@end

@implementation structIndexPaths
@end

@implementation eDetailorSlide
@end;

@implementation CalenderStruct
-(void)initObject
{
    self.arrDrs = [[NSMutableArray alloc]init];
  
}
@end

@implementation ScheduleCallDescription
-(void)initObject
{
    self.arrDoctors = [[NSMutableArray alloc]init];
    self.arreDetailors = [[NSMutableArray alloc]init];
    self.arrPreviousHistory = [[NSMutableArray alloc]init];
}

@end

#pragma mark - call completed
@implementation callCompleted
-(void)initObject
{
    self.arrCallReportVisitDetail = [[NSMutableArray alloc]init];
    self.arrCallReportBrandSlideDetail = [[NSMutableArray alloc]init];
    self.arrCallReportBrandDetail = [[NSMutableArray alloc]init];
    self.arrCallRecordHistory = [[NSMutableArray alloc]init];
}
@end


@implementation PreviousHistory
@end

@implementation CallDetailHistory
@end

@implementation CallReportVisitDetail
@end

@implementation CallReportBrandDetail
@end

@implementation CallReportBrandSlideDetail
@end

@implementation  Leave
@end
//******************Sravan
@implementation CustomerStruct
@end
@implementation SyncData
@end






