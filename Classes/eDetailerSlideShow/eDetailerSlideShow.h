//
//  eDetailerSlideShow.h
//  InclinIQ
//
//  Created by Gagan on 29/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"

@protocol eDetailerSlideShowDelegate
- (void)slideShowCompleted:(NSMutableArray *)arrSlides eDetId : (NSString *)eId;
@end

@interface eDetailerSlideShow : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>
{
     IBOutlet UIScrollView *scrlWebView;
     IBOutlet UIView *viewBrand;
     IBOutlet UIView *viewHome;
     IBOutlet UIView *viewMenu;
    
     IBOutlet UIScrollView *scrlBrandView;
     IBOutlet UIScrollView *scrlMenuView;
    
    eDetailorSlide * currentSlide;
    NSString *eDetailorId;
    NSMutableArray *arrBrands;
    NSMutableArray *arrMenu;

    NSMutableArray *arrWebViews;
    
    BOOL isHomeView;
    BOOL isBrandView;
    BOOL isMenuView;
    
    //********** Timer Code***************//
    NSTimer *timer;
    NSInteger timeCount;
    NSInteger slideTag;
    NSInteger brandTag;
    NSString *startTime;
    //**************************************//

    NSInteger intLastTag;
    CGFloat lastContentX;
    CGFloat lastContentXTemp;
    NSInteger minimumCount;
    BOOL isThumbClicked;
    
}
- (IBAction)btnHomeButtonClicked:(UIButton *)sender;
@property (nonatomic, assign) id<eDetailerSlideShowDelegate> delegate;
@property (nonatomic,strong) eDetailor *currenteDetailor;
@property(atomic) BOOL captureTime;
@property(atomic) int currentScheduleContentId;
@property(atomic) int currentScheduleId;
@property(atomic) int isFromTempTables;
@end
