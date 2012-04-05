//
//  PSMasterViewController.m
//  MobileBroadband
//
//  Created by Медведь on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSTariffsController.h"
#import "PSTariffModel.h"
#import "PSTariffsTableViewCell.h"
#import "PSTariffDetailController.h"
#import "PSTariffsHederSectionView.h"
#import "PSSortDialog.h"


@interface PSTariffsController () {
    
}

@property (nonatomic, retain) NSMutableArray *objects;  

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
    self.objects = [PSTariffModel newListByCountry:self.country];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Указываем заголовок
    self.title = NSLocalizedString(@"PSTariffsController.title", nil);;
    
    //Подгружаем данные со странами    
    self.objects = [PSTariffModel newListByCountry:self.country];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *btnSort = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PSTariffsController.sortButton.title", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onTouchButtonSort:)];
    self.navigationItem.rightBarButtonItem = btnSort;
    [btnSort release];
    
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


- (void)onTouchButtonSort:(UIBarButtonItem *)sender {
    PSSortDialog *dialog = [[PSSortDialog alloc] initWithTitle:sender.title];   
    [dialog addTarget:self action:@selector(onSort:)];
    [dialog showFromBarButtonItem:sender animated:YES];
    [dialog release];    
}

- (void)onSort:(NSIndexPath *)indexPath {
    //Получаем индекс колонки по которой необходимо выполнить сортировку
    NSInteger column = indexPath.row + 1;
    
    /*
    NSLog(@"%d", column);
        
    NSLog(@"TAG = %d: %@; SORT %@", column.tag, column.titleLabel.text, column.sortAscending ? @"v" : @"^");    
    NSLog(@"------  До  ------");
    for (PSTariffModel *model1 in _broadbandList) {
        NSLog(@"ID=%d\t: %f", model1.ID, model1.price);
    }
    //*/
    
    //Выполняем сортировку
    [_objects sortUsingComparator:(NSComparator)^(id obj1, id obj2){
        PSTariffModel *model1 = (PSTariffModel *)obj1;
        PSTariffModel *model2 = (PSTariffModel *)obj2;
        
        
        NSComparisonResult result = NSOrderedSame;
        switch (column) {
            case 1: //По наименованию провайдера
                result = [model1.provaderName compare:model2.provaderName options:NSCaseInsensitiveSearch];
                break;
            case 2: //По тарифу 
                result = [model1.trafficType compare:model2.trafficType options:NSCaseInsensitiveSearch];
                break;
            case 3: //По стоимости 
                if (model1.priceForSort < model2.priceForSort) result = NSOrderedAscending;
                else if (model1.priceForSort > model2.priceForSort) result = NSOrderedDescending;
                break;
            case 4: //По скорости
                if (model1.speedForSort > model2.speedForSort) result = NSOrderedAscending;
                else if (model1.speedForSort < model2.speedForSort) result = NSOrderedDescending;
                break;  
            case 5: //По лимиту
                result = [model1.dataLimit compare:model2.dataLimit options:NSCaseInsensitiveSearch];
                break;
            default:
                break;
        }
                
        //NSLog(@"%d - %d \t %f <> %f \t result = %d", model1.ID, model2.ID, model1.price, model2.price, result);
        
        return result;
    }];
    
    /*
    NSLog(@"------ После ------");
    for (PSTariffModel *model1 in _broadbandList) {
        NSLog(@"ID=%d\t: %f", model1.ID, model1.price);
    }
    //*/
    
    [self.tableView reloadData]; 
    
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

 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    PSTariffsHederSectionView *header = [[PSTariffsHederSectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)]; //размеры от болды только для удобства
    return [header autorelease];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PSTariffModel *object = [_objects objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    PSTariffsTableViewCell *cell = (PSTariffsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PSTariffsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.object = object;
    
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
