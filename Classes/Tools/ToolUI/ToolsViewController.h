//
//  ToolsViewController.h
//  InclinIQ
//
//  Created by Sajida on 21/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultViewController.h"
@interface ToolsViewController : DefaultViewController
{
    IBOutlet UIView *viewMain;
    IBOutlet UIView *viewBack;
    BOOL isSlide;
}

-(IBAction)onUpdateeDetailor:(id)sender;
-(IBAction)onAssistance:(id)sender;
- (IBAction)btnMenuClicked:(UIButton *)sender;
@end
