 //
//  FMDBManager.m
//  C+R
//
//  Created by Akash Malhotra on 24/03/14.
//

#import "SQLManager.h"
#import "AppDelegate.h"
#import "Utils.h"


@implementation SQLManager
#pragma mark - Initialization
-(id)init
{
    if(self != nil)
    {
        NSString *yourOriginalDatabasePath = [[NSBundle mainBundle] pathForResource:@"inclinIQ" ofType:@"db"];
        
        NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
        
        NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"inclinIQ.db"];
        
        if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath]) {
            
            NSError * error = nil;
            if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:&error] != YES)
            {
                NSLog(@"%@",error.description);
                return  nil;
            }
        }
        
        database = [FMDatabase databaseWithPath:yourNewDatabasePath];
        
        
    }
    return self;
}
+ (id)sharedInstance
{
    static SQLManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SQLManager alloc] init];
    });
    return _sharedInstance;
}

-(BOOL)isDBInUse
{
    return database.inTransaction;
}

-(void)closeDB
{
    [database close];
}
#pragma mark - Table operations
-(void)createTable:(tblName)tableName
{
    
    NSString *statement;
    
    [database open];
    
    switch (tableName)
    {
        case DownloadedeDetailors_tbl:
            statement = @" CREATE TABLE IF NOT EXISTS [Schedule]([Id] [int] ,[RowId] INTEGER PRIMARY KEY AUTOINCREMENT,         [Date] [datetime] NOT NULL, [CallType] [varchar](20) NOT NULL,[CallObjective] [varchar](200) NULL, [ActionDate] [datetime] NOT NULL,[ActionBy] [varchar](15) NOT NULL,[IsActive] [bit] NOT NULL)";
            break;
        case ScheduleCall_tbl:
            statement = @"CREATE TABLE IF NOT EXISTS [ScheduleCall]([Id] [int] ,[RowId] INTEGER PRIMARY KEY AUTOINCREMENT, [ScheduleId] [int] NOT NULL,[DoctorId] [int] NULL,[DoctorName] [varchar](200) NULL,            [ActionDate] [datetime] NOT NULL, [ActionBy] [varchar](15) NOT NULL,[IsActive] [bit] NOT NULL)";
            break;
            
        case ScheduleContent_tbl:
            statement = @"CREATE TABLE IF NOT EXISTS [ScheduleContent]( [Id] [int] , [RowId] INTEGER PRIMARY KEY AUTOINCREMENT, [ScheduleId] [int] NOT NULL,[EdetailerId] [int] NOT NULL,[ActionDate] [datetime] NOT NULL, [ActionBy] [varchar](15) NOT NULL,[IsActive] [bit] NOT NULL)";
            break;
            
        default:
            NSLog(@"Table not found");
    }
    
    [database executeUpdate:statement];
    [database close];
}

-(void)insertIntoSchuleCall : (doctorStuct*)objDr;
{
    [database open];
    NSMutableArray * arrDoc = [[NSMutableArray alloc]initWithObjects:objDr,nil];
    if(objDr.isSchInsert)
        [self insertRecord:TempScheduleCall_tbl :arrDoc];
    else
         [self insertRecord:ScheduleCall_tbl :arrDoc];
    [database close];
    
}
-(void)DeleteFromSchuleCall : (doctorStuct*)objDr;
{
    [database open];
    NSString * statement;
    
    if(objDr.isSchInsert)
        statement = [NSString stringWithFormat:@"DELETE from TempScheduleCall where DoctorId = %d",objDr.doctorId];

    else
        statement = [NSString stringWithFormat:@"DELETE from ScheduleCall where DoctorId = %d",objDr.doctorId];

    
    if( [database executeUpdate: statement])
    {
       
        NSLog(@"TABLE DELETED:");
    }
    else
        NSLog(@"delete Failed");
    
    [database close];
    
}


-(void)deleteScheduleDoctorIfAlreadySchedules : (doctorStuct *)objDr
{

    BOOL alreadySheduled = NO;
    [database open];
    NSString * sate ;
    
    sate = [NSString stringWithFormat:@"SELECT ScheduleId FROM ScheduleCall where DoctorId = %d ",objDr.doctorId];
    
    FMResultSet *results = [database executeQuery:sate];
    
    while([results next])
    {
        alreadySheduled = YES;
        
        int ScheduleId =  [results intForColumn:@"ScheduleId"];
        
        NSString *statement = [NSString stringWithFormat:@"DELETE from ScheduleCall where DoctorId = %d",objDr.doctorId];
        
        if( [database executeUpdate: statement])
        {
            NSLog(@"TABLE DELETED:");
        }
        else
            NSLog(@"delete Failed");
        
        NSString * sate1 = [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM ScheduleCall where ScheduleId = %d ",ScheduleId];


        FMResultSet *results = [database executeQuery:sate1];
        
        while([results next])
        {
          int count =  [results intForColumn:@"count"];
          
          if(count == 0)
          {
              NSString *statement = [NSString stringWithFormat:@"DELETE from Schedule where Id = %d",ScheduleId];
              
              if( [database executeUpdate: statement])
              {
                  NSLog(@"TABLE DELETED:");
              }
              else
                  NSLog(@"delete Failed");
              
              NSString *statement1 = [NSString stringWithFormat:@"DELETE from ScheduleContent where ScheduleId = %d",ScheduleId];
              
              if( [database executeUpdate: statement1])
              {
                  NSLog(@"TABLE DELETED:");
              }
              else
                  NSLog(@"delete Failed");
              
              
          }
           
              
        }
    }
    
    
    
    if(alreadySheduled == NO)
    {
        sate = [NSString stringWithFormat:@"SELECT TempScheduleId FROM TempScheduleCall where DoctorId = %d",objDr.doctorId];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            alreadySheduled = YES;
            
            int ScheduleId =  [results intForColumn:@"TempScheduleId"];
            
            NSString *statement = [NSString stringWithFormat:@"DELETE from TempScheduleCall where DoctorId = %d",objDr.doctorId];
            
            if( [database executeUpdate: statement])
            {
                NSLog(@"TABLE DELETED:");
            }
            else
                NSLog(@"delete Failed");
            
            NSString * sate1 = [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM TempScheduleCall where TempScheduleId = %d ",ScheduleId];
            
            
            FMResultSet *results = [database executeQuery:sate1];
            
            while([results next])
            {
                int count =  [results intForColumn:@"count"];
                if(count == 0)
                {
                    NSString *statement = [NSString stringWithFormat:@"DELETE from TempSchedule where Id = %d",ScheduleId];
                    
                    if( [database executeUpdate: statement])
                    {
                        NSLog(@"TABLE DELETED:");
                    }
                    else
                        NSLog(@"delete Failed");
                    
                    NSString *statement1 = [NSString stringWithFormat:@"DELETE from TempScheduleContent where TempScheduleId = %d",ScheduleId];
                    
                    if( [database executeUpdate: statement1])
                    {
                        NSLog(@"TABLE DELETED:");
                    }
                    else
                        NSLog(@"delete Failed");
                    
                    
                }
                
            }

        }
        
    }
    
    [database close];
   

    
}

-(BOOL)insertRecord:(tblName)name : (NSMutableArray *)objectArr {
    
    BOOL success = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    for(int i = 0;i<[objectArr count]; i++)
    {
        switch (name)
        {
            case TempSchedule_tbl:
            {
                ScheduleCallDescription * objSchedule = (ScheduleCallDescription *) [objectArr objectAtIndex:i];
                
                NSString * sate = [NSString stringWithFormat:@"INSERT into TempSchedule(Id,Date,CallType,CallObjective,isCallCompleted) values (%d,'%@','%@','%@',%d);", objSchedule.ScheduleId,objSchedule.date ,[NSString stringWithFormat:@"%d",objSchedule.callType],objSchedule.callObjective,0];
                
                NSLog(@"%@",sate);
                
                if( [database executeUpdate: sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
            case TempScheduleCall_tbl:
            {
                doctorStuct * objScheduleCall = (doctorStuct *) [objectArr objectAtIndex:i];
                
                
                NSString * sate = [ NSString stringWithFormat:@"INSERT into TempScheduleCall(Id,TempScheduleId,DoctorId,DoctorName) values (%d,%d,%d,'%@')", 0,objScheduleCall.scheduleId,objScheduleCall.doctorId,objScheduleCall.fname];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate:sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
            case TempScheduleContent_tbl:
            {
                eDetailor * objScheduleContent = (eDetailor *) [objectArr objectAtIndex:i];
                
                NSString * sate = [ NSString stringWithFormat:@"INSERT into TempScheduleContent(Id,TempScheduleId,EdetailerId,TimeSpent,StartTime) values (%d,%d,%d,%f,'00:00:00')",0, objScheduleContent.scheduleId,objScheduleContent.Id,0.0];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate: sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;

                
            case Schedule_tbl:
            {
                 NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
                
                ScheduleCallDescription * objSchedule = (ScheduleCallDescription *) [objectArr objectAtIndex:i];
                NSString * sate = [NSString stringWithFormat:@"INSERT into Schedule(Id,Date,CallType,CallObjective,ActionDate,ActionBy,IsActive,EmployeeId,EmployeeVersion,isCallCompleted) values (%d,'%@','%@','%@','%@','%@',%d,%d,%d,%d);", objSchedule.ScheduleId,objSchedule.date ,[NSString stringWithFormat:@"%d",objSchedule.callType],objSchedule.callObjective,actionDate,[defaults objectForKey:@"Username"],1,[objDel.empId intValue],[objDel.empVersion intValue],0];
                
                NSLog(@"%@",sate);
                
                if( [database executeUpdate: sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
            case ScheduleCall_tbl:
            {
                doctorStuct * objScheduleCall = (doctorStuct *) [objectArr objectAtIndex:i];
                
                NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
                NSString * sate = [ NSString stringWithFormat:@"INSERT into ScheduleCall(Id,ScheduleId,DoctorId,DoctorName,ActionDate,ActionBy,IsActive) values (%d,%d,%d,'%@','%@','%@',%d)", 0,objScheduleCall.scheduleId,objScheduleCall.doctorId,objScheduleCall.fname,actionDate,[defaults objectForKey:@"Username"],1];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate:sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
            case ScheduleContent_tbl:
            {
                eDetailor * objScheduleContent = (eDetailor *) [objectArr objectAtIndex:i];
                NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];

                NSString * sate = [ NSString stringWithFormat:@"INSERT into ScheduleContent(Id,ScheduleId,EdetailerId,ActionDate,ActionBy,IsActive,StartTime) values (%d,%d,%d,'%@','%@',%d,'00:00:00')",0, objScheduleContent.scheduleId,objScheduleContent.Id,actionDate,[defaults objectForKey:@"Username"],1];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate: sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
                
            case CallReport_tbl:
            {
                callCompleted * objSchedule = (callCompleted *) [objectArr objectAtIndex:i];
                
                 NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
                
                AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
                
                NSString * sate = [ NSString stringWithFormat:@" INSERT into CallReport( Id  , CallReportDate ,EmployeeId , EmployeeVersion ,  ActionDate , ActionBy , IsActive) values (%d,'%@',%d,'%@','%@','%@',%d)",objSchedule.Id, objSchedule.CallReportDate,[objDel.empId intValue],objDel.empVersion,actionDate,[defaults objectForKey:@"Username"],1];
                
                NSLog(@"%@",sate);
                
                if( [database executeUpdate:sate] )
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
                
            case CallReportVisitDetail_tbl:
            {
                CallReportVisitDetail * objDr = (CallReportVisitDetail *) [objectArr objectAtIndex:i];
                NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
                NSString * sate = [ NSString stringWithFormat:@"INSERT into  CallReportVisitDetail( Id  , CallReportId , DoctorId  ,  VisitName  ,  Time  ,  Remarks ,ActionDate , ActionBy , IsActive) values (%d,%d,%d,'%@','%@','%@','%@','%@',%d);", objDr.Id,objDr.CallReportId,objDr.DoctorId,objDr.VisitName,objDr.Time,objDr.Remarks,actionDate,[defaults objectForKey:@"Username"],1];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate:sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
                
            case CallReportBrandDetail_tbl:
            {
                CallReportBrandDetail * objCall = (CallReportBrandDetail *) [objectArr objectAtIndex:i];
                 NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
                NSString * sate = [ NSString stringWithFormat:@"INSERT into  CallReportBrandDetail ( Id  , CallReportVisitDetailId  , BrandClusterId, ActionDate , ActionBy ,IsActive, TimeSpent,StartTime ) values (%d,%d,%d,'%@','%@',%d,%f,'%@');", objCall.Id,objCall.CallReportVisitDetailId,objCall.BrandClusterId,actionDate,[defaults objectForKey:@"Username"],1,objCall.timeSpent,objCall.StartTime];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate:sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
                
            case CallReportBrandSlideDetail_tbl:
            {
                CallReportBrandSlideDetail * objCall = (CallReportBrandSlideDetail *) [objectArr objectAtIndex:i];
                NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];

                NSString * sate = [ NSString stringWithFormat:@"INSERT into  CallReportBrandSlideDetail ( Id   , CallReportBrandDetailId  , SlideNo  , ActionDate , ActionBy ,  StartTime ,  EndTime ,  IsActive ) values (%d,%d,%d,'%@','%@','%@','%@',%d);", objCall.Id,objCall.CallReportBrandDetailId,objCall.SlideNo,actionDate,[defaults objectForKey:@"Username"],objCall.StartTime,objCall.EndTime, 1];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate:sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
                
            case CallDetailHistory_tbl:
            {
                CallDetailHistory * objCall = (CallDetailHistory *) [objectArr objectAtIndex:i];
                NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];

                NSString * sate = [ NSString stringWithFormat:@"INSERT into  CallDetailHistory ( Id   , EmployeeVersion  , EmployeeId  , Date , DoctorId ,  CallDetails ,  BrandName, ActionDate , ActionBy  ,  IsActive) values (%d,%d,%d,'%@',%d,'%@','%@','%@','%@',%d);", objCall.Id,objCall.EmployeeVersion,objCall.EmployeeId,[Utils getCurrentDate],objCall.DoctorId,objCall.CallDetails,objCall.BrandNames,actionDate,[defaults objectForKey:@"Username"],1];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate:sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
                
            case DoctorBrandClusterMatrix_tbl:
            {
                CallDetailHistory * objCall = (CallDetailHistory *) [objectArr objectAtIndex:i];
                NSString * actionDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
                NSString * sate = [ NSString stringWithFormat:@"INSERT into  CallDetailHistory ( Id   , EmployeeVersion  , EmployeeId  , Date , DoctorId ,  CallDetails ,  BrandNames , ActionDate , ActionBy  ,  IsActive) values (%d,%d,%d,'%@',%d,'%@','%@','%@','%@',%d);", objCall.Id,objCall.EmployeeVersion,objCall.EmployeeId,[Utils getCurrentDate],objCall.DoctorId,objCall.CallDetails,objCall.BrandNames,actionDate,[defaults objectForKey:@"Username"],1];
                
                NSLog(@"%@",sate);
                
                
                if( [database executeUpdate:sate])
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;

                
            default:
                NSLog(@"Table not found");
                
                break;
        }
    }
    
    
    return success;
}
-(BOOL)deleteRecord:(NSString *)name{
    
    [database open];
    BOOL success = NO;
    NSString * statement = [NSString stringWithFormat:@"DELETE from %@",name];
    
   
    if( [database executeUpdate: statement])
    {
        success = YES;
        NSLog(@"TABLE DELETED: %@",name);
    }
    else
        NSLog(@"delete Failed");
    
    [database close];
    return success;
}

#pragma mark - Brand ClusterMatrix screen

-(NSMutableArray *)getDoctorForBrandMatrix{
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT distinct d.Id,FirstName,LastName,d.specialisationId ,s.name as sName FROM Doctor d left outer join specialisation s on (d.specialisationId = s.id)"];
    
    NSMutableArray * arrDoctors = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        drBrandCluster * objDoc = [[drBrandCluster alloc]init];
        [objDoc initObj];
        objDoc.doctorId = [results intForColumn:@"Id"];
        objDoc.Name = [NSString stringWithFormat:@"%@ %@",[results stringForColumn:@"FirstName"],[results stringForColumn:@"LastName"]];
        objDoc.specialisation = [results stringForColumn:@"sName"];
        [arrDoctors addObject:objDoc];
        
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
    //eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
    
    for(int j=0; j<arrDoctors.count;j++)
    {
        drBrandCluster * objDoc1 = [arrDoctors objectAtIndex:j];
        
        NSString * state = [NSString stringWithFormat:@"SELECT ed.Id as eId,bc.BrandClusterName,ed.NoOfPages,ed.version,bc.Id FROM DoctorBrandClusterMatrix dbcm, BrandCluster bc ,Edetailer ed where dbcm.BrandClusterId=bc.id and ed.BrandClusterId=dbcm.BrandClusterId and dbcm.DoctorId = %d",objDoc1.doctorId];
        
        FMResultSet *results = [database executeQuery:state];
        
        while([results next])
        {
            eDetailor * objeDet = [[eDetailor alloc]init];
            [objeDet initObject];
            objeDet.Id = [results intForColumn:@"eId"];
            objeDet.noOfSlides = [results intForColumn:@"NoOfPages"];
            objeDet.versionNo = [results stringForColumn:@"version"];
            objeDet.brandName = [results stringForColumn:@"BrandClusterName"];
            //objeDet.publishDate = [results stringForColumn:@"PublishDate"];
            objeDet.brandId = [results intForColumn:@"Id"];
//            eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
//            objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",eDeTailorFolderPath];

            NSString * path = [NSString stringWithFormat:@"%@/%d",eDeTailorFolderPath,objeDet.Id];
            
            objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",path];
            [objDoc1.arrBrands addObject:objeDet];
            
        }
        
    }
    [database close];
    return arrDoctors;
}

-(BOOL)updatedBrandClusterMatrix : (drBrandCluster *)objDBC
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [database open];
    BOOL bRet = true;
    
    NSString * sate = [NSString stringWithFormat:@"DELETE from DoctorBrandClusterMatrix where DoctorId = %d",objDBC.doctorId];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    for(int i=0; i<objDBC.arrBrands.count;i++)
    {
        
        eDetailor * objeDet  = [objDBC.arrBrands objectAtIndex:i];
        
        NSString * sate = [NSString stringWithFormat:@"INSERT into DoctorBrandClusterMatrix(Id,DoctorId,BrandClusterId,ActionDate,ActionBy,IsActive) values (%d,%d,%d,'%@','%@',%d);",1,objDBC.doctorId,objeDet.brandId,[Utils getCurrentDate], [defaults objectForKey:@"Username"] ,1];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
        {
            NSLog(@"INSERT SUCCESS");
            bRet = YES;
        }
        else
        {
            bRet = NO;
            NSLog(@"INSERT FAILED");
        }
        
    }

    [database close];
    
    return bRet;
}
-(NSMutableArray *)getBrandClusterMatrix
{
    [database open];
    
    NSString * state = [NSString stringWithFormat:@"SELECT d.FirstName,d.LastName, s.Name, bc.BrandClusterName, dbcm.Id FROM DoctorBrandClusterMatrix dbcm, Doctor d,BrandCluster bc ,Specialisation s where dbcm.DoctorId = d.Id and dbcm.BrandClusterId = bc.Id and d.SpecialisationId = s.Id"];
    FMResultSet *results = [database executeQuery:state];
    
    NSMutableArray * arreBCM = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        BrandClust * objBC = [[BrandClust alloc]init];
        objBC.Id = [results intForColumn:@"Id"];
        objBC.brandNames = [results stringForColumn:@"BrandClusterName"];
        objBC.specialisation = [results stringForColumn:@"Name"];
        objBC.drName = [NSString stringWithFormat:@"%@ %@",[results stringForColumn:@"FirstName"],[results stringForColumn:@"LastName"]];
        [arreBCM addObject:objBC];
        
    }
    
    [database close];
    return arreBCM;
}

-(void)insertIntoScheduleContent :(drBrandCluster *)objBC
{
    [database open];
    
    NSString * state = [NSString stringWithFormat:@"SELECT tsc.TempScheduleId, ts.IsCallCompleted FROM TempScheduleCall tsc, TempSchedule ts where DoctorId = %d AND tsc.TempScheduleId = ts.Id",objBC.doctorId];
    
    FMResultSet *results = [database executeQuery:state];
   
    BOOL present = NO;
    int TempScheduleId = 0;
    NSString * callCompleted ;
    
    while([results next])
    {
        callCompleted  =  [results stringForColumn:@"IsCallCompleted"];
        TempScheduleId =  [results intForColumn:@"TempScheduleId"];
        present = YES;
    }

    if(present == YES)
    {
        for(int i = 0; i < objBC.arrBrands.count; i++)
        {
            eDetailor * objDet = [objBC.arrBrands objectAtIndex:i];
    
            NSString * sate = [ NSString stringWithFormat:@"INSERT into TempScheduleContent(Id,TempScheduleId,EdetailerId,TimeSpent,StartTime) values (%d,%d,%d,%f,'00:00:00')",0, TempScheduleId,objDet.Id,0.0];
    
            NSLog(@"%@",sate);
    
            if( [database executeUpdate: sate])
                NSLog(@"INSERT PASS");
            else
                NSLog(@"INSERT FAILED");
        }
    }
    
    [database close];

}

#pragma mark - Home screen
-(void)deleteTempSheduleTables
{
    [database open];
    
    //NSString * sate = [NSString stringWithFormat:@"DELETE from TempSchedule where ActionDate < '%@'",[Utils getCurrentDate]];
    NSString * sate = [NSString stringWithFormat:@"DELETE from TempSchedule"];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    //sate = [NSString stringWithFormat:@"DELETE from TempScheduleCall where ActionDate < '%@'",[Utils getCurrentDate]];
    sate = [NSString stringWithFormat:@"DELETE from TempScheduleCall"];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    //sate = [NSString stringWithFormat:@"DELETE from TempSchedulContent where ActionDate < '%@'",[Utils getCurrentDate]];
    sate = [NSString stringWithFormat:@"DELETE from TempSchedulContent"];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    [database close];

}

-(void)createMTPScheduleForToday
{
    
    
    //
    //delete previous day records
    [self deleteTempSheduleTables];
    //
    
    [database open];
    
    NSMutableArray *arrMTPSchedule = [self getScheduleDataFromMTP];
    
   
    
    for(int i=0; i< arrMTPSchedule.count; i++)
    {
        ScheduleCallDescription *objSC = [arrMTPSchedule objectAtIndex:i];
      
        NSMutableArray *arrSC = [[NSMutableArray alloc]init];
        [arrSC addObject:objSC];
        
        [self insertRecord:TempSchedule_tbl :arrSC];
        [self insertRecord:TempScheduleCall_tbl :objSC.arrDoctors];
        [self insertRecord:TempScheduleContent_tbl :objSC.arreDetailors];
    }
    
    [database close];
    
}

-(NSMutableArray *)getScheduleCallData
{
    
    ///
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSString * str = [defaults objectForKey:@"MTPSchedule"];
      if(str == nil || [str isEqualToString:@""])
      {
         [defaults setObject:[Utils getCurrentDate] forKey:@"MTPSchedule"];
         [defaults synchronize];
      }
    
    if(![str isEqualToString:[Utils getCurrentDate]])
      {
          [self createMTPScheduleForToday];
          [defaults setObject:[Utils getCurrentDate] forKey:@"MTPSchedule"];
          [defaults synchronize];
      }

    
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];

    FMResultSet *results1 = [database executeQuery:@"SELECT * FROM TempSchedule"];
    
    //get from schedule table
    while([results1 next])
    {
        ScheduleCallDescription *objSCD = [[ScheduleCallDescription alloc]init];
        [objSCD initObject];
        objSCD.ScheduleId = [results1 intForColumn:@"Id"];
        objSCD.callObjective = [results1 stringForColumn:@"CallObjective"];
        objSCD.callType = [results1 intForColumn:@"CallType"];
        objSCD.date = [results1 stringForColumn:@"Date"];
        objSCD.isCallCompleted = [results1 intForColumn:@"isCallCompleted"];
        objSCD.StandardTourPlanDayId = 1;
        [arrSchedule addObject:objSCD];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
    //eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
    
    //get from dr tables
    for(int iCnt = 0; iCnt < arrSchedule.count; iCnt++)
    {
        
        int Idsc = 0;
        ScheduleCallDescription *objSCD = [arrSchedule objectAtIndex:iCnt];
        
        
        NSString * state = [NSString stringWithFormat:@"SELECT DoctorName,DoctorId,s.Name as sName FROM TempScheduleCall sc, Doctor d, Specialisation s where TempScheduleId = %d and d.Id = sc.DoctorId and d.SpecialisationId = s.Id",objSCD.ScheduleId];
        FMResultSet *results = [database executeQuery:state];
        int iDocId = 0;
        while([results next])
        {
            doctorStuct *objDr = [[doctorStuct alloc]init];
            objDr.fname = [results stringForColumn:@"DoctorName"];
            objDr.specializationName = [results stringForColumn:@"sName"];
            iDocId = objDr.doctorId = [results intForColumn:@"DoctorId"];
            [objSCD.arrDoctors addObject:objDr];
        }
        
        state = [NSString stringWithFormat:@"SELECT e.Id as eId,e.NoOfPages,e.version,b.BrandClusterName,e.PublishDate,b.Id,sc.RowId as scId FROM TempScheduleContent sc left outer join Edetailer e on (e.Id = sc.EdetailerId) left outer join BrandCluster b on (e.BrandClusterId = b.Id) where sc.TempScheduleId = %d",objSCD.ScheduleId];
        
        FMResultSet *results1 = [database executeQuery:state];
        
        while([results1 next])
        {
            eDetailor * objeDet = [[eDetailor alloc]init];
            [objeDet initObject];
            objeDet.scheduleContentId = [results1 intForColumn:@"scId"];
            objeDet.Id = [results1 intForColumn:@"eId"];
            objeDet.noOfSlides = [results1 intForColumn:@"NoOfPages"];
            objeDet.versionNo = [results1 stringForColumn:@"version"];
            objeDet.brandName = [results1 stringForColumn:@"BrandClusterName"];
            objeDet.brandId = [results1 intForColumn:@"Id"];
            
            // eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
            NSString * path = [NSString stringWithFormat:@"%@/%d",eDeTailorFolderPath,objeDet.Id];
            
            objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",path];
            
            
            [objSCD.arreDetailors addObject:objeDet];
            
            //            for(int i =0; i < objSCD.arreDetailors.count; i++)
            //            {
            //                eDetailor * objeDet = [objSCD.arreDetailors objectAtIndex:i];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors"];
            eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
            eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
            NSString *eDeTailorThumFolderPath  = [eDeTailorFolderPath stringByAppendingString:@"/thumbnails/"];
            
            NSString * state = nil;
            if(objSCD.callType == INDIVIDUAL_CALL)
            {
                state  = [NSString stringWithFormat:@"SELECT eswsd.Id as eswsdId, eswsd.SlideNo,s.Name FROM  Doctor d, EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd, Specialisation s where  esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=d.SpecialisationId and s.Id=d.SpecialisationId and d.id=%d and esd.EdetailerId=%d ",iDocId,objeDet.Id ];
            }
            else
            {
                state = [NSString stringWithFormat:@"SELECT eswsd.Id as eswsdId, esd.EdetailerId,eswsd.SlideNo,spe.Name FROM  EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd,Specialisation spe where esd.EdetailerId=%d and esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=spe.id",objeDet.Id ];
            }
            
            FMResultSet *results = [database executeQuery:state];
            
            while([results next])
            {
                eDetailorSlide * objeDetSlide = [[eDetailorSlide alloc]init];
                objeDetSlide.Id = [results intForColumn:@"eswsdId"];
                objeDetSlide.ScheduleContentId = Idsc;
                objeDetSlide.eDetailorId =objeDet.Id;
                objeDetSlide.slideNo = [results intForColumn:@"SlideNo"];
                objeDetSlide.TargetSpecialization = [results stringForColumn:@"Name"];
                objeDetSlide.thumbPath = [NSString stringWithFormat:@"%@%d.png",eDeTailorThumFolderPath,objeDetSlide.slideNo];
                objeDetSlide.eDetailorId = objeDet.Id;
                objeDetSlide.URLPath =[NSString stringWithFormat:@"%@%@",eDeTailorFolderPath,[self getSlideURLPath:objeDetSlide.slideNo]];
                
                objeDetSlide.eDetailorId = objeDet.Id;
                [objeDet.arrSlides addObject:objeDetSlide];
                
            }
            //}
            
            
            
        }
        
        if(objSCD.arrDoctors.count == 1)
        {
            doctorStuct *objDr = [objSCD.arrDoctors objectAtIndex:0];
            NSString * state = [NSString stringWithFormat:@"SELECT * FROM CallDetailHistory where DoctorId = %d",objDr.doctorId];
            
            FMResultSet *results = [database executeQuery:state];
            
            while([results next])
            {
                CallDetailHistory *objCall = [[CallDetailHistory alloc]init];
                objCall.Date = [results stringForColumn:@"Date"];
                objCall.BrandNames = [results stringForColumn:@"BrandName"];
                objCall.CallDetails = [results stringForColumn:@"CallDetails"];
                [objSCD.arrPreviousHistory addObject:objCall];
            }
            
            
            
        }
        
        
    }

    
    ///
    
   // [database open];
   // NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    //arrSchedule = [self getScheduleDataFromMTP];
    
    NSString * state = [NSString stringWithFormat:@"SELECT * FROM Schedule where date = '%@'",[Utils getCurrentDate]];
    
    FMResultSet *results = [database executeQuery:state];
    
    //get from schedule table
    while([results next])
    {
        ScheduleCallDescription *objSCD = [[ScheduleCallDescription alloc]init];
        [objSCD initObject];
        objSCD.ScheduleId = [results intForColumn:@"Id"];
        objSCD.callObjective = [results stringForColumn:@"CallObjective"];
        objSCD.callType = [results intForColumn:@"CallType"];
        objSCD.date = [results stringForColumn:@"Date"];
        objSCD.isCallCompleted = [results intForColumn:@"isCallCompleted"];
        objSCD.StandardTourPlanDayId = 0;
        [arrSchedule addObject:objSCD];
    }
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
//    //eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
    
    //get from dr tables
    for(int iCnt = 0; iCnt < arrSchedule.count; iCnt++)
    {
        ScheduleCallDescription *objSCD = [arrSchedule objectAtIndex:iCnt];
        
        int scId = 0;
        NSString * state = [NSString stringWithFormat:@"SELECT DoctorName,DoctorId,s.Name as sName FROM ScheduleCall sc, Doctor d, Specialisation s where ScheduleId = %d and d.Id = sc.DoctorId and d.SpecialisationId = s.Id",objSCD.ScheduleId];
        FMResultSet *results = [database executeQuery:state];
        int iDocId = 0;
        while([results next])
        {
            doctorStuct *objDr = [[doctorStuct alloc]init];
            objDr.fname = [results stringForColumn:@"DoctorName"];
            objDr.specializationName = [results stringForColumn:@"sName"];
           iDocId = objDr.doctorId = [results intForColumn:@"DoctorId"];
            [objSCD.arrDoctors addObject:objDr];
        }
        
        state = [NSString stringWithFormat:@"SELECT e.Id as eId,e.NoOfPages,e.version,b.BrandClusterName,e.PublishDate,b.Id ,sc.RowId as scId  FROM ScheduleContent sc left outer join Edetailer e on (e.Id = sc.EdetailerId) left outer join BrandCluster b on (e.BrandClusterId = b.Id) where sc.ScheduleId = %d",objSCD.ScheduleId];
        
        FMResultSet *results1 = [database executeQuery:state];
        
        while([results1 next])
        {
            eDetailor * objeDet = [[eDetailor alloc]init];
            [objeDet initObject];
            objeDet.Id = [results1 intForColumn:@"eId"];
            objeDet.scheduleContentId  = [results1 intForColumn:@"scId"];
            objeDet.noOfSlides = [results1 intForColumn:@"NoOfPages"];
            objeDet.versionNo = [results1 stringForColumn:@"version"];
            objeDet.brandName = [results1 stringForColumn:@"BrandClusterName"];
            objeDet.brandId = [results1 intForColumn:@"Id"];
          
           // eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
            NSString * path = [NSString stringWithFormat:@"%@/%d",eDeTailorFolderPath,objeDet.Id];
            
            objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",path];

            
            [objSCD.arreDetailors addObject:objeDet];
            
//            for(int i =0; i < objSCD.arreDetailors.count; i++)
//            {
//                eDetailor * objeDet = [objSCD.arreDetailors objectAtIndex:i];
            
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors"];
                eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
                eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
                NSString *eDeTailorThumFolderPath  = [eDeTailorFolderPath stringByAppendingString:@"/thumbnails/"];
                
            NSString * state = nil;
                if(objSCD.callType == INDIVIDUAL_CALL)
                {
                    state  = [NSString stringWithFormat:@"SELECT eswsd.Id as eswsdId, eswsd.SlideNo,s.Name FROM  Doctor d, EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd, Specialisation s where  esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=d.SpecialisationId and s.Id=d.SpecialisationId and d.id=%d and esd.EdetailerId=%d ",iDocId,objeDet.Id ];
                }
            else
            {
                 state = [NSString stringWithFormat:@"SELECT eswsd.Id as eswsdId, esd.EdetailerId,eswsd.SlideNo,spe.Name FROM  EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd,Specialisation spe where esd.EdetailerId=%d and esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=spe.id",objeDet.Id ];
            }
            
                FMResultSet *results = [database executeQuery:state];
                
                while([results next])
                {
                    eDetailorSlide * objeDetSlide = [[eDetailorSlide alloc]init];
                    objeDetSlide.Id = [results intForColumn:@"eswsdId"];
                    objeDetSlide.eDetailorId =objeDet.Id;
                    objeDetSlide.ScheduleContentId = scId;
                    objeDetSlide.slideNo = [results intForColumn:@"SlideNo"];
                    objeDetSlide.TargetSpecialization = [results stringForColumn:@"Name"];
                    objeDetSlide.thumbPath = [NSString stringWithFormat:@"%@%d.png",eDeTailorThumFolderPath,objeDetSlide.slideNo];
                    objeDetSlide.eDetailorId = objeDet.Id;
                    objeDetSlide.URLPath =[NSString stringWithFormat:@"%@%@",eDeTailorFolderPath,[self getSlideURLPath:objeDetSlide.slideNo]];
                    
                    objeDetSlide.eDetailorId = objeDet.Id;
                    [objeDet.arrSlides addObject:objeDetSlide];
                    
                }
            //}

            
            
        }
        
        if(objSCD.arrDoctors.count == 1)
        {
            doctorStuct *objDr = [objSCD.arrDoctors objectAtIndex:0];
            NSString * state = [NSString stringWithFormat:@"SELECT * FROM CallDetailHistory where DoctorId = %d",objDr.doctorId];
            
            FMResultSet *results = [database executeQuery:state];
            
            while([results next])
            {
                CallDetailHistory *objCall = [[CallDetailHistory alloc]init];
                objCall.Date = [results stringForColumn:@"Date"];
                objCall.BrandNames = [results stringForColumn:@"BrandName"];
                objCall.CallDetails = [results stringForColumn:@"CallDetails"];
                [objSCD.arrPreviousHistory addObject:objCall];
            }
            
            
            
        }
        
        
    }
    
    
    [database close];
    return arrSchedule;
}

//-(NSMutableArray *)getDoctorListForMTP : (int)STPDId
//{
//    [database open];
//    
//    NSString * state = [NSString stringWithFormat:@"SELECT d.FirstName,d.LastName,d.Id,stp.FWPName FROM StandardTourPlan stp left outer join Doctor d on (stp.DoctorId = d.Id) where stp.StandardTourPlanDayId =  (SELECT StandardTourPlanDayId FROM MonthlyTourProgram where MTPDate = '%@')",date];
//    FMResultSet *results = [database executeQuery:state];
//    
//    NSMutableArray * arrDoctors = [[NSMutableArray alloc]init];
//    
//    while([results next])
//    {
//        
//        doctorStuct *objDr = [[doctorStuct alloc]init];
//        objDr.fname = [ NSString stringWithFormat:@"%@ %@",[results stringForColumn:@"FirstName"],[results stringForColumn:@"LastName"] ];
//        objDr.doctorId = [results intForColumn:@"DoctorId"];
//        [objSCD.arrDoctors addObject:objDr];
//        
//        STPDoctor * objSTPDoctor = [[STPDoctor alloc]init];
//        objSTPDoctor.drName =
//        objSTPDoctor.Id = [results intForColumn:@"Id"];
//        [arrDoctors addObject:objSTPDoctor];
//        
//    }
//    
//    [database close];
//    return arrDoctors;
//    
//}

-(BOOL)isDownloadedeDetailor : (int)eDetId
{
    BOOL isDow = NO;
    
    [database open];
    
    
    NSString * state = [NSString stringWithFormat:@"SELECT isDownloaded from Edetailer where Id = %d",eDetId];
    FMResultSet *results = [database executeQuery:state];
    
    while([results next])
    {
        NSString * date = nil;
        date = [results stringForColumn:@"isDownloaded"];
        
       if([date isEqualToString:@"True"])
           isDow = YES;
        else
            isDow = NO;
    }
    
    [database close];

    
    return isDow;
}

-(NSMutableArray *)getScheduleDataFromMTP
{
    NSMutableArray *arrSchedule = [[NSMutableArray  alloc]init];
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
    
    NSString * state = [NSString stringWithFormat:@"SELECT distinct stp.StandardTourPlanDayId, stp.EmployeeVersion, d.FirstName,d.LastName,d.Id as dId,stp.FWPName, s.Name as sName  FROM Specialisation s, StandardTourPlan stp ,Doctor d  where stp.StandardTourPlanDayId IN (SELECT StandardTourPlanDayId FROM MonthlyTourProgram where DATE(MTPDATE) = DATE ('%@')) and stp.DoctorId = d.Id and d.SpecialisationId = s.Id",[Utils getCurrentDate]
                    ];
     NSLog(@"%@",state);
    FMResultSet *results = [database executeQuery:state];
    
    while([results next])
    {
        ScheduleCallDescription *objSCD = [[ScheduleCallDescription alloc]init];
        [objSCD initObject];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * sid = [defaults objectForKey:@"scheduleId"];
        objSCD.ScheduleId = [sid intValue];
        [defaults setObject:[NSString stringWithFormat:@"%d",([sid intValue] + 1)] forKey:@"scheduleId"];
        [defaults synchronize];
        
        objSCD.date = [Utils getCurrentDate];
        //objSCD.ScheduleId = 0;
       //objSCD.ScheduleId = [results intForColumn:@"StandardTourPlanDayId"];
        objSCD.callObjective = @"";
        //objSCD.date = [results stringForColumn:@"MTPDate"];
        if([results intForColumn:@"EmployeeVersion"] == 1)
            objSCD.isCallCompleted = NO;
        else
            objSCD.isCallCompleted = YES;
        
       objSCD.StandardTourPlanDayId = [results intForColumn:@"StandardTourPlanDayId"];
        
        doctorStuct * objDoc = [[doctorStuct alloc]init];
        int iDocId = objDoc.doctorId = [results intForColumn:@"dId"];
        objDoc.fname =  [ NSString stringWithFormat:@"%@ %@",[results stringForColumn:@"FirstName"],[results stringForColumn:@"LastName"] ];
        objDoc.specializationName = [results stringForColumn:@"sName"];
        objDoc.scheduleId = objSCD.ScheduleId ;
        [objSCD.arrDoctors addObject:objDoc];
        
        NSString * state = [NSString stringWithFormat:@"SELECT e.NoOfPages,e.version,bc.BrandClusterName,e.Id as eId,bc.Id as bcId  from  DoctorBrandClusterMatrix dbcm,Edetailer e,BrandCluster bc where e.BrandClusterId  = dbcm.BrandClusterId and dbcm.BrandClusterId = bc.id and dbcm.DoctorId = %d",iDocId];
        FMResultSet *results1 = [database executeQuery:state];
        
        objSCD.callType = INDIVIDUAL_CALL;
        while([results1 next])
        {
           
         eDetailor * objeDet = [[eDetailor alloc]init];
        [objeDet initObject];
        objeDet.Id = [results1 intForColumn:@"eId"];
        objeDet.noOfSlides = [results1 intForColumn:@"NoOfPages"];
        objeDet.versionNo = [results1 stringForColumn:@"version"];
        objeDet.brandName = [results1 stringForColumn:@"BrandClusterName"];
        objeDet.brandId = [results1 intForColumn:@"bcId"];
        NSString * path = [NSString stringWithFormat:@"%@/%d",eDeTailorFolderPath,objeDet.Id];
        objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",path];
        objeDet.scheduleId = objSCD.ScheduleId ;
            [objSCD.arreDetailors addObject:objeDet];
            
            for(int i =0; i < objSCD.arreDetailors.count; i++)
            {
                eDetailor * objeDet = [objSCD.arreDetailors objectAtIndex:i];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors"];
                eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
                eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
                NSString *eDeTailorThumFolderPath  = [eDeTailorFolderPath stringByAppendingString:@"/thumbnails/"];
                
                
                
                NSString * state = nil;
                if(objSCD.callType == INDIVIDUAL_CALL)
                {
                    state  = [NSString stringWithFormat:@"SELECT eswsd.Id as eswsdId, eswsd.SlideNo,s.Name FROM  Doctor d, EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd, Specialisation s where  esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=d.SpecialisationId and s.Id=d.SpecialisationId and d.id=%d and esd.EdetailerId=%d ",iDocId,objeDet.Id ];
                }
                else
                {
                    state = [NSString stringWithFormat:@"SELECT  eswsd.Id as eswsdId, esd.EdetailerId,eswsd.SlideNo,spe.Name FROM  EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd,Specialisation spe where esd.EdetailerId=%d and esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=spe.id",objeDet.Id ];
                }

                
                FMResultSet *results = [database executeQuery:state];
                
                while([results next])
                {
                    eDetailorSlide * objeDetSlide = [[eDetailorSlide alloc]init];
//                    objeDetSlide.eDetailorId = [results intForColumn:@"Id"];
                    objeDetSlide.Id = [results intForColumn:@"eswsdId"];
                    objeDetSlide.slideNo = [results intForColumn:@"SlideNo"];
                    objeDetSlide.TargetSpecialization = [results stringForColumn:@"Name"];
                    objeDetSlide.thumbPath = [NSString stringWithFormat:@"%@%d.png",eDeTailorThumFolderPath,objeDetSlide.slideNo];
                    objeDetSlide.eDetailorId =objeDet.Id;
                    objeDetSlide.URLPath =[NSString stringWithFormat:@"%@%@",eDeTailorFolderPath,[self getSlideURLPath:objeDetSlide.slideNo]];
                    [objeDet.arrSlides addObject:objeDetSlide];
                    
                }
            }

        
        }
        
        if(objSCD.arrDoctors.count == 1)
        {
            doctorStuct *objDr = [objSCD.arrDoctors objectAtIndex:0];
            NSString * state = [NSString stringWithFormat:@"SELECT * FROM CallDetailHistory where DoctorId = %d",objDr.doctorId];
            
            FMResultSet *results = [database executeQuery:state];
            
            while([results next])
            {
                CallDetailHistory *objCall = [[CallDetailHistory alloc]init];
                objCall.Date = [results stringForColumn:@"Date"];
                objCall.BrandNames = [results stringForColumn:@"BrandName"];
                objCall.CallDetails = [results stringForColumn:@"CallDetails"];
                [objSCD.arrPreviousHistory addObject:objCall];
            }
            
            
            
        }

        

        [arrSchedule addObject:objSCD];
     }
   
    
    return arrSchedule;
}

#pragma mark - Call execute
-(void)updateStartTimeInScheduleContentForScheduleId:(int)scheduleId eDetailorId:(int)eDetId time:(NSString *)strTime table:(int)type
{
    [database open];
    //UPDATE TempScheduleContent set StartTime = "20-12-2015" where TempScheduleId = 14
    NSString * sate = nil;
    
    if(type == 1)
    {
     sate = [NSString stringWithFormat:@"UPDATE TempScheduleContent set StartTime = '%@' where TempScheduleId = %d and EdetailerId = %d and StartTime = '00:00:00';",strTime,scheduleId,eDetId];
    }
    else
        {
            sate = [NSString stringWithFormat:@"UPDATE ScheduleContent set StartTime = '%@' where ScheduleId = %d and EdetailerId = %d and StartTime = '00:00:00';",strTime,scheduleId,eDetId];
        }
        
    NSLog(@"%@",sate);
    
    if( [database executeUpdate: sate])
         NSLog(@"SUCCESS : %@",sate);
    else
    {
        NSLog(@"FAILED : %@",sate);
    }

    [database close];
}

-(void)insertScheduleContentForScheduleId:(eDetailor *)objScheduleContent TempTable:(int)TempTable;
{
    NSString * sate = nil;

    [database open];
    
    if(TempTable == 1)
    {
        
        BOOL present = NO;
        NSString * state = [NSString stringWithFormat:@"SELECT * FROM TempScheduleContent where EdetailerId = %d and TempScheduleId = %d",objScheduleContent.Id,objScheduleContent.scheduleId];
        
        FMResultSet *results = [database executeQuery:state];
        
        while([results next])
        {
            present = YES;
        }

        if(!present)
        {
            sate = [ NSString stringWithFormat:@"INSERT into TempScheduleContent(Id,TempScheduleId,EdetailerId,TimeSpent,StartTime,ActionDate) values (%d,%d,%d,%f,'%@','%@')",0, objScheduleContent.scheduleId,objScheduleContent.Id,0.0,objScheduleContent.starttime,[Utils getCurrentDate]];
        
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                NSLog(@"INSERT SUCCESS");
            else
                NSLog(@"INSERT FAILED");
        
        }
        
    }
    else
    {
        
        BOOL present = NO;
        NSString * state = [NSString stringWithFormat:@"SELECT * FROM ScheduleContent where EdetailerId = %d and ScheduleId = %d",objScheduleContent.Id,objScheduleContent.scheduleId];
        
        FMResultSet *results = [database executeQuery:state];
        
        while([results next])
        {
            present = YES;
        }

         if(!present)
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
             sate = [ NSString stringWithFormat:@"INSERT into ScheduleContent(Id,ScheduleId,EdetailerId,ActionDate,ActionBy,IsActive,StartTime) values (%d,%d,%d,'%@','%@',%d,'00:00:00')",0, objScheduleContent.scheduleId,objScheduleContent.Id,[Utils getCurrentDate],[defaults objectForKey:@"Username"],1];
             
             NSLog(@"%@",sate);
             
             if( [database executeUpdate: sate])
                 NSLog(@"INSERT SUCCESS");
             else
                 NSLog(@"INSERT FAILED");
         }
        
       
    }
    
     [database close];
}


-(void)insertSlideDetail : (eDetailorSlide *)slide
{
     [database open];
    
    NSString * sate = [NSString stringWithFormat:@"INSERT into TempScheduleBrandSlideDetail(Id,TempScheduleContentId,SlideNo,StartTime,EndTime) values (%d,%d,%d,'%@','%@');", slide.Id,slide.ScheduleContentId,slide.slideNo,slide.StartTime,slide.EndTime
                      ];
    
    NSLog(@"%@",sate);
    
    if( [database executeUpdate: sate])
       NSLog(@"INSERT OK");
    else
        NSLog(@"INSERT FAILED");

    
     [database close];
}

-(int)checkForCallCompletedEntry
{
    int CCId = -1;
    [database open];
    
    NSString * state = [NSString stringWithFormat:@"Select Id from CallReport where CallReportDate = '%@'",[Utils getCurrentDate]];
    FMResultSet *results = [database executeQuery:state];
 
    while([results next])
    {
        CCId = [results intForColumn:@"Id"];
    }
    
    [database close];
    return CCId;
}

-(NSMutableArray *)geteSlideeDetailorForSchedule :(int)scheduleId eDetailorId:(int )eDetId
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSString * sate ;
    
   
        sate = [NSString stringWithFormat:@"SELECT * FROM TempScheduleBrandSlideDetail where Id = %d and TempScheduleContentId = %d ", eDetId, scheduleId];
    
    
    FMResultSet *results = [database executeQuery:sate];
    
    while([results next])
    {
        
        eDetailorSlide * objSlide = [[eDetailorSlide alloc]init];
        objSlide.slideNo =  [results intForColumn:@"SlideNo"];
        objSlide.StartTime = [results stringForColumn:@"StartTime"];
        objSlide.EndTime = [results stringForColumn:@"EndTime"];
        
        [arrSchedule addObject:objSlide];
    }
    [database close];
    return arrSchedule;
    

}

-(NSMutableArray *)getDoctorForSchedule :(int)scheduleId tempTable:(int )tempTbl
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
   
    NSString * sate ;
    
    if(!tempTbl)
    {
        sate = [NSString stringWithFormat:@"SELECT * FROM ScheduleCall where ScheduleId = %d", scheduleId];
    }
    else
    {
        sate = [NSString stringWithFormat:@"SELECT * FROM TempScheduleCall where TempScheduleId = %d", scheduleId];
    }
    
    FMResultSet *results = [database executeQuery:sate];
    
    while([results next])
    {
        
        doctorStuct * objDr = [[doctorStuct alloc]init];
        objDr.doctorId =  [results intForColumn:@"DoctorId"];
        objDr.fname = [results stringForColumn:@"DoctorName"];
        
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"ScheduleId"]] forKey:@"ScheduleId"];
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"DoctorId"]]  forKey:@"DoctorId"];
//        [myMutableDictionary setObject:[results stringForColumn:@"DoctorName"] forKey:@"DoctorName"];
//        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
//        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"IsActive"]]  forKey:@"IsActive"];
        
        
        [arrSchedule addObject:objDr];
    }
    [database close];
    return arrSchedule;

    
}

-(NSMutableArray *)geteDetailorForSchedule :(int)scheduleId tempTable:(int )tempTbl
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSString * sate ;
    
    if(!tempTbl)
    {
        sate = [NSString stringWithFormat:@"SELECT bc.BrandClusterName as Name, e.BrandClusterId as ebcId, e.Id as eDetId , sc.StartTime FROM ScheduleContent sc , Edetailer e, BrandCluster bc where ScheduleId = %d and sc.EdetailerId = e.Id and bc.Id = e.BrandClusterId", scheduleId];
    }
    else
    {
        sate = [NSString stringWithFormat:@"SELECT e.BrandClusterId as ebcId, e.Id as eDetId, sc.StartTime FROM TempScheduleContent sc, Edetailer e where sc.TempScheduleId = %d and sc.EdetailerId = e.Id ", scheduleId];
    }
    
    FMResultSet *results = [database executeQuery:sate];
    
    while([results next])
    {
        
        eDetailor * objDr = [[eDetailor alloc]init];
        objDr.brandId =  [results intForColumn:@"ebcId"];
        objDr.Id =  [results intForColumn:@"eDetId"];
        objDr.brandName = [results stringForColumn:@"Name"];
        objDr.starttime = [results stringForColumn:@"StartTime"];
        
        //        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        //        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"ScheduleId"]] forKey:@"ScheduleId"];
        //        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"DoctorId"]]  forKey:@"DoctorId"];
        //        [myMutableDictionary setObject:[results stringForColumn:@"DoctorName"] forKey:@"DoctorName"];
        //        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        //        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        //        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"IsActive"]]  forKey:@"IsActive"];
        
        
        [arrSchedule addObject:objDr];
    }
    [database close];
    return arrSchedule;
    

}

-(void)insertCallCompleted : (callCompleted *)objSC
{
    [database open];
    
    if(objSC.needToInsert == YES)
    {
        NSMutableArray *arrSC = [[NSMutableArray alloc]init];
        [arrSC addObject:objSC];
        [self insertRecord:CallReport_tbl :arrSC];
    }
    
    [self insertRecord:CallReportVisitDetail_tbl :objSC.arrCallReportVisitDetail];
    [self insertRecord:CallReportBrandDetail_tbl :objSC.arrCallReportBrandDetail];
    [self insertRecord:CallReportBrandSlideDetail_tbl :objSC.arrCallReportBrandSlideDetail];
  
    
    [self insertRecord:CallDetailHistory_tbl :objSC.arrCallRecordHistory];
    
    if(!objSC.isFromMTP)
      [self callCompletedStatusInSchedule:objSC.ScheduleCallDescriptionId];
    else
        [self callCompletedStatusInTempSchedule:objSC.ScheduleCallDescriptionId];
    [database close];
}

//-(void)callCompletedStatusinSTP : (int)drId STPId:(int)stpid
//{
//    
//    NSString * sate = [NSString stringWithFormat:@"Update StandardTourPlan set EmployeeVersion = 0 where DoctorId = %d and StandardTourPlanDayId = %d",drId,stpid];
//    
//    //get from schedule table
//    if( [database executeUpdate: sate])
//        NSLog(@"Update passed");
//    else
//        NSLog(@"Update FAILED");
//    
//}

-(void)callCompletedStatusInSchedule : (int)scheduleId
{
    NSString * sate = [NSString stringWithFormat:@"Update Schedule set isCallCompleted = 1 where Id = %d",scheduleId];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
}
-(void)callCompletedStatusInTempSchedule : (int)scheduleId
{
    NSString * sate = [NSString stringWithFormat:@"Update TempSchedule set isCallCompleted = 1 where Id = %d",scheduleId];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
}

#pragma mark - Schedule Call screen

-(int)checkIfDoctorIsAleadyScheduledForDate:(NSString *)date doctorId:(int)drId
{
    int alreadySheduled = 0;
    [database open];
    NSString * sate ;
    
    sate = [NSString stringWithFormat:@"SELECT  s.* FROM Schedule s, ScheduleCall sc where s.Id = sc.ScheduleId and s.Date = '%@'   and sc.DoctorId = %d ",date,drId];
    
    FMResultSet *results = [database executeQuery:sate];
    
    while([results next])
    {
        alreadySheduled = 1;
    }
    
    if(alreadySheduled == NO)
    {
        sate = [NSString stringWithFormat:@"SELECT  s.* FROM TempSchedule s, TempScheduleCall sc where s.Id = sc.TempScheduleId and s.Date = '%@'   and sc.DoctorId = %d ",date,drId];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            alreadySheduled = 2;
        }

    }
    
    [database close];
    return alreadySheduled;

}

-(NSMutableArray *)getMTPeDetailors :(NSMutableArray *)drArr;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
   // eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
    
    [database open];
    NSString * drList = @"(";
    
    for(int i=0;i<drArr.count;i++)
    {
       doctorStuct *objDr =  [drArr objectAtIndex:i];
        drList = [drList stringByAppendingString:[NSString stringWithFormat:@"%d,",objDr.doctorId]];
    }
    drList = [drList stringByAppendingString:@");"];
    
    NSString * state = [NSString stringWithFormat:@"SELECT bc.BrandClusterName,ed.NoOfPages,ed.version,ed.Id as eId FROM DoctorBrandClusterMatrix dbcm, BrandCluster bc ,Edetailer ed where dbcm.BrandClusterId=bc.id and ed.BrandClusterId=dbcm.BrandClusterId and dbcm.DoctorId in %@",drList];
        FMResultSet *results = [database executeQuery:state];
        
        NSMutableArray * arreDetailors = [[NSMutableArray alloc]init];
        
        while([results next])
        {
            eDetailor * objeDet = [[eDetailor alloc]init];
            [objeDet initObject];
            objeDet.Id = [results intForColumn:@"eId"];
            objeDet.noOfSlides = [results intForColumn:@"NoOfPages"];
            objeDet.versionNo = [results stringForColumn:@"version"];
            objeDet.brandName = [results stringForColumn:@"BrandClusterName"];
            //objeDet.publishDate = [results stringForColumn:@"PublishDate"];
            objeDet.brandId = [results intForColumn:@"Id"];
            
            NSString * path = [NSString stringWithFormat:@"%@/%d",eDeTailorFolderPath,objeDet.Id];
            
            objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",path];
            
//            eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
//            objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",eDeTailorFolderPath];

            [arreDetailors addObject:objeDet];
            
        }
    
    for(int i =0; i < arreDetailors.count; i++)
    {
        eDetailor * objeDet = [arreDetailors objectAtIndex:i];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors"];
        eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
        eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
        NSString *eDeTailorThumFolderPath  = [eDeTailorFolderPath stringByAppendingString:@"/thumbnails/"];
        
        
        
        NSString * state = [NSString stringWithFormat:@"SELECT eswsd.Id as eswsdId, esd.EdetailerId,eswsd.SlideNo,spe.Name FROM  EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd,Specialisation spe where esd.EdetailerId=%d and esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=spe.id",objeDet.Id ];
        
        FMResultSet *results = [database executeQuery:state];
        
        while([results next])
        {
            eDetailorSlide * objeDetSlide = [[eDetailorSlide alloc]init];
             objeDetSlide.Id = [results intForColumn:@"eswsdId"];
                    objeDetSlide.eDetailorId =objeDet.Id;
            objeDetSlide.slideNo = [results intForColumn:@"SlideNo"];
            objeDetSlide.TargetSpecialization = [results stringForColumn:@"Name"];
            objeDetSlide.thumbPath = [NSString stringWithFormat:@"%@%d.png",eDeTailorThumFolderPath,objeDetSlide.slideNo];
            
            objeDetSlide.URLPath =[NSString stringWithFormat:@"%@%@",eDeTailorFolderPath,[self getSlideURLPath:objeDetSlide.slideNo]];
            [objeDet.arrSlides addObject:objeDetSlide];
            
        }
    }

        [database close];
        return arreDetailors;
    

}
-(NSMutableArray *)getDoctor : (NSString *)scheduleDate
{
    
    [database open];
    
        NSString * sate = [NSString stringWithFormat:@"SELECT distinct d.Id,FirstName,LastName,d.specialisationId ,s.name FROM Doctor d LEFT JOIN specialisation s on (d.specialisationId = s.id) WHERE d.[Id] not in (SELECT  vd.DoctorId FROM CallReport as cr INNER JOIN CallReportvisitDetail as vd ON cr.Id = vd. CallReportId WHERE cr.CallReportDate = '%@');", scheduleDate];
    
     FMResultSet *results = [database executeQuery:sate];
    
//    FMResultSet *results = [database executeQuery:@"SELECT distinct d.Id,FirstName,LastName,d.specialisationId ,s.name FROM Doctor d left outer join specialisation s on (d.specialisationId = s.id)"];

    
    NSMutableArray * arrDoctors = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        doctorStuct * objDoc = [[doctorStuct alloc]init];
        objDoc.doctorId = [results intForColumn:@"Id"];
        objDoc.fname = [ NSString stringWithFormat:@"%@ %@",[results stringForColumn:@"FirstName"],[results stringForColumn:@"LastName"]];
        //objDoc.lname = [results stringForColumn:@"LastName"];
        objDoc.specializationId = [results intForColumn:@"SpecialisationId"];
        objDoc.specializationName = [results stringForColumn:@"Name"];
        
        [arrDoctors addObject:objDoc];
        
    }
    
    [database close];
    return arrDoctors;
}

-(void)insertScheduleCall : (ScheduleCallDescription *)objSC
{
    [database open];
    
    NSMutableArray *arrSC = [[NSMutableArray alloc]init];
    [arrSC addObject:objSC];
    
    [self insertRecord:Schedule_tbl :arrSC];
    [self insertRecord:ScheduleCall_tbl :objSC.arrDoctors];
    [self insertRecord:ScheduleContent_tbl :objSC.arreDetailors];
    
    [database close];
}

#pragma mark - eDetailor screen
-(NSMutableArray *)geteDetailerDataForPrew:(BOOL)allSlidesFlag
{
    NSMutableArray * arreDetailor = [[NSMutableArray alloc]init];
    
    [database open];
    
    NSString * statement = [NSString stringWithFormat:@"SELECT e.Id as eId,e.NoOfPages,e.version,b.BrandClusterName,e.PublishDate ,b.Id FROM Edetailer e left outer join BrandCluster b on (e.BrandClusterId = b.Id) where e.isDownloaded = 'True'"];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
   // eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
   
    
    FMResultSet *results = [database executeQuery:statement];
    
    while([results next])
    {
        eDetailor * objeDet = [[eDetailor alloc]init];
        [objeDet initObject];
        objeDet.Id = [results intForColumn:@"eId"];
        objeDet.noOfSlides = [results intForColumn:@"NoOfPages"];
        objeDet.versionNo = [results stringForColumn:@"version"];
        objeDet.brandName = [results stringForColumn:@"BrandClusterName"];
        objeDet.publishDate = [results stringForColumn:@"PublishDate"];
        objeDet.brandId = [results intForColumn:@"Id"];
        NSString * path = [NSString stringWithFormat:@"%@/%d",eDeTailorFolderPath,objeDet.Id];
        
        objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",path];
        
//         eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
//        objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",eDeTailorFolderPath];
        [arreDetailor addObject:objeDet];
        
    }

    for(int i =0; i < arreDetailor.count; i++)
    {
        eDetailor * objeDet = [arreDetailor objectAtIndex:i];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors"];
        eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
        eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
        NSString *eDeTailorThumFolderPath  = [eDeTailorFolderPath stringByAppendingString:@"/thumbnails/"];
        
        
        
        for(int j=0; j < objeDet.noOfSlides; j++)
        {
            eDetailorSlide * objeDetSlide = [[eDetailorSlide alloc]init];
            //objeDetSlide.Id = [results intForColumn:@"eswsdId"];
            objeDetSlide.slideNo = j+1;
            
            objeDetSlide.thumbPath = [NSString stringWithFormat:@"%@%d.png",eDeTailorThumFolderPath,objeDetSlide.slideNo];
            objeDetSlide.eDetailorId = objeDet.Id ;
            
            objeDetSlide.URLPath =[NSString stringWithFormat:@"%@%@",eDeTailorFolderPath,[self getSlideURLPath:objeDetSlide.slideNo]];
            
            NSString * state = nil;
            state = [NSString stringWithFormat:@"SELECT esd.EdetailerId,eswsd.SlideNo,spe.Name FROM  EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd,Specialisation spe where esd.EdetailerId=%d and esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=spe.id and SlideNo = %d",objeDet.Id,j+1];
            
            FMResultSet *results1 = [database executeQuery:state];
            
            NSMutableArray * arrTrg = [[NSMutableArray alloc]init];
            
            while([results1 next])
            {
               
                NSString * trg =  [results1 stringForColumn:@"Name"];
                [arrTrg addObject:trg];
                
            }
            
            NSString *target = [[NSString alloc] init];
            for(int i=0; i<arrTrg.count; i++)
            {
              
                NSString *strTemp = [arrTrg objectAtIndex:i];
                if(i == arrTrg.count-1)
                    target = [NSString stringWithFormat:@"%@ %@",target,strTemp];
                else
                    target = [NSString stringWithFormat:@"%@ %@,",target,strTemp];
            }
            
            objeDetSlide.TargetSpecialization = target;
            [objeDet.arrSlides addObject:objeDetSlide];
        }
        //
        //
        //        if(allSlidesFlag)
        //        {
        //                       state = [NSString stringWithFormat:@"SELECT esd.EdetailerId,eswsd.SlideNo,spe.Name FROM  EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd,Specialisation spe where esd.EdetailerId=%d and esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=spe.id and SlideNo = %d",objeDet.Id,i+1];
        //        }
        //        else
        //        {
        //            state = [NSString stringWithFormat:@"SELECT eswsd.Id as eswsdId, esd.EdetailerId,eswsd.SlideNo,spe.Name FROM  EdetailerSpecialisationDetail esd , EdetailerSlideWiseSpecDetail eswsd,Specialisation spe where esd.EdetailerId=%d and esd.Id=eswsd.EdetailerSpecialisationDetailId and esd.SpecialisationId=spe.id",objeDet.Id ];
        //        }
        //
        //         FMResultSet *results = [database executeQuery:state];
        //
        //        while([results next])
        //        {
        //            eDetailorSlide * objeDetSlide = [[eDetailorSlide alloc]init];
        //            //objeDetSlide.eDetailorId = [results intForColumn:@"Id"];
        //            objeDetSlide.Id = [results intForColumn:@"eswsdId"];
        //            objeDetSlide.slideNo = [results intForColumn:@"SlideNo"];
        //            objeDetSlide.TargetSpecialization = [results stringForColumn:@"Name"];
        //            objeDetSlide.thumbPath = [NSString stringWithFormat:@"%@slide%d_2x.png",eDeTailorThumFolderPath,objeDetSlide.slideNo];
        //            objeDetSlide.eDetailorId = objeDet.Id ;
        //
        //            objeDetSlide.URLPath =[NSString stringWithFormat:@"%@%@",eDeTailorFolderPath,[self getSlideURLPath:objeDetSlide.slideNo]];
        //            [objeDet.arrSlides addObject:objeDetSlide];
        //            
        //        }
    }
    [database close];
    
    return arreDetailor;
}

-(NSString *)getSlideURLPath : (int )slideNo
{
  
    NSString * countPath = [[NSString alloc]init];
    
    countPath = [NSString stringWithFormat:@"/%d",slideNo];
    
//    if(slideNo < 10)
//        countPath = [NSString stringWithFormat:@"/0%d",slideNo];
//    else
//        countPath = [NSString stringWithFormat:@"/%d",slideNo];
    
    countPath = [NSString stringWithFormat:@"%@/%d.html",countPath,slideNo];
    //countPath = [NSString stringWithFormat:@"%@/slide%d.html",countPath,slideNo+1];
    NSLog(@"%@",countPath);
    
    return countPath;
}

#pragma mark - Customers
-(NSMutableArray *)getCustomerList{
    
    [database open];
    NSMutableArray * arrDoctors = [[NSMutableArray alloc]init];
    
    NSString * state = [NSString stringWithFormat:@"SELECT s.Name as speName,*,q.Name as qName FROM doctor d left outer join specialisation s on (d.specialisationId = s.id) left outer join Qualification q on (d.QualificationId = q.id)"];
    FMResultSet *results = [database executeQuery:state];
    while([results next])
    {
        CustomerStruct * objCust = [[CustomerStruct alloc]init];
       
        objCust.Specialization = [results stringForColumn:@"speName"];
        objCust.Id = [results intForColumn:@"Id"];
        objCust.Name =[ NSString stringWithFormat:@"%@ %@",[results stringForColumn:@"FirstName"],[results stringForColumn:@"LastName"]];
        ;
         objCust.MobileNo= [results stringForColumn:@"MobileNo"];
         objCust.bestTime= [results stringForColumn:@"BestTime"];
         objCust.bestDay = [results stringForColumn:@"BestDay"];
         objCust.DOB = [results stringForColumn:@"DOB"];
         objCust.Qualification = [results stringForColumn:@"qName"];
        [arrDoctors addObject:objCust];
        
    }
    
    [database close];
    return arrDoctors;
}

#pragma mark - eDetailor update screen
-(NSMutableArray *)geteDetailors : (int )type{
    
    [database open];
    
    NSString * typeSTR = nil;
    if(type == 0)
        typeSTR = @"False";
    else
        typeSTR = @"True";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
  //  eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:@"/"];
  
    
//    Select *
//    
//    FROM Edetailer as e
//    
//    INNER JOIN FinancialYear AS f ON e.[FinancialYearId] = f.id
//    
//    INNER JOIN [Period] AS p ON e.[PeriodId] = p.id
//    
//    WHERE  cast(strftime('%m') as Integer) Between  p.[StartMonthNo] AND p.[EndMonthNo]
//    
   // AND strftime('%Y-%m-%d') Between f.[FinYearStartDate] AND f.[FinYearEndDate]
    
//    NSString * state = [NSString stringWithFormat:@"SELECT e.Id as eId,e.NoOfPages,e.version,b.BrandClusterName,e.PublishDate,b.Id FROM Edetailer e left outer join BrandCluster b on (e.BrandClusterId = b.Id) where e.isDownloaded = '%@'",typeSTR];
//
    
    NSString * state = [NSString stringWithFormat:@"Select e.isDownloaded,e.Id as eId,b.BrandClusterName,e.NoOfPages,e.version ,e.PublishDate,b.Id  FROM Edetailer as e INNER JOIN FinancialYear AS f ON e.[FinancialYearId] = f.id INNER JOIN [Period] AS p ON e.[PeriodId] = p.id left outer join BrandCluster b on (e.BrandClusterId = b.Id) where e.isDownloaded = '%@' and  cast(strftime('%%m') as Integer) Between  p.[StartMonthNo] AND p.[EndMonthNo] AND strftime('%%Y-%%m-%%d') Between f.[FinYearStartDate] AND f.[FinYearEndDate] ",typeSTR];
    
    
    FMResultSet *results = [database executeQuery:state];
    
    NSMutableArray * arreDetailors = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        eDetailor * objeDet = [[eDetailor alloc]init];
        [objeDet initObject];
        objeDet.Id = [results intForColumn:@"eId"];
        objeDet.noOfSlides = [results intForColumn:@"NoOfPages"];
        objeDet.versionNo = [results stringForColumn:@"version"];
        objeDet.brandName = [results stringForColumn:@"BrandClusterName"];
        objeDet.publishDate = [results stringForColumn:@"PublishDate"];
        objeDet.isDownloaded = [results intForColumn:@"isDownloaded"];
        objeDet.brandId = [results intForColumn:@"Id"];
//        eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d",objeDet.Id]];
//        objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",eDeTailorFolderPath];
        
        NSString * path = [NSString stringWithFormat:@"%@/%d",eDeTailorFolderPath,objeDet.Id];
        
        objeDet.imgPath = [NSString stringWithFormat:@"%@/preview.png",path];
//
        [arreDetailors addObject:objeDet];
        
    }
    
    [database close];
    return arreDetailors;
}

#pragma mark - Calender

-(NSMutableArray *)getLeaveForEmployee:(int)employeeId
{
    [database open];
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM LeaveApplication where EmployeeId = %d and Status = 'A';", employeeId];
    
    FMResultSet *results = [database executeQuery:sate];
    
    NSMutableArray * arrLeaves = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        Leave * objLeave = [[Leave alloc]init];
        objLeave.empId = [results intForColumn:@"EmployeeId"];
        objLeave.startDate = [results stringForColumn:@"LeaveFrom"];
        NSArray *arrStartDate = [objLeave.startDate componentsSeparatedByString:@" "];
        
        objLeave.endDate = [results stringForColumn:@"LeaveUpto"];
        NSArray *arrEndDate = [objLeave.endDate componentsSeparatedByString:@" "];
        
        objLeave.startDate = [NSString stringWithFormat:@"%@",[arrStartDate objectAtIndex:0]];
        objLeave.endDate = [NSString stringWithFormat:@"%@",[arrEndDate objectAtIndex:0]];
        NSInteger numberOfDays = [self returnNumberOfDays:objLeave.startDate withEndDate:objLeave.endDate];
        
        [arrLeaves addObject:objLeave.startDate];
        
        //""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//
        if(numberOfDays >0)
        {
            NSArray *arrStartDate = [objLeave.startDate componentsSeparatedByString:@"-"];
            
            NSInteger montn, year, day;
            year = [[arrStartDate objectAtIndex:0] integerValue];
            montn = [[arrStartDate objectAtIndex:1] integerValue];
            day = [[arrStartDate objectAtIndex:2] integerValue];
            
            for(int i=0; i<numberOfDays-1; i++)
            {
                NSInteger lastDate = [self getNumberofDays:montn YearVlue:year];
                {
                    if(montn == 12 && day == lastDate)
                    {
                        year++;
                        montn = 1;
                        day = 1;
                    }
                    else if(day == lastDate)
                    {
                        montn ++;
                        day = 1;
                    }
                    else
                        day++;
                }
                NSString *date = [NSString stringWithFormat:@"%d-%d-%d",year,montn,day];
                NSArray *arrmain = [date componentsSeparatedByString:@"-"];
                
                NSString *strMonth = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:1]];
                NSString *strDate = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:2]];
                
                if([strMonth length]<2)
                    strMonth = [NSString stringWithFormat:@"0%@",strMonth];
                
                if([strDate length]<2)
                    strDate = [NSString stringWithFormat:@"0%@",strDate];
                
                date = [NSString stringWithFormat:@"%@-%@-%@",[arrmain objectAtIndex:0],strMonth,strDate];
                
                [arrLeaves addObject:date];
            }
        }
        //""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//""""//
    }
    return arrLeaves;
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
    return [components day];
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

-(NSMutableArray *)getHolidays
{
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT hd.Date, h.Occassion FROM HolidayDate hd, Holiday h where hd.HolidayId = h.Id"];
    NSMutableArray * arrHolidays = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        NSString * date = nil, *name =nil;
        NSMutableDictionary * objDic = [[NSMutableDictionary alloc]init];
        
        date = [results stringForColumn:@"Date"];
        name = [results stringForColumn:@"Occassion"];
        //        date = [date stringByReplacingOccurrencesOfString:@" 00:00:00.000" withString:@""];
        
        NSArray *arrDate = [date componentsSeparatedByString:@" "];
        date= [NSString stringWithFormat:@"%@",[arrDate objectAtIndex:0]];
        [objDic setObject:date forKey:@"date"];
        [objDic setObject:name forKey:@"holidayName"];
        
        [arrHolidays addObject:objDic];
    }
    
    [database close];
    
    return arrHolidays;
}

-(NSMutableArray *)getCalenderData:(int)month year:(int)yr 
{
    [database open];
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
   // objApp.empId = @"5";

//    NSString * state = [NSString stringWithFormat:@"Select cr.CallReportDate AS Date, stp.FWPName AS FWPName,  count(cvd.id) as ExecutedCount FROM  CallReport as cr INNER JOIN  CallReportVisitDetail as cvd ON cr.Id = cvd.callReportId LEFT JOIN MonthlyTourProgram as mtp  ON mtp.mtpDate = cr.CallReportDate  LEFT JOIN StandardTourPlan as stp ON mtp.StandardTourPlanDayId = stp.StandardTourPlanDayId  WHERE cast (strftime('%%m',cr.[CallReportDate]) as integer)= %d AND cast (strftime('%%Y',cr.[CallReportDate]) as integer)= %d  and cr.[EmployeeId] = %d  GROUP BY cr.CallReportDate, stp.FWPName",month,yr,6];
//
//    NSString * state = [NSString stringWithFormat:@" Select cr.CallReportDate AS Date,fwp.FWPName AS FWPName,count(cvd.id) as ExecutedCount FROM   CallReport as cr INNER JOIN CallReportVisitDetail as cvd ON     cr.Id = cvd.callReportId INNER JOIN (SELECT   Distinct FWPName,b.[MTPDate] FROM StandardTourPlan a INNER JOIN MonthlyTourProgram b ON  a.[StandardTourPlanDayId] = b.StandardTourPlanDayId WHERE  cast (strftime('%%m',b. [MTPDate]) as integer)= %d   /* MonthNo */ AND cast (strftime('%%Y',b.[MTPDate]) as integer)= %d  /*YearNo */ AND cast (strftime('%%d',b.[MTPDate]) as integer)= %d  /*Day No */ ) as fwp ON cast (strftime('%%m',cr.[CallReportDate]) as integer)= cast (strftime('%%m',fwp.mtpDate) as integer) AND  cast (strftime('%%Y',cr.[CallReportDate]) as integer)= cast (strftime('%%Y',fwp.mtpDate) as integer) AND  cast (strftime('%%d',cr.[CallReportDate]) as integer)= cast (strftime('%%d',fwp.mtpDate) as integer)  WHERE cast (strftime('%%m',cr.[CallReportDate]) as integer)= %d  /* MonthNo */ AND cast (strftime('%%Y',cr.[CallReportDate]) as integer)= %d  /*YearNo */ AND cast (strftime('%%d',cr.[CallReportDate]) as integer)= %d  /*Day No */ AND cr.[EmployeeId] = %d  /*(EmployeeID)*/",month,yr,dt,month,yr,dt,[objDel.empId intValue]];
    
  NSString * state = [NSString stringWithFormat:@"Select mtp.mtpDate AS Date,stp.FWPName AS FWPName,count(distinct cvd.id) as ExecutedCount FROM MonthlyTourProgram as mtp LEFT join StandardTourPlan as stp ON   mtp.[StandardTourPlanDayId] = stp.StandardTourPlanDayId LEFT JOIN CallReport as cr ON cast (strftime('%%m',cr.[CallReportDate]) as integer)= cast (strftime('%%m',mtp.mtpDate) as integer) AND  cast (strftime('%%Y',cr.[CallReportDate]) as integer)= cast (strftime('%%Y',mtp.mtpDate) as integer) AND  cast (strftime('%%d',cr.[CallReportDate]) as integer)= cast (strftime('%%d',mtp.mtpDate) as integer) LEFT JOIN CallReportVisitDetail as cvd ON cr.Id = cvd.callReportId WHERE cast (strftime('%%m',mtp.[mtpDate]) as integer)= %d AND cast (strftime('%%Y',mtp.[mtpDate]) as integer)= %d AND mtp.[EmployeeId] = %d Group BY mtp.mtpDate ,stp.FWPName",month,yr,[objDel.empId intValue]];
    
    

    
    
    FMResultSet *results = [database executeQuery:state];
    
    NSMutableArray * arrCal = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        CalenderStruct * objCal = [[CalenderStruct alloc]init];
        objCal.FWPName          = [results stringForColumn:@"FWPName"];
        objCal.executedCount    = [results intForColumn:@"ExecutedCount"];
        objCal.date             = [results stringForColumn:@"Date"];
        [arrCal addObject:objCal];
        
    }
    
    [database close];
    return arrCal;
}


//get list of deviations
-(NSMutableArray *)getSTPListForDeviation
{
    [database open];
    
    NSString * state = [NSString stringWithFormat:@"SELECT Distinct stpd.Id,stp.FWPName FROM StandardTourPlan stp, StandardTourPlanDay stpd where stpd.Id = stp.StandardTourPlanDayId"];
    FMResultSet *results = [database executeQuery:state];
    
    NSMutableArray * arrSTP = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        STPDoctor * objSTPDoctor = [[STPDoctor alloc]init];
        objSTPDoctor.drName =[results stringForColumn:@"FWPName"];
        objSTPDoctor.Id = [results intForColumn:@"Id"];
        [arrSTP addObject:objSTPDoctor];
        
    }
    
    [database close];
    return arrSTP;
    
}

-(BOOL)checkForDeviationForCurrentDate
{
    BOOL bRet = NO;
    NSString * date = [Utils getCurrentDate];
    
    [database open];
    
    NSString * state = [NSString stringWithFormat:@" SELECT * from CallReportVisitDetail where ActionDate = '%@' and DoctorId IN ( SELECT DoctorId from StandardTourPlan where StandardTourPlanDayId = (SELECT StandardTourPlanDayId FROM MonthlyTourProgram where DATE(MTPDate) = '%@'))]",date,date];
    
    
    FMResultSet *results = [database executeQuery:state];
    
    while([results next])
    {
        bRet = YES;
    }
    
    [database close];
  
    return bRet;
    
}
//Update deviation
-(BOOL)updateDeviation : (NSString *)date STPDId : (int)Id
{
    [database open];
    BOOL bRet = YES;
    NSString * sate = [NSString stringWithFormat:@"UPDATE MonthlyTourProgram set StandardTourPlanDayId = %d , IsDeviated = 'True' where DATE(MTPDate) = '%@' ;", Id,date];
    
    NSLog(@"%@",sate);
    
    if( [database executeUpdate: sate])
        bRet = YES;
    else
        bRet = NO;
      [database close];
    return bRet;
}

#pragma mark - Update eDetailor
//Update deviation
-(BOOL)updateeDetailorDownloadStatus : (int)eDetailorId
{
    [database open];
    BOOL bRet = YES;
    NSString * sate = [NSString stringWithFormat:@"UPDATE Edetailer set isDownloaded = 'True' where Id = %d ;", eDetailorId];
    
    NSLog(@"%@",sate);
    
    if( [database executeUpdate: sate])
        bRet = YES;
    else
        bRet = NO;
    [database close];
    return bRet;
}

#pragma mark - STP screen
-(NSMutableArray *)getSTPDayList
{
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT  distinct stp.FWPName, stpd.Id FROM StandardTourPlanDay stpd, StandardTourPlan stp where stp.StandardTourPlanDayId = stpd.Id"];
    NSMutableArray * arrSTPD = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        STPD * objSTPD = [[STPD alloc]init];
        [objSTPD initObject];
        objSTPD.FWPName = [results stringForColumn:@"FWPName"];
        objSTPD.Id = [results intForColumn:@"Id"];
        [arrSTPD addObject:objSTPD];
    }
    
    for(int i=0;i<arrSTPD.count;i++)
    {
        STPD * objSTPD = [arrSTPD objectAtIndex:i];
        NSString * state = [NSString stringWithFormat:@"SELECT d.FirstName,d.LastName,d.Id,stp.FWPName, s.Name FROM StandardTourPlan stp , Specialisation s left outer join Doctor d on (stp.DoctorId = d.Id) where stp.StandardTourPlanDayId = %d and s.Id = d.SpecialisationId",objSTPD.Id];
        
        FMResultSet *results1 = [database executeQuery:state];
  
        while([results1 next])
        {
            STPDoctor * objSTPDoctor = [[STPDoctor alloc]init];
            objSTPDoctor.drName =[ NSString stringWithFormat:@"%@ %@",[results1 stringForColumn:@"FirstName"],[results1 stringForColumn:@"LastName"] ];
            objSTPDoctor.Id = [results1 intForColumn:@"Id"];
            objSTPDoctor.spcialization = [results1 stringForColumn:@"Name"];
            [objSTPD.arrDoctors addObject:objSTPDoctor];
        }

        
    }
    
    [database close];
    return arrSTPD;
}
-(NSMutableArray *)getSpecialisation
{
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT * FROM Specialisation"];
    NSMutableArray * arrSpecialisation = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        specialisationStruct * objSpc = [[specialisationStruct alloc]init];
        objSpc.name = [results stringForColumn:@"Name"];
        objSpc.abbrevation = [results stringForColumn:@"LastName"];
        objSpc.Id = [results intForColumn:@"SpecialisationId"];
        
        [arrSpecialisation addObject:objSpc];
    }
    
    [database close];
    return arrSpecialisation;
}

#pragma mark - Settings
-(NSMutableArray *)getSetting
{
     [database open];
    NSMutableArray * arrData = [[NSMutableArray alloc]init];
    [database open];
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    NSString * state = [NSString stringWithFormat:@"SELECT  e.FirstName ||' '|| e.LastName AS EmployeeName,l.Name[LocationName],e1.FirstName ||' '|| e1.LastName AS ManagerName,l1.Name[ManagerLocationName], e2.FirstName ||' '|| e2.LastName AS ZMName,l2.Name[ZMLocationName]  FROM  LocationEmployee le,LocationEmployee le1,LocationEmployee le2,  Employee e,Employee e1,Employee e2,Location l,Location l1,Location l2  WHERE le1.EmployeeId =%d AND le.Id = le1.LocationReportingId  AND le.LocationReportingId = le2.Id AND e.Version = %d AND e.Id = le1.EmployeeId AND e1.Id = le.EmployeeId AND e2.Id = le2.EmployeeId AND l.Id = le1.EmployeeId AND l1.Id = le.EmployeeId AND l2.Id = le2.EmployeeId",objDel.empId.intValue ,objDel.empVersion.intValue];
    
    FMResultSet *results = [database executeQuery:state];
    
    while([results next])
    {
        [arrData addObject:[results stringForColumn:@"EmployeeName"]];
        [arrData addObject:[results stringForColumn:@"LocationName"]];
        [arrData addObject:[results stringForColumn:@"ManagerName"]];
        [arrData addObject:[results stringForColumn:@"ManagerLocationName"]];
        [arrData addObject:[results stringForColumn:@"ZMName"]];
        [arrData addObject:[results stringForColumn:@"ZMLocationName"]];
        
    }
    
    [database close];
    return arrData;
}

#pragma mark - Login
-(BOOL)VerifyLoginWithUsername:(NSString *)userName password:(NSString *)pass
{
    BOOL ret = NO;
   
    [database open];
    
    NSString * state = [NSString stringWithFormat:@"SELECT * from Employee where UserId = '%@' and password = '%@'",userName,pass];
    FMResultSet *results = [database executeQuery:state];
    
    while([results next])
    {
        AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
        objDel.empId = [NSString  stringWithFormat:@"%d",[results intForColumn:@"Id"]];
        objDel.empVersion = [NSString  stringWithFormat:@"%d",[results intForColumn:@"Version"]];
        ret = YES;
    }
    
    [database close];
    return ret;
    
}

#pragma mark - Employee

-(NSString *)getEmpName : (int)empId
{
    NSString * name = nil;
    
    [database open];
    
    NSString * state = [NSString stringWithFormat:@"SELECT * from Employee where Id = %d",empId];
    FMResultSet *results = [database executeQuery:state];
    
    while([results next])
    {
        name= [NSString  stringWithFormat:@"%@ %@",[results stringForColumn:@"FirstName"],[results stringForColumn:@"LastName"]];
        
    }
    [database close];

    return name;
    
}
#pragma mark - DB Sync

-(void)startSync :(NSMutableArray *)array  isDelete:(BOOL)del
{
    isSyncDelete = del;
    [database open];
    for(int i = 0; i < array.count; i++)
    {
        SyncData * objData = [array objectAtIndex:i];
        [self syncTable:objData.methodName dataArray:objData.arrData];
    }
    [database close];
}
-(void)syncTable:(wsMethodNames)tableName dataArray:(NSMutableArray *)array
{
    switch (tableName)
    {
        case FinancialYear:
            [self syncFinancialTable:array];
            break;
        
        case Period:
            [self syncPeriod:array];
            break;
            
        case BrandCluster:
            [self syncBrandCluster:array];
            break;
            
        case Qualification:
            [self syncQualification:array];
            break;
        case Specialisation:
            [self syncSpecialisation:array];
            break;
            
        case LocationType:
            [self syncLocationType:array];
            break;
            
        case DivisionLocationType:
            [self syncDivisionLocationType:array];
            break;
            
        case Designation:
            [self syncDesignation:array];
            break;
            
        case DivisionDesignation:
            [self syncDivisionDesignation:array];
            break;
            
        case LocationEmployee:
            [self syncLocationEmployee:array];
            break;
            
        case Location:
            [self syncLocation:array];
            break;
            
        case HolidayDate:
            [self syncHolidayDate:array];
            break;
            
        case Employee:
            [self syncEmployee:array];
            break;
            
        case Doctor:
            [self syncDoctor:array];
            break;
            
        case DoctorBrandClusterMatrix:
            [self syncDoctorBrandClusterMatrix:array];
            break;
            
        case LeaveType:
            [self syncLeaveType:array];
            break;
            
        case LeaveApplication:
            [self syncLeaveApplication:array];
            break;
            
        case HolidayZone:
            [self syncHolidayZone:array];
            break;
            
        case HolidayZoneMap:
            [self syncHolidayZoneMap:array];
            break;
            
        case Holiday:
            [self syncHoliday:array];
            break;
            
        case Edetailer:
            [self syncEdetailer:array];
            break;
            
        case EdetailerSpecialisationDetail:
            [self syncEdetailerSpecialisationDetail:array];
            break;
            
        case EdetailerSlideWiseSpecDetail:
            [self syncEdetailerSlideWiseSpecDetail:array];
            break;
            
        case StandardTourPlanDay:
            [self syncStandardTourPlanDay:array ];
            
            break;
        case StandardTourPlantbl:
            [self syncStandardTourPlantbl:array];
            break;
            
        case MonthlyTourProgram:
            [self syncMonthlyTourProgram:array];
            break;
            
        default:
            break;
    }
}
-(BOOL)syncFinancialTable : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM FinancialYear where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
           NSLog(@"%@",@"DELETE FinancialYear Failed");
            bRet = NO;
        }

        return bRet;
    }
    
    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM FinancialYear where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
         
            NSString * sate = [NSString stringWithFormat:@"UPDATE FinancialYear set FinYearName = '%@', FinYearStartDate = '%@' , FinYearEndDate = '%@' where Id = %d ;",[data objectForKey:@"FinYearName"],[data objectForKey:@"FinYearStartDate"],[data objectForKey:@"FinYearEndDate"],[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                NSLog(@"%@",@"UPDATE FinancialYear Failed");
                break;
            }
            

            
            //UPdtae
        }
        else
        {
             //Insert
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into FinancialYear (Id,FinYearName,FinYearStartDate,FinYearEndDate) values (%d,'%@','%@','%@');",[num intValue],[data objectForKey:@"FinYearName"],[data objectForKey:@"FinYearStartDate"],[data objectForKey:@"FinYearEndDate"]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                NSLog(@"%@",@"INSERT FinancialYear Failed");
                bRet = NO;
                break;
            }
        }
    }
    
    return bRet;
}
-(BOOL)syncPeriod : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Period where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            NSLog(@"%@",@"DELETE FROM Period Failed");
            bRet = NO;
        }
        
        return bRet;
    }

    
    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Period where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"StartMonthNo"];
            NSNumber * n2 = [data objectForKey:@"EndMonthNo"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE Period set Name = '%@', StartMonthNo = %d , EndMonthNo = %d where Id = %d ;",[data objectForKey:@"Name"],n1.intValue,n2.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                 NSLog(@"%@",@"UPDATE FROM Period Failed");
                bRet = NO;
                break;
            }
            
        
        
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"StartMonthNo"];
            NSNumber * n2 = [data objectForKey:@"EndMonthNo"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into Period (Id,Name,StartMonthNo,EndMonthNo) values (%d,'%@',%d,%d);",[num intValue],[data objectForKey:@"Name"],n1.intValue,n2.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                 NSLog(@"%@",@"INSERT Period Failed");
                bRet = NO;
                break;
            }
        }
    
    }
    return bRet;

}
-(BOOL)syncBrandCluster : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM BrandCluster where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
              NSLog(@"%@",@"DELETE BrandCluster Failed");
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM BrandCluster where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
      
            NSString * sate = [NSString stringWithFormat:@"UPDATE BrandCluster set BrandClusterName = '%@', BrandClusterAbbr = '%@' , DivisionId = %d where Id = %d ;",[data objectForKey:@"BrandClusterName"],[data objectForKey:@"BrandClusterAbbr"],n1.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                  NSLog(@"%@",@"UPDATE BrandCluster Failed");
                
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into BrandCluster (Id,BrandClusterName,BrandClusterAbbr,DivisionId) values (%d,'%@','%@',%d);",[num intValue],[data objectForKey:@"BrandClusterName"],[data objectForKey:@"BrandClusterAbbr"],n1.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                 NSLog(@"%@",@"INSERT BrandCluster Failed");
                bRet = NO;
                break;
            }
        }
    }
    
    return bRet;

 }
    
-(BOOL)syncQualification : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Qualification where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
             NSLog(@"%@",@"DELETE FROM Qualification Failed");
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Qualification where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
             NSString * sate = [NSString stringWithFormat:@"UPDATE Qualification set Name = '%@', Abbreviation = '%@' where Id = %d ;",[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                   NSLog(@"%@",@"UPDATE FROM Qualification Failed");
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
          
            NSString * sate = [NSString stringWithFormat:@"INSERT into Qualification (Id,Name,Abbreviation) values (%d,'%@','%@');",[num intValue],[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                 NSLog(@"%@",@"INSERT FROM Qualification Failed");
                bRet = NO;
                break;
            }
        }
    }
    
        return bRet;
        

}
-(BOOL)syncSpecialisation : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Specialisation where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
              NSLog(@"%@",@"INSERT Specialisation Failed");
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Specialisation where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSString * sate = [NSString stringWithFormat:@"UPDATE Specialisation set Name = '%@', Abbreviation = '%@' where Id = %d ;",[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                 NSLog(@"%@",@"UPDATE Specialisation Failed");
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into Specialisation (Id,Name,Abbreviation) values (%d,'%@','%@');",[num intValue],[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                 NSLog(@"%@",@"INSERT Specialisation Failed");
                bRet = NO;
                break;
            }
        }
    }
    
        return bRet;

}

-(BOOL)syncLocationType : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM LocationType where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            NSLog(@"%@",@"DELETE LocationType Failed");
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM LocationType where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"SortOrder"];
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE LocationType set Name = '%@', Abbreviation = '%@',SortOrder = %d where Id = %d ;",[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],n1.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                NSLog(@"%@",@"UPDATE LocationType Failed");
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
             NSNumber * n1 = [data objectForKey:@"SortOrder"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into LocationType (Id,Name,Abbreviation,SortOrder) values (%d,'%@','%@',%d);",[num intValue],[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],n1.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
}

-(BOOL)syncDivisionLocationType : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM DivisionLocationType where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM DivisionLocationType where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            NSNumber * n2 = [data objectForKey:@"LocationTypeId"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE DivisionLocationType set DivisionId = %d, LocationTypeId =  %d where Id = %d ;",n1.intValue,n2.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            NSNumber * n2 = [data objectForKey:@"LocationTypeId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into DivisionLocationType (Id,DivisionId,LocationTypeId) values (%d,%d,%d);",[num intValue],n1.intValue,n2.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
}


-(BOOL)syncDesignation : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Designation where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Designation where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"LocationTypeId"];
            NSNumber * n2 = [data objectForKey:@"ReportingId"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE Designation set Description = '%@', Abbreviation =  '%@', LocationTypeId = %d, ReportingId = %d where Id = %d ;",[data objectForKey:@"Description"],[data objectForKey:@"Abbreviation"],n1.intValue,n2.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            NSNumber * n2 = [data objectForKey:@"LocationTypeId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into Designation (Id,Description,Abbreviation,LocationTypeId,ReportingId) values (%d,'%@','%@',%d,%d);",[num intValue],[data objectForKey:@"Description"],[data objectForKey:@"Abbreviation"],n1.intValue,n2.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;

}


-(BOOL)syncDivisionDesignation : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM DivisionDesignation where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM DivisionDesignation where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            NSNumber * n2 = [data objectForKey:@"DesignationId"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE DivisionDesignation set DivisionId = %d, DesignationId = %d where Id = %d ;",n1.intValue,n2.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            NSNumber * n2 = [data objectForKey:@"DesignationId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into DivisionDesignation (Id,DivisionId,DesignationId) values (%d,%d,%d);",[num intValue],n1.intValue,n2.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
    }
    
        return bRet;
        
   }

-(BOOL)syncLocationEmployee : (NSMutableArray * )arrData
{
   
    
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM LocationEmployee where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM LocationEmployee where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"LocationId"];
            NSNumber * n2 = [data objectForKey:@"EmployeeId"];
            NSNumber * n3 = [data objectForKey:@"LocationReportingId"];
            NSNumber * n4 = [data objectForKey:@"Version"];
            NSNumber * n5 = [data objectForKey:@"EmployeeVersion"];
            NSNumber * n6 = [data objectForKey:@"LocationReportingVersion"];
            NSNumber * n7 = [data objectForKey:@"HolidayZoneId"];
            
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE LocationEmployee set LocationId = %d, EmployeeId = %d, LocationReportingId = %d, Version = %d, EmployeeVersion = %d,LocationReportingVersion = %d,HolidayZoneId = %d where Id = %d ;",n1.intValue,n2.intValue,n3.intValue,n4.intValue,n5.intValue,n6.intValue,n7.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"LocationId"];
            NSNumber * n2 = [data objectForKey:@"EmployeeId"];
            NSNumber * n3 = [data objectForKey:@"LocationReportingId"];
            NSNumber * n4 = [data objectForKey:@"Version"];
            NSNumber * n5 = [data objectForKey:@"EmployeeVersion"];
            NSNumber * n6 = [data objectForKey:@"LocationReportingVersion"];
            NSNumber * n7 = [data objectForKey:@"HolidayZoneId"];

            NSString * sate = [NSString stringWithFormat:@"INSERT into LocationEmployee (Id,LocationId,EmployeeId,LocationReportingId,Version,EmployeeVersion,LocationReportingVersion,HolidayZoneId) values (%d,%d,%d,%d,%d,%d,%d,%d);",[num intValue],n1.intValue,n2.intValue,n3.intValue,n4.intValue,n5.intValue,n6.intValue,n7.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
        
   }

-(BOOL)syncLocation : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Location where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Location where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"DivisionLocationTypeId"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE Location set Code = '%@', Name = '%@', DivisionLocationTypeId = %d where Id = %d ;",[data objectForKey:@"Code"],[data objectForKey:@"Name"],n1.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"DivisionLocationTypeId"];
           
            NSString * sate = [NSString stringWithFormat:@"INSERT into Location (Id,Code,Name,DivisionLocationTypeId) values (%d,'%@','%@',%d);",[num intValue],[data objectForKey:@"Code"],[data objectForKey:@"Name"],n1.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
    }
    
        return bRet;

    
   }
-(BOOL)syncEmployee : (NSMutableArray * )arrData
{
   
    
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Employee where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Employee where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"Version"];
            NSNumber * n2 = [data objectForKey:@"DivisionDesignationId"];
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE Employee set Version = %d, Code = '%@', FirstName = '%@', LastName = '%@' ,UserId = '%@' ,Password = '%@' , MobileNo = '%@' , DivisionDesignationId = %d ,Email = '%@' where Id = %d ;",n1.intValue,[data objectForKey:@"Code"],[data objectForKey:@"FirstName"],[data objectForKey:@"LastName"],[data objectForKey:@"UserId"],[data objectForKey:@"Password"],[data objectForKey:@"MobileNo"],n2.intValue,[data objectForKey:@"Email"],[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"Version"];
            NSNumber * n2 = [data objectForKey:@"DivisionDesignationId"];
          
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into Employee (Id,Version,Code,FirstName,LastName,UserId,Password,MobileNo,DivisionDesignationId,Email) values (%d,%d,'%@','%@','%@','%@','%@','%@',%d,'%@');",[num intValue],n1.intValue,[data objectForKey:@"Code"],[data objectForKey:@"FirstName"],[data objectForKey:@"LastName"],[data objectForKey:@"UserId"],[data objectForKey:@"Password"],[data objectForKey:@"MobileNo"],n2.intValue,[data objectForKey:@"Email"]];
                               NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
                               }
        return bRet;
        
        

}
-(BOOL)syncDoctor : (NSMutableArray * )arrData
{
  
    
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Doctor where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Doctor where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"QualificationId"];
            NSNumber * n2 = [data objectForKey:@"SpecialisationId"];
            NSNumber * n3 = [data objectForKey:@"LocationEmployeeId"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE Doctor set Salutation = '%@', FirstName = '%@', MiddleName = '%@', LastName = '%@' ,Gender = '%@' , MobileNo = '%@' ,Email = '%@' ,DOB = '%@',QualificationId = %d,SpecialisationId = %d,BestDay = '%@',BestTime = '%@',LocationEmployeeId = %d where Id = %d ;",[data objectForKey:@"Salutation"],[data objectForKey:@"FirstName"],[data objectForKey:@"MiddleName"],[data objectForKey:@"LastName"],[data objectForKey:@"Gender"],[data objectForKey:@"MobileNo"],[data objectForKey:@"Email"],[data objectForKey:@"DOB"],n1.intValue,n2.intValue,[data objectForKey:@"BestDay"],[data objectForKey:@"BestTime"],n3.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"QualificationId"];
            NSNumber * n2 = [data objectForKey:@"SpecialisationId"];
            NSNumber * n3 = [data objectForKey:@"LocationEmployeeId"];
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into Doctor (Id,                              Salutation,FirstName,MiddleName,LastName,Gender,MobileNo,Email,DOB,QualificationId,SpecialisationId,BestDay,BestTime,LocationEmployeeId) values (%d,'%@','%@','%@','%@','%@','%@','%@','%@',%d,%d,'%@','%@',%d);",[num intValue],[data objectForKey:@"Salutation"],[data objectForKey:@"FirstName"],[data objectForKey:@"MiddleName"],[data objectForKey:@"LastName"],[data objectForKey:@"Gender"],[data objectForKey:@"MobileNo"],[data objectForKey:@"Email"],[data objectForKey:@"DOB"],n1.intValue,n2.intValue,[data objectForKey:@"BestDay"],[data objectForKey:@"BestTime"],n3.intValue];
                               NSLog(@"%@",sate);
                               
                               if( [database executeUpdate: sate])
                               bRet = YES;
                               else
                               {
                                   bRet = NO;
                                   break;
                               }
                               }
                               
                               }
                               return bRet;
}

-(BOOL)syncDoctorBrandClusterMatrix : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM DoctorBrandClusterMatrix where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM DoctorBrandClusterMatrix where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"DoctorId"];
            NSNumber * n2 = [data objectForKey:@"BrandClusterId"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE DoctorBrandClusterMatrix set DoctorId = %d, BrandClusterId = %d, ActionDate = '%@', ActionBy = '%@', IsActive = '%@' where Id = %d ;",n1.intValue,n2.intValue,[data objectForKey:@"ActionDate"],[data objectForKey:@"ActionBy"],@"True",[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"DoctorId"];
            NSNumber * n2 = [data objectForKey:@"BrandClusterId"];
           
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into DoctorBrandClusterMatrix (Id,DoctorId,BrandClusterId,ActionDate,ActionBy,IsActive) values (%d,%d,%d,'%@','%@','%@');",[num intValue],n1.intValue,n2.intValue,[data objectForKey:@"ActionDate"],[data objectForKey:@"ActionBy"],[data objectForKey:@"IsActive"]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
    }
    
        return bRet;

   
}

-(BOOL)syncLeaveType : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM LeaveType where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM LeaveType where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSString * sate = [NSString stringWithFormat:@"UPDATE LeaveType set Name = '%@', Abbreviation = '%@' where Id = %d ;",[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into LeaveType (Id,Name,Abbreviation) values (%d,'%@','%@');",[num intValue],[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
    
   }
-(BOOL)syncLeaveApplication : (NSMutableArray * )arrData
{
 
    
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM LeaveApplication where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM LeaveApplication where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
     
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"EmployeeId"];
            NSNumber * n2 = [data objectForKey:@"LeaveTypeId"];
            NSNumber * n3 = [data objectForKey:@"EmployeeVersion"];
            NSNumber * n4 = [data objectForKey:@"LeaveCount"];
            
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE LeaveApplication set EmployeeId = %d, LeaveTypeId = %d ,AppliedDate = '%@',LeaveFrom = '%@',LeaveUpto = '%@',Halfday = '%@',LeaveCount = %d,Status = '%@',EmployeeVersion = %d where Id = %d ;",n1.intValue,n2.intValue,[data objectForKey:@"AppliedDate"],[data objectForKey:@"LeaveFrom"],[data objectForKey:@"LeaveUpto"],[data objectForKey:@"Halfday"],n4.intValue,[data objectForKey:@"Status"],n3.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            
            NSNumber * n1 = [data objectForKey:@"EmployeeId"];
            NSNumber * n2 = [data objectForKey:@"LeaveTypeId"];
            NSNumber * n3 = [data objectForKey:@"EmployeeVersion"];
            NSNumber * n4 = [data objectForKey:@"LeaveCount"];
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into LeaveApplication (Id,EmployeeId,LeaveTypeId,AppliedDate,LeaveFrom,LeaveUpto,Halfday,LeaveCount,Status,EmployeeVersion) values (%d,%d,%d,'%@','%@','%@','%@',%d,'%@',%d);",[num intValue],n1.intValue,n2.intValue,[data objectForKey:@"AppliedDate"],[data objectForKey:@"LeaveFrom"],[data objectForKey:@"LeaveUpto"],[data objectForKey:@"Halfday"],n4.intValue,[data objectForKey:@"Status"],n3.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
 
}
-(BOOL)syncHolidayZone : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM HolidayZone where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM HolidayZone where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE HolidayZone set Name = '%@', Abbreviation = '%@',DivisionId = %d where Id = %d ;",[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],n1.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into HolidayZone (Id,Name,Abbreviation,DivisionId) values (%d,'%@','%@',%d);",[num intValue],[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],n1.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;

        
   }
-(BOOL)syncHolidayZoneMap : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM HolidayZoneMap where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM HolidayZoneMap where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"HolidayId"];
            NSNumber * n2 = [data objectForKey:@"HolidayZoneId"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE HolidayZoneMap set HolidayId = %d, HolidayZoneId = %d where Id = %d ;",n1.intValue,n2.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"HolidayId"];
            NSNumber * n2 = [data objectForKey:@"HolidayZoneId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into HolidayZoneMap (Id,HolidayId,HolidayZoneId) values (%d,%d,%d);",[num intValue],n1.intValue,n2.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
        

}

-(BOOL)syncHoliday : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Holiday where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Holiday where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }

        if(bFound)
        {
          
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE Holiday set Occassion = '%@', OccassionCode = '%@' where Id = %d ;",[data objectForKey:@"Occassion"],[data objectForKey:@"OccassionCode"],[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
           
            NSString * sate = [NSString stringWithFormat:@"INSERT into Holiday (Id,Occassion,OccassionCode) values (%d,'%@','%@');",[num intValue],[data objectForKey:@"Occassion"],[data objectForKey:@"OccassionCode"]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
        
    }
-(BOOL)syncHolidayDate : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM HolidayDate where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM HolidayDate where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
       
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"HolidayId"];
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE HolidayDate set HolidayId = %d, Date = '%@' where Id = %d ;",n1.intValue,[data objectForKey:@"Date"],[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            
            NSNumber * n1 = [data objectForKey:@"HolidayId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into HolidayDate (Id,HolidayId,Date) values (%d,%d,'%@');",[num intValue],n1.intValue,[data objectForKey:@"Date"]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;

        
    }
-(BOOL)syncEdetailer : (NSMutableArray * )arrData
{
  
    
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM Edetailer where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Edetailer where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
         if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"BrandClusterId"];
             NSNumber * n2 = [data objectForKey:@"PeriodId"];
             NSNumber * n3 = [data objectForKey:@"NoOfPages"];
             NSNumber * n4 = [data objectForKey:@"isDownloaded"];
             NSNumber * n5 = [data objectForKey:@"Version"];
            
            NSString * str = nil;
            if(n4.intValue == 0)
                str= @"False";
            else
                str = @"True";
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE Edetailer set BrandClusterId = %d, PeriodId = %d,NoOfPages = %d, version = %d ,PublishDate = '%@',isDownloaded = '%@' where Id = %d ;",n1.intValue,n2.intValue,n3.intValue,n5.intValue,[data objectForKey:@"PublishDate"],str,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            
            NSNumber * n1 = [data objectForKey:@"BrandClusterId"];
            NSNumber * n2 = [data objectForKey:@"PeriodId"];
            NSNumber * n3 = [data objectForKey:@"NoOfPages"];
            NSNumber * n4 = [data objectForKey:@"isDownloaded"];
            NSNumber * n5 = [data objectForKey:@"Version"];
            
            NSString * str = nil;
            if(n4.intValue == 0)
                str= @"False";
            else
                str = @"True";
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into Edetailer (Id,BrandClusterId,PeriodId,NoOfPages,version,PublishDate,isDownloaded) values (%d,%d,%d,%d,%d,'%@','%@');",[num intValue],n1.intValue,n2.intValue,n3.intValue,n5.intValue,[data objectForKey:@"PublishDate"],str];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;

        
}
-(BOOL)syncEdetailerSpecialisationDetail : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM EdetailerSpecialisationDetail where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
      for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM EdetailerSpecialisationDetail where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"EdetailerId"];
            NSNumber * n2 = [data objectForKey:@"SpecialisationId"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE EdetailerSpecialisationDetail set EdetailerId = %d, SpecialisationId = %d where Id = %d ;",n1.intValue,n2.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"EdetailerId"];
            NSNumber * n2 = [data objectForKey:@"SpecialisationId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into EdetailerSpecialisationDetail (Id,EdetailerId,SpecialisationId) values (%d,%d,%d);",[num intValue],n1.intValue,n2.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
    }
    
        return bRet;
        
        

    
}
-(BOOL)syncEdetailerSlideWiseSpecDetail : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM EdetailerSlideWiseSpecDetail where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM EdetailerSlideWiseSpecDetail where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"EdetailerSpecialisationDetailId"];
            NSNumber * n2 = [data objectForKey:@"SlideNo"];
            NSString * sate = [NSString stringWithFormat:@"UPDATE EdetailerSlideWiseSpecDetail set EdetailerSpecialisationDetailId = %d, SlideNo = %d where Id = %d ;",n1.intValue,n2.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"EdetailerSpecialisationDetailId"];
            NSNumber * n2 = [data objectForKey:@"SlideNo"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into EdetailerSlideWiseSpecDetail (Id,EdetailerSpecialisationDetailId,SlideNo) values (%d,%d,%d);",[num intValue],n1.intValue,n2.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
        
        
}
-(BOOL)syncStandardTourPlanDay : (NSMutableArray * )arrData
{
    BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM StandardTourPlanDay where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM StandardTourPlanDay where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE StandardTourPlanDay set Name = '%@', Abbreviation = '%@',DivisionId = %d where Id = %d ;",[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],n1.intValue,[num intValue]];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"DivisionId"];
            NSString * sate = [NSString stringWithFormat:@"INSERT into StandardTourPlanDay (Id,Name,Abbreviation,DivisionId) values (%d,'%@','%@',%d);",[num intValue],[data objectForKey:@"Name"],[data objectForKey:@"Abbreviation"],n1.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
        
    }
        return bRet;
        

        
    }
-(BOOL)syncStandardTourPlantbl : (NSMutableArray * )arrData
{
     BOOL bRet = YES;
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM StandardTourPlan where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    

    
    for(int i =0; i< arrData.count; i++)
    {
        BOOL bFound = NO;
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM StandardTourPlan where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
      
        
        if(bFound)
        {
             NSNumber * n1 = [data objectForKey:@"StandardTourPlanDayId"];
             NSNumber * n2 = [data objectForKey:@"DoctorId"];
             NSNumber * n3 = [data objectForKey:@"EmployeeId"];
             NSNumber * n4 = [data objectForKey:@"EmployeeVersion"];
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE StandardTourPlan set StandardTourPlanDayId = %d, FWPName = '%@',DoctorId = %d ,EmployeeId = %d ,EmployeeVersion = %d where Id = %d ;",n1.intValue,[data objectForKey:@"FWPName"],n2.intValue,n3.intValue,n4.intValue,[num intValue]];
            
          
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
                       //Insert
            NSNumber * n1 = [data objectForKey:@"StandardTourPlanDayId"];
            NSNumber * n2 = [data objectForKey:@"DoctorId"];
            NSNumber * n3 = [data objectForKey:@"EmployeeId"];
            NSNumber * n4 = [data objectForKey:@"EmployeeVersion"];
            
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into StandardTourPlan (Id,StandardTourPlanDayId,FWPName,DoctorId,EmployeeId,EmployeeVersion) values (%d,%d,'%@',%d,%d,%d);",[num intValue],n1.intValue,[data objectForKey:@"FWPName"],n2.intValue,n3.intValue,n4.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
    }
    
        return bRet;
        
}
-(BOOL)syncMonthlyTourProgram : (NSMutableArray * )arrData
{
   
                                  
    
    BOOL bRet = YES;
    
    
    if(isSyncDelete)
    {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"(0"];
        for(int i =0; i< arrData.count; i++)
        {
            NSDictionary * data = [arrData objectAtIndex:i];
            [str appendString:@","];
            NSNumber * num = [data objectForKey:@"Id"];
            [str appendString:[NSString stringWithFormat:@"%d",num.intValue]];
            
        }
        [str appendString:@");"];
        
        NSString * sate = [NSString stringWithFormat:@"DELETE FROM MonthlyTourProgram where Id IN %@",str];
        
        NSLog(@"%@",sate);
        
        if( [database executeUpdate: sate])
            bRet = YES;
        else
        {
            bRet = NO;
        }
        
        return bRet;
    }
    
    BOOL bFound1 = NO;
    
    for(int i =0; i< arrData.count; i++)
    {
        bFound1 = YES;
          BOOL bFound = NO;
      
        NSDictionary * data = [arrData objectAtIndex:i];
        NSNumber * num = [data objectForKey:@"Id"];
        NSString * sate = [NSString stringWithFormat:@"SELECT * FROM MonthlyTourProgram where Id =  %d",[num intValue]];
        
        FMResultSet *results = [database executeQuery:sate];
        
        while([results next])
        {
            bFound = YES;
        }
        
     
        
        
        
        if(bFound)
        {
            NSNumber * n1 = [data objectForKey:@"StandardTourPlanDayId"];
            NSNumber * n2 = [data objectForKey:@"EmployeeId"];
            NSNumber * n3 = [data objectForKey:@"IsDeviated"];
            NSNumber * n4 = [data objectForKey:@"IsActive"];
            NSNumber * n5 = [data objectForKey:@"EmployeeVersion"];
        
            
            NSString * sate = [NSString stringWithFormat:@"UPDATE MonthlyTourProgram set MTPDate = '%@', StandardTourPlanDayId = %d,EmployeeId = %d ,ApprovalStatus = '%@' ,IsDeviated = %d,ActionDate ='%@', ActionBy ='%@',IsActive = %d,EmployeeVersion = %d where Id = %d ;",[data objectForKey:@"MTPDate"],n1.intValue,n2.intValue,[data objectForKey:@"ApprovalStatus"],n3.intValue,[data objectForKey:@"ActionDate"],[data objectForKey:@"ActionBy"],n4.intValue,n5.intValue,[num intValue]];
            
            
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
            
            
            
            //UPdtae
        }
        else
        {
            //Insert
            NSNumber * n1 = [data objectForKey:@"StandardTourPlanDayId"];
            NSNumber * n2 = [data objectForKey:@"EmployeeId"];
            NSNumber * n3 = [data objectForKey:@"IsDeviated"];
            NSNumber * n4 = [data objectForKey:@"IsActive"];
            NSNumber * n5 = [data objectForKey:@"EmployeeVersion"];
            
            
            NSString * sate = [NSString stringWithFormat:@"INSERT into MonthlyTourProgram (Id,MTPDate,StandardTourPlanDayId,EmployeeId,ApprovalStatus,IsDeviated,ActionDate,ActionBy,IsActive,EmployeeVersion) values (%d,'%@',%d,%d,'%@',%d,'%@','%@',%d,%d);",[num intValue],[data objectForKey:@"MTPDate"],n1.intValue,n2.intValue,[data objectForKey:@"ApprovalStatus"],n3.intValue,[data objectForKey:@"ActionDate"],[data objectForKey:@"ActionBy"],n4.intValue,n5.intValue];
            
            NSLog(@"%@",sate);
            
            if( [database executeUpdate: sate])
                bRet = YES;
            else
            {
                bRet = NO;
                break;
            }
        }
    }
    
    
    if(bFound1)
   {
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"MTPSchedule"];
    [defaults synchronize];
   
   }
        return bRet;

}



#pragma mark - Upload on server

-(NSMutableArray *)getScheduleDataForUpload
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
    NSString * date = [defaults objectForKey:@"LastSync"];
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM Schedule where ActionDate > '%@'",date];
    
    FMResultSet *results = [database executeQuery:sate];
    
//    FMResultSet *results = [database executeQuery:@"SELECT * FROM Schedule where ActionDate > '2014-11-16'"];
    
    //get from schedule table

    while([results next])
    {
       NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeId"]] forKey:@"EmployeeId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeVersion"]]  forKey:@"EmployeeVersion"];
      
        [myMutableDictionary setObject:[results stringForColumn:@"Date"]  forKey:@"Date"];
        [myMutableDictionary setObject:[results stringForColumn:@"CallType"]  forKey:@"CallType"];
        [myMutableDictionary setObject:[results stringForColumn:@"CallObjective"]  forKey:@"CallObjective"];
        [myMutableDictionary setObject:[results stringForColumn:@"IsCallCompleted"]  forKey:@"IsCallCompleted"];
        
        [myMutableDictionary setObject:[results stringForColumn:@"EmployeeVersion"]  forKey:@"EmployeeVersion"];
        
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"IsActive"]]  forKey:@"IsActive"];
        
      
        [arrSchedule addObject:myMutableDictionary];
    }
     [database close];
    return arrSchedule;

}


-(NSMutableArray *)getScheduleCallDataForUpload
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
   // FMResultSet *results = [database executeQuery:@"SELECT * FROM ScheduleCall"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * date = [defaults objectForKey:@"LastSync"];
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM ScheduleCall where ActionDate > '%@'",date];
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    FMResultSet *results = [database executeQuery:sate];
    
    //get from schedule table
    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"ScheduleId"]] forKey:@"ScheduleId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"DoctorId"]]  forKey:@"DoctorId"];
        [myMutableDictionary setObject:[results stringForColumn:@"DoctorName"] forKey:@"DoctorName"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"IsActive"]]  forKey:@"IsActive"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[objDel.empId intValue]]  forKey:@"EmployeeId"];
        
        [arrSchedule addObject:myMutableDictionary];
    }
     [database close];
    return arrSchedule;
    
}


-(NSMutableArray *)getScheduleContentDataForUpload
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    NSString * date = [defaults objectForKey:@"LastSync"];
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM ScheduleContent where ActionDate > '%@'",date];
     FMResultSet *results = [database executeQuery:sate];
    
  //  FMResultSet *results = [database executeQuery:@"SELECT * FROM ScheduleContent"];
    
    //get from schedule table
    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"ScheduleId"]] forKey:@"ScheduleId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EdetailerId"]]  forKey:@"EdetailerId"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"IsActive"]]  forKey:@"IsActive"];
           [myMutableDictionary setObject:[NSNumber numberWithInt:[objDel.empId intValue]]  forKey:@"EmployeeId"];
        
        [arrSchedule addObject:myMutableDictionary];
    }
     [database close];
    return arrSchedule;
    
}

-(NSMutableArray *)getMonthlyTourPlanDataForUpload // TODO
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * lastSyncDate = [defaults objectForKey:@"LastSync"];
    
      NSString * sate = [NSString stringWithFormat:@"SELECT * FROM MonthlyTourProgram where ActionDate > '%@'",lastSyncDate];
        FMResultSet *results = [database executeQuery:sate];
   // FMResultSet *results = [database executeQuery:@"SELECT * FROM MonthlyTourProgram where ActionDate > %@", lastSyncDate];
    
    //get from schedule table
    
//    CREATE TABLE [MonthlyTourProgram] (
//                                       [Id] int NOT NULL,
//                                       [RowId] INTEGER PRIMARY KEY AUTOINCREMENT,
//                                       [MTPDate] datetime NOT NULL,
//                                       [StandardTourPlanDayId] int,
//                                       [EmployeeId] int NOT NULL,
//                                       [ApprovalStatus] char, 
//                                       [IsDeviated] bit NOT NULL,   
//                                       [EmployeeVersion] INT
//                                       [ActionDate] [datetime] NOT NULL,
//                                       [ActionBy] [varchar](15) NOT NULL,
//                                       [IsActive] [bit] NOT NULL)
    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"StandardTourPlanDayId"]] forKey:@"StandardTourPlanDayId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeId"]]  forKey:@"EmployeeId"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"IsActive"]]  forKey:@"IsActive"];
        [myMutableDictionary setObject:[results stringForColumn:@"ApprovalStatus"]  forKey:@"ApprovalStatus"];
        [myMutableDictionary setObject:[results stringForColumn:@"MTPDate"]  forKey:@"MTPDate"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeVersion"]]  forKey:@"EmployeeVersion"];
        
        
        [arrSchedule addObject:myMutableDictionary];
    }
    [database close];
    return arrSchedule;
    
}
-(NSMutableArray *)getDoctorBrandClusterMatrixDataForUpload // TODO
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * lastSyncDate = [defaults objectForKey:@"LastSync"];
    
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM DoctorBrandClusterMatrix where ActionDate > '%@'",lastSyncDate];
    FMResultSet *results = [database executeQuery:sate];
    
    //FMResultSet *results = [database executeQuery:@"SELECT * FROM DoctorBrandClusterMatrix where ActionDate > %@",lastSyncDate];
    
//    CREATE TABLE [DoctorBrandClusterMatrix] (
//                                             [Id] int  NULL,
//                                             [RowId] INTEGER PRIMARY KEY AUTOINCREMENT,
//                                             [DoctorId] int NOT NULL,
//                                             [BrandClusterId] int NOT NULL,
//                                             [ActionDate] [datetime] NOT NULL,
//                                             [ActionBy] [varchar](15) NOT NULL,
//                                             [IsActive] [bit] NOT NULL 
//                                             )                              [IsActive] [bit] NOT NULL)
//    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"DoctorId"]] forKey:@"DoctorId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"BrandClusterId"]]  forKey:@"BrandClusterId"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[results stringForColumn:@"IsActive"]  forKey:@"IsActive"];
      
        
        
        [arrSchedule addObject:myMutableDictionary];
    }
    [database close];
    return arrSchedule;
    
}

-(NSMutableArray *)getCallReportDataForUpload
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
   // FMResultSet *results = [database executeQuery:@"SELECT * FROM CallReport"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * date = [defaults objectForKey:@"LastSync"];
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM CallReport where ActionDate > '%@'",date];
    
    FMResultSet *results = [database executeQuery:sate];

    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]] forKey:@"RowId"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeId"]] forKey:@"EmployeeId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeVersion"]]  forKey:@"EmployeeVersion"];
        [myMutableDictionary setObject:[results stringForColumn:@"CallReportDate"]  forKey:@"CallReportDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"IsActive"]]  forKey:@"IsActive"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        
        
        [arrSchedule addObject:myMutableDictionary];
    }
     [database close];
    return arrSchedule;
    
}

-(NSMutableArray *)getCallRecordHistoryDataForUpload
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * date = [defaults objectForKey:@"LastSync"];
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM CallRecordHistory where ActionDate > '%@'",date];
    
    //FMResultSet *results = [database executeQuery:@"SELECT * FROM CallRecordHistory"];
    
//    CREATE TABLE [CallRecordHistory](
//                                     [Id] [int]  NULL,
//                                     [RowId] INTEGER PRIMARY KEY AUTOINCREMENT,
//                                     [DATE] [datetime] NOT NULL,
//                                     [EmployeeId] [int] NOT NULL,
//                                     [EmployeeVersion] [int] NOT NULL,
//                                     [PlanCallCount] [int] NOT NULL,
//                                     [ExecutedCallCount] [int] NOT NULL,
//                                     [MissedCallCount] [int] NOT NULL,
//                                     [FWPName] [varchar](100) NOT NULL,
//                                     [IsDeviated] [bit] NOT NULL,
//                                     [ActionDate] [datetime] NOT NULL,
//                                     [ActionBy] [varchar](15) NOT NULL,
//                                     [IsActive] [bit] NOT NULL
//                                     )
//    
    //get from schedule table
    FMResultSet *results = [database executeQuery:sate];
    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]] forKey:@"RowId"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeId"]] forKey:@"EmployeeId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeVersion"]]  forKey:@"EmployeeVersion"];
        [myMutableDictionary setObject:[results stringForColumn:@"FWPName"]  forKey:@"FWPName"];
        
        [myMutableDictionary setObject:[results stringForColumn:@"IsDeviated"]  forKey:@"IsDeviated"];
       
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"MissedCallCount"]]  forKey:@"MissedCallCount"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"ExecutedCallCount"]]forKey:@"ExecutedCallCount"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"PlanCallCount"]]  forKey:@"PlanCallCount"];
        
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"IsActive"]]  forKey:@"IsActive"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        
                                                                                                                                                                                                                                                                                                                                                                                                                                                           
        [arrSchedule addObject:myMutableDictionary];
    }
    [database close];
    return arrSchedule;
    
}


-(NSMutableArray *)getCallReportBrandDetailDataForUpload
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * date = [defaults objectForKey:@"LastSync"];
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM CallReportBrandDetail where ActionDate > '%@'",date];

    //get from schedule table
    FMResultSet *results = [database executeQuery:sate];

 //   FMResultSet *results = [database executeQuery:@"SELECT * FROM CallReportBrandDetail"];
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    //get from schedule table
    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]] forKey:@"RowId"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"CallReportVisitDetailId"]] forKey:@"CallReportVisitDetailId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"BrandClusterId"]]  forKey:@"BrandClusterId"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[results stringForColumn:@"StartTime"]  forKey:@"StartTime"];
        [myMutableDictionary setObject:@"True" forKey:@"IsActive"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"TimeSpent"]]  forKey:@"TimeSpent"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[objDel.empId intValue]]  forKey:@"EmployeeId"];
        
        [arrSchedule addObject:myMutableDictionary];
    }
     [database close];
    return arrSchedule;
    
}
-(NSMutableArray *)getCallReportVisitDetailDataForUpload
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * date = [defaults objectForKey:@"LastSync"];
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM CallReportVisitDetail where ActionDate > '%@'",date];
    
    FMResultSet *results = [database executeQuery:sate];
    
   // FMResultSet *results = [database executeQuery:@"SELECT * FROM CallReportVisitDetail"];
     AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    //get from schedule table
    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"RowId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"Id"];

        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"CallReportId"]] forKey:@"CallReportId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"DoctorId"]]  forKey:@"DoctorId"];
        [myMutableDictionary setObject:[results stringForColumn:@"VisitName"]  forKey:@"VisitName"];
        [myMutableDictionary setObject:[results stringForColumn:@"Time"]  forKey:@"Time"];
        [myMutableDictionary setObject:[results stringForColumn:@"Remarks"]  forKey:@"Remarks"];
        [myMutableDictionary setObject:@"True"  forKey:@"IsActive"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[objDel.empId intValue]]  forKey:@"EmployeeId"];
        
        [arrSchedule addObject:myMutableDictionary];
    }
     [database close];
    return arrSchedule;
    
}
-(NSMutableArray *)getCallReportBrandSlideDetail
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * date = [defaults objectForKey:@"LastSync"];
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM CallReportBrandSlideDetail where ActionDate > '%@'",date];
  
    
  //  FMResultSet *results = [database executeQuery:@"SELECT * FROM CallReportBrandSlideDetail"];
    
    FMResultSet *results = [database executeQuery:sate];
    
     AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    //get from schedule table
    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];

        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]] forKey:@"RowId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"CallReportBrandDetailId"]] forKey:@"CallReportBrandDetailId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"SlideNo"]]  forKey:@"SlideNo"];
        [myMutableDictionary setObject:[results stringForColumn:@"StartTime"]  forKey:@"StartTime"];
         [myMutableDictionary setObject:[results stringForColumn:@"EndTime"]  forKey:@"EndTime"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        [myMutableDictionary setObject:@"True"  forKey:@"IsActive"];
           [myMutableDictionary setObject:[NSNumber numberWithInt:[objDel.empId intValue]]  forKey:@"EmployeeId"];
        [arrSchedule addObject:myMutableDictionary];
    }
     [database close];
    return arrSchedule;
    
}
-(NSMutableArray *)getCallDetailHistoryDataForUpload
{
    [database open];
    NSMutableArray * arrSchedule = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * date = [defaults objectForKey:@"LastSync"];
    
    NSString * sate = [NSString stringWithFormat:@"SELECT * FROM CallDetailHistory where ActionDate > '%@'",date];
    
    
    //  FMResultSet *results = [database executeQuery:@"SELECT * FROM CallReportBrandSlideDetail"];
    
    FMResultSet *results = [database executeQuery:sate];
 
    
    //FMResultSet *results = [database executeQuery:@"SELECT * FROM CallDetailHistory"];
    
    //get from schedule table
    
    while([results next])
    {
        NSMutableDictionary *myMutableDictionary = [NSMutableDictionary dictionary];
        
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]]  forKey:@"Id"];
//        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]] forKey:@"RowId"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"RowId"]]  forKey:@"Id"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"Id"]] forKey:@"RowId"];
        
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeId"]] forKey:@"EmployeeId"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"EmployeeVersion"]]  forKey:@"EmployeeVersion"];
        [myMutableDictionary setObject:[NSNumber numberWithInt:[results intForColumn:@"DoctorId"]]  forKey:@"DoctorId"];
        [myMutableDictionary setObject:[results stringForColumn:@"CallDetails"]  forKey:@"CallDetails"];
        [myMutableDictionary setObject:[results stringForColumn:@"BrandName"]  forKey:@"BrandName"];
        [myMutableDictionary setObject:[results stringForColumn:@"Date"]  forKey:@"Date"];
        
        [myMutableDictionary setObject:@"True"  forKey:@"IsActive"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionDate"]  forKey:@"ActionDate"];
        [myMutableDictionary setObject:[results stringForColumn:@"ActionBy"]  forKey:@"ActionBy"];
        
        
        [arrSchedule addObject:myMutableDictionary];
    }
     [database close];
    return arrSchedule;
    
}

-(void)deleteAllTables
{
    
    [database open];
    
    NSString * sate = [NSString stringWithFormat:@"DELETE from Schedule where ActionDate < '%@'",[Utils getCurrentDate]];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    sate = [NSString stringWithFormat:@"DELETE from ScheduleCall where ActionDate < '%@'",[Utils getCurrentDate]];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    sate = [NSString stringWithFormat:@"DELETE from ScheduleContent where ActionDate < '%@'",[Utils getCurrentDate]];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    sate = [NSString stringWithFormat:@"DELETE from CallReport where ActionDate < '%@'",[Utils getCurrentDate]];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    sate = [NSString stringWithFormat:@"DELETE from CallReportVisitDetail where ActionDate < '%@'",[Utils getCurrentDate]];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    sate = [NSString stringWithFormat:@"DELETE from CallReportBrandDetail where ActionDate < '%@'",[Utils getCurrentDate]];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
    sate = [NSString stringWithFormat:@"DELETE from CallReportBrandSlideDetail where ActionDate < '%@'",[Utils getCurrentDate]];
    
    //get from schedule table
    if( [database executeUpdate: sate])
        NSLog(@"Update passed");
    else
        NSLog(@"Update FAILED");
    
//    sate = [NSString stringWithFormat:@"DELETE from CalDetailHistory"];
//    
//    //get from schedule table
//    if( [database executeUpdate: sate])
//        NSLog(@"Update passed");
//    else
//        NSLog(@"Update FAILED");
//    sate = [NSString stringWithFormat:@"DELETE from MonthlyTourProgram"];
//    
//    //get from schedule table
//    if( [database executeUpdate: sate])
//        NSLog(@"Update passed");
//    else
//        NSLog(@"Update FAILED");
//    sate = [NSString stringWithFormat:@"DELETE from DoctorBrandClusterMatrix"];
//    
//    //get from schedule table
//    if( [database executeUpdate: sate])
//        NSLog(@"Update passed");
//    else
//        NSLog(@"Update FAILED");
    
    
    [database close];
}
@end