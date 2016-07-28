//
//  Utils.m
//  DateAndTime
//
//  Created by sravan.vodnala on 31/03/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import "Utils.h"
#import "base64.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+stripHtml.h"
@implementation Utils

+(NSString *)getCurrentTime
{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    return resultString;
    
    
    
//    NSDate *currentTime = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"hh-mm"];
//    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    

}

+(NSString *)getCurrentDateTime
{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    return resultString;
    
    
    
    //    NSDate *currentTime = [NSDate date];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"hh-mm"];
    //    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    
}

+(NSString *)getCurrentDate
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    return dateString;
    
    
}
+(NSString *)checkForNil:(NSString *)value
{
    if((value == nil) || ([value isEqualToString:@""]))
        return @"-";
    else
        return value;
    
}

+(NSString *)RetrieveDate:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSArray *temp = [[arr objectAtIndex:1] componentsSeparatedByString:@"."];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[temp objectAtIndex:0]];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
//    NSDate *formatedDate = [dateFormatter1 dateFromString:dateStr];
//    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
//    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
//    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:formatedDate];
//    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:formatedDate];
//    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
//    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:formatedDate];
    
//    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
//    [dateFormatters setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatters setTimeStyle:NSDateFormatterNoStyle];
//    [dateFormatters setDoesRelativeDateFormatting:NO];
//    [dateFormatters setTimeZone:[NSTimeZone systemTimeZone]];
//    
//    dateStr = [dateFormatters stringFromDate:destinationDate];
    
//    NSArray *arrmain = [dateStr componentsSeparatedByString:@" at "];
//    dateStr = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:0]];
//    
//    NSArray *arrDate = [dateStr componentsSeparatedByString:@"/"];
//     dateStr = [NSString stringWithFormat:@"%@- %@- %@",[arrDate objectAtIndex:0],[arrDate objectAtIndex:1],[arrDate objectAtIndex:2]];
  
    NSArray *arrmain = [dateStr componentsSeparatedByString:@" "];
    dateStr = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:0]];
    
    NSArray *arrDate = [dateStr componentsSeparatedByString:@"-"];
    dateStr = [NSString stringWithFormat:@"%@-%@-%@",[arrDate objectAtIndex:1],[arrDate objectAtIndex:2],[arrDate objectAtIndex:0]];

    return dateStr;
}
+(NSString *)retriveTime:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSArray *temp = [[arr objectAtIndex:1] componentsSeparatedByString:@"."];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[temp objectAtIndex:0]];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *formatedDate = [dateFormatter1 dateFromString:dateStr];
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:formatedDate];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:formatedDate];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:formatedDate];
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateStyle:NSDateFormatterNoStyle];
    [dateFormatters setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatters setDoesRelativeDateFormatting:NO];
    [dateFormatters setTimeZone:[NSTimeZone systemTimeZone]];

    dateStr = [dateFormatters stringFromDate:destinationDate];
   
    NSArray *arrTime = [dateStr componentsSeparatedByString:@":"];
    if([[arrTime objectAtIndex:0] length] == 1)
        dateStr = [NSString stringWithFormat:@"0%@:%@",[arrTime objectAtIndex:0],[arrTime objectAtIndex:1]];
    return dateStr;
}
+(NSString *)retrievCurrentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    return currentTime;
}
+(NSString *) getLocalizedString:(NSString *)name
{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * languageSelected = [defaults objectForKey:@"Language"];
        NSString *fname = [[NSBundle mainBundle] pathForResource:languageSelected ofType:@"strings"];
        NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:fname];
        NSString *message = [d objectForKey:name];
    
    return message;
}

+(NSString *)aaa:(NSString*)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * languageSelected = [defaults objectForKey:@"Language"];
    NSString *fname = [[NSBundle mainBundle] pathForResource:languageSelected ofType:@"strings"];
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:fname];
    NSString *message = [d objectForKey:name];
    
    return message;
}

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeDat(result, 20, base64Result, &theResultLength, YES);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    
    return base64EncodedResult;
}

+(BOOL)checkNet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"NO NET");
        return NO;
    }
    else
    {
        NSLog(@"YES NET");
        return YES;
    }
}
+(NSString *)getNormalString:(NSString *)stringTemp
{
    NSString *stringReplay = [[stringTemp stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    return stringReplay;
}
+(CGFloat )getHeightOfString:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width
{
    if([string isEqualToString:@""] || string == nil)
        return 0.0;
    else
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSAttributedString *attVal = [[NSAttributedString alloc] initWithString:[self getNormalString:string] attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName : fontType}];
        CGRect textRect = [attVal boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return ceilf(textRect.size.height);
    }
}
+(CGFloat )getWidthOfString:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width
{
    if([string isEqualToString:@""] || string == nil)
        return 0.0;
    else
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSAttributedString *attVal = [[NSAttributedString alloc] initWithString:[self getNormalString:string] attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName : fontType}];
        CGRect textRect = [attVal boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return ceilf(textRect.size.height);
    }
}
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize forImage:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            // thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)getScaledImage:(UIImage *)actualImage toSize:(CGRect)requiredSize
{
	UIGraphicsBeginImageContext( requiredSize.size );
	[actualImage drawInRect:CGRectMake(0,0,requiredSize.size.width,requiredSize.size.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}
+(BOOL)isPreviousDate:(NSDate *)date
{
    BOOL isPrevious = NO;
    
    NSDate * today = [NSDate date];
    NSComparisonResult result = [today compare:date];
    switch (result)
    {
        case NSOrderedAscending:
            NSLog(@"Future Date");
            break;
        case NSOrderedDescending:
        {
            isPrevious = YES;
            break;
        }
        case NSOrderedSame:
            isPrevious = YES;
            break;
        default:
            NSLog(@"Error Comparing Dates");
            break;
    }
    return isPrevious;
}

@end
