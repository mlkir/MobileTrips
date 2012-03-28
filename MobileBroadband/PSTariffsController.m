//
//  PSMasterViewController.m
//  MobileBroadband
//
//  Created by Медведь on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSTariffsController.h"
#import "PSTariffModel.h"

#import "PSTariffDetailController.h"

@interface PSTariffsController () {
    
}

@property (nonatomic, retain) NSArray *objects;  

@end



@implementation PSTariffsController

@synthesize country = _country;
@synthesize objects = _objects;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        /*
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
         */
    }
    return self;
}
							
- (void)dealloc
{
    [_objects release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Указываем заголовок
    self.title = NSLocalizedString(@"PSTariffsController.title", nil);;
    
    //Подгружаем данные со странами    
    self.objects = [PSTariffModel newListByCountryId:3];//self.country.ID]; TODO: вернуть по ИД страны
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(insertNewObject:)] autorelease];
    //self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.objects = nil;
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PSTariffModel *object = [_objects objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


    
    cell.textLabel.text = object.tariffName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f: %@", object.price, object.tariffType];
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];	
	[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSTariffModel *object = [_objects objectAtIndex:indexPath.row];
    
	PSTariffDetailController *controller = [[[PSTariffDetailController alloc] initWithNibName:@"PSTariffDetailController" bundle:nil] autorelease];
    [controller setTariff:object];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
