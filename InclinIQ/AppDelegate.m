//
//  AppDelegate.m
//  InclinIQ
//
//  Created by Gagan on 08/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Defines.h"
#import "SQLManager.h"
#import "eDetailorPreviewViewController.h"
#import "ZipArchive.h"
#import "SyncDB.h"
@implementation AppDelegate

@synthesize heightOfCalendarIncreased, token, empId, empVersion, arrScheduleData, int_EntpId;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    
    //SQLManager * objSQL = [SQLManager sharedInstance];
  //  NSMutableArray * arrCal = [objSQL getScheduleDataForUpload];
     // NSMutableArray * arrCal = [objSQL getSTPDayList];
 
    empId = [[NSString alloc]init];
    empVersion = [[NSString alloc]init];

//    SyncDB * obj = [[SyncDB alloc]init];
//    obj.isDelete = YES;
//    [obj Start];
    
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    [arr addObject:@"one"];
    [arr addObject:@"two"];
    [arr addObject:@"three"];
    NSString *strBrands = [[NSString alloc] init];
    
    for(int i=0; i<arr.count; i++)
    {
        NSString *strTemp = [arr objectAtIndex:i];
        strBrands = [NSString stringWithFormat:@"%@ %@",strBrands,strTemp];
    }
    
    heightOfCalendarIncreased =0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LoginViewController *objLoginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:objLoginController];
    self.window .rootViewController = self.navController;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//    {
//        self.window.clipsToBounds = YES;
//        [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
//        
////        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
////        if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
////        {
//            self.window.frame =  CGRectMake(20, 0,self.window.frame.size.width-20,self.window.frame.size.height);
//            self.window.bounds = CGRectMake(20, 0, self.window.frame.size.width, self.window.frame.size.height);
////        }
////    else
////        {
////            self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
////            self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
////        }
//    }
    
    
    [Utils getCurrentDate];
    
    
    [self firstTimeLogin];
    return YES;
}

-(void)firstTimeLogin
{
    BOOL bFirstTime = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * firstTime = [defaults objectForKey:@"firstTime"];
    if((firstTime == nil ) || ([firstTime isEqualToString:@""]))
    {
        bFirstTime = YES;
//        [defaults setObject:@"1" forKey:@"firstTime"];
//        [defaults synchronize];
    }
   
    if(bFirstTime)
    {
        NSString * value = [defaults objectForKey:@"LastUpdate"];
        if((value == nil ) || ([value isEqualToString:@""]))
        {
            
            [defaults setObject:[Utils getCurrentDate] forKey:@"LastUpdate"];
            [defaults synchronize];
        }
       
        value = [defaults objectForKey:@"LastSync"];
        if((value == nil ) || ([value isEqualToString:@""]))
        {
             NSString * syncDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
            [defaults setObject:syncDate forKey:@"LastSync"];
            [defaults synchronize];
        }
        
        value = [defaults objectForKey:@"AutoSyncFreq"];
        if((value == nil ) || ([value isEqualToString:@""]))
        {
            
            [defaults setObject:@"1" forKey:@"AutoSyncFreq"];
            [defaults synchronize];
        }
        
        value = [defaults objectForKey:@"PreferedLang"];
        if((value == nil ) || ([value isEqualToString:@""]))
        {
            
            [defaults setObject:@"English" forKey:@"PreferedLang"];
            [defaults synchronize];
        }
        
        value = [defaults objectForKey:@"AppVer"];
        if((value == nil ) || ([value isEqualToString:@""]))
        {
            
            [defaults setObject:@"1.0" forKey:@"AppVer"];
            [defaults synchronize];
        }
        
        
        NSString * sid = [defaults objectForKey:@"TempScheduleId"];
//        if((sid == nil ) || ([sid isEqualToString:@""]))
//        {
//            [defaults setObject:@"10000" forKey:@"scheduleId"];
//            [defaults synchronize];
//        }
        
        //Add ScheduleId in userdefault
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        sid = [defaults objectForKey:@"scheduleId"];
        if((sid == nil ) || ([sid isEqualToString:@""]))
        {
            [defaults setObject:@"1" forKey:@"scheduleId"];
            [defaults synchronize];
        }
        
        
        NSString * crid = [defaults objectForKey:@"callReportId"];
        if((crid == nil ) || ([crid isEqualToString:@""]))
        {
            [defaults setObject:@"1" forKey:@"callReportId"];
            [defaults synchronize];
        }
        
        NSString * crbdid = [defaults objectForKey:@"CallReportBrandDetailId"];
        if((crbdid == nil ) || ([crbdid isEqualToString:@""]))
        {
            [defaults setObject:@"1" forKey:@"CallReportBrandDetailId"];
            [defaults synchronize];
        }
        
        
        
        NSString * crbdsdid = [defaults objectForKey:@"CallReportBrandSlideDetail"];
        if((crbdsdid == nil ) || ([crbdsdid isEqualToString:@""]))
        {
            [defaults setObject:@"1" forKey:@"CallReportBrandSlideDetail"];
            [defaults synchronize];
        }
        
        
        
        NSString * crvdid = [defaults objectForKey:@"CallReportVisitDetailId"];
        if((crvdid == nil ) || ([crvdid isEqualToString:@""]))
        {
            [defaults setObject:@"1" forKey:@"CallReportVisitDetailId"];
            [defaults synchronize];
        }

    }
    
}

-(void)ChangeRootViewControllerAnimation:(UIViewController *)viewController
{
    [self.navController removeFromParentViewController];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window .rootViewController = self.navController;

    [UIView beginAnimations:nil context:NULL];
   [UIView setAnimationDuration:1.0];
   [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
   [UIView commitAnimations];
 
}

-(void)ChangeRootViewController:(UIViewController *)viewController
{
    [self.navController removeFromParentViewController];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window .rootViewController = self.navController;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
    [UIView commitAnimations];

}

-(void)ChangeViewController:(UIViewController *)viewController
{
    self.navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window .rootViewController = self.navController;
    
    
}

-(void)loadLoginScreen
{
    LoginViewController *objLogin = [[LoginViewController alloc] init];
    self.window.rootViewController = objLogin;
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
