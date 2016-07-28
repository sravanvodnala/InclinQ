//
//  eDetailorPreviewViewController.m
//  InclinIQ
//
//  Created by Sajida on 21/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "eDetailorPreviewViewController.h"
#import "Structures.h"
#import "Utils.h"
#import "ZipArchive.h"

@interface eDetailorPreviewViewController () 
@end


@implementation eDetailorPreviewViewController

@synthesize eDetailorId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.items = [NSMutableArray array];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
   // self.eDetailorId = @"1";
   // [self saveZipToDocument];
    [self loadSlideArray];
  
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated
{
     NSLog(@"viewDidDisappear");
}

-(void)loadSlideArray
{
   // [self.items removeAllObjects];
    
    //get eDetailor path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   // NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors"];
    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingString:@"/"];
    eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:self.eDetailorId];
    
    //getCount from DB
    int totalCount= 13;
    //load array
    for(int iCnt =0; iCnt < totalCount; iCnt++ )
    {
        NSString * path = eDeTailorFolderPath;
        NSString * countPath = [[NSString alloc]init];
        countPath = [NSString stringWithFormat:@"/%d",iCnt+1];
//        if(iCnt < 10)
//        {
//            countPath = [NSString stringWithFormat:@"/0%d",iCnt+1];
//            
//        }
//        else
//        {
//            countPath = [NSString stringWithFormat:@"/%d",iCnt+1];
//        }
        
        path = [path stringByAppendingString:countPath];
        countPath = [NSString stringWithFormat:@"/%d.html",iCnt+1];
        //countPath = [NSString stringWithFormat:@"/slide%d.html",iCnt+1];
        path = [path stringByAppendingString:countPath];
        NSLog(@"%@",path);
        
        
        [self.items addObject:path];
    }
    
    
    
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [_items count];
}

-(void)saveZipToDocument
{
    NSString *yourOriginalDatabasePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"zip"];
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    
    NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"1.zip"];
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath]) {
        
        NSError * error = nil;
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:&error] != YES)
        {
            NSLog(@"%@",error.description);
            
        }
    }
    
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: yourNewDatabasePath])
    {
        BOOL ret = [za UnzipFileTo: documentsDirectory overWrite: YES];
        if (NO == ret)
        {}
        [za UnzipCloseFile];
    }
    
    
}


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UIWebView *webView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:view.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        webView.backgroundColor = [UIColor clearColor];
        webView.tag = 1;
        webView.scalesPageToFit = YES;
        [view addSubview:webView];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleFingerTap.numberOfTapsRequired = 1;
        singleFingerTap.numberOfTouchesRequired = 1;
        
        UITapGestureRecognizer *doubleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleFingerTap.numberOfTapsRequired = 1;
        doubleFingerTap.numberOfTouchesRequired = 2;
        
        UITapGestureRecognizer *tripleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap:)];
        tripleFingerTap.numberOfTapsRequired = 1;
        tripleFingerTap.numberOfTouchesRequired = 3;
        
        label = [[UILabel alloc] initWithFrame:view.frame];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 2;
        label.userInteractionEnabled = YES;
        [view addSubview:label];
        [label addGestureRecognizer:singleFingerTap];
        [label addGestureRecognizer:doubleFingerTap];
        [label addGestureRecognizer:tripleFingerTap];


        
        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x, 690, view.frame.size.width, view.frame.size.height)];
        self.menuView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.menuView.backgroundColor = [UIColor yellowColor];
        self.menuView.tag = 3;
        [view addSubview:self.menuView];
        self.menuView.hidden = YES;
        
//        self.slideView = [[HorizontalTableView alloc] initWithFrame:CGRectMake(view.frame.origin.x, 650, view.frame.size.width, view.frame.size.height-650)];
//        self.slideView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.slideView.backgroundColor = [UIColor grayColor];
//        self.slideView.tag = 4;
//        [view addSubview:self.slideView];
//        self.slideView.hidden = YES;
//        
        self.brandView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,50)];
        self.brandView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.brandView.backgroundColor = [UIColor lightGrayColor];
        self.brandView.tag = 5;
        [view addSubview:self.brandView];
        self.brandView.hidden = YES;


    }
    else
    {
        //get a reference to the label in the recycled view
        webView = (UIWebView *)[view viewWithTag:1];
        label =  (UILabel *)[view viewWithTag:2];
    }
    
    //set background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    view.backgroundColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    // label.text = [_items[index] stringValue];
    
    

    //eDetailorSlide * objSlide = [_items objectAtIndex:index];
    NSString * path =  [_items objectAtIndex:index];
    
    NSURL* address = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:address] ;
    [webView loadRequest:request];
    
    //objSlide.StartTime = [Utils  getCurrentTime];
   
   // NSTimeInterval timeInterval = [self.start timeIntervalSinceNow];

    

    
  //  label.text = @"Hello";
    
    return view;
}
-(void)handleTripleTap : (id)sen
{
    NSLog(@"Triple Tap");
    
    if(isBrandVisisble == NO)
    {
        self.brandView.hidden = NO;
        isBrandVisisble = YES;
    }
    else
    {
        self.brandView.hidden = YES;
        isBrandVisisble = NO;
    }
    
}
-(void)handleDoubleTap : (id)sen
{
//     NSLog(@"Dpouble Tap");
//    
//    if(isSlidesVisible == NO)
//    {
//        self.slideView.hidden = NO;
//        isSlidesVisible = YES;
//    }
//    else
//    {
//        self.slideView.hidden = YES;
//        isSlidesVisible = NO;
//    }

}
-(void)handleSingleTap : (id)sen
{
    NSLog(@"Single Tap");
    
    if(isMainViewVisible == NO)
    {
        self.menuView.hidden = NO;
        isMainViewVisible = YES;
    }
    else
    {
        self.menuView.hidden = YES;
        isMainViewVisible = NO;
    }
    
    
}
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}
@end
