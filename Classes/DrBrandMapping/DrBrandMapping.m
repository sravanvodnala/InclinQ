//
//  DrBrandMapping.m
//  InclinIQ
//
//  Created by Gagan on 16/10/14.
//  Copyright (c) 2014 Ace. All rights reserved.
//

#import "DrBrandMapping.h"
#import "Defines.h"
#import "SQLManager.h"
#import "WorkFlowCell.h"
#import "UIPopUPViewController.h"
#import "StandardTourPlan.h"
#import "AppDelegate.h"
@interface DrBrandMapping ()

@end

@implementation DrBrandMapping
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

-(void)viewWillDisappear:(BOOL)animated
{
    SQLManager * objSQL = [SQLManager sharedInstance];
    AppDelegate * objDel = [[UIApplication  sharedApplication]delegate];
    objDel.arrScheduleData = [objSQL getScheduleCallData];
}
- (void)viewDidLoad
{
    arrPreviousBrands = [[NSMutableArray alloc]init];
    
    self.navigationController.navigationBarHidden = YES;
    arrBrands = [[NSMutableArray alloc] init];
    arrTargettedBrands = [[NSMutableArray alloc] init];[super viewDidLoad];
    strDrName = @"";
    strSpecialist = @"";
    isEditable = NO;
    
    btnEdit.titleLabel.font = font_ProCond(25.0);
    btnSave.titleLabel.font = font_ProCond(25.0);
    btnCancel.titleLabel.font = font_ProCond(25.0);
    
    arrData = [[NSMutableArray alloc] init];
    arrSectionArray = [[NSMutableArray alloc] init];
    arrIndexArray = [[NSMutableArray alloc] init];
    filteredTableData = [[NSMutableArray alloc] init];
    
    
    arrAlphabets=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    frameTargettedBrands = viewTargettedBrands.frame;
    frameBrands = viewBrands.frame;
    
    SQLManager *objSQl = [SQLManager sharedInstance];
    arrData = [objSQl getDoctorForBrandMatrix];
    [self getDataForSearch];
   
    arrBrands = [objSQl geteDetailors:1];
    
    [self reloadBrands];
    [self reloadTargettedBrands];
    [self showHideBrands:YES];
}

-(NSMutableArray *)mapBrandsAndTargetedBrands : (NSMutableArray *)arrTargetedBrands
{
    [arrBrands removeAllObjects];
    NSMutableArray * arrRequiredBrands = nil;
    SQLManager *objSQl = [SQLManager sharedInstance];
    arrRequiredBrands = [objSQl geteDetailerDataForPrew:YES];
    BOOL found = NO;
    for(int i=0; i< arrRequiredBrands.count; i++ )
    {
        found = NO;
        eDetailor * objBrand = [arrRequiredBrands objectAtIndex:i];
        for(int j=0;j< arrTargetedBrands.count; j++)
        {
            eDetailor * objBrand1 = [arrTargetedBrands objectAtIndex:j];
            if(objBrand.Id == objBrand1.Id)
            {
                found = YES;
                break;
                
            }
        }
        
        if(!found)
            [arrBrands addObject:objBrand];
        
    }
    
    return arrBrands;
}

-(void)showHideBrands : (BOOL)flag
{
    viewBrands.hidden = flag;
    lblBrands.hidden = flag;
    
}
-(void)getDataForSearch
{
    for(int i = 0; i<[arrAlphabets count];i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int x=0;x<[arrData count];x++)
        {
            drBrandCluster *objDocStruct = [arrData objectAtIndex:x];
            
            NSString *myString = objDocStruct.Name;
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:0]];
            
            if( [ichar isEqualToString:[arrAlphabets objectAtIndex:i]])
            {
                NSLog(@"%@", myString);
                [array addObject:objDocStruct];
            }
        }
        if([array count])
        {
            drBrandCluster *objDocStructSub = [array objectAtIndex:0];
            
            NSString *myString = objDocStructSub.Name;
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
            drBrandCluster *obj = [arrData objectAtIndex:i];
            NSRange descriptionRange = [obj.Name rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:[arrData objectAtIndex:i]];
            }
        }
    }
    
    [tblViewDoctors reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
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
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        drBrandCluster *objStructure = nil;
        
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
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",objStructure.Name];
        
        if(intDoctorid == objStructure.doctorId)
        {
            cell.textLabel.textColor = [UIColor colorWithRed:255/255.0 green:202/255.0 blue:54/255.0 alpha:8.0];
            cell.textLabel.shadowColor = [UIColor lightGrayColor];
            
        }
        else
        {
            cell.textLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:8.0];
            cell.textLabel.shadowColor = [UIColor clearColor];
        }
        if([strDrName isEqualToString:@""] && indexPath.row == 0 && !isFirstTime)
        {
                isFirstTime = YES;
                arrTargettedBrands = (NSMutableArray *)objStructure.arrBrands;
                selectedBrandCluster = objStructure;
                strDrName = objStructure.Name;
                intDoctorid = objStructure.doctorId;
                lblSpecialist.text = objStructure.specialisation;
                lblDrName.text = strDrName;
                arrBrands = [self mapBrandsAndTargetedBrands:arrTargettedBrands];
                
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView == tblViewDoctors)
    {
        drBrandCluster *objStructure = nil;
        if(isFiltered)
            objStructure = [filteredTableData objectAtIndex:indexPath.row];
        else
            objStructure = [[arrSectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        arrTargettedBrands = objStructure.arrBrands;
        
        strDrName = objStructure.Name;
        intDoctorid = objStructure.doctorId;
        
        lblDrName.text = strDrName;
        lblSpecialist.text = objStructure.specialisation;
        //        lblSpecialist.text = strSpecialist;
        
        arrBrands = [self mapBrandsAndTargetedBrands:arrTargettedBrands];
        
        selectedBrandCluster = objStructure;
        [self reloadTargettedBrands];
        [self reloadBrands];
        
        [tblViewDoctors reloadData];
        
    }
    
//    if(tableView == tblBrandsPopUP)
//    {
//        if(isEditable)
//        {
//            if(arrBrands.count>0)
//            {
//                eDetailor *objStructure = [arrBrands objectAtIndex:indexPath.row];
//                
//                [arrTargettedBrands addObject:objStructure];
//                [arrBrands removeObjectAtIndex:indexPath.row];
//                
//                [self removePopUp];
//                [self performSelectorOnMainThread:@selector(reloadTargettedBrands) withObject:self waitUntilDone:YES];
//                [self performSelectorOnMainThread:@selector(reloadBrands) withObject:nil waitUntilDone:YES];
//                
//                [tblBrands reloadData];
//                [tblBrandsPopUP reloadData];
//            }
//        }
//    }
//    
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
          return [arrIndexArray objectAtIndex:section];
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

#pragma mark - Update Brand Matrix
-(void)updateBrandMatrix : (drBrandCluster *) objdrBC
{
    SQLManager * objSQL = [SQLManager sharedInstance];
    [objSQL updatedBrandClusterMatrix:objdrBC];
}


#pragma mark - CellSwipe Delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    eDetailor *objStructure = [arrTargettedBrands objectAtIndex:indexPath.row];
    
    [arrBrands addObject:objStructure];
    [arrTargettedBrands removeObjectAtIndex:indexPath.row];
    
    [self removePopUp];
    [self performSelectorOnMainThread:@selector(reloadTargettedBrands) withObject:self waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(reloadBrands) withObject:nil waitUntilDone:YES];
    
//    [tblBrands reloadData];
//    [tblBrandsPopUP reloadData];
}
#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    btnSave.hidden = YES;
    btnCancel.hidden = YES;
    btnEdit.hidden = NO;
    [self showHideBrands:YES];
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            SQLManager * objSQL = [SQLManager sharedInstance];
            [objSQL updatedBrandClusterMatrix:selectedBrandCluster];
            [objSQL insertIntoScheduleContent:selectedBrandCluster];
        }
    }
}

- (IBAction)btnPopUpClicked:(UIButton *)sender
{
    [self removePopUp];
}
-(void)removePopUp
{
    [popoverController dismissPopoverAnimated:YES];
}
- (IBAction)btnCancelClicked:(UIButton *)sender
{
    [selectedBrandCluster.arrBrands removeAllObjects];
    for(int i=0; i<arrPreviousBrands.count; i++ )
    {
        [selectedBrandCluster.arrBrands addObject:[arrPreviousBrands objectAtIndex:i]];
    }
    
    arrTargettedBrands = selectedBrandCluster.arrBrands;
    btnSave.hidden = YES;
    btnEdit.hidden = NO;
    btnCancel.hidden = YES;
    [self showHideBrands:YES];
    
    [self reloadTargettedBrands];
    
    
}

- (IBAction)btnSaveClicked:(UIButton *)sender
{
    //    [arrBrands removeAllObjects];
    //    [arrTargettedBrands removeAllObjects];
    //
    //    arrBrands = arrBrandsTemp;
    //    arrTargettedBrands = arrTargettedBrandsTemp;
    //    [tblBrands reloadData];
    //    [tblBrandsPopUP reloa];
    isEditable = NO;
    if(sender.tag == 23456)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                              
                                                        message:@"Are you sure you want change targetted Brands?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        alert.tag = 10;
        [alert show];
    }
    else
    {
        btnSave.hidden = YES;
        btnEdit.hidden = NO;
        btnCancel.hidden = YES;
        [self showHideBrands:YES];
    }
}

- (IBAction)btnEditClicked:(UIButton *)sender
{
    [arrPreviousBrands removeAllObjects];
    for(int i=0; i< selectedBrandCluster.arrBrands.count; i++)
    {
        [ arrPreviousBrands addObject:[selectedBrandCluster.arrBrands objectAtIndex:i]];
    }
   
    isEditable = YES;
    btnSave.hidden = NO;
    btnEdit.hidden = YES;
    btnCancel.hidden = NO;
    [self showHideBrands:NO];
  
}

- (IBAction)ntmBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)reloadTargettedBrands
{
    for(UIView *v in viewTargettedBrands.subviews)
    {
        [v removeFromSuperview];
    }
    CGFloat xpos = 0.0, ypos = 0.0, width = frameTargettedBrands.size.width, height = 45.0;

    if(arrTargettedBrands.count>0)
    {
        for(int count = 0; count< arrTargettedBrands.count; count++)
        {
            eDetailor *objStructure = [arrTargettedBrands objectAtIndex:count];
            UIView *view = [self createBrandView:objStructure withTag:100+count withFrame:CGRectMake(xpos, ypos, width, height)];
            [viewTargettedBrands addSubview:view];
            ypos+= 50.0;
        }
    }
    else
    {
        UIView *view = [self createBrandView:nil withTag:0 withFrame:CGRectMake(xpos, ypos, width, height)];
        [viewTargettedBrands addSubview:view];
    }
}
-(void)reloadBrands
{
    for(UIView *v in viewBrands.subviews)
    {
        [v removeFromSuperview];
    }
    
    CGFloat xpos = 15.0, ypos = 0.0, width = frameTargettedBrands.size.width-30, height = 45.0;
    if(arrBrands.count>0)
    {
        for(int count = 0; count<arrBrands.count; count++)
        {
            eDetailor *objStructure = [arrBrands objectAtIndex:count];
            UIView *view = [self createBrandView:objStructure withTag:100+count withFrame:CGRectMake(xpos, ypos, width, height)];
            [viewBrands addSubview:view];
            
            ypos+= 50.0;
        }
    }
    else
    {
        UIView *view = [self createBrandView:nil withTag:0 withFrame:CGRectMake(xpos, ypos, width, height)];
        [viewBrands addSubview:view];
    }

}
-(UIView *)createBrandView:(eDetailor *)objStructure withTag:(NSInteger)tagValue withFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(15, 0, view.frame.size.width-30, view.frame.size.height);
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = font_ProCond(18.0);
   
    if(objStructure == nil)
        ; //lbl.text =  @"There is no related Brands to Display";
    else
    {
        lbl.text =  [NSString stringWithFormat:@"%@",objStructure.brandName];
        view.tag = objStructure.Id;
    }


    lbl.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:8.0];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [view addSubview:lbl];
    

    CALayer *layerView = [view layer];
    [layerView setMasksToBounds:YES];
    [layerView setCornerRadius:10.0];

    return view;
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.view.superview == viewTargettedBrands && arrTargettedBrands.count>0)
    {
        viewTempTargettedBrands = (UIView *)touch.view;
        actualRect = viewTempTargettedBrands.frame;
    }
    if(touch.view.superview == viewBrands && arrBrands.count>0)
    {
        viewTempBrands = (UIView *)touch.view;
        actualRect = viewTempBrands.frame;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.view.superview == viewTargettedBrands && arrTargettedBrands.count>0)
    {
        CGPoint location = [touch locationInView:viewTargettedBrands];
        touch.view.center = CGPointMake(location.x, location.y);
        tempRect = touch.view.frame;
    }
   
    if(touch.view.superview == viewBrands && arrBrands.count>0)
    {
        CGPoint location = [touch locationInView:viewBrands];
        touch.view.center = CGPointMake(location.x, location.y);
        tempRect = touch.view.frame;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   NSLog(@"%f, %f",tempRect.origin.x,tempRect.origin.y);
    
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.view.superview == viewTargettedBrands && arrTargettedBrands.count>0)
    {
        if(tempRect.origin.x>(actualRect.origin.x+300))
        {
            viewTempTargettedBrands.frame = tempRect;
            [self reloadDataInTargettedBrands];
        }
        else
        {
            viewTempTargettedBrands.frame = actualRect;
        }
    }
   
    if(touch.view.superview == viewBrands && arrBrands.count>0)
    {
        if((actualRect.origin.x-400) < tempRect.origin.x)
        {
            viewTempBrands.frame = tempRect;
            [self reloadDataInBrands];
        }
        else
        {
            viewTempBrands.frame = actualRect;
        }
    }
}
-(void)reloadDataInTargettedBrands
{
    for(int i=0; i<arrTargettedBrands.count; i++)
    {
        eDetailor*objStructure = [arrTargettedBrands objectAtIndex:i];
        if(objStructure.Id == viewTempTargettedBrands.tag)
        {
            [arrTargettedBrands removeObjectAtIndex:i];
            [arrBrands addObject:objStructure];
            [self reloadTargettedBrands];
            [self reloadBrands];
            return;

        }
    }
}
-(void)reloadDataInBrands
{
    for(int i=0; i<arrBrands.count; i++)
    {
        eDetailor*objStructure = [arrBrands objectAtIndex:i];
        if(objStructure.Id == viewTempBrands.tag)
        {
            [arrBrands removeObjectAtIndex:i];
            [arrTargettedBrands addObject:objStructure];
           
            [self reloadTargettedBrands];
            [self reloadBrands];
             return;
        }
    }
}
@end
