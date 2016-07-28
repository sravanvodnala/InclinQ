//
//  SQLManager.h
//  C+R
//
//  Created by Akash Malhotra on 24/03/14.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Structures.h"

@interface SQLManager : NSObject
{
    NSString *dbPath;
    FMDatabase *database;
}

-(doctorStuct *)getDoctor;
-(BOOL)isDBInUse;
-(void)closeDB;
-(void)createTable:(tblName)tableName;
//-(BOOL)insertRecord:(tblName)name : (NSMutableArray *)objectArr;
-(BOOL)deleteRecord:(NSString *)name;
+(id)sharedInstance;

@end
