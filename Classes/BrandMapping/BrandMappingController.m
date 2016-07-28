//
//  BrandMappingController.m
//  InclinIQ
//
//  Created by Gagan on 16/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "BrandMappingController.h"
#import "BrandCell.h"
#import "Defines.h"
#import "HomeViewController.h"
#import "SQLManager.h"
#import "CustomersController.h"
#import "DrBrandMapping.h"
@interface BrandMappingController ()

@end

@implementation BrandMappingController

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
    lblTitleMain.font = font_ProCond(30.0);
    [self designBagroundView:viewBack];
    
    viewMain.frame = CGRectMake(0, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
    isSlide = YES;
    
    [self btnMenuClicked:nil];
    
    
    viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    viewMain.layer.shadowOpacity = 0.7f;
    viewMain.layer.shadowOffset = CGSizeMake(-5.0f,20.0f);
    viewMain.layer.shadowRadius = 10.0f;
    viewMain.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:viewMain.bounds];
    viewMain.layer.shadowPath = pathBtn.CGPath;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(10, 0, viewTitle.frame.size.width-20, viewTitle.frame.size.height);
    view.backgroundColor = [UIColor clearColor];
    [viewTitle addSubview:view];
    
    NSArray *arr = [NSArray arrayWithObjects:@"Name",@"Speciality",@"Target Brands", nil];
    for(int i=0; i<arr.count; i++)
    {
        UILabel *lbl = [[UILabel alloc] init];
        if(i==0)
            lbl.frame = CGRectMake(20, 0, 200, 44);
        if(i==1)
            lbl.frame = CGRectMake(295, 0, 100, 44);
        if(i==2)
            lbl.frame = CGRectMake(495, 0, 150, 44);
        lbl.tag = i;
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.text = [arr objectAtIndex:i];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor colorWithRed:255/255.0 green:202/255.0 blue:54/255.0 alpha:8.0];
        lbl.shadowColor = [UIColor lightGrayColor];
        lbl.font = font_ProCond(22.0);
        [view addSubview:lbl];
    }
    arrData = [[NSMutableArray alloc] init];
    arrSectionArray = [[NSMutableArray alloc] init];
    arrIndexArray = [[NSMutableArray alloc] init];
    filteredTableData = [[NSMutableArray alloc] init];
    arrAlphabets=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    
    SQLManager *objSQl = [SQLManager sharedInstance];
    NSMutableArray * arrData1 = [objSQl getBrandClusterMatrix];
    arrData = [self clubBrandNames:arrData1];
    [self getDataForSearch];
    
}

-(NSMutableArray *)clubBrandNames : (NSMutableArray * )arrData1
{
    NSMutableArray * arrBrands = [[NSMutableArray alloc]init];
    BOOL bFound = NO;
    
    for(int i =0; i<arrData1.count ; i++)
    {
        bFound = NO;
        BrandClust * objBC =  [ arrData1 objectAtIndex:i];
        
        for(int j=0; j< arrBrands.count ; j++)
        {
            BrandClust * objBC1 =  [ arrBrands objectAtIndex:j];
            if([objBC1.drName isEqualToString:objBC.drName])
            {
                objBC1.brandNames = [NSString stringWithFormat:@"%@, %@",objBC1.brandNames,objBC.brandNames];
                bFound = YES;
            }
        }
        
        if(!bFound)
            [arrBrands addObject:objBC];
    }
    
    return arrBrands;
}

-(void)getDataForSearch
{
    for(int i = 0; i<[arrAlphabets count];i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int x=0;x<[arrData count];x++)
        {
            BrandClust *objDocStruct = [arrData objectAtIndex:x];
            
            NSString *myString = objDocStruct.drName;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            
            if( [ichar isEqualToString:[arrAlphabets objectAtIndex:i]])
            {
                NSLog(@"%@", myString);
                [array addObject:objDocStruct];
            }
        }
        if([array count])
        {
            BrandClust *objDocStructSub = [array objectAtIndex:0];
            
            NSString *myString = objDocStructSub.drName;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            [arrIndexArray addObject:ichar];
            [arrSectionArray addObject:array];
        }
        array = nil;
    }
    NSLog(@"%@",[arrSectionArray description]);
    NSLog(@"%d",[arrSectionArray count]);
    
    
}
#pragma mark - SearchBar Delegate methods
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    stringSearch = text;
    if(text.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        
        if([filteredTableData count])
            [filteredTableData removeAllObjects];
        
        NSLog(@"%@",[filteredTableData description]);
        
        for (int i=0; i<[arrData count];i++)
        {
            BrandClust *obj = [arrData objectAtIndex:i];
            NSRange descriptionRange = [obj.drName rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:[arrData objectAtIndex:i]];
            }
        }
    }
    
    [tblView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark -
#pragma mark TableView Delegates
#pragma mark TableView Delegate Methods
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
//    view.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
//
//    NSArray *arr = [NSArray arrayWithObjects:@"Name",@"Target",@"Speciality",@"Account",@"Address",@"Last call", nil];
//    for(int i=0; i<arr.count; i++)
//    {
//        UILabel *lbl = [[UILabel alloc] init];
//        if(i==0)
//            lbl.frame = CGRectMake(0, 0, 200, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(205, 0, 40, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(320, 0, 150, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(480, 0, 150, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(655, 0, 250, 44);
//        if(i==0)
//            lbl.frame = CGRectMake(915, 0, 90, 44);
//        lbl.tag = i;
//        lbl.textAlignment = NSTextAlignmentLeft;
//        lbl.text = [arr objectAtIndex:i];
//        lbl.backgroundColor = [UIColor clearColor];
//        lbl.font = fontHelveticaBold_15;
//        [view addSubview:lbl];
//    }
//    return view;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    view.backgroundColor =  [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isFiltered)
        return 1;
    else
        return [arrSectionArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered)
        return [filteredTableData count];
    else
        return [[arrSectionArray objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BrandCell";
    BrandCell *cell = (BrandCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BrandClust *objStructure = nil;
    
    if(isFiltered)
    {
        objStructure = [filteredTableData objectAtIndex:indexPath.row];
        
    }
    else
    {
        objStructure = [[arrSectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
    }
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BrandCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.lblName.text = [NSString stringWithFormat:@"%@",objStructure.drName];
        cell.lblTargetBrands.text = [NSString stringWithFormat:@"%@",objStructure.brandNames];
        cell.lblSpeciality.text = [NSString stringWithFormat:@"%@",objStructure.specialisation];
        
        cell.lblName.font = font_ProCond(20.0);
        cell.lblSpeciality.font = font_ProCond(20.0);
        cell.lblTargetBrands.font = font_ProCond(20.0);
        
        if(indexPath.row %2 == 0)
            cell.contentView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        else
            cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DrBrandMapping *obj = [[DrBrandMapping alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    obj = nil;
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(isFiltered)
        return 0;
    else
        return arrIndexArray;
}
#pragma mark - Search Bar
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(isFiltered)
        return stringSearch;
    else
    {
        return [arrIndexArray objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    if(isFiltered)
        return 0;
    else
        return [arrIndexArray indexOfObject:title];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = fontMain(25.0);
    [header setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnTargetClicked:(UIButton *)sender
{
//    BrandMappingController *objBrand = [[BrandMappingController alloc]init];
//    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appdelegate ChangeRootViewControllerAnimation:objBrand];
}

- (IBAction)btnCustomersClicked:(UIButton *)sender
{
    CustomersController *projectViewController = [[CustomersController alloc]init];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeRootViewControllerAnimation:projectViewController];
}

- (IBAction)btnHomeButtonClicked:(UIButton *)sender
{
    HomeViewController *projectViewController = [[HomeViewController alloc]init];
    projectViewController.isFirstTime = YES;
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate ChangeRootViewControllerAnimation:projectViewController];
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


@end
