//
//  SyncDB.m
//  InclinIQ
//
//  Created by Sajida on 02/11/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//



#import "AppDelegate.h"
#import "SQLManager.h"
#import "SyncDB.h"

@implementation SyncDB

@synthesize isDelete;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)Start
{
    arrTableNames = [[NSMutableArray alloc]init];
    arrDBData = [[NSMutableArray alloc]init];
    currentIndex = 0;
    statusMessage = [[NSString alloc]init];
    [self Login];
}

-(void)Login
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * username =   [defaults objectForKey:@"Username"];
    NSString * pass     =   [defaults objectForKey:@"Password"];
   
//    loginRequestStruct *obj = [[loginRequestStruct alloc]init];
//    obj.userName = @"prithvip";// username;
//    obj.password = @"aa"; //pass;
    
    NSString * url =[NSString stringWithFormat:@"%@login/GetLogin?userId=%@&pwd=%@&DeviceNo=appId#username",BASE_URL,username,pass];
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:login withObject:nil withRefrence:self URL:url];
    
}

-(void)GetSyncList
{
   // http://acipl-betasite.com/incliniq/api/Synchronization/GetLatestSyncList/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    NSString * url = nil;
    
    //objDel.empId = @"6";
    if(self.isDelete)
    {
        
         url =[NSString stringWithFormat:@"%@Synchronization/GetLatestDeleteList/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
    
        url =[NSString stringWithFormat:@"%@Synchronization/GetLatestSyncList/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    }
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:getSync withObject:nil withRefrence:self URL:url];
}

-(void)updateAllTables
{
    if(currentIndex < arrTableNames.count)
    {
        NSString * tableName = [arrTableNames objectAtIndex:currentIndex];
        
        
        if([tableName isEqualToString:@"FinancialYear"])
        {
            [self syncFinancialTable];
        }
        else
            
        if([tableName isEqualToString:@"Period"])
        {
         [self syncPeriod];
        }
        else
        if([tableName isEqualToString:@"BrandCluster"])
         {
          [self syncBrandCluster];
          }
          else
          if([tableName isEqualToString:@"Qualification"])
           {
             [self syncQualification];
          }
          else
           if([tableName isEqualToString:@"Specialisation"])
           {
           [self syncSpecialisation];
          }
           else
           if([tableName isEqualToString:@"LocationType"])
           {
            [self syncLocationType];
            }
            else
             if([tableName isEqualToString:@"DivisionLocationType"])
             {
            [self syncDivisionLocationType];
            }
            else
            if([tableName isEqualToString:@"Designation"])
            {
              [self syncDesignation];
           }
             else
            if([tableName isEqualToString:@"DivisionDesignation"])
              {
               [self syncDivisionDesignation];
             }
             else
              if([tableName isEqualToString:@"LocationEmployee"])
             {
              [self syncLocationEmployee];
             }
             else
             if([tableName isEqualToString:@"Location"])
             {
               [self syncLocation];
             }
             else
              if([tableName isEqualToString:@"Employee"])
              {
               [self syncEmployee];
              }
              else
               if([tableName isEqualToString:@"Doctor"])
              {
               [self syncDoctor];
               }
              else
             if([tableName isEqualToString:@"DoctorBrandClusterMatrix"])
               {
               [self syncDoctorBrandClusterMatrix];
              }
              else
               if([tableName isEqualToString:@"LeaveType"])
                 {
                 [self syncLeaveType];
              }
               else
              if([tableName isEqualToString:@"LeaveApplication"])
                 {
                [self syncLeaveApplication];
                }
              else
             if([tableName isEqualToString:@"HolidayZone"])
               {
                [self syncHolidayZone];
                }
             else
                 if([tableName isEqualToString:@"HolidayZoneMap"])
                 {
                     [self syncHolidayZoneMap];
                 }
                 else
                     if([tableName isEqualToString:@"Holiday"])
                     {
                         [self syncHoliday];
                     }
                     else
                         if([tableName isEqualToString:@"HolidayDate"])
                         {
                             [self syncHolidayDate];
                         }
                         else
                             if([tableName isEqualToString:@"Edetailer"])
                             {
                                 [self syncEdetailer];
                             }
                             else
                                 if([tableName isEqualToString:@"EdetailerSpecialisationDetail"])
                                 {
                                     [self syncEdetailerSpecialisationDetail];
                                 }
                                 else
                                     if([tableName isEqualToString:@"EdetailerSlideWiseSpecDetail"])
                                     {
                                         [self syncEdetailerSlideWiseSpecDetail];
                                     }
                                     else
                                         if([tableName isEqualToString:@"StandardTourPlanDay"])
                                         {
                                             [self syncStandardTourPlanDay];
                                         }
                                         else
                                             if([tableName isEqualToString:@"StandardTourPlan"])
                                             {
                                                 [self syncStandardTourPlantbl];
                                             }
                                             else
                                                 if([tableName isEqualToString:@"MonthlyTourProgram"])
                                                 {
                                                     [self syncMonthlyTourProgram];
                                                 }
        
            }
    else
    {
        SQLManager * objSQL = [SQLManager sharedInstance];
        [objSQL startSync:arrDBData isDelete:isDelete];
        
        if(isDelete == NO)
        {
            [arrDBData removeAllObjects];
            isDelete = YES;
            [self GetSyncList];
        }
        else
        {
            [self uploadDataOnServer];
        }
        NSLog(@"Done");

    }
}

-(void)syncFinancialTable
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@FinancialYear/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@FinancialYear/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:FinancialYear withObject:nil withRefrence:self URL:url];
    
}
-(void)syncPeriod
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@FinancialYear/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Period/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

    }

    
  //  NSString * url =[NSString stringWithFormat:@"%@Period/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Period withObject:nil withRefrence:self URL:url];
}
-(void)syncBrandCluster
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@BrandCluster/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@BrandCluster/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
    
    //NSString * url =[NSString stringWithFormat:@"%@BrandCluster/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:BrandCluster withObject:nil withRefrence:self URL:url];
}
-(void)syncQualification
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@Qualification/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Qualification/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

        
    }
   // NSString * url =[NSString stringWithFormat:@"%@Qualification/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Qualification withObject:nil withRefrence:self URL:url];
}
-(void)syncSpecialisation
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@Specialisation/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Specialisation/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
        
    }
    
  //  NSString * url =[NSString stringWithFormat:@"%@Specialisation/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Specialisation withObject:nil withRefrence:self URL:url];
}

-(void)syncLocationType
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@LocationType/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@LocationType/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
    //NSString * url =[NSString stringWithFormat:@"%@LocationType/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:LocationType withObject:nil withRefrence:self URL:url];
}

-(void)syncDivisionLocationType
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@DivisionLocationType/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@DivisionLocationType/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

        
    }
   // NSString * url =[NSString stringWithFormat:@"%@DivisionLocationType/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:DivisionLocationType withObject:nil withRefrence:self URL:url];
    
}


-(void)syncDesignation
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@Designation/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Designation/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
   // NSString * url =[NSString stringWithFormat:@"%@Designation/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Designation withObject:nil withRefrence:self URL:url];
    
}


-(void)syncDivisionDesignation
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@DivisionDesignation/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@DivisionDesignation/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

        
    }
   // NSString * url =[NSString stringWithFormat:@"%@DivisionDesignation/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:DivisionDesignation withObject:nil withRefrence:self URL:url];
    
}

-(void)syncLocationEmployee
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@LocationEmployee/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@LocationEmployee/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
  //  NSString * url =[NSString stringWithFormat:@"%@LocationEmployee/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:LocationEmployee withObject:nil withRefrence:self URL:url];
}

-(void)syncLocation
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@Location/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Location/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

        
    }
   // NSString * url =[NSString stringWithFormat:@"%@Location/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Location withObject:nil withRefrence:self URL:url];
}
-(void)syncEmployee
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@Employee/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Employee/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

        
    }
  //  NSString * url =[NSString stringWithFormat:@"%@Employee/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Employee withObject:nil withRefrence:self URL:url];
    
}
-(void)syncDoctor
{
//    1.	http://acipl-betasite.com/incliniq/api/LocationType/GetLatestData/597a2b2f-2c33-4f06-af75-b894ba5a7963?employeeid=6
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@Doctor/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Doctor/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
        
    }
    
    //NSString * url =[NSString stringWithFormat:@"%@Doctor/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Doctor withObject:nil withRefrence:self URL:url];
}

-(void)syncDoctorBrandClusterMatrix
{
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@DoctorBrandClusterMatrix/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@DoctorBrandClusterMatrix/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
  //  NSString * url =[NSString stringWithFormat:@"%@DoctorBrandClusterMatrix/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:DoctorBrandClusterMatrix withObject:nil withRefrence:self URL:url];
}

-(void)syncLeaveType
{
  
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@LeaveType/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@LeaveType/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
   // NSString * url =[NSString stringWithFormat:@"%@LeaveType/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:LeaveType withObject:nil withRefrence:self URL:url];
}
-(void)syncLeaveApplication
{
   
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@LeaveApplication/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@LeaveApplication/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
   // NSString * url =[NSString stringWithFormat:@"%@LeaveApplication/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:LeaveApplication withObject:nil withRefrence:self URL:url];
}
-(void)syncHolidayZone
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@HolidayZone/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@HolidayZone/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
    
   // NSString * url =[NSString stringWithFormat:@"%@HolidayZone/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:HolidayZone withObject:nil withRefrence:self URL:url];
}
-(void)syncHolidayZoneMap
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@HolidayZoneMap/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@HolidayZoneMap/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
    //NSString * url =[NSString stringWithFormat:@"%@HolidayZoneMap/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:HolidayZoneMap withObject:nil withRefrence:self URL:url];
}

-(void)syncHoliday
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@Holiday/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Holiday/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
   // NSString * url =[NSString stringWithFormat:@"%@Holiday/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Holiday withObject:nil withRefrence:self URL:url];
}
-(void)syncHolidayDate
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@HolidayDate/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@HolidayDate/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
    
  // NSString * url =[NSString stringWithFormat:@"%@HolidayDate/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:HolidayDate withObject:nil withRefrence:self URL:url];
}
-(void)syncEdetailer
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@Edetailer/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@Edetailer/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
  //  NSString * url =[NSString stringWithFormat:@"%@Edetailer/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Edetailer withObject:nil withRefrence:self URL:url];
}
-(void)syncEdetailerSpecialisationDetail
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@EdetailerSpecialisationDetail/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@EdetailerSpecialisationDetail/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
    
 //   NSString * url =[NSString stringWithFormat:@"%@EdetailerSpecialisationDetail/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:EdetailerSpecialisationDetail withObject:nil withRefrence:self URL:url];
}
-(void)syncEdetailerSlideWiseSpecDetail
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@EdetailerSlideWiseSpecDetail/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@EdetailerSlideWiseSpecDetail/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
        
    }
    
   // NSString * url =[NSString stringWithFormat:@"%@EdetailerSlideWiseSpecDetail/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:EdetailerSlideWiseSpecDetail withObject:nil withRefrence:self URL:url];
}
-(void)syncStandardTourPlanDay
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@StandardTourPlanDay/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@StandardTourPlanDay/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

        
    }
    
   // NSString * url =[NSString stringWithFormat:@"%@StandardTourPlanDay/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:StandardTourPlanDay withObject:nil withRefrence:self URL:url];
}
-(void)syncStandardTourPlantbl
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@StandardTourPlan/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@StandardTourPlan/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

        
    }
    
   // NSString * url =[NSString stringWithFormat:@"%@StandardTourPlan/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:StandardTourPlantbl withObject:nil withRefrence:self URL:url];
}
-(void)syncMonthlyTourProgram
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = nil;
    
    if(self.isDelete)
    {
        url =[NSString stringWithFormat:@"%@MonthlyTourProgram/GetDeleteData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    }
    else
    {
        url =[NSString stringWithFormat:@"%@MonthlyTourProgram/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];

        
    }
    
   // NSString * url =[NSString stringWithFormat:@"%@MonthlyTourProgram/GetLatestData/%@?employeeid=%d",BASE_URL,objDel.token,[objDel.empId intValue]];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:MonthlyTourProgram withObject:nil withRefrence:self URL:url];
}

#pragma mark Login Response Handling
-(void)didRecivewithError:(NSError *)error
{
    //[self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
    //statusMessage =@"Error occurred while getting response from server";
    //[self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    
    [self.delegate syncError];
}
-(void)didRecivewithNullData
{
    [self.delegate syncError];
    
    //[self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
//    statusMessage =@"Error occurred while getting response from server";
//    [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    
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


-(void)didReciveResponse:(id)responsedata withMethodName:(wsMethodNames)name error:(int)errorCode
{
    NSLog(@"didReciveResponceObj form view controller");
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSNumber * err = nil ;
   
    switch (name)
    {
        case login:
            
             err = [responsedata objectForKey:@"IsValid"];
            if ([err intValue] ==0)
            {
                //  statusMessage = [NSString stringWithFormat:@"Invalid username/password"];
                [self performSelectorOnMainThread:@selector(callFailureBlock) withObject:nil waitUntilDone:YES];
            }
            else
            {
                AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
                objDel.token = [responsedata objectForKey:@"token"];
                [self GetSyncList];
                
            }
            break;
            
        case getSync:
            
            arrTableNames = responsedata;
            [self updateAllTables];
            break;
            
        case
            BrandCluster:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
       case     FinancialYear:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
          case  Period:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
            case Qualification:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case Specialisation:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case LocationType:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case DivisionLocationType:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case Designation:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case DivisionDesignation:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case LocationEmployee:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case Location:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
          case  Employee:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
          case  Doctor:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
          case  DoctorBrandClusterMatrix:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
          case  LeaveType:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case LeaveApplication:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case HolidayZone:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case HolidayZoneMap:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case Holiday:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
        case HolidayDate:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
          case  Edetailer:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
          case EdetailerSpecialisationDetail:
            
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case EdetailerSlideWiseSpecDetail:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case StandardTourPlanDay:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case StandardTourPlantbl:
        {
            SyncData * objData = [[SyncData alloc]init];
            objData.methodName = name;
            objData.arrData =responsedata;
            
            [arrDBData addObject:objData];
            
            currentIndex++;
            [self updateAllTables];
        }
            
            break;
           case MonthlyTourProgram :
            {
                SyncData * objData = [[SyncData alloc]init];
                objData.methodName = name;
                objData.arrData =responsedata;
                
                [arrDBData addObject:objData];

                currentIndex++;
                [self updateAllTables];
            }
            break;
            
       case CallReport:
            [self UploadCallReportVisitDetail];
             break;
       case CalReportVisitDetail:
            [self UploadCallReportBrandDetail];
             break;
       case CalReportBrandDetail:
            [self UploadCallReportBrandSlideDetail];
            break;
       case CalReportBrandSlideDetail:
            [self UploadCallDetailHistory];
             break;
       case CalDetailHistory:
            [self UploadCallRecordHistory];
             break;
            
        case CalRecordHistory:
            [self UploadaSchedule];
            break;
            
        case Schedule:
            [self UploadScheduleCall];
            break;
       case ScheduleCal:
            [self UploadScheduleContent];
            break;
       case SchedulContent:
            [self UpdateMonthlyTourPlan];
            break;
            
        case MonthlyTourProgramUpload:
            [self UpdateDoctorBrandClusterMatrix];
            break;
        
        case DoctorBrandClusterMatrixUpload:
       
            [objSQL deleteAllTables];
            [self sendSyncStatusToServer:YES];
            
            break;
        case SyncStatus:
            
            
            if (self.delegate != NULL)
            {
                AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
                objDel.arrScheduleData = [objSQL getScheduleCallData];
                [self.delegate syncCompletion];
            }
            break;
            
        default:
            break;
    }
  
}

-(void)sendSyncStatusToServer : (BOOL)status
{
    NSString * statusVal = nil;
    if(status)
        statusVal = @"S";
    else
         statusVal = @"E";
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@Synchronization/UpdateSyncStatus/%@?employeeid=%@&status=%@",BASE_URL,objDel.token,objDel.empId,statusVal];
    
    NSMutableArray * arrData = [[NSMutableArray alloc]init];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:SyncStatus withObject:arrData withRefrence:self URL:url];

}

-(void)callFailureBlock
{
    NSLog(@"%@",@"************************FAILED********************************");
}

#pragma mark - Upload Tab data

-(void)uploadDataOnServer
{
    [self UploadCallReport];
}

-(void)UploadCallReport
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@CallReport/Sync/%@",BASE_URL,objDel.token];
  
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getCallReportDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:CallReport withObject:arrData withRefrence:self URL:url];
}

-(void)UploadCallReportVisitDetail
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@CallReportVisitDetail/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getCallReportVisitDetailDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:CalReportVisitDetail withObject:arrData withRefrence:self URL:url];
}

-(void)UploadCallReportBrandDetail
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@CallReportBrandDetail/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getCallReportBrandDetailDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:CalReportBrandDetail withObject:arrData withRefrence:self URL:url];
}

-(void)UploadCallReportBrandSlideDetail
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@CallReportBrandSlideDetail/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getCallReportBrandSlideDetail];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:CalReportBrandSlideDetail withObject:arrData withRefrence:self URL:url];
}

-(void)UploadCallDetailHistory
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@CallDetailHistory/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getCallDetailHistoryDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:CalDetailHistory withObject:arrData withRefrence:self URL:url];
}

-(void)UploadCallRecordHistory
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@CallRecordHistory/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getCallRecordHistoryDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:CalRecordHistory withObject:arrData withRefrence:self URL:url];
}

-(void)UploadaSchedule
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@Schedule/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getScheduleDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:Schedule withObject:arrData withRefrence:self URL:url];
}
-(void)UploadScheduleCall
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@ScheduleCall/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getScheduleCallDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:ScheduleCal withObject:arrData withRefrence:self URL:url];
}
-(void)UploadScheduleContent
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@ScheduleContent/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getScheduleContentDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:SchedulContent withObject:arrData withRefrence:self URL:url];
}
-(void)UpdateMonthlyTourPlan
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@MonthlyTourProgram/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getMonthlyTourPlanDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:MonthlyTourProgramUpload withObject:arrData withRefrence:self URL:url];
}

-(void)UpdateDoctorBrandClusterMatrix
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"%@DoctorBrandClusterMatrix/Sync/%@",BASE_URL,objDel.token];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    NSMutableArray * arrData = [objSQL getDoctorBrandClusterMatrixDataForUpload];
    
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:DoctorBrandClusterMatrixUpload withObject:arrData withRefrence:self URL:url];
}
@end
