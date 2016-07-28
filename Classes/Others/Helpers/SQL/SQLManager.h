//
//  SQLManager.h
//  C+R
//
//  Created by Akash Malhotra on 24/03/14.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Structures.h"
#import "Defines.h"
#import "Structures.h"

@interface SQLManager : NSObject
{
    NSString *dbPath;
    FMDatabase *database;
    BOOL isSyncDelete;
}
-(void)DeleteFromSchuleCall : (doctorStuct*)objDr;
-(void)insertIntoSchuleCall : (doctorStuct*)objDr;
-(BOOL)isDownloadedeDetailor : (int)eDetId;
-(void)deleteAllTables;
-(NSMutableArray *)getDoctor : (NSString *)scheduleDate;
-(NSString *)getEmpName : (int)empId;
-(BOOL)isDBInUse;
-(void)closeDB;
-(void)createTable:(tblName)tableName;
-(BOOL)insertRecord:(tblName)name : (NSMutableArray *)objectArr;
-(BOOL)deleteRecord:(NSString *)name;
+(id)sharedInstance;
-(NSMutableArray *)geteDetailors : (int)type;
-(void)insertScheduleCall : (ScheduleCallDescription *)objSC;
-(void)insertCallCompleted : (callCompleted *)objSC;
-(NSMutableArray *)getScheduleCallData;
-(NSMutableArray *)getCustomerList;
-(NSMutableArray *)geteDetailerDataForPrew :(BOOL)allSlideFlag;
-(NSMutableArray *)getSTPDayList;
-(NSMutableArray *)getCalenderData:(int)month year:(int)yr;
-(NSMutableArray *)getSTPListForDeviation;
-(BOOL)updateDeviation : (NSString *)date STPDId : (int)Id;
-(NSMutableArray *)getBrandClusterMatrix;
-(NSMutableArray *)getDoctorForBrandMatrix;
-(NSMutableArray *)getSpecialisation;//
-(BOOL)updateeDetailorDownloadStatus : (int)eDetailorId;
-(BOOL)updatedBrandClusterMatrix : (drBrandCluster *)objDBC;
-(NSMutableArray *)getSetting;
-(NSMutableArray *)getHolidays;
-(BOOL)VerifyLoginWithUsername:(NSString *)userName password:(NSString *)pass;
-(void)syncTable:(wsMethodNames)tableName dataArray:(NSMutableArray *)arraydt;
-(void)startSync :(NSMutableArray *)array  isDelete:(BOOL)del;
-(int)checkForCallCompletedEntry;
-(NSMutableArray *)getScheduleDataForUpload;
-(NSMutableArray *)getScheduleCallDataForUpload;
-(NSMutableArray *)getScheduleContentDataForUpload;
-(NSMutableArray *)getCallReportDataForUpload;
-(NSMutableArray *)getCallReportBrandDetailDataForUpload;
-(NSMutableArray *)getCallReportVisitDetailDataForUpload;
-(NSMutableArray *)getCallRecordHistoryDataForUpload;
-(NSMutableArray *)getCallDetailHistoryDataForUpload;
-(NSMutableArray *)getCallReportBrandSlideDetail;
-(NSMutableArray *)getMonthlyTourPlanDataForUpload ;
-(NSMutableArray *)getDoctorBrandClusterMatrixDataForUpload;
-(NSMutableArray *)geteDetailorsWithAllSlides;
-(NSMutableArray *)getLeaveForEmployee:(int)employeeId;
-(BOOL)checkForDeviationForCurrentDate;
-(void)insertIntoScheduleContent :(drBrandCluster *)objBC;
-(void)insertSlideDetail : (eDetailorSlide *)slide;

-(void)insertScheduleContentForScheduleId:(eDetailor *)objScheduleContent TempTable:(int)TempTable;

-(NSMutableArray *)getDoctorForSchedule :(int)scheduleId tempTable:(int )tempTbl;
-(NSMutableArray *)geteSlideeDetailorForSchedule :(int)scheduleId eDetailorId:(int )eDetId;
-(NSMutableArray *)geteDetailorForSchedule :(int)scheduleId tempTable:(int )tempTbl;
-(int)checkIfDoctorIsAleadyScheduledForDate:(NSString *)date doctorId:(int)drId;
-(void)deleteScheduleDoctorIfAlreadySchedules : (doctorStuct *)objDr;

-(void)updateStartTimeInScheduleContentForScheduleId:(int)scheduleId eDetailorId:(int)eDetId time:(NSString *)strTime table:(int)type;
@end
