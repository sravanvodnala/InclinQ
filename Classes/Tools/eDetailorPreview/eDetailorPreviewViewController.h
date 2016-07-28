//
//  eDetailorPreviewViewController.h
//  InclinIQ
//
//  Created by Sajida on 21/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface eDetailorPreviewViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate>

{
    BOOL isMainViewVisible,isSlidesVisible,isBrandVisisble;
}
@property (nonatomic, strong) IBOutlet SwipeView *swipeView;
//@property (nonatomic, strong)  HorizontalTableView *slideView;
@property (nonatomic, strong)  UIView *brandView;
@property (nonatomic, strong)  UIView *menuView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString * eDetailorId;
@property (nonatomic, strong) NSDate *start;
@end
