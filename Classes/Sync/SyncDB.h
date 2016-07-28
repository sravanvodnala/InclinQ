//
//  SyncDB.h
//  InclinIQ
//
//  Created by Sajida on 02/11/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Structures.h"
#import "SyncDB.h"
#import "WebServerManager.h"

@protocol syncCompletedDelegate
- (void)syncCompletion;
-(void)syncError;
@end

@interface SyncDB : UIView

{
     
    NSMutableArray * arrTableNames;
    int currentIndex;
    NSMutableArray * arrDBData;
     NSString *statusMessage;
}

@property (atomic) BOOL isDelete;
@property (nonatomic, assign) id<syncCompletedDelegate> delegate;
-(void)Start;
@end
