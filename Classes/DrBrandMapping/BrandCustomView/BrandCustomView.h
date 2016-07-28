//
//  BrandCustomView.h
//  InclinIQ
//
//  Created by Gagan on 26/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandCustomView : UIView
{
    CGRect tempRect;
    CGRect actualRect;
    
    BOOL isRotated;
}


@property(nonatomic, retain) NSString *strBrandName;

@end
