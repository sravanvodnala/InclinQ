//
//  LoginViewController.h
//  Filenet
//
//  Created by sravan.vodnala on 28/05/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "MBProgressHUD.h"
#import "WebServerManager.h"

@interface LoginViewController : UIViewController<NSURLSessionDelegate>
{
    IBOutlet UIImageView *imgViewLogo;
     MBProgressHUD *loadingProgress;
    IBOutlet UITextField *txtFldPassword;
    IBOutlet UITextField *txtFldUserName;
    IBOutlet UIButton *btnLogin;
    NSString *statusMessage;
    WebServerManager * webService;
}
- (IBAction)btnLoginClicked:(UIButton *)sender;
@end
