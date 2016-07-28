//
//  DefaultViewController.m
//  InclinIQ
//
//  Created by Gagan on 14/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "DefaultViewController.h"
#import "CustomCell.h"
#import "LoginViewController.h"
#import "Calander.h"
#import "CustomCell.h"
#import "ToolsViewController.h"
#import "HomeViewController.h"
#import "UpdateViewController.h"
#import "eDetailerController.h"
#import "CustomersController.h"
#import "SettingsController.h"
#import "BrandMappingController.h"
@interface DefaultViewController ()

@end
@implementation DefaultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
- (BOOL)prefersStatusBarHidden NS_AVAILABLE_IOS(7_0)
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [Utils getLocalizedString:@"mymessages_title"];
    self.navigationController.navigationBarHidden = YES;
    
//    UIImage *img1;
//    btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    img1 = [UIImage imageNamed:@"menu_whote.png"];
//    btnLeft.frame = CGRectMake(0,0,48,40);
//    [btnLeft setImage:img1 forState:UIControlStateNormal];
//    [btnLeft addTarget:self action:@selector(btnHomeClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationController.navigationBarHidden = YES;
//    UIBarButtonItem *lefttBtn = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
//    self.navigationItem.leftBarButtonItem = lefttBtn;
//    
//    if(LessThanIOS7)
//    {
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    }
//    else
//    {
//        [self setNeedsStatusBarAppearanceUpdate];
//        self.navigationController.navigationBar.barTintColor =  [UIColor whiteColor];
//        self.navigationController.navigationBar.translucent = NO;
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    }
    
//    btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnRight setImage:[UIImage imageNamed:@"addUser_White.png"] forState:UIControlStateNormal];
//    [btnRight addTarget:self action:@selector(btnRightClicked) forControlEvents:UIControlEventTouchUpInside];
//    btnRight.frame = CGRectMake(0,0,44,44);
//    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
-(void)btnHomeClicked
{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [UIView commitAnimations];
}
-(void)btnRightClicked
{
    
}
-(void)designBagroundView:(UIView *)viewBackGround
{
    NSMutableArray *arrList = [[NSMutableArray alloc] initWithObjects:@"Home",@"Customers",@"Plan",@"eDetailers",@"Updates",@"Settings", nil];
    NSMutableArray *arrImages = [[NSMutableArray alloc]initWithObjects:@"icon-home-30x30.png",@"icon-customers-30x30.png",@"icon-plan-30x30.png",@"icon-eDetailers-30x30.png",@"icon-updates-30x30.png",@"icon-settings-30x30.png", nil];
    

    viewBackGround.tag = tagValueView;
    viewBackGround.backgroundColor = defaultYellow;
    
    
    UIImageView *imgIcon = [self createUIImageView:80 withYposition:60 withWidth:150 withHeight:85 withImageName:@"left-nav-logo-252x142.png" withTag:10];
    [viewBackGround addSubview:imgIcon];
    
    NSInteger xpos = 40, ypos = 150, width = 200, height = 40, widthImage = 30, heightImage = 30;
   
    for(int i=0; i<arrList.count; i++)
    {
        ypos += height+25;
        
        NSString *strTemp = [NSString stringWithFormat:@"%@",[arrImages objectAtIndex:i]];

        UIImageView *imgDoctor = [self createUIImageView:xpos withYposition:ypos+2 withWidth:widthImage withHeight:heightImage withImageName:strTemp withTag:10];
        [viewBackGround addSubview:imgDoctor];
        
        strTemp = [NSString stringWithFormat:@"%@",[arrList objectAtIndex:i]];
        
        UILabel *lblDocName = [self createUIlabel:xpos+widthImage+20 withYposition:ypos withWidth:width withHeight:height withText:strTemp withTag:10 withFont:font_ProCond(24.0)];
        lblDocName.textColor = [UIColor blackColor];
        [viewBackGround addSubview:lblDocName];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 3000+i;
        [btn addTarget:self action:@selector(btnSlideMenuListClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = lblDocName.frame;
        [viewBackGround addSubview:btn];
    }
}
-(void)btnSlideMenuListClicked:(UIButton *)sender
{
    if(sender.tag == 3000)
    {
        /*********   Customers    ********/
        [self HomeViewController];
    }
    else
    if(sender.tag == 3001)
    {
        /*********   Customers    ********/
        [self CustomersViewController];
    }
    else if(sender.tag == 3002)
    {
        /*********  Plan     ********/
        [self CalanderViewController];
    }
    else if(sender.tag == 3003)
    {
        /*********   eDetailers    ********/
        [self eDetailerController];
    }
    else if(sender.tag == 3004)
    {
        [self UpdateeDetailorViewController];
        
        /*********   Updates    ********/

    }
    else if(sender.tag == 3005)
    {
        /*********   Settings    ********/
        [self ToolsViewController];

        
    }
    else if(sender.tag == 3006)
    {
        /*********  Logout     ********/
        [self logOut];
    }
}
#pragma mark - ReusableMethods
-(UILabel *)createUIlabel:(CGFloat )xpos withYposition:(CGFloat)ypos withWidth:(CGFloat )width withHeight:(CGFloat)height withText:(NSString *)text withTag:(NSInteger )tagValue withFont:(UIFont *)font
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(xpos, ypos, width, height);
    lbl.tag = tagValue;
    lbl.text = text;
    lbl.numberOfLines = 1000;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = font;
    return lbl;
}
-(UIImageView *)createUIImageView:(CGFloat )xpos withYposition:(CGFloat)ypos withWidth:(CGFloat )width withHeight:(CGFloat)height withImageName:(NSString *)imageName withTag:(NSInteger )tagValue
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(xpos, ypos, width, height);
    imgView.tag = tagValue;
    imgView.image = [UIImage imageNamed:imageName];
    imgView.backgroundColor = [UIColor clearColor];
    return imgView;
}
-(UIButton *)createUIButton:(CGFloat )xpos withYposition:(CGFloat)ypos withWidth:(CGFloat )width withHeight:(CGFloat)height withTitle:(NSString *)title withFontSize:(CGFloat)fontSize withImageName:(NSString *)imageName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(xpos, ypos, width, height);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)btnClicked:(UIButton *)sender
{
    
}
-(void)setShadowEffect:(UIImageView *)view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.7f;
    view.layer.shadowOffset = CGSizeMake(7.0f, 7.0f);
    view.layer.shadowRadius = 5.0f;
    view.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = pathBtn.CGPath;
}
-(void)setShadowEffectForUIButton:(UIButton *)view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowOffset = CGSizeMake(7.0f, 7.0f);
    view.layer.shadowRadius = 5.0f;
    view.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = pathBtn.CGPath;
}
-(void)setShadowEffectForUIWebView:(UIWebView *)view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.7f;
    view.layer.shadowOffset = CGSizeMake(7.0f, 7.0f);
    view.layer.shadowRadius = 5.0f;
    view.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = pathBtn.CGPath;
}
-(void)setShadowEffectForUITextView:(UITextView *)view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.7f;
    view.layer.shadowOffset = CGSizeMake(7.0f, 7.0f);
    view.layer.shadowRadius = 5.0f;
    view.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = pathBtn.CGPath;
}
-(void)setShadowEffectForUIScrlView:(UIScrollView *)view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.7f;
    view.layer.shadowOffset = CGSizeMake(7.0f, 7.0f);
    view.layer.shadowRadius = 5.0f;
    view.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = pathBtn.CGPath;
}
-(void)setShadowEffectForUIView:(UIView *)view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.7f;
    view.layer.shadowOffset = CGSizeMake(7.0f, 7.0f);
    view.layer.shadowRadius = 5.0f;
    view.layer.masksToBounds = YES;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = pathBtn.CGPath;
}
-(void)HomeViewController
{
    HomeViewController *projectViewController = [[HomeViewController alloc]init];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeViewController:projectViewController];
}

-(void)logOut
{
    LoginViewController *projectViewController = [[LoginViewController alloc]init];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeRootViewController:projectViewController];
}
-(void)CalanderViewController
{
    Calander *projectViewController = [[Calander alloc]init];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeViewController:projectViewController];
}
-(void)CustomersViewController
{
    CustomersController *projectViewController = [[CustomersController alloc]init];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeViewController:projectViewController];
}
-(void)homeClicked
{
    HomeViewController *projectViewController = [[HomeViewController alloc]init];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeViewController:projectViewController];
}
-(void)UpdateeDetailorViewController
{
    UpdateViewController  *objUDV = [[UpdateViewController alloc]init];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeViewController:objUDV];
}
-(void)ToolsViewController
{
    SettingsController * objTools = [[SettingsController alloc]initWithNibName:@"SettingsController" bundle:nil];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeViewController:objTools];
}
-(void)eDetailerController
{
    eDetailerController * objTools = [[eDetailerController alloc]initWithNibName:@"eDetailerController" bundle:nil];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeViewController:objTools];
}
@end