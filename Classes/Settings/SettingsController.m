//
//  SettingsController.m
//  InclinIQ
//
//  Created by Gagan on 11/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "SettingsController.h"
#import "SQLManager.h"
#import "SyncDB.h"
#import "ZipArchive.h"

@interface SettingsController ()

@end

@implementation SettingsController
@synthesize isFirstTime;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    loadingProgress = [[MBProgressHUD alloc] initWithView:self.view];
    loadingProgress.labelText = @"Synching...";
    [self.view addSubview:loadingProgress];
    
    txtUpdatedOn.font = font_ProCond(20.0);
    txtLastSyncOn.font = font_ProCond(20.0);
    txtFrequency.font = font_ProCond(20.0);
    txtNameOfEmployee.font = font_ProCond(20.0);
    txtHqName.font = font_ProCond(20.0);
    txtAreaManagerNae.font = font_ProCond(20.0);
    txtAreaManagerHqNmae.font = font_ProCond(20.0);
    txtPreferredLaunguage.font = font_ProCond(20.0);
    txtVersion.font = font_ProCond(20.0);
    txtRegionManagerNmae.font = font_ProCond(20.0);
    txtRegionName.font = font_ProCond(20.0);
    
    for(int i=101; i<=106; i++)
    {
        UIView *view = (UIView *)[self.view viewWithTag:i];
        CALayer * l = [view layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
    }
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    arrData = [objSQL getSetting];
    
    if(arrData.count >= 6)
    {
        txtNameOfEmployee.text = [arrData objectAtIndex:0];
        txtHqName.text = [arrData objectAtIndex:1];
        txtAreaManagerNae.text = [arrData objectAtIndex:2];
        txtAreaManagerHqNmae.text = [arrData objectAtIndex:3];
        txtRegionManagerNmae.text = [arrData objectAtIndex:4];
        txtRegionName.text = [arrData objectAtIndex:5];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    txtUpdatedOn.text = [defaults objectForKey:@"LastUpdate"];
    txtLastSyncOn.text = [defaults objectForKey:@"LastSync"];
    txtFrequency.text = [defaults objectForKey:@"AutoSyncFreq"];
    txtPreferredLaunguage.text = [defaults objectForKey:@"PreferedLang"];
    txtVersion.text = [defaults objectForKey:@"AppVer"];
  

    

}
-(void)viewWillDisappear:(BOOL)animated
{
    isFirstTime = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isSlide = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    [self designBagroundView:viewBack];
    
    if(!isFirstTime)
    {
        viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
        isSlide = YES;
        
        [self btnHomeButtonClicked:nil];
        isFirstTime = NO;
    }
    viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    viewMain.layer.shadowOpacity = 0.7f;
    viewMain.layer.shadowOffset = CGSizeMake(-5.0f,20.0f);
    viewMain.layer.shadowRadius = 10.0f;
    viewMain.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:viewMain.bounds];
    viewMain.layer.shadowPath = pathBtn.CGPath;
    
}
#pragma mark - UItextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [textField becomeFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnHomeButtonClicked:(UIButton *)sender
{
    [UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:0.5];
    if(isSlide)
    {
        viewMain.frame = CGRectMake(0, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
        isSlide = NO;
    }
    else
    {
        viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
        isSlide = YES;
    }
    [UIView commitAnimations];
    
}

- (IBAction)btnSynchronuosClicked:(UIButton *)sender
{
   
    [loadingProgress show:YES];
    
    SyncDB * obj = [[SyncDB alloc]init];
    obj.delegate = self;
    [obj Start];
    
}

-(void)syncCompletion
{
    
    NSString * syncDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:syncDate forKey:@"LastSync"];
     [defaults setObject:[Utils getCurrentDate] forKey:@"LastUpdate"];
     [defaults synchronize];
    
     txtLastSyncOn.text = syncDate;
     txtUpdatedOn.text = [Utils getCurrentDate];
  
    [loadingProgress hide:YES];
    
    statusMessage =@"Sync is completed successfully";


    [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(updateSyncUI) withObject:nil waitUntilDone:YES];

//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"SUCCESS" message:@"Sync is completed successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];

}

-(void)updateSyncUI
{
    NSString * syncDate = [NSString stringWithFormat:@"%@ %@",[Utils getCurrentDate],[Utils getCurrentTime]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:syncDate forKey:@"LastSync"];
    [defaults setObject:[Utils getCurrentDate] forKey:@"LastUpdate"];
    [defaults synchronize];
    
    txtLastSyncOn.text = syncDate;
    txtUpdatedOn.text = [Utils getCurrentDate];
}

-(void)syncError
{
    [loadingProgress hide:YES];
    
    statusMessage =@"Error getting response from server" ;
    
    
    [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];

    
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Error getting response from server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}



- (IBAction)btnUpdateDataBaseCliced:(UIButton *)sender
{
    loadingProgress.labelText = @"Uploading Database...";
    [loadingProgress show:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *dbFolderPath = [documentsDirectory stringByAppendingPathComponent:@"Database"];
    
    
    NSString *dbfPath = [documentsDirectory stringByAppendingPathComponent:@"inclinIQ.db"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    NSString * zipName = [NSString stringWithFormat:@"%@_%@_%@.zip", [defaults objectForKey:@"Username"],[Utils getCurrentDate],[Utils getCurrentTime]];
    NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:zipName];
    
    // 4
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipPath];
    
    
    // 6
    [za addFileToZip:dbfPath newname:@"inclinIQ.db"];
    
    // 7
    BOOL success = [za CloseZipFile2];
    NSLog(@"Zipped file with result %d",success);
    
    
    //Upload to server
    NSData * data = [zipPath dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"http://mobility-test.datamatics.com/demo/Map/prod2.zip"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         
         if (data.length > 0 && connectionError == nil)
         {
         
             statusMessage =@"Database uploaded successfully";
            
         }
         else
         {
             statusMessage =@"Error uploading database file";
         }
         
          [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
     }];
    

}
-(void)ShowAlert
{
    [loadingProgress hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:statusMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end
