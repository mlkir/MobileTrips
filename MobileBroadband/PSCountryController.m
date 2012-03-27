//
//  PSCountryController.m
//  MobileBroadband
//
//  Created by Медведь on 27.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSCountryController.h"
#import "PSCountryModel.h"
#import "Utils.h"
#import "PSCountryInfoDialog.h"



@interface PSCountryController () {
    
}

@property (nonatomic, retain) NSArray *objects;  
@end


@implementation PSCountryController

@synthesize objects = _objects;
@synthesize countryTableView = _countryTableView;   
@synthesize lastUpdateLabel = _lastUpdateLabel;
@synthesize commentLabel = _commentLabel;
@synthesize downloadButton = _downloadButton;
@synthesize downloadSegmentedControl = _downloadSegmentedControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
        
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
	self.title = NSLocalizedString(@"PSCountryController.title", nil);
    
    //Подгружаем данные со странами
    self.objects = [PSCountryModel newList];
    
    //Указываем тату последнего обновления
    NSString *str = NSLocalizedString(@"PSCountryController.lastUpdateLabel.text", nil);
    self.lastUpdateLabel.text = [NSString stringWithFormat:str,  @"10.10.2010"];
    
    //Название кнопки загрузки данных с сервера
    str = NSLocalizedString(@"PSCountryController.downloadButton.title", nil);
    [self.downloadButton setTitle:str forState:UIControlStateNormal];
    //[self.downloadButton setTitle:str forState:UIControlState];
    [self.downloadButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    
    UIImage *img = [[UIImage imageNamed:@"btn_download.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 5, 8, 5)];
    [self.downloadButton setBackgroundImage:img forState:UIControlStateNormal];
    
    //Доп информация 
    self.commentLabel.text = NSLocalizedString(@"PSCountryController.commentLabel.text", nil);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //Чистим за собой
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

- (IBAction)onDownload:(UIButton *)sender {
    NSString *lang = [Utils getCurrentLanguage];
    
    NSLog(@"Надо загрузить базу на языке %@", lang);
}


- (void)onShowCountryInfo:(UIButton *)sender {
    int index = sender.superview.tag;
    NSIndexPath *selIndexPath = _countryTableView.indexPathForSelectedRow;
    if (index != selIndexPath.row) {
        [_countryTableView deselectRowAtIndexPath:selIndexPath animated:YES];
    }
            
    PSCountryModel *object = [_objects objectAtIndex:index];    
    //if (object.isPageExists) {
        //Отображаем описание     
        PSCountryInfoDialog *dialog = [[PSCountryInfoDialog alloc] init];
        dialog.title = object.name;
        dialog.text = object.page;
        [dialog showInView:self.view];
        [dialog release];    
    //}
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
    
    PSCountryModel *object = [_objects objectAtIndex:indexPath.row];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        cell.indentationLevel = 1;
        cell.indentationWidth = 50;
        CGSize size = cell.frame.size;
        
        UISegmentedControl *btn = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"info"]];
        btn.frame = CGRectMake(20, (size.height - 20)/ 2 , 40, 20);
        btn.segmentedControlStyle = UISegmentedControlStyleBar;
        btn.momentary = YES;        
        //btn.tintColor = [UIColor darkGrayColor];
        [btn addTarget:self action:@selector(onShowCountryInfo:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:btn];
        [btn release];
        
        btn.alpha = 1.0f;
        cell.imageView.alpha = 1.0f;
        
    }
    
    cell.tag = indexPath.row;
    cell.textLabel.text = object.name;
    //cell.imageView.image = [UIImage imageNamed:@"btn_russia.png"];

    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSCountryModel *object = [_objects objectAtIndex:indexPath.row];
    NSLog(@"%@", object.name);
    
   /* if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[[PSTariffDetailController alloc] initWithNibName:@"PSTariffDetailController" bundle:nil] autorelease];
	    }
	    self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
    */
}

@end
