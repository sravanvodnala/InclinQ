//
//  eDetailerController.m
//  InclinIQ
//
//  Created by Gagan on 29/09/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "eDetailerController.h"
#import "eDetailerPreviewCustomCell.h"
#import "eDetailerSearchCell.h"
#import "Defines.h"
#import "SQLManager.h"
#import "eDetailerWebViewController.h"
#import "eDetailerSlideShow.h"
@interface eDetailerController ()

@end

@implementation eDetailerController

@synthesize currenteDetailor;
- (BOOL)prefersStatusBarHidden NS_AVAILABLE_IOS(7_0)
{
    return YES;
}

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
    isSlide = NO;
    tblPreview.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    tblViewSearch.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];

    viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    viewMain.layer.shadowOpacity = 0.7f;
    viewMain.layer.shadowOffset = CGSizeMake(-5.0f,20.0F);
    viewMain.layer.shadowRadius = 10.0f;
    viewMain.layer.masksToBounds = NO;
    
    UIBezierPath *pathBtn = [UIBezierPath bezierPathWithRect:viewMain.bounds];
    viewMain.layer.shadowPath = pathBtn.CGPath;
    
    [self designBagroundView:viewBack];

    
    viewMain.frame = CGRectMake(320, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height);
    isSlide = YES;
    
    [self btnMenuClicked:nil];
    
    arrData = [[NSMutableArray alloc] init];
    arrDetailers  = [[NSMutableArray alloc] init];
    arrSectionArray = [[NSMutableArray alloc] init];
    arrIndexArray = [[NSMutableArray alloc] init];
    filteredTableData = [[NSMutableArray alloc] init];
    arrAlphabets=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    //****** Retriving from Database
    SQLManager * objSQL = [SQLManager sharedInstance];
    arrData = [objSQL geteDetailerDataForPrew:YES]; //ALL
    
    if(arrData.count)
    {
        eDetailor *objStruct = [arrData objectAtIndex:0];
        [arrDetailers addObjectsFromArray:objStruct.arrSlides];
        currenteDetailor = objStruct;
    }
//    else
//            [tblViewSearch reloadData];
    
   
    [self getDataForSearch];
}
-(void)getDataForSearch
{
    for(int i = 0; i<[arrAlphabets count];i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int x=0;x<[arrData count];x++)
        {
            eDetailor *objDocStruct = [arrData objectAtIndex:x];
            
            NSString *myString = objDocStruct.brandName;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            
            if( [ichar isEqualToString:[arrAlphabets objectAtIndex:i]])
            {
                NSLog(@"%@", myString);
                [array addObject:objDocStruct];
            }
        }
        if([array count])
        {
            eDetailor *objDocStructSub = [array objectAtIndex:0];
            
            NSString *myString = objDocStructSub.brandName;
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
            // NSRange nameRange = [stringSearch rangeOfString:text options:NSCaseInsensitiveSearch];
            eDetailor *obj = [arrData objectAtIndex:i];
            NSRange descriptionRange = [obj.brandName rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:[arrData objectAtIndex:i]];
            }
        }
    }
    
    [tblViewSearch reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark -
#pragma mark TableView Delegates
#pragma mark TableView Delegate Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    view.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    view.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblViewSearch)
        return 90.0;
    return 100.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == tblViewSearch)
    {
        if(arrData.count == 0)
            return 1;

        if(isFiltered)
            return 1;
        else
            return [arrSectionArray count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblViewSearch)
    {
         if(arrData.count == 0)
             return 1;
        
        if(isFiltered)
            return [filteredTableData count];
        else
            return [[arrSectionArray objectAtIndex:section] count];
        
        
    }
    
    if(tableView == tblPreview)
        return arrDetailers.count;
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblViewSearch) //SearchBar
    {
        if(arrData.count == 0)
        {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell1"];
            if(!cell)
            {
                cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                UILabel *lbl= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
                lbl.textColor = [UIColor blackColor];
                lbl.text = @"Currently there are no e-Detailers.";
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
            static NSString *CellIdentifier = @"eDetailerSearchCell";
            eDetailerSearchCell *cell = (eDetailerSearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            eDetailor *objStructure = nil;
            
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
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"eDetailerSearchCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
                cell.lblBrandName.text = [NSString stringWithFormat:@"%@",objStructure.brandName];
                cell.lblNoofSlides.text = [NSString stringWithFormat:@"Number of Slides : %d",objStructure.noOfSlides];
                cell.lblVersionNumber.text = [NSString stringWithFormat:@"Version : %@",objStructure.versionNo];
                UIImage *image = [UIImage imageWithContentsOfFile:objStructure.imgPath];
                
                if(image == nil)
                    cell.imgView.image = [UIImage imageNamed:@"preview.png"];
                else
                    cell.imgView.image = image;
                
                cell.lblBrandName.font = font_ProCond(20.0);
                cell.lblNoofSlides.font = font_ProCond(18.0);
                cell.lblVersionNumber.font = font_ProCond(18.0);
                
                if(currenteDetailor == nil)
                {
                    if(indexPath.row == 0)
                        cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                    
                }
                else
                {
                    if(!(objStructure == currenteDetailor))
                        cell.contentView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
                    else
                        cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    else
    {
        static NSString *CellIdentifier = @"eDetailerPreviewCustomCell";
        eDetailerPreviewCustomCell *cell = (eDetailerPreviewCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        eDetailorSlide *objStructure = [arrDetailers objectAtIndex:indexPath.row];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"eDetailerPreviewCustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.lblSpecialization.text = [NSString stringWithFormat:@"TargetSpecialization : %@",objStructure.TargetSpecialization];
            cell.lblSlideNo.text = [NSString stringWithFormat:@"Slide %d",objStructure.slideNo];
            UIImage *image = [UIImage imageWithContentsOfFile:objStructure.thumbPath];
            if(image == nil)
                cell.imgView.image = [UIImage imageNamed:@"preview.png"];
            else
            cell.imgView.image = image;
            
            cell.lblSpecialization.font = font_ProCond(20.0);
            cell.lblSlideNo.font = font_ProCond(20.0);
            
//            if(indexPath.row %2 == 0)
                cell.contentView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
//            else
//                cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(arrData.count == 0)
        return;
    if(tableView == tblViewSearch)
    {
        eDetailor *objStructure = nil;
        if(isFiltered)
            objStructure = [filteredTableData objectAtIndex:indexPath.row];
        else
            objStructure = [[arrSectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        currenteDetailor = objStructure;
        if(arrDetailers.count)
            [arrDetailers removeAllObjects];
        [arrDetailers addObjectsFromArray:objStructure.arrSlides];
        [tblViewSearch reloadData];
        [tblPreview reloadData];
    }
    if(tableView == tblPreview)
    {
        eDetailorSlide *obj = [arrDetailers objectAtIndex:indexPath.row];
        
        eDetailerWebViewController *objController = [[eDetailerWebViewController alloc] initWithNibName:nil bundle:nil];
        objController.objStruct = obj;
        [self.navigationController pushViewController:objController animated:YES];
        objController = nil;
    }
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == tblViewSearch)
    {
        if(isFiltered)
            return 0;
        else
            return arrIndexArray;
    }
    return nil;
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
    if(tableView == tblViewSearch)
    {
        
        if(isFiltered)
            return 0;
        else
            return [arrIndexArray indexOfObject:title];
    }
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPreviewClicked:(UIButton *)sender
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"In progress" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    
   eDetailerSlideShow *objController = [[eDetailerSlideShow alloc] initWithNibName:nil bundle:nil];
   [self.navigationController pushViewController:objController animated:YES];
   objController.captureTime = NO;
   objController.currenteDetailor =  currenteDetailor;
   objController = nil;
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
