
//
//  WebServerManager.m
//  C+R
//
//  Created by Sajida Deshmukh on 26/02/14.
//  Copyright (c) 2014 Datamatics. All rights reserved.
//

#import "WebServerManager.h"


@implementation WebServerManager

@synthesize _delegate;

/**
 *  Service connection method
 *
 *  @param data       -input json data for request
 *  @param MethodType -service operation name as input parameter for service request
 */
-(void)Service_CallWithPostData:(NSData *)data withMethodName:(wsMethodNames)MethodType HTTPMethod:(NSString *)httpMehod URL :(NSString *)url
{
    self.methodType = MethodType;
    
   // NSString * requestURL = [self getURLforFunction:MethodType];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
   
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:httpMehod];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if(data)
    {
       
        [request setHTTPBody:data];
    }
    
    // print json:
    NSLog(@"**********************************************************************");
    NSLog(@"->                                                                                         ");
    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]);
    
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(SendRequest:) object:request];
    [self.thread start];
    
}

/**
 *  Service connection call and its response callback handling. Respective delegate method of webservice protocol is called implementated for different services.
 *
 *  @param request -service request
 */
-(void)SendRequest:(NSMutableURLRequest*)request
{
  
      [NSURLConnection sendAsynchronousRequest:request
                                         queue:[[NSOperationQueue alloc] init]
                                         completionHandler:^(NSURLResponse *response,
                                         NSData *data,
                                         NSError *error)
       {
  
           if ([data length] >0 && error == nil)
           {
  
               [self didReciveResponse:data withMethodName:self.methodType];
  
           }
           else if (error != nil)
           {
  
               NSLog(@"Error = %@", error);
               [_delegate didRecivewithError:error];
               
           }
           
           
       }];
}


/**
 *  Service request menthods sagregated with service names
 *
 *  @param methodName -name of service
 *  @param Object     -input data if any
 *  @param refrence   -respective viewcontroller reference
 */
-(void)sendRequestToServer:(wsMethodNames)methodName withObject:(id)Object withRefrence:(id)refrence URL:(NSString *)url
{
    _delegate = refrence;
    NSData* jsonData = nil;
    NSString * HTTPMth = @"GET";
    if(Object)
    {
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:Object options:kNilOptions error:&error];
        HTTPMth = @"POST";
    }
    
    NSLog(@"URL : %@",url);
    
   [self Service_CallWithPostData:jsonData withMethodName:methodName HTTPMethod:HTTPMth URL:url];
    
    
    return;
}

/**
 *  predefined server url for service connection
 *
 *  @param MethodType -service name
 *
 *  @return -it returns service url
 */
-(NSString *)getURLforFunction:(wsMethodNames)MethodType
{
    NSString * url;
    
    switch (MethodType)
    {
        case login:
                    url = BASE_URL;
            break;
               default:
            url = nil;
            break;
    }
    return url;
}

/**
 *  Response handling of response coming from server. Data is parsed using jsonconvertor class and send back to view. Respective delegate method of view is called for further response handling.
 *
 *  @param responsedata -response data coming from server
 *  @param name         -service name
 */
- (void)didReciveResponse:(NSData *)responsedata withMethodName:(wsMethodNames)name
{
   
    id respObjct;
    int error = 0;

    
    NSString *jsonString = [[NSString alloc]initWithData:responsedata encoding:NSUTF8StringEncoding];
    NSLog(@"STRING IS %@",jsonString);
    
    NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responsedata  options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"----- Json Response ======> %@",[jsonArray description]);

    if (jsonArray == nil)
    {
        NSLog(@"Nothing was downloaded.");
        [_delegate didRecivewithNullData];
        return;
    }
    
     respObjct = jsonArray;
  
        switch(name)
        {
            case login:
            {
                NSLog(@"didReciveResponce login called");
                respObjct = jsonArray;
                break;
            }
                
            case getSync:
            {
                NSLog(@"didReciveResponce getSync called");
                respObjct = jsonArray;
                break;
            }
                
            default:
                break;
        }
    
    [_delegate didReciveResponse:respObjct withMethodName:name error:error];
    

    return;
    
}

#pragma mark NSURLConnection delegate
/**
 *  Connection class delegate method
 *
 *  @param connection     -connection object
 *  @param cachedResponse -cached response
 *
 *  @return
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}

// Forward errors to the delegate.
/**
 *  Connection class delegate method called when connection failed with any error
 *
 *  @param connection -connection object
 *  @param error      -connection error
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

	UIApplication * app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	[_delegate didRecivewithError:error];
}


/**
 *  Called when a chunk of data has been downloaded.
 *
 *  @param connection -connection object
 *  @param data       -data downloaded from server
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// Append the downloaded chunk of data.
	[mutableData appendData:data];
}

/**
 *  Called when all server data has received
 *
 *  @param connection -connection object
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UIApplication * app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	[self didReciveResponse:mutableData withMethodName:self.methodType];
}

/**
 *  called to cancel current service connection by stoping connection thread
 */
-(void)CancelRequest
{
     [self.thread cancel];
     self.thread = nil;
}

@end
