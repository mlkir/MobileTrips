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
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end



@implementation PSTariffsController

@synthesize country = _country;
@synthesize objects = _objects;
@synthesize masterPopoverController = _masterPopoverController;


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
    [_masterPopoverController release];
    
    [super dealloc];
}

- (void)setCountry:(PSCountryModel *)country {
    [_country release];
    _country = [country retain];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)refreshTableView {
    //Подгружаем данные со странами    
    self.objects = [PSTariffModel newListByCountryId:self.country.ID];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Указываем заголовок
    self.title = NSLocalizedString(@"PSTariffsController.title", nil);;
    
    //Подгружаем данные со странами    
    self.objects = [PSTariffModel newListByCountryId:self.country.ID];
    
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

#pragma mark - Split view


- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"PSCountryController.title", nil);
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
