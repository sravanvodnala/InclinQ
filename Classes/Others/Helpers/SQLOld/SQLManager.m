//
//  FMDBManager.m
//  C+R
//
//  Created by Akash Malhotra on 24/03/14.
//

#import "SQLManager.h"



@implementation SQLManager
/**
 *  sql create table query creation
 *
 *  @param tableName - name of the sqlite table, it is an enum value
 */
-(void)createTable:(tblName)tableName
{
    
    NSString *statement;
    
    [database open];
    
    switch (tableName)
    {
        case Schedule_tbl:
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

-(BOOL)insertRecord:(tblName)name : (NSMutableArray *)objectArr {
    
    BOOL success = NO;
    
    [database open];
    for(int i = 0;i<[objectArr count]; i++)
    {
        switch (name)
        {
            case Schedule_tbl:
            {
                schedule * objSchedule = (schedule *) [objectArr objectAtIndex:i];
                if( [database executeUpdate: @"INSERT into Schedule(Id,Date,CallType,CallObjective,ActionDate,ActionBy,IsActive) values (?,?,?,?,?,?,?)", 0, objSchedule.datetime,objSchedule.CallType,objSchedule.CallObjective,objSchedule.ActionDate,objSchedule.ActionBy,1] )
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
            case ScheduleCall_tbl:
            {
                ScheduleCall * objScheduleCall = (ScheduleCall *) [objectArr objectAtIndex:i];
                if( [database executeUpdate: @"INSERT into ScheduleCall(Id,ScheduleId,DoctorId,DoctorName,ActionDate,ActionBy,IsActive) values (?,?,?,?,?,?,?)", 0,0,objScheduleCall.DoctorId,objScheduleCall.DoctorName,objScheduleCall.ActionDate,objScheduleCall.ActionBy,1] )
                    success = YES;
                else
                    NSLog(@"INSERT FAILED");
                
            }
                break;
            case ScheduleContent_tbl:
            {
                ScheduleContent * objScheduleContent = (ScheduleContent *) [objectArr objectAtIndex:i];
                if( [database executeUpdate: @"INSERT into ScheduleContent(Id,ScheduleId,EdetailerId,ActionDate,ActionBy,IsActive) values (?,?,?,?,?,?)",0, objScheduleContent.ScheduleId,objScheduleContent.EdetailerId,objScheduleContent.ActionDate,objScheduleContent.ActionBy,1] )
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
    
    [database close];
    return success;
}
/**
 *  Initializes of database CPlusR.sqlite
 *
 *  @return -it returns instance of the created database
 */
-(id)init
{
    if(self != nil)
    {
        // NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // NSString *documentsDir = [docPaths objectAtIndex:0];
        
        NSString *file = [[NSBundle mainBundle] pathForResource:@"inclinIQ" ofType:@"db"];
        
        //dbPath = [documentsDir stringByAppendingPathComponent:@"inclinIQ.db"];
        database = [FMDatabase databaseWithPath:file];
    }
    return self;
}

/**
 *  singleton implementation for sqlite manager
 *
 *  @return - it return singleton instance of sql manager
 */
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

/**
 *  Database insertion query
 *
 *  @param name      - tablename in which we want to insert the data
 *  @param objectArr - array of data which we need to insert in given table
 *
 *  @return - it returns YES as a successful result if data is inserted without any failure, for failure it returns NO.
 */

#pragma mark - Doctors

-(NSMutableArray *)getDoctor{
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT distinct d.Id,FirstName,LastName,d.specialisationId ,s.name FROM Doctor d left outer join specialisation s on (d.specialisationId = s.id)"];
    NSMutableArray * arrDoctors = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        doctorStuct * objDoc = [[doctorStuct alloc]init];
        objDoc.doctorId = [results intForColumn:@"Id"];
        objDoc.fname = [results stringForColumn:@"FirstName"];
        objDoc.lname = [results stringForColumn:@"LastName"];
        objDoc.specializationId = [results intForColumn:@"SpecialisationId"];
        objDoc.specializationName = [results stringForColumn:@"Name"];
        
        [arrDoctors addObject:objDoc];
        
    }
    
    [database close];
    return arrDoctors;
}

-(NSMutableArray *)geteDetailors{
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT e.Id,e.NoOfPages,e.version,b.BrandClusterName FROM Edetailer e left outer join BrandCluster b on (e.BrandClusterId = b.Id)"];
    
    NSMutableArray * arreDetailors = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        eDetailor * objeDet = [[eDetailor alloc]init];
        objeDet.Id = [results intForColumn:@"Id"];
        objeDet.noOfSlides = [results intForColumn:@"NoOfPages"];
        objeDet.versionNo = [results stringForColumn:@"version"];
        objeDet.brandName = [results stringForColumn:@"BrandClusterName"];
        
        [arreDetailors addObject:objeDet];
        
    }
    
    [database close];
    return arreDetailors;
}

-(NSMutableArray *)getSpecialisation
{
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT * FROM Specialisation"];
    NSMutableArray * arrSpecialisation = [[NSMutableArray alloc]init];
    
    while([results next])
    {
        specialisationStruct * objSpc = [[specialisationStruct alloc]init];
        objSpc.name = [results stringForColumn:@"FirstName"];
        objSpc.abbrevation = [results stringForColumn:@"LastName"];
        objSpc.Id = [results intForColumn:@"SpecialisationId"];
        
        [arrSpecialisation addObject:objSpc];
    }
    
    [database close];
    return arrSpecialisation;
}
//-(BOOL)insertRecord:(tblName)name : (NSMutableArray *)objectArr {
//
//    BOOL success = NO;
//
//    [database open];
//    for(int i = 0;i<[objectArr count]; i++)
//    {
//        switch (name)
//        {
//            case loginTbl:
//            {
//                loginRequestStruct * loginObj = (loginRequestStruct *) [objectArr objectAtIndex:i];
//               if( [database executeUpdate: @"INSERT into Login(username,password) values (?,?)", loginObj.userName,loginObj.password] )
//                   success = YES;
//                else
//                    NSLog(@"INSERT FAILED");
//                break;
//            }
//
//            default:
//                NSLog(@"Table not found");
//
//                break;
//        }
//    }
//
//    [database close];
//    return success;
//}

/**
 *  Deletion query for sqlite
 *
 *  @param name -name of the table from which we want to delete the data
 *
 *  @return -return success or failure for delete operation
 */
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
@end