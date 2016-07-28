//
//  ToolsViewController.m
//  InclinIQ
//
//  Created by Sajida on 21/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "ToolsViewController.h"
#import "AppDelegate.h"
#import "UpdateViewController.h"
#import "ZipArchive.h"
@interface ToolsViewController ()

@end

@implementation ToolsViewController

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
    [self designBagroundView:viewBack];
    
    viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
    isSlide = YES;
    
    [self btnMenuClicked:nil];
    

    
//    viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
//    isSlide = YES;
//    
//    [self btnMenuClicked:nil];
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onUpdateeDetailor:(id)sender
{
   
    UpdateViewController *objeDetailorViewController = [[UpdateViewController alloc]initWithNibName:@"UpdateeDetailorViewController" bundle:nil];
    [self.navigationController pushViewController:objeDetailorViewController animated:YES];
}

- (IBAction)btnMenuClicked:(UIButton *)sender
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



-(IBAction)onAssistance:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbFolderPath = [documentsDirectory stringByAppendingPathComponent:@"Database"];
    
    BOOL isDir = YES;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dbFolderPath isDirectory:&isDir])
    {
        if(![fileManager createDirectoryAtPath:dbFolderPath withIntermediateDirectories:YES attributes:nil error:NULL])
        {
            NSLog(@"Error: Create folder failed %@", dbFolderPath);
        }
    }
    
    NSString *dbfPath = [dbFolderPath stringByAppendingPathComponent:@"inclinIQ.db"];
    
    NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:@"db.zip"];
    
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
             
             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             
             NSString *documentsDirectory = [paths objectAtIndex:0];
             NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors"];
             
             BOOL isDir = YES;
             NSFileManager *fileManager= [NSFileManager defaultManager];
             if(![fileManager fileExistsAtPath:eDeTailorFolderPath isDirectory:&isDir])
             {
                 if(![fileManager createDirectoryAtPath:eDeTailorFolderPath withIntermediateDirectories:YES attributes:nil error:NULL])
                 {
                     NSLog(@"Error: Create folder failed %@", eDeTailorFolderPath);
                 }
             }
             
             
             NSString *pdfPath = [eDeTailorFolderPath stringByAppendingPathComponent:@"prod1.zip"];
             
             NSLog(@"Succeeded! Received %d bytes of data",[data length]);
             
             [data writeToFile:pdfPath atomically:YES];
             
             [self performSelectorOnMainThread:@selector(processZipFile) withObject:nil waitUntilDone:YES];
         }
     }];

    
}

-(void)processZipFile
{
}

@end
