//
//  Defines.h
//  InclinIQ
//
//  Created by Gagan on 08/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#ifndef InclinIQ_Defines_h
#define InclinIQ_Defines_h

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "Structures.h"
#import "Utils.h"

#import "fontProCondensed.h"
#import "fontProBoldCondenced.h"
typedef enum webService_method_names
{
    login,
    getSync,
    FinancialYear,
    Period,
    BrandCluster,
    Qualification,
    Specialisation,
    LocationType,
    DivisionLocationType,
    Designation,
    DivisionDesignation,
    LocationEmployee,
    Location,
    Employee,
    Doctor,
    DoctorBrandClusterMatrix,
    LeaveType,
    LeaveApplication,
    HolidayZone,
    HolidayZoneMap,
    Holiday,
    HolidayDate,
    Edetailer,
    EdetailerSpecialisationDetail,
    EdetailerSlideWiseSpecDetail,
    StandardTourPlanDay,
    StandardTourPlantbl,
    MonthlyTourProgram,
    Schedule,
    ScheduleCal,
    SchedulContent,
    CallReport,
    CalReportVisitDetail,
    CalReportBrandDetail,
    CalReportBrandSlideDetail,
    CalDetailHistory,
    CalRecordHistory,
    MonthlyTourProgramUpload,
    DoctorBrandClusterMatrixUpload,
    SyncStatus
    


}wsMethodNames;


#pragma mark - SQL table names


#define BASE_URL              @"http://acipl-betasite.com/inclinIQ/api/"
#define LessThanIOS7 ([[[UIDevice currentDevice] systemVersion] compare:(@"7.0") options:NSNumericSearch] == NSOrderedAscending)

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

#define fontHelveticaBold_20 [UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
#define fontHelveticaBold_14 [UIFont fontWithName:@"HelveticaNeue-Bold" size:14]
#define fontHelvetica_20 [UIFont fontWithName:@"HelveticaNeue" size:20]
#define fontHelvetica_18 [UIFont fontWithName:@"HelveticaNeue" size:18]
#define fontHelveticaBold_18 [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]
#define fontHelvetica_14 [UIFont fontWithName:@"HelveticaNeue" size:14]
#define fontHelveticaBold_15 [UIFont fontWithName:@"HelveticaNeue-Bold" size:15]
#define fontHelvetica_15 [UIFont fontWithName:@"HelveticaNeue" size:15]
#define fontHelveticaBold_21 [UIFont fontWithName:@"HelveticaNeue-Bold" size:21]
#define fontHelvetica_21 [UIFont fontWithName:@"HelveticaNeue" size:21]


#define fontLTSTDLight_30 [UIFont fontWithName:@"HELVETICANEUELTSTD-LTCN" size:30]
#define fontLTSTDLight_18 [UIFont fontWithName:@"HELVETICANEUELTSTD-LTCN" size:18]
#define fontLTSTDHVCN_15 [UIFont fontWithName:@"HELVETICANEUELTSTD-HVCN" size:15]
#define fontLTSTDHVCN_21 [UIFont fontWithName:@"HELVETICANEUELTSTD-HVCN" size:21]
#define fontLTSTDHVCN_25 [UIFont fontWithName:@"HELVETICANEUELTSTD-HVCN" size:25]


#define fontMain(v) [UIFont fontWithName:@"MyriadPro-BoldCond" size:v]
#define fontSub(v) [UIFont fontWithName:@"MyriadPro-Cond" size:v]
#define fontNormal(v) [UIFont fontWithName:@"MyriadPro-Regular" size:v]
#define fontMainOne(v) [UIFont fontWithName:@"MyriadPro-Semibold" size:v]

#define font_ProBoldCondensed(v) [UIFont fontWithName:@"MyriadPro-BoldCond" size:v]
#define font_ProCond(v) [UIFont fontWithName:@"MyriadPro-Cond" size:v]

#define ColorNormal [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0 ];
#define ColorNThik [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0 ];
//#define fontThin(v) [UIFont fontWithName:@"HELVETICANEUELTSTD-THCN" size:v]
//#define fontThin1(v) [UIFont fontWithName:@"HELVETICANEUELTSTD-ULTLTCN" size:v]

#define blueColor  [UIColor colorWithRed:99/255.0 green:161/255.0 blue:255.0/255.0 alpha:1.0f]
#define defaultYellow  [UIColor colorWithRed:250/255.0 green:200/255.0 blue:0/255.0 alpha:1.0f]
#endif
