//
//  Utils.h
//  DateAndTime
//
//  Created by sravan.vodnala on 31/03/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface Utils : NSObject
+(NSString *)RetrieveDate:(NSString *)str;
+(NSString *)retriveTime:(NSString *)str;
+(NSString *)retrievCurrentTime;
+(NSString *)getLocalizedString:(NSString *)name;

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret;
+(BOOL)checkNet;

+(NSString *)getNormalString:(NSString *)stringTemp;
+(CGFloat )getWidthOfString:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width;
+(CGFloat )getHeightOfString:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width;
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize forImage:(UIImage *)image;
+ (UIImage *)getScaledImage:(UIImage *)actualImage toSize:(CGRect)requiredSize;
+(NSString *)getCurrentDate;
+(NSString *)getCurrentTime;
+(NSString *)getCurrentDateTime;
+(BOOL)isPreviousDate:(NSDate *)date;
+(NSString *)checkForNil:(NSString *)value;
@end
