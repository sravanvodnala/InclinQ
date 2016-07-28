//
//  LoginViewController.m
//  Filenet
//
//  Created by sravan.vodnala on 28/05/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
#import "Structures.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Calander.h"
#import "eDetailerSlideShow.h"
#import "CustomersController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
}
- (BOOL)prefersStatusBarHidden NS_AVAILABLE_IOS(7_0)
{
    return YES;
}

#pragma mark - Keyboard Notification Method
-(void) keyboardWillHide:(NSNotification *)note
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    //        if(isLandscape || isLandscapeFirst)
    //            viewTextField.frame = CGRectMake( viewTextField.frame.origin.x, 316.5, viewTextField.frame.size.width, viewTextField.frame.size.height);
    //        else
    //            viewTextField.frame = CGRectMake( viewTextField.frame.origin.x, 320, viewTextField.frame.size.width, viewTextField.frame.size.height);
    [UIView commitAnimations];
}
-(void) keyboardWillShow:(NSNotification *)note
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    //        if(isLandscape || isLandscapeFirst)
    //            viewTextField.frame = CGRectMake( viewTextField.frame.origin.x, 200, viewTextField.frame.size.width, viewTextField.frame.size.height);
    //        else
    //            viewTextField.frame = CGRectMake( viewTextField.frame.origin.x, 320, viewTextField.frame.size.width, viewTextField.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    loadingProgress = [[MBProgressHUD alloc] initWithView:self.view];
    loadingProgress.labelText = @"Authenticating...";
    [self.view addSubview:loadingProgress];
    
    imgViewLogo.alpha = 0.9f;
    
    txtFldPassword.font = fontSub(25.0);
    txtFldUserName.font = fontSub(25.0);
    btnLogin.titleLabel.font = fontSub(30.0);

    CALayer * l = [btnLogin layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:20.0];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"Login";
    
  txtFldUserName.text = @"cynth";
  txtFldPassword.text = @"cynth";
//   txtFldUserName.text = @"prithvip";
//   txtFldPassword.text = @"aa";
    
    UIButton *btnInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    btnInfo.frame = CGRectMake(0,0,45,45);
    btnInfo.titleLabel.textColor = [UIColor whiteColor];
    btnInfo.tintColor = [UIColor whiteColor];
    [btnInfo addTarget:self action:@selector(btnAboutClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *lrightBtn = [[UIBarButtonItem alloc]initWithCustomView:btnInfo];
    self.navigationItem.rightBarButtonItem = lrightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    if(LessThanIOS7)
    {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:195/255.0 green:145/255.0 blue:87/255.0 alpha:1.0f];
    }
    else
    {
        self.navigationController.navigationBar.barTintColor =   [UIColor colorWithRed:195/255.0 green:145/255.0 blue:87/255.0 alpha:8.0f];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}
-(void)setShadowEffectForUIButton:(UIButton *)view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowOffset = CGSizeMake(7.0f, 7.0f);
    
    view.layer.shadowRadius = 5.0f;
    view.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = pathBtn.CGPath;
}
-(void)setShadowEffectForView:(UIView *)view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.7f;
    view.layer.shadowOffset = CGSizeMake(7.0f, 7.0f);
    
    view.layer.shadowRadius = 5.0f;
    view.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = pathBtn.CGPath;
}

#pragma mark - textFiled Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return  YES;
}
/**
 *  This method is for hiding keyboard
 *
 *  @param textField -current textfield
 *
 *  @return - return the boolean value for hiding keyboard
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(txtFldUserName == textField)
        [txtFldPassword becomeFirstResponder];
    else
        [txtFldPassword resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - btnClicked
-(void)btnAboutClicked
{
    [txtFldPassword resignFirstResponder];
    [txtFldUserName resignFirstResponder];
}
- (IBAction)btnLoginClicked:(UIButton *)sender
{
    [txtFldUserName resignFirstResponder];
    [txtFldPassword resignFirstResponder];
    
    if (txtFldUserName.text == nil || [txtFldPassword.text isEqualToString:@""] || txtFldUserName.text == nil || [txtFldPassword.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your login credentials" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if (txtFldUserName.text == nil || [txtFldPassword.text isEqualToString:@""] || txtFldUserName.text == nil || [txtFldPassword.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your login credentials" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * firstTime = [defaults objectForKey:@"firstTime"];
            
            if(!((firstTime == nil ) || ([firstTime isEqualToString:@""])))
            {
                SQLManager * objSQL = [SQLManager sharedInstance];
                BOOL bRet = [objSQL VerifyLoginWithUsername:txtFldUserName.text password:txtFldPassword.text];
                if(!bRet)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Username/Password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                else
                    [self performSelectorOnMainThread:@selector(OpenHomeController) withObject:nil waitUntilDone:YES];
            }
            else
            {
                if( ![Utils checkNet] )
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Device is not connected to internet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                
//                                 http://acipl-betasite.com/incliniq/api/Login/GetLogin?userid=cynth&pwd=cynth&deviceNo=asdf&isnewdb=true //New
//                                 http://acipl-betasite.com/inclinIQ/api/login/GetLogin?userId=cynth&pwd=cynth&deviceNo=appId#username&isnewdb=true
                
                [loadingProgress show:YES];
                
                NSString * url =[NSString stringWithFormat:@"%@login/GetLogin?userId=%@&pwd=%@&deviceNo=appId&isnewdb=true",BASE_URL,txtFldUserName.text,txtFldPassword.text];
                
                webService = [[WebServerManager alloc]init];
                [webService sendRequestToServer:login withObject:nil withRefrence:self URL:url];
            }
        }
    }
}
#pragma mark Login Response Handling
-(void)didReciveResponse:(id)responsedata withMethodName:(wsMethodNames)name error:(int)errorCode
{
    NSLog(@"didReciveResponceObj form view controller");
    NSNumber * err = [responsedata objectForKey:@"IsValid"];
    if (err.intValue ==0)
    {
        [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
        statusMessage = [NSString stringWithFormat:@"Invalid username/password"];
        [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    }
    else
    {
        AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
        NSNumber * empId = [responsedata objectForKey:@"Employeeid"];
        objDel.int_EntpId = [empId intValue];
        objDel.empId = [NSString stringWithFormat:@"%d",empId.intValue];
        objDel.token = [responsedata objectForKey:@"token"];
        objDel.empVersion = @"1";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:objDel.empId forKey:@"EmpId"];
        
        NSString * firstTime = [defaults objectForKey:@"firstTime"];
        if((firstTime == nil ) || ([firstTime isEqualToString:@""]))
        {
            [self DownloadDBFile];
            [defaults setObject:@"1" forKey:@"firstTime"];
            [defaults setObject:txtFldUserName.text forKey:@"Username"];
            [defaults setObject:txtFldPassword.text forKey:@"Password"];
            [defaults synchronize];
        }
    }
}
#pragma mark - NSURLSessionDownloadTask
-(void) downloadFile
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"http://acipl-betasite.com/incliniq/api/Download/Database/%@?id=%@",objDel.token,objDel.empId];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask * downloadTask = [defaultSession downloadTaskWithURL:[NSURL URLWithString:url]];
    [downloadTask resume];
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data =  [NSData dataWithContentsOfURL:location];
    if([data length] > 0)
    {
        [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
        
        NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
        
        NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"inclinIQ.db"];
        
        if (![data writeToFile:yourNewDatabasePath atomically:YES])
        {
            statusMessage =@"Error downloading DB file";
            [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
            return ;
        }
        [self performSelectorOnMainThread:@selector(OpenHomeController) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
        statusMessage =@"Error downloading DB file";
        [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
     }
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
    statusMessage =@"Error downloading DB file";
    [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
}
#pragma mark -
-(void)DownloadDBFile
{
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    
    NSString * url = [NSString stringWithFormat:@"http://acipl-betasite.com/incliniq/api/Download/Database/%@?id=%@",objDel.token,objDel.empId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
             
             NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             
             NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
             
             NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"inclinIQ.db"];
             
             if (![data writeToFile:yourNewDatabasePath atomically:YES])
             {
                 statusMessage =@"Error downloading DB file";
                 [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
                 return ;
             }
             [self performSelectorOnMainThread:@selector(OpenHomeController) withObject:nil waitUntilDone:YES];
         }
         else if (error != nil)
         {
             [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
             statusMessage =@"Error downloading DB file";
             [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
         }
     }];
}
-(void)didRecivewithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
    statusMessage =@"Error occurred while getting response from server";
    [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
}
-(void)didRecivewithNullData
{
    [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
    statusMessage =@"Login failed";
    [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
}
-(void)ShowAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:statusMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)OpenHomeController
{
    SQLManager * objSQL = [SQLManager sharedInstance];
    [objSQL VerifyLoginWithUsername:txtFldUserName.text password:txtFldPassword.text];
    
    HomeViewController *projectViewController = [[HomeViewController alloc]init];
    projectViewController.isFirstTime = YES;
    
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdelegate.arrScheduleData = [objSQL getScheduleCallData];
    [appdelegate ChangeRootViewController:projectViewController];
}
-(void)removeIndicator
{
    [loadingProgress hide:YES];
}
@end
/*
 //[ defaultSession downloadTaskWithURL:[NSURL URLWithString:url];
 
 //                                                                completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
 //                                              {
 //                                                  NSData *data =  [NSData dataWithContentsOfURL:location];
 //
 //                                                  if(error == nil && [data length] >0)
 //                                                  {
 //                                                      [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
 //
 //                                                      NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 //
 //                                                      NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
 //
 //                                                      NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"inclinIQ.db"];
 //
 //                                                      if (![data writeToFile:yourNewDatabasePath atomically:YES])
 //                                                      {
 //                                                          statusMessage =@"Error downloading DB file";
 //                                                          [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
 //                                                          return ;
 //                                                      }
 //                                                      [self performSelectorOnMainThread:@selector(OpenHomeController) withObject:nil waitUntilDone:YES];
 //                                                  }
 //                                                  else
 //                                                  {
 //                                                      [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:YES];
 //                                                      statusMessage =@"Error downloading DB file";
 //                                                      [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
 //                                                  }
 //                                              }];
 //    [downloadTask resume];

 */