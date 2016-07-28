//
//  Structures.h
//  InclinIQ
//
//  Created by Gagan on 08/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"
//Request

//******************Sravan
@interface WebViewStruct : NSObject
@property (atomic) NSInteger tagValue;
@property (atomic) BOOL isSelected;
@end

@interface CustomerStruct : NSObject
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *Qualification;
@property (nonatomic,strong) NSString *DOB;
@property (nonatomic,strong) NSString *MobileNo;
@property (nonatomic,strong) NSString *Specialization;
@property (nonatomic,strong) NSString *bestDay;
@property (nonatomic,strong) NSString *bestTime;
@property (atomic) int Id;
@end

@interface BrandClust : NSObject
@property (nonatomic,strong) NSString *drName;
@property (nonatomic,strong) NSString * specialisation;
@property (nonatomic,strong) NSString *brandNames;
@property (atomic) int Id;
@end


@interface drBrandCluster : NSObject
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *specialisation;
@property (atomic) int doctorId;
@property (nonatomic,strong) NSMutableArray * arrBrands;
-(void)initObj;
@end


@interface loginRequestStruct  : NSObject
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *password;
@end

@interface doctorStuct : NSObject
@property (nonatomic,strong) NSString *fname;
@property (nonatomic,strong) NSString *lname;
@property (atomic) int specializationId;
@property (atomic) int doctorId;
@property (atomic) int scheduleId;
@property (atomic) BOOL isSelected;
@property (atomic) BOOL isSchInsert;
@property (nonatomic,strong) NSString *specializationName;
@end

@interface specialisationStruct : NSObject
@property (nonatomic,strong) NSString *abbrevation;
@property (nonatomic,strong) NSString *name;
@property (atomic) int Id;
@end

@interface timerStruct : NSObject
@property (atomic) NSInteger starttime;
@property (atomic) NSInteger pausetime;
@property (atomic) NSInteger endtime;
@property (atomic) NSInteger slideID;
@end

@interface eDetailor : NSObject
@property (nonatomic,strong) NSString *brandName;
@property (atomic) int brandId;
@property (atomic) int noOfSlides;
@property (nonatomic,strong) NSString *versionNo;
@property (nonatomic,strong) NSString *imgPath;
@property (atomic) int Id;
@property (atomic) int scheduleId;
@property (atomic) int scheduleContentId;
@property (nonatomic,strong) NSString *publishDate;
@property (nonatomic,strong) NSString *startDate;
@property (nonatomic,strong) NSMutableArray * arrSlides;
@property (atomic) int isDownloaded;
@property (atomic) BOOL isSelected;
@property (atomic) BOOL isDetailed;
@property (nonatomic,strong) NSString * starttime;
-(void)initObject;
@end

@interface eDetailorSlide : NSObject
@property (nonatomic,strong) NSString *URLPath;
@property (nonatomic,strong) NSString *thumbPath;
@property (atomic) int slideNo;
@property (atomic) int Id;
@property (atomic) int ScheduleContentId;
@property (nonatomic,strong) NSString *TargetSpecialization;
@property (atomic) int eDetailorId;
@property (nonatomic,strong) NSString * StartTime;
@property (nonatomic,strong) NSString * EndTime;
@property (atomic) float timeSpent;
@end


@interface schedule : NSObject
@property (nonatomic,strong) NSString *datetime;
@property (nonatomic,strong) NSString *ActionDate;
@property (nonatomic,strong) NSString *CallType;
@property (nonatomic,strong) NSString *CallObjective;
@property (nonatomic,strong) NSString *ActionBy;
@end

@interface ScheduleCall : NSObject
@property (atomic) int ScheduleId;
@property (atomic) int DoctorId;
@property (nonatomic,strong) NSString *DoctorName;
@property (nonatomic,strong) NSString *ActionDate;
@property (nonatomic,strong) NSString *ActionBy;
@end

@interface ScheduleContent : NSObject
@property (atomic) int EdetailerId;
@property (atomic) int ScheduleId;
@property (nonatomic,strong) NSString *ActionDate;
@property (nonatomic,strong) NSString *ActionBy;
@end

@interface structIndexPaths  : NSObject
@property (atomic, assign) BOOL isSelected;
@property (atomic, assign) NSInteger indexPath;
@end

@interface ScheduleCallDescription : NSObject
@property (nonatomic,strong) NSMutableArray * arreDetailors;
@property (nonatomic,strong) NSMutableArray * arrDoctors;
@property (nonatomic,strong) NSMutableArray * arrPreviousHistory;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *callNotes;
@property (nonatomic,strong) NSString *callObjective;
@property (atomic) int callType; // 1 - Individual , 2 Group
@property (atomic) int ScheduleId;
@property (atomic) int isCallCompleted;
@property (atomic) int StandardTourPlanDayId;
-(void)initObject;
@end

@interface PreviousHistory : NSObject
@property (nonatomic,strong) NSMutableArray * arreDetailors;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *callNotes;
@property (atomic) int Id;
@end

#pragma mark - Call completed
@interface callCompleted : NSObject
@property (nonatomic,strong) NSMutableArray * arrCallReportVisitDetail;
@property (nonatomic,strong) NSMutableArray * arrCallReportBrandDetail;
@property (nonatomic,strong) NSMutableArray * arrCallReportBrandSlideDetail;
@property (nonatomic,strong) NSMutableArray * arrCallRecordHistory;
@property (nonatomic,strong) NSString *CallReportDate;
@property (atomic) int ScheduleCallDescriptionId;
@property (atomic) int Id;
@property (atomic) int isFromMTP;
@property (atomic) int DoctId;
@property (atomic) int StandardTourPlanDayId;
@property (atomic) BOOL needToInsert;
-(void)initObject;
@end

@interface CallReportVisitDetail : NSObject
@property (atomic) int CallReportId;
@property (atomic) int DoctorId;
@property (atomic) int Id;
@property (nonatomic,strong) NSString *VisitName;
@property (nonatomic,strong) NSString *Time;
@property (nonatomic,strong) NSString *Remarks;
@end

@interface CallReportBrandDetail : NSObject
@property (atomic) int CallReportVisitDetailId;
@property (atomic) int BrandClusterId;
@property (atomic) float timeSpent;
@property (nonatomic,strong) NSString * StartTime;
@property (atomic) int Id;
@end

@interface CallReportBrandSlideDetail : NSObject
@property (atomic) int CallReportBrandDetailId;
@property (atomic) int SlideNo;
@property (nonatomic,strong) NSString * StartTime;
@property (nonatomic,strong) NSString * EndTime;
@property (atomic) int Id;
@end

@interface CallDetailHistory : NSObject
@property (atomic) int EmployeeVersion;
@property (atomic) int EmployeeId;
@property (nonatomic,strong) NSString * Date;
@property (atomic) int DoctorId;
@property (nonatomic,strong) NSString * CallDetails;
@property (nonatomic,strong) NSString * BrandNames;
@property (atomic) int Id;
@end

#pragma mark - Calender
@interface CalenderStruct : NSObject
@property (atomic) int executedCount;
@property (nonatomic,strong) NSString * date;
@property (nonatomic,strong) NSString * FWPName;
@property (nonatomic,strong) NSMutableArray * arrDrs;
@end

@interface STPD : NSObject
@property (nonatomic,strong) NSString *FWPName;
@property (nonatomic,strong) NSMutableArray * arrDoctors;
@property (atomic) int Id;
-(void)initObject;
@end

@interface STPDoctor : NSObject
@property (nonatomic,strong) NSString *drName;
@property (nonatomic,strong) NSString *spcialization;
@property (atomic) BOOL isSelected;
@property (atomic) int Id;
@end

@interface Leave : NSObject
@property (nonatomic,strong) NSString *startDate;
@property (nonatomic,strong) NSString *endDate;
@property (atomic) int empId;
@end

@interface SyncData : NSObject
@property (nonatomic,strong) NSMutableArray * arrData;
@property (atomic) int methodName;
@end

typedef enum tables
{
    Schedule_tbl,
    ScheduleCall_tbl,
    ScheduleContent_tbl,
    CallReport_tbl,
    CallReportVisitDetail_tbl,
    CallReportBrandDetail_tbl,
    CallReportBrandSlideDetail_tbl,
    CallDetailHistory_tbl,
    DownloadedeDetailors_tbl,
    DoctorBrandClusterMatrix_tbl,
    TempSchedule_tbl,
    TempScheduleCall_tbl,
    TempScheduleContent_tbl
}tblName;



typedef enum callTypeNames
{
   INDIVIDUAL_CALL  = 1,
   GROUP_CALL       = 2
    
}callType;
