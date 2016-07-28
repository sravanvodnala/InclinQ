//
//  WebServerManager.h
//  C+R
//
//  Created by Sajida Deshmukh on 26/02/14.
//  Copyright (c) 2014 Datamatics. All rights reserved.
//

#import <Foundation/Foundation.h>
   
#import "Config.h"
#import "Defines.h"

@protocol WebServerManagerDelegate <NSObject>
@required

- (void)didReciveResponse:(id)responsedata withMethodName:(wsMethodNames)name error:(int)errorCode;
- (void)didRecivewithError:(NSError *)error;
- (void)didRecivewithNullData;
@end

@interface WebServerManager : NSObject
{
    NSMutableData *mutableData;
    NSURLConnection * nsUrlConnection;
    
}

-(void)CancelRequest;
-(void)sendRequestToServer:(wsMethodNames)methodName withObject:(id)Object withRefrence:(id)refrence URL:(NSString *)url;


@property (nonatomic,strong) NSThread *thread;
@property (nonatomic, strong) id  _delegate;
@property (nonatomic) wsMethodNames methodType;

@end
