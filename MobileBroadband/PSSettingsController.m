//
//  PSSettingsController.m
//  MobileBroadband
//
//  Created by Медведь on 27.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSSettingsController.h"



@interface PSSettingsController ()

@property (nonatomic, retain) NSArray *listOfSizes;
@property (nonatomic, retain) NSArray *listOfFontNames;

@end

@implementation PSSettingsController

@synthesize tableView = _tableView;
@synthesize listOfSizes = _listOfSizes;
@synthesize listOfFontNames = _listOfFontNames;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        
    }
    return self;
}

- (void)dealloc
{

    [_listOfSizes release];
    [_listOfFontNames release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Создаем список названий шрифтов
    _listOfSizes = [[NSArray alloc] initWithObjects:
                    LocalizedString(@"PSSettingsController.table.row00"), 
                    LocalizedString(@"PSSettingsController.table.row01"), 
                    LocalizedString(@"PSSettingsController.table.row02"), 
                    nil];
    
    //Создаем список размеров шрифтов
    _listOfFontNames = [[UIFont familyNames] retain];
      
    
    //Только для iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        _tableView.frame = CGRectInset(self.view.frame, -100.0f, 0.0f);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        UIImageView *v = (UIImageView *)_tableView.backgroundView;
        self.view.backgroundColor = [UIColor colorWithPatternImage:v.image];
        _tableView.backgroundView = nil;
    }
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //Чистим за собой
    self.listOfSizes = nil;
    self.listOfFontNames = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}




#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return LocalizedString(@"PSSettingsController.table.section0"); 
        case 1: return LocalizedString(@"PSSettingsController.table.section1"); 
        default:return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return _listOfSizes.count;
        case 1: return _listOfFontNames.count;
        default:return 0;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.indentationLevel = 1;
        cell.indentationWidth = 20.0f;
    }
    
    cell.textLabel.font = [Utils getFont];
    switch (indexPath.section) {
        case 0:            
            cell.textLabel.text = [_listOfSizes objectAtIndex:indexPath.row];
            cell.accessoryType = (indexPath.row == [Utils getFontSizeIndex]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.textLabel.text = [_listOfFontNames objectAtIndex:indexPath.row];
            cell.accessoryType = (indexPath.row == [Utils getFontNameIndex]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;    
        default:
            break;
    }
    
       
    
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];	
    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
} 


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:            
            for (int i = 0; i < _listOfSizes.count; i++) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (cell) {                    
                    cell.accessoryType = (i == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                }
            }
            [Utils setFontSizeIndex:indexPath.row];
            [_tableView reloadData];
            break;
        case 1:
            for (int i = 0; i < _listOfFontNames.count; i++) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                if (cell) {                    
                    cell.accessoryType = (i == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                }
            }
            [Utils setFontNameIndex:indexPath.row];
            [_tableView reloadData];
            break;    
        default:
            break;
    }
    
}

@end
