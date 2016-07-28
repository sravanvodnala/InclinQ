//
//  SettingsController.h
//  InclinIQ
//
//  Created by Gagan on 11/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultViewController.h"
#import "Defines.h"
#import "SyncDB.h"
@interface SettingsController : DefaultViewController<UITextFieldDelegate,syncCompletedDelegate>
{
      MBProgressHUD *loadingProgress;
    BOOL isSlide;
     IBOutlet UIView *viewBack;
     IBOutlet UIView *viewMain;
     NSString *statusMessage;
    
     IBOutlet UITextField *txtUpdatedOn;
     IBOutlet UITextField *txtLastSyncOn;
     IBOutlet UITextField *txtFrequency;
     IBOutlet UITextField *txtNameOfEmployee;
     IBOutlet UITextField *txtHqName;
     IBOutlet UITextField *txtAreaManagerNae;
     IBOutlet UITextField *txtAreaManagerHqNmae;
     IBOutlet UITextField *txtPreferredLaunguage;
     IBOutlet UITextField *txtVersion;
     IBOutlet UITextField *txtRegionManagerNmae;
     IBOutlet UITextField *txtRegionName;
    NSMutableArray * arrData;
}
@property (atomic) BOOL isFirstTime;
- (IBAction)btnHomeButtonClicked:(UIButton *)sender;
- (IBAction)btnSynchronuosClicked:(UIButton *)sender;


- (IBAction)btnUpdateDataBaseCliced:(UIButton *)sender;
@end
