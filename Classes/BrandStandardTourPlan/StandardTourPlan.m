//
//  StandardTourPlan.m
//  InclinIQ
//
//  Created by Gagan on 20/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "StandardTourPlan.h"
#import "SQLManager.h"
#import "Defines.h"
#import "StandardTourCustomCell.h"
@interface StandardTourPlan ()

@end

@implementation StandardTourPlan
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
    
    strSTPName = @"";
    arrDoctors = [[NSMutableArray alloc] init];
    arrData = [[NSMutableArray alloc] init];
    arrSectionArray = [[NSMutableArray alloc] init];
    arrIndexArray = [[NSMutableArray alloc] init];
    filteredTableData = [[NSMutableArray alloc] init];
    arrAlphabets=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    SQLManager *objSQl = [SQLManager sharedInstance];
    arrData = [objSQl getSTPDayList];
    [self getDataForSearch];
    
//    for (int i=0; i<10; i++)
//    {
//        specialisationStruct * objSpc = [[specialisationStruct alloc]init];
//        objSpc.name = [NSString stringWithFormat:@"DrName %d",i];
//        objSpc.abbrevation = [NSString stringWithFormat:@"Specialisation %d",i];
//        [arrDoctors addObject:objSpc];
//    }
}
-(void)getDataForSearch
{
    for(int i = 0; i<[arrAlphabets count];i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int x=0;x<[arrData count];x++)
        {
            STPD *objStp = [arrData objectAtIndex:x];
            
            NSString *myString = objStp.FWPName;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            
            if( [ichar isEqualToString:[arrAlphabets objectAtIndex:i]])
            {
                NSLog(@"%@", myString);
                [array addObject:objStp];
            }
        }
        if([array count])
        {
            STPD *objStpSub = [array objectAtIndex:0];
            
            NSString *myString = objStpSub.FWPName;
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
            STPD *obj = [arrData objectAtIndex:i];
            NSRange descriptionRange = [obj.FWPName rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:[arrData objectAtIndex:i]];
            }
        }
    }
    
    [tblSTP reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBarObject
{
    [searchBarObject resignFirstResponder];
}
#pragma mark -
#pragma mark TableView Delegates
#pragma mark TableView Delegate Methods
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    view.backgroundColor =  [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == tblSTP)
        return 40.0;
    return 0.0;
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
    if(tableView == tblSTP)
    {
        if(isFiltered)
            return 1;
        else
            return [arrSectionArray count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblSTP)
    {
        if(isFiltered)
            return [filteredTableData count];
        else
            return [[arrSectionArray objectAtIndex:section] count];
    }
    
        return arrDoctors.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblSTP)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        STPD *objStructure = nil;
        
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
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.textLabel.font = font_ProCond(20.0);
            
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",objStructure.FWPName];
       
        if(intDoctorid == objStructure.Id)
        {
            cell.textLabel.textColor = [UIColor colorWithRed:255/255.0 green:202/255.0 blue:54/255.0 alpha:8.0];
            cell.textLabel.shadowColor = [UIColor lightGrayColor];
            
        }
        else
        {
            cell.textLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:8.0];
            cell.textLabel.shadowColor = [UIColor clearColor];
        }
        if(indexPath.row == 0 && !isFirstTime)
        {
            isFirstTime = YES;
            arrDoctors = objStructure.arrDoctors;
            intDoctorid = objStructure.Id;
            [tblDoctores reloadData];
            
            cell.textLabel.textColor = [UIColor colorWithRed:255/255.0 green:202/255.0 blue:54/255.0 alpha:8.0];
            cell.textLabel.shadowColor = [UIColor lightGrayColor];
        }
        

        if(indexPath.row %2 == 0)
            cell.contentView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        else
            cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"StandardTourCustomCell";
        StandardTourCustomCell *cell = (StandardTourCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        STPDoctor *objStructure  = [arrDoctors objectAtIndex:indexPath.row];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StandardTourCustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.lblDrName.text = [NSString stringWithFormat:@"%@",objStructure.drName];
            cell.lblDrSpecialisation.text = [NSString stringWithFormat:@"%@",objStructure.spcialization];
            
            cell.lblDrName.font = font_ProCond(20.0);
            cell.lblDrSpecialisation.font = font_ProCond(20.0);
            
            if(indexPath.row %2 == 0)
                cell.contentView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
            else
                cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView == tblSTP)
    {
        STPD * objSTPD;
        if(isFiltered)
            objSTPD = [filteredTableData objectAtIndex:indexPath.row];
        else
            objSTPD = [[arrSectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        arrDoctors = objSTPD.arrDoctors;
        intDoctorid = objSTPD.Id;
        [tblDoctores reloadData];
        [tblSTP reloadData];
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == tblSTP)
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
    if(tableView == tblSTP)
    {
        
        if(isFiltered)
            return 0;
        else
            return [arrIndexArray indexOfObject:title];
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if(tableView == tblSTP)
    {
        [view setBackgroundColor:[UIColor whiteColor]];
        
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.font = fontMain(25.0);
        [header setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDraged = NO;
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    isDraged = YES;
    CGPoint startPoint = [[touches anyObject] locationInView:self.view];
    NSLog(@"touchesMoved %lf %lf",startPoint.x,startPoint.y);
    
    
    int xAxis = ((int)(startPoint.x/45.8));
    
    int yAxis =  ((int)(startPoint.y/60));
    
    
    int selectedBtnTag = xAxis + yAxis*7;
    
     NSLog(@"selectedBtnTag %i",selectedBtnTag);
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     isDraged = NO;
    CGPoint startPoint = [[touches anyObject] locationInView:self.view];
    NSLog(@"touchesEnded %lf %lf",startPoint.x,startPoint.y);
    
    if (!isDraged)
    {
        int xAxis = ((int)(startPoint.x/45.8));
        
        int yAxis =  ((int)(startPoint.y/60));
        
        int selectedBtnTag = xAxis + yAxis*7;
        
        NSLog(@"selectedBtnTag %i",selectedBtnTag);
        
        
    }
    
    
}


@end
