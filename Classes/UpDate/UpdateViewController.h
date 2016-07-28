//
//  UpdateViewController.h
//  InclinIQ
//
//  Created by Gagan on 30/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultViewController.h"
#import "DownloadManager.h"
@interface UpdateViewController : DefaultViewController <DownloadManagerDelegate>
{
     IBOutlet UIView *viewMain;
     IBOutlet UIView *viewBack;
     BOOL isSlide;
     IBOutlet UITableView *tblView;
    NSInteger intTagValue;
    BOOL isDownloading;
    NSString * statusMessage;
}
@property (strong, nonatomic) NSURLConnection *connectionManager;
@property (strong, nonatomic) NSMutableData *downloadedMutableData;
@property (strong, nonatomic) NSURLResponse *urlResponse;

@property (strong, nonatomic) DownloadManager *downloadManager;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic) NSInteger downloadErrorCount;
@property (nonatomic) NSInteger downloadSuccessCount;

- (IBAction)btnMenuClicked:(UIButton *)sender;
@property (nonatomic,strong) NSMutableArray * arrData;
@end
