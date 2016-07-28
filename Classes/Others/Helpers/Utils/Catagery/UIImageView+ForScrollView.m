//
//  UIImageView+ForScrollView.m
//  C+R
//
//  Created by sravan.vodnala on 10/07/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import "UIImageView+ForScrollView.h"

#define noDisableVerticalScrollTag 836913
#define noDisableHorizontalScrollTag 836914

@implementation UIImageView (ForScrollView)

- (void) setAlpha:(float)alpha
{
    if (self.superview.tag == noDisableVerticalScrollTag)
    {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin)
        {
            if (self.frame.size.width <10 && self.frame.size.height > self.frame.size.width)
            {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.height < sc.contentSize.height)
                {
                    [sc bringSubviewToFront:self];
                    self.backgroundColor = [UIColor colorWithRed:23/255.0 green:164/255.0 blue:161/255.0 alpha:1.0f];
                    return;
                }
            }
        }
    }
    
    if (self.superview.tag == noDisableHorizontalScrollTag)
    {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin)
        {
            if (self.frame.size.height <10 && self.frame.size.height < self.frame.size.width)
            {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width)
                {
                    return;
                }
            }
        }
    }
    
    [super setAlpha:alpha];
}
@end
