//
//  eDetailerWebViewController.m
//  InclinIQ
//
//  Created by Gagan on 29/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "eDetailerWebViewController.h"

@interface eDetailerWebViewController ()

@end

@implementation eDetailerWebViewController
@synthesize objStruct;
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
   
    self.navigationController.navigationBarHidden = YES;

    webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit = YES;
    webView.delegate = self;

    if(objStruct.URLPath != nil)
    {
        NSURL* address = [NSURL fileURLWithPath:objStruct.URLPath];
        NSURLRequest* request = [NSURLRequest requestWithURL:address] ;
        [webView loadRequest:request];
    }
    else
        lblNoDate.hidden = NO;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Lodeding Started.");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Loded Completed.");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"%@",error.description);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
