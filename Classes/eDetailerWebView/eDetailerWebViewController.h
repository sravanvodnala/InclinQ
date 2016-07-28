//
//  eDetailerWebViewController.h
//  InclinIQ
//
//  Created by Gagan on 29/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface eDetailerWebViewController : UIViewController<UIWebViewDelegate>
{
    
     IBOutlet UILabel *lblNoDate;
     IBOutlet UIWebView *webView;
}
- (IBAction)btnBackClicked:(UIButton *)sender;
@property (nonatomic,strong) eDetailorSlide * objStruct;
@end
