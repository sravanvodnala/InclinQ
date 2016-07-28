//
//  eDetailerSlideShow.m
//  InclinIQ
//
//  Created by Gagan on 29/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "eDetailerSlideShow.h"
#import "HomeViewController.h"
#import "Defines.h"
#import "SQLManager.h"
#define lblWidth 150
@interface eDetailerSlideShow ()

@end

@implementation eDetailerSlideShow

@synthesize currenteDetailor,captureTime,currentScheduleContentId,currentScheduleId,isFromTempTables;

- (BOOL)prefersStatusBarHidden NS_AVAILABLE_IOS(7_0)
{
    return YES;
}

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
    
    timeCount = 0;
    brandTag = 0;
    slideTag = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countCall) userInfo:nil repeats:YES];
    
    isHomeView = NO;
    isBrandView = NO;
    isMenuView = NO;
    
    arrBrands = [[NSMutableArray alloc] init];
    arrMenu = [[NSMutableArray alloc] init];
    arrWebViews = [[NSMutableArray alloc] init];
    
    [self getDataAtFirstTime];
    [self designTapGestures];
}
-(void)getDataAtFirstTime
{
    NSMutableArray *arrFinal = [[NSMutableArray alloc]init];
    NSMutableArray *arrTempSlides = [[NSMutableArray alloc] init];
    
    for(int i=0; i<currenteDetailor.arrSlides.count; i++)
    {
        eDetailorSlide *obj = [currenteDetailor.arrSlides objectAtIndex:i];
        [arrTempSlides addObject:obj];
    }
   
    minimumCount = [currenteDetailor.arrSlides count];
    scrlWebView.contentSize = CGSizeMake(1024*minimumCount, 300);

    SQLManager * objSQL = [SQLManager sharedInstance];
    arrBrands = [objSQL geteDetailerDataForPrew:YES];
    
    for(int i=0; i<arrBrands.count; i++)
    {
        eDetailor *obj = [arrBrands objectAtIndex:i];
        if(obj.brandId == currenteDetailor.brandId)
        {
            currenteDetailor = (eDetailor *)obj;
        }
    }
    arrMenu = currenteDetailor.arrSlides;
    
    /** Sorting Array**/
    [arrFinal addObjectsFromArray:arrTempSlides];
    
    BOOL isFound = NO;
    
    for(int j=0; j<arrMenu.count; j++)
    {
        isFound = NO;
        eDetailorSlide *objTemp = [arrMenu objectAtIndex:j];
        
        for(int i=0; i<arrTempSlides.count; i++)
        {
            eDetailorSlide *obj = [arrTempSlides objectAtIndex:i];
            if(objTemp.slideNo == obj.slideNo)
            {
                isFound = YES;
                break;
            }
        }
       
        if(!isFound)
            [arrFinal addObject:objTemp];
    }
    
    [arrMenu removeAllObjects];
    [arrMenu addObjectsFromArray:arrFinal];
    
    eDetailorId = [NSString stringWithFormat:@"%d",currenteDetailor.Id];
    
    [self designBrandView:arrBrands];
    [self designMenuView:arrMenu];
    [self designWebView];
}
-(void)getData
{
    if(arrBrands.count)
        [arrBrands removeAllObjects];
    if(arrMenu.count)
        [arrMenu removeAllObjects];
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    arrBrands = [objSQL geteDetailerDataForPrew:YES];
    
    eDetailorId = [NSString stringWithFormat:@"%d",currenteDetailor.Id];
  
    minimumCount = [currenteDetailor.arrSlides count];
    scrlWebView.contentSize = CGSizeMake(1024*minimumCount, 300);
    arrMenu = currenteDetailor.arrSlides;
    
    [self designBrandView:arrBrands];
    [self designMenuView:currenteDetailor.arrSlides];
    
    [self designWebView];
}
-(void)designWebView
{
    for(UIWebView *web in scrlWebView.subviews)
    {
        [web removeFromSuperview];
    }
    for(int i=0; i<arrMenu.count; i++)
    {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(i*scrlWebView.frame.size.width, -20, scrlWebView.frame.size.width, scrlWebView.frame.size.height);
        [webView sizeToFit];
        webView.clipsToBounds = YES;
        webView.scrollView.scrollEnabled = NO;
        webView.backgroundColor = [UIColor clearColor];
        webView.tag = i;
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [scrlWebView addSubview:webView];
        
        
        //****************************************---------Sravan
//        eDetailorSlide * slide = [arrMenu objectAtIndex:i];
//        NSString * path = slide.URLPath;
//        NSURL* address = [NSURL fileURLWithPath:path];
//        NSURLRequest* request = [NSURLRequest requestWithURL:address] ;
//        [webView loadRequest:request];

        WebViewStruct *objStruct = [[WebViewStruct alloc] init];
        objStruct.tagValue = i;
        objStruct.isSelected = NO;

        if(i==0)
        {
            objStruct.isSelected = YES;
           
            eDetailorSlide * slide = [arrMenu objectAtIndex:i];
            currentSlide = slide;
            NSString * path = slide.URLPath;
            NSURL* address = [NSURL fileURLWithPath:path];
            NSURLRequest* request = [NSURLRequest requestWithURL:address] ;
            [webView loadRequest:request];
        }
        
        [arrWebViews addObject:objStruct];
        //****************************************---------End
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self updateeDetailorSlide];
    [timer invalidate];
}
-(void)countCall
{
    timeCount++;
}
#pragma mark - WebView Delegates
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(captureTime == YES)
    {
        if(arrMenu.count >=  webView.tag)
        {
            eDetailorSlide *obj = [arrMenu objectAtIndex:webView.tag];
            if(obj.StartTime == nil)
                obj.StartTime = [self retrievTime];
            
            //currentSlide = obj;
        }
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //****************************************---------Sravan

    WebViewStruct *objStruct = [arrWebViews objectAtIndex:webView.tag];
   
    if(objStruct.tagValue == webView.tag && !objStruct.isSelected)
    {
        objStruct.isSelected = YES;
        
        eDetailorSlide * slide = [arrMenu objectAtIndex:webView.tag];
        NSString * path = slide.URLPath;
        NSURL* address = [NSURL fileURLWithPath:path];
        NSURLRequest* request = [NSURLRequest requestWithURL:address] ;
        [webView loadRequest:request];
        
    }
    //****************************************---------Endc

}
#pragma mark - UIScrollView Delegates
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentXTemp = scrlWebView.contentOffset.x;
    NSLog(@"asdkaskd----");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == scrlWebView)
    {
        if(slideTag != scrlWebView.contentOffset.x/scrlWebView.frame.size.width)
        {
            
           
            [self updateeDetailorSlide];
            
            SQLManager * objSQL = [SQLManager sharedInstance];
            currentSlide.ScheduleContentId = currentScheduleContentId;
            //currentSlide.Id = currentScheduleId;
             currentSlide.Id = currenteDetailor.Id;
            [objSQL insertSlideDetail:currentSlide];
            

            slideTag = scrlWebView.contentOffset.x/scrlWebView.frame.size.width;
           
            currentSlide =  [arrMenu objectAtIndex:slideTag];
            //****************************************---------Sravan

            UIWebView *webView = (UIWebView *)[scrlWebView viewWithTag:slideTag];
            WebViewStruct *objStruct = [arrWebViews objectAtIndex:slideTag];
            if(objStruct.tagValue == slideTag && !objStruct.isSelected)
            {
                objStruct.isSelected = YES;
                
                eDetailorSlide * slide = [arrMenu objectAtIndex:slideTag];
                NSString * path = slide.URLPath;
                NSURL* address = [NSURL fileURLWithPath:path];
                NSURLRequest* request = [NSURLRequest requestWithURL:address] ;
                [webView loadRequest:request];
            }
            
            //****************************************---------End

            timeCount = 0;
        }
        if(minimumCount != arrMenu.count && isThumbClicked)
        {
            if(scrlWebView.contentOffset.x == lastContentXTemp)
                NSLog(@"");
            else
            {
                scrlWebView.contentSize = CGSizeMake(minimumCount*scrlWebView.frame.size.width, 300);
                scrlWebView.contentOffset = CGPointMake(lastContentX, 0);
                isThumbClicked = NO;
            }
        }
    }
}
-(void)updateeDetailorSlide
{
    
    
    if(captureTime == YES)
    {
        if(arrMenu.count>= slideTag)
        {
            eDetailorSlide *obj = [arrMenu objectAtIndex:slideTag];
            NSLog(@"Slide No - %d",obj.slideNo);
            obj.EndTime =  [self retrievTime];
            obj.timeSpent += timeCount;
        }
    }
}
-(void)designTapGestures
{
    UIView *viewTop = [[UIView alloc] init];
    viewTop.frame = CGRectMake(0, 0, self.view.frame.size.width, 45);
    viewTop.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewTop];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTopSingleTap:)];
    singleFingerTap.numberOfTapsRequired = 1;
    singleFingerTap.numberOfTouchesRequired = 1;
    [viewTop addGestureRecognizer:singleFingerTap];
    
    
    UIView *viewBottom = [[UIView alloc] init];
    viewBottom.frame = CGRectMake(40, self.view.frame.size.height-45, scrlWebView.frame.size.width, 60);
    viewBottom.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewBottom];
    
    UITapGestureRecognizer *singleFingerTapBottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBottomSingleTap:)];
    singleFingerTapBottom.numberOfTapsRequired = 1;
    singleFingerTapBottom.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *doubleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBottomDoubleTap:)];
    doubleFingerTap.numberOfTapsRequired = 2;
    doubleFingerTap.numberOfTouchesRequired = 1;
    
    [viewBottom addGestureRecognizer:singleFingerTapBottom];
    [viewBottom addGestureRecognizer:doubleFingerTap];
    
}
-(void)designBrandView:(NSMutableArray *)arrData
{
    for(UIView *v in scrlBrandView.subviews)
    {
        [v removeFromSuperview];
    }
    CGFloat xpos = 5;
    
    for(int i=0; i<arrData.count; i++)
    {
        eDetailor * obj = [arrData objectAtIndex:i];
        NSString *strTemp = [NSString stringWithFormat:@"%@",obj.brandName];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(xpos, 2, lblWidth-4, scrlBrandView.frame.size.height-4);
        view.backgroundColor = [UIColor darkGrayColor];
        [scrlBrandView addSubview:view];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(1, 1, view.frame.size.width - 2, view.frame.size.height-2);
        lbl.backgroundColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = font_ProCond(22.0);
        lbl.text = strTemp;
        [view addSubview:lbl];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 2, view.frame.size.width-4, view.frame.size.height-4);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnBrandCliced:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [view addSubview:btn];
        
        xpos = xpos + 5 + lblWidth-4;
        
        [self setCurveLayer:view];
        [self setCurveLayer:lbl];
        [self setCurveLayer:btn];
    }
    scrlBrandView.contentSize = CGSizeMake(xpos, scrlBrandView.frame.size.height);
}
-(void)designMenuView:(NSMutableArray *)arrData
{
    for(UIView *v in scrlMenuView.subviews)
    {
        [v removeFromSuperview];
    }
    CGFloat xpos = 5;
    
    for(int i=0; i<arrData.count; i++)
    {
        UIView *view = [[UIView alloc] init];
        
        view.frame = CGRectMake(xpos, 2, scrlMenuView.frame.size.height-4, scrlMenuView.frame.size.height-4);
        view.backgroundColor = [UIColor blackColor];
        view.clipsToBounds = YES;
        [scrlMenuView addSubview:view];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(1, 1, view.frame.size.width-2, view.frame.size.height-2);
        eDetailorSlide * objSlide = [arrData objectAtIndex:i];
        image.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",objSlide.thumbPath]];
        image.backgroundColor = [UIColor whiteColor];
        [view addSubview:image];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 2, view.frame.size.width-4, view.frame.size.height-4);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnMenuCliced:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [view addSubview:btn];
        
        xpos = xpos + 5 + scrlMenuView.frame.size.height-4;
        
        [self setCurveLayer:view];
        [self setCurveLayer:image];
        [self setCurveLayer:btn];
    }
    
    scrlMenuView.contentSize = CGSizeMake(xpos, scrlMenuView.frame.size.height);
}
-(void)setCurveLayer:(UIView *)view
{
    CALayer * l = [view layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
}
#pragma mark - Btn Clicked*****UIButton
-(void)btnBrandCliced:(UIButton *)btn
{
    [self updateeDetailorSlide];
   
    [arrWebViews removeAllObjects];     //******---------Sravan

    
    slideTag = 0;
    brandTag = btn.tag;

    isThumbClicked = NO;

    scrlWebView.contentOffset = CGPointMake(0, 0);
    currenteDetailor = [arrBrands objectAtIndex:btn.tag];
    
   // currentScheduleContentId = currenteDetailor.Id;
    currenteDetailor.scheduleId = currentScheduleId;
    currenteDetailor.starttime = [Utils getCurrentTime];
    SQLManager * objSQL = [SQLManager sharedInstance];
    [objSQL insertScheduleContentForScheduleId:currenteDetailor TempTable:isFromTempTables];
    [self getData];
    
}
-(void)btnMenuCliced:(UIButton *)btn
{
    //****************************************---------Sravan

    [self updateeDetailorSlide];
    SQLManager * objSQL = [SQLManager sharedInstance];
    currentSlide.ScheduleContentId = currentScheduleContentId;
   // currentSlide.Id = currentScheduleId;
     currentSlide.Id = currenteDetailor.Id;
    [objSQL insertSlideDetail:currentSlide];
    
    NSInteger i = btn.tag;
   
    UIWebView *webView = (UIWebView *)[scrlWebView viewWithTag:i];
    WebViewStruct *objStruct = [arrWebViews objectAtIndex:i];
    if(objStruct.tagValue == i && !objStruct.isSelected)
    {
        objStruct.isSelected = YES;
        
        eDetailorSlide * slide = [arrMenu objectAtIndex:i];
        NSString * path = slide.URLPath;
        NSURL* address = [NSURL fileURLWithPath:path];
        NSURLRequest* request = [NSURLRequest requestWithURL:address] ;
        [webView loadRequest:request];
        
       
        
    }
    //****************************************---------End

    [self updateeDetailorSlide];
    slideTag = btn.tag;
    timeCount = 0;
 
    
    currentSlide = [arrMenu objectAtIndex:slideTag];
    if(minimumCount != arrMenu.count && btn.tag > minimumCount)
    {
        isThumbClicked = YES;
        scrlWebView.contentSize = CGSizeMake((2+btn.tag)*scrlWebView.frame.size.width, 300);
    }
    
    intLastTag = btn.tag;
    lastContentX = scrlWebView.contentOffset.x;
    
    if(arrMenu.count>(btn.tag ))
        scrlWebView.contentOffset = CGPointMake(btn.tag*scrlWebView.frame.size.width, 0);
}
#pragma mark - Tap Events & Touch Events
-(void)handleTopSingleTap : (id)sen
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    
    if(isBrandView)
    {
        viewBrand.hidden = YES;
        isBrandView = NO;
    }
    else
    {
        viewBrand.hidden = NO;
        isBrandView = YES;
    }
    
    [UIView commitAnimations];
    
}

-(void)handleBottomSingleTap : (id)sen
{
    NSLog(@"handleBottomSingleTap - Menu Tapped");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    if(isHomeView)
    {
        viewHome.hidden = YES;
        isHomeView = NO;
        if(isMenuView)
        {
            viewMenu.hidden = YES;
            isMenuView = NO;
        }
        [UIView commitAnimations];
        return;
    }
    if(isMenuView)
    {
        viewMenu.hidden = YES;
        isMenuView = NO;
    }
    else
    {
        viewMenu.hidden = NO;
        isMenuView = YES;
    }
    
    [UIView commitAnimations];
    
    
}

-(void)handleBottomDoubleTap:(id)sen
{
    NSLog(@"handleBottomDoubleTap");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    
    if(isHomeView)
    {
        viewHome.hidden = YES;
        isHomeView = NO;
    }
    else
    {
        viewHome.hidden = NO;
        isHomeView = YES;
    }
    if(isMenuView)
    {
        viewMenu.hidden = YES;
        isMenuView = NO;
    }
    [UIView commitAnimations];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	if ([touch view] == viewBrand)
    {
        if(isBrandView)
        {
            viewBrand.hidden = YES;
            isBrandView = NO;
        }
        else
        {
            viewBrand.hidden = NO;
            isBrandView = YES;
        }
        
    }
	if ([touch view] == viewHome)
    {
        if(isHomeView)
        {
            viewHome.hidden = YES;
            isHomeView = NO;
        }
        else
        {
            viewHome.hidden = NO;
            isHomeView = YES;
        }
        
    }
	if ([touch view] == viewMenu)
    {
        if(isMenuView)
        {
            viewMenu.hidden = YES;
            isMenuView = NO;
        }
        else
        {
            viewMenu.hidden = NO;
            isMenuView = YES;
        }
        
    }
}
-(NSString *)retrievTime
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
//    return currentTime;
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    return resultString;
    
}

- (IBAction)btnHomeButtonClicked:(UIButton *)sender
{
    [self updateeDetailorSlide];
    SQLManager * objSQL = [SQLManager sharedInstance];
    
    if(captureTime)
    {
        
        currentSlide.ScheduleContentId = currentScheduleContentId;
        //currentSlide.Id = currentScheduleId;
         currentSlide.Id = currenteDetailor.Id;
        [objSQL insertSlideDetail:currentSlide];
        
        [self.delegate slideShowCompleted:arrMenu eDetId:eDetailorId];
    }
    
    AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
    objDel.arrScheduleData = [objSQL getScheduleCallData];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
