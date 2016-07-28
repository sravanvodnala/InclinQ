//
//  DefaultViewController.h
//  InclinIQ
//
//  Created by Gagan on 14/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Defines.h"
#import "AppDelegate.h"
#define tagValueView 987654321
@interface DefaultViewController : UIViewController
{
    NSInteger indexPathOfCell;

    UIButton *btnLeft;
    UIButton *btnRight;
    
}
-(void)designBagroundView:(UIView *)viewBackGround;
-(void)btnSlideMenuListClicked:(UIButton *)sender;
-(void)logOut;
-(void)btnRightClicked;
-(UILabel *)createUIlabel:(CGFloat )xpos withYposition:(CGFloat)ypos withWidth:(CGFloat )width withHeight:(CGFloat)height withText:(NSString *)text withTag:(NSInteger )tagValue withFont:(UIFont *)font;
-(UIImageView *)createUIImageView:(CGFloat )xpos withYposition:(CGFloat)ypos withWidth:(CGFloat )width withHeight:(CGFloat)height withImageName:(NSString *)imageName withTag:(NSInteger )tagValue;
-(UIButton *)createUIButton:(CGFloat )xpos withYposition:(CGFloat)ypos withWidth:(CGFloat )width withHeight:(CGFloat)height withTitle:(NSString *)title withFontSize:(CGFloat)fontSize withImageName:(NSString *)imageName;

-(void)setShadowEffect:(UIImageView *)view;
-(void)setShadowEffectForUIButton:(UIButton *)view;
-(void)setShadowEffectForUIWebView:(UIWebView *)view;
-(void)setShadowEffectForUITextView:(UITextView *)view;
-(void)setShadowEffectForUIScrlView:(UIScrollView *)view;
-(void)setShadowEffectForUIView:(UIView *)view;
@end
