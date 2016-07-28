//
//  Structures.m
//  InclinIQ
//
//  Created by Gagan on 08/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "Structures.h"

//Request
@implementation loginRequestStruct
@synthesize userName,password;
@end

@implementation  doctorStuct
@synthesize fname,lname,specializationId,specializationName,doctorId;
@end

@implementation specialisationStruct
@synthesize abbrevation, name,Id;
@end

@implementation  eDetailor
@synthesize brandName,noOfSlides,versionNo,Id;
@end

@implementation schedule
@synthesize datetime,ActionBy,ActionDate,CallObjective,CallType;
@end

@implementation ScheduleCall
@end

@implementation ScheduleContent
@end
@implementation structIndexPaths
@end

@implementation ScheduleCallDescription
@end