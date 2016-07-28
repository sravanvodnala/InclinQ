//
//  UpdateViewController.m
//  InclinIQ
//
//  Created by Gagan on 30/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "UpdateViewController.h"
#import "ZipArchive.h"
#import "eDetailorPreviewViewController.h"
#import "UpdateCustomCell.h"
#import "SQLManager.h"
#import "WebServerManager.h"
@interface UpdateViewController ()

@end

@implementation UpdateViewController

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
    
    [self Login];
    self.navigationController.navigationBarHidden = YES;
    
    [self designBagroundView:viewBack];
    
    viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
    isSlide = YES;
    
    [self btnMenuClicked:nil];
    
    
    
    viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    viewMain.layer.shadowOpacity = 0.7f;
    viewMain.layer.shadowOffset = CGSizeMake(-5.0f,20.0f);
    viewMain.layer.shadowRadius = 10.0f;
    viewMain.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:viewMain.bounds];
    viewMain.layer.shadowPath = pathBtn.CGPath;
    
    SQLManager * objSQL = [SQLManager sharedInstance];
    _arrData = [objSQL geteDetailors:0];
    
    
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
    
    //[request setURL:[NSURL URLWithString:@"http://mobility-test.datamatics.com/demo/Map/prod1.zip"]];
    //[data writeToFile:pdfPath atomically:YES];
    // queue the files to be downloaded
    
    
    self.downloadManager = [[DownloadManager alloc] initWithDelegate:self];
    for(int i=0; i< _arrData.count ; i++)
    {
        eDetailor * objeDet = [_arrData objectAtIndex:i];
        NSString *devicePath = [eDeTailorFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.zip",objeDet.Id]];
        
        //        NSString *urlString = @"http://mobility-test.datamatics.com/demo/Map/prod1.zip";
        NSString *downloadFilename = [eDeTailorFolderPath stringByAppendingPathComponent:[devicePath lastPathComponent]];
        NSURL *url = [NSURL URLWithString:devicePath];
        [self.downloadManager addDownloadWithFilename:downloadFilename URL:url];
    }
    
    //  [self saveZipToDocument];
}

-(void)saveZipToDocument
{
    NSString *yourOriginalDatabasePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"zip"];
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    
    NSString *eDetailorFolder = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
    
    BOOL isDir = YES;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:eDetailorFolder isDirectory:&isDir])
    {
        if(![fileManager createDirectoryAtPath:eDetailorFolder withIntermediateDirectories:YES attributes:nil error:NULL])
        {
            NSLog(@"Error: Create folder failed %@", eDetailorFolder);
        }
    }
    
    NSString *yourNewDatabasePath = [eDetailorFolder stringByAppendingPathComponent:@"1.zip"];
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath])
    {
        NSError * error = nil;
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:&error] != YES)
        {
            NSLog(@"%@",error.description);
        }
    }
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: yourNewDatabasePath])
    {
        BOOL ret = [za UnzipFileTo: eDetailorFolder overWrite: YES];
        if (NO == ret)
        {
        }
        [za UnzipCloseFile];
    }
}
#pragma mark - DownloadManager Delegate Methods
- (void)didFinishLoadingAllForManager:(DownloadManager *)downloadManager
{
    NSString *message;
    
    NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:self.startDate];
    
    if (self.downloadErrorCount == 0)
        message = [NSString stringWithFormat:@"%ld file(s) downloaded successfully. The files are located in the app's Documents folder on your device/simulator. (%.1f seconds)", (long)self.downloadSuccessCount, elapsed];
    else
        message = [NSString stringWithFormat:@"%ld file(s) downloaded successfully. %ld file(s) were not downloaded successfully. The files are located in the app's Documents folder on your device/simulator. (%.1f seconds)", (long)self.downloadSuccessCount, (long)self.downloadErrorCount, elapsed];
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}
- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFinishLoading:(Download *)download;
{
    self.downloadSuccessCount++;
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
}

-(void)reloadTableView
{
    [tblView reloadData];
}
- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFail:(Download *)download;
{
    self.downloadErrorCount++;
    
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
}

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidReceiveData:(Download *)download;
{
    for (NSInteger row = 0; row < [downloadManager.downloads count]; row++)
    {
        if (download == downloadManager.downloads[row])
        {
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            break;
        }
    }
}

#pragma mark - Table view utility methods

#pragma mark - IBAction methods

- (IBAction)tappedCancelButton:(id)sender
{
    [self.downloadManager cancelAll];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_arrData.count == 0)
        return 1;
    else
        return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrData.count == 0)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell1"];
        if(!cell)
        {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            UILabel *lbl= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
            lbl.textColor = [UIColor blackColor];
            lbl.text = @"Currently there are no Updates.";
            lbl.font = font_ProCond(25.0);
            lbl.numberOfLines = 5;
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lbl];
        }
        return  cell;
    }
    else
    {
        static NSString *CellIdentifier = @"UpdateCustomCell";
        
        UpdateCustomCell *cell = (UpdateCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        eDetailor * objeDet = [_arrData objectAtIndex:indexPath.row];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpdateCustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            [cell.btnDownload addTarget:self action:@selector(updateClicled:) forControlEvents:UIControlEventTouchUpInside];
            cell.activityIndicator.tag = indexPath.row;
            cell.lblPercantage.hidden = YES;
            cell.activityIndicator.hidden = YES;
            cell.lblPercantage.tag = indexPath.row;
            cell.btnDownload.tag = indexPath.row;
            cell.tag = indexPath.row;
        }
        
        cell.lblTitle.font = font_ProBoldCondensed(20.0);
        cell.lblClideCount.font = font_ProCond(20.0);
        cell.lblVersion.font = font_ProCond(20.0);
        cell.lblPercantage.font = font_ProCond(20.0);
        
        cell.lblTitle.text = objeDet.brandName;
        cell.lblVersion.text = [ NSString stringWithFormat:@" %@ ",objeDet.versionNo];
        cell.lblClideCount.text = [ NSString stringWithFormat:@" %d",objeDet.noOfSlides];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 5.0f);
        cell.activityIndicator.transform = transform;
        
        if(objeDet.isDownloaded)
        {
            cell.btnDownload.hidden = YES;
            cell.imgView.image = [UIImage imageNamed:@"preview.png"];
        }
        else
        {
            cell.btnDownload.hidden = NO;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)stopActivity:(NSTimer*)theTimer
{
    NSString *strTemp = (NSString*)[theTimer userInfo];
    UpdateCustomCell *cell = (UpdateCustomCell *)[tblView viewWithTag:[strTemp integerValue]];
    if(cell)
    {
        cell.activityIndicator.hidden = YES;
        cell.btnDownload.userInteractionEnabled = YES;
    }
}
- (void)makeMyProgressBarMoving
{
    UpdateCustomCell *cell = (UpdateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:intTagValue inSection:0]];
    float actual = [cell.activityIndicator progress];
    if (actual < 1.0)
    {
        cell.activityIndicator.progress += 0.0005;
        cell.lblPercantage.text = [NSString stringWithFormat:@"%0.f %%",cell.activityIndicator.progress*100];
        [NSTimer scheduledTimerWithTimeInterval:0.0005 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
    }
    else
    {
        isDownloading = NO;
        [cell.activityIndicator removeFromSuperview];
        [cell.btnDownload removeFromSuperview];
        [cell.lblPercantage removeFromSuperview];
        cell.imgView.image = [UIImage imageNamed:@"preview.png"];
        
        SQLManager * objSQL = [SQLManager sharedInstance];
        eDetailor * objeDet = [_arrData objectAtIndex:intTagValue];
        [objSQL updateeDetailorDownloadStatus:objeDet.Id];
    }
}
-(void)updateClicled:(UIButton *)sender
{
    if(!isDownloading)
    {
        intTagValue = sender.tag;
        
        eDetailor * det = [_arrData objectAtIndex:intTagValue];
        
        UpdateCustomCell *cell = (UpdateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:intTagValue inSection:0]];
        
        cell.lblPercantage.text = [NSString stringWithFormat:@"%0.f %%",cell.activityIndicator.progress*100];
        if (cell.activityIndicator.progress == 1)
        {
            cell.activityIndicator.hidden = YES;
        }
        else
        {
            cell.activityIndicator.hidden = NO;
        }

        self.downloadedMutableData = [[NSMutableData alloc] init];
        AppDelegate * objDel = [[UIApplication sharedApplication]delegate];

        NSString * url = [NSString stringWithFormat:@"http://acipl-betasite.com/incliniq/api/download/Edetailer/%@?id=%d", objDel.token,det.Id];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                timeoutInterval:60.0];
        self.connectionManager = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    }
    else
    {
        
    }
}
#pragma mark - Download delegates
-(void)Login
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * username =   [defaults objectForKey:@"Username"];
    NSString * pass     =   [defaults objectForKey:@"Password"];

    NSString * url =[NSString stringWithFormat:@"%@login/GetLogin?userId=%@&pwd=%@&DeviceNo=appId#username",BASE_URL,username,pass];
 
    WebServerManager *webService = [[WebServerManager alloc]init];
    [webService sendRequestToServer:login withObject:nil withRefrence:self URL:url];
}
#pragma mark - Delegate Methods
-(void)didRecivewithError:(NSError *)error
{
    statusMessage =@"Error occurred while getting response from server";
    [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
}
-(void)didRecivewithNullData
{
    statusMessage =@"Login failed";
    [self performSelectorOnMainThread:@selector(ShowAlert) withObject:nil waitUntilDone:YES];
}
-(void)ShowAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:statusMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    isDownloading = NO;

    UpdateCustomCell *cell = (UpdateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:intTagValue inSection:0]];
    [cell.activityIndicator removeFromSuperview];
    [cell.lblPercantage removeFromSuperview];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Error downloading file. Please check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)didReciveResponse:(id)responsedata withMethodName:(wsMethodNames)name error:(int)errorCode
{
    NSLog(@"didReciveResponceObj form view controller");
    NSNumber * err = nil ;
    
    switch (name)
    {
        case login:
            
            err = [responsedata objectForKey:@"IsValid"];
            if ([err intValue] ==0)
            {
                [self performSelectorOnMainThread:@selector(callFailureBlock) withObject:nil waitUntilDone:YES];
            }
            else
            {
                AppDelegate * objDel = [[UIApplication sharedApplication]delegate];
                objDel.token = [responsedata objectForKey:@"token"];
            }
            break;
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%lld", response.expectedContentLength);
    
    if(response.expectedContentLength < 10000)
    {
        [self.connectionManager cancel];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Error downloading file" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UpdateCustomCell *cell = (UpdateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:intTagValue inSection:0]];
    cell.activityIndicator.progress = 0.0;
    cell.activityIndicator.hidden = NO;
    cell.lblPercantage.hidden = NO;
    cell.lblPercantage.text = @"0 %";
    isDownloading = YES;
    self.urlResponse = response;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedMutableData appendData:data];
    
    UpdateCustomCell *cell = (UpdateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:intTagValue inSection:0]];
    cell.activityIndicator.progress = ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length)/100;
    
    cell.lblPercantage.text = [NSString stringWithFormat:@"%0.f %%",cell.activityIndicator.progress*100];
    if (cell.activityIndicator.progress == 1)
    {
        cell.activityIndicator.hidden = YES;
    }
    else
    {
        cell.activityIndicator.hidden = NO;
    }
    NSLog(@"%.0f%%", ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length));
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished");
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    eDetailor * objeDet = [_arrData objectAtIndex:intTagValue];
    
    NSString *eDeTailorFolderPath = [documentsDirectory stringByAppendingPathComponent:@"eDetailors/"];
    
    BOOL isDir = YES;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:eDeTailorFolderPath isDirectory:&isDir])
    {
        if(![fileManager createDirectoryAtPath:eDeTailorFolderPath withIntermediateDirectories:YES attributes:nil error:NULL])
        {
            NSLog(@"Error: Create folder failed %@", eDeTailorFolderPath);
        }
    }
    
    NSString *zipName = [NSString stringWithFormat:@"%d.zip",objeDet.Id];
    NSString *pdfPath = [eDeTailorFolderPath stringByAppendingPathComponent:zipName];
    [self.downloadedMutableData writeToFile:pdfPath atomically:YES];
    
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: pdfPath])
    {
        BOOL ret = [za UnzipFileTo: eDeTailorFolderPath overWrite: YES];
        if (NO == ret)
        {
            
        }
        [za UnzipCloseFile];
    }
    
    UpdateCustomCell *cell = (UpdateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:intTagValue inSection:0]];
    isDownloading = NO;
    [cell.activityIndicator removeFromSuperview];
    [cell.btnDownload removeFromSuperview];
    [cell.lblPercantage removeFromSuperview];

    SQLManager * objSQL = [SQLManager sharedInstance];
    [objSQL updateeDetailorDownloadStatus:objeDet.Id];
   
    eDeTailorFolderPath = [eDeTailorFolderPath stringByAppendingString:[NSString stringWithFormat:@"%d/preview.png",objeDet.Id]];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:eDeTailorFolderPath];
}
/*-(void)processZipFile
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
    
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: pdfPath])
    {
        BOOL ret = [za UnzipFileTo: eDeTailorFolderPath overWrite: YES];
        if (NO == ret)
        {
            
        }
        [za UnzipCloseFile];
    }
} */

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
@end
