//
//  AppDelegate.h
//  InclinIQ
//
//  Created by Gagan on 08/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIWindow *window;
-(void)loadLoginScreen;
-(void)ChangeRootViewController:(UIViewController *)viewController;
-(void)ChangeRootViewControllerAnimation:(UIViewController *)viewController;
-(void)ChangeViewController:(UIViewController *)viewController;
@property (nonatomic, assign) NSInteger heightOfCalendarIncreased;
@property (nonatomic, strong) NSString *empId;
@property (assign) int int_EntpId;
@property (nonatomic, strong) NSString *empVersion;
@property (nonatomic, strong) NSString *token;
@property (nonatomic,strong)  NSMutableArray * arrScheduleData;
@end
