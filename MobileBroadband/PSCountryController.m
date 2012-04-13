//
//  PSCountryController.m
//  MobileBroadband
//
//  Created by Медведь on 27.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSCountryController.h"
#import "PSCountryInfoController.h"
#import "PSCountryModel.h"
#import "PSParamModel.h"
#import "Utils.h"
#import "PSHtmlDialog.h"
#import "PSTariffsController.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"


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
@synthesize detailNavigationController = _detailNavigationController;

static UIPopoverController *_popoverController = nil;


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
    [_detailNavigationController release];
    
    [super dealloc];
}

//Указываем дату последнего обновления
- (void)refreshlastUpdateLabel {
    //Указываем дату последнего обновления        
    NSString *ver = [PSParamModel getValueByKey:PARAM_VERSION];
    NSString *lastUpdate = [PSParamModel getValueByKey:PARAM_LAST_UPDATE];
    NSString *str = NSLocalizedString(@"PSCountryController.lastUpdateLabel.text", nil);
    self.lastUpdateLabel.text = [NSString stringWithFormat:str, lastUpdate, ver];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Если язык не соответсвует текущему выбранному
    NSString *lang = [PSParamModel getValueByKey:PARAM_LANGUAGE];
    if (lang && ![lang isEqualToString:[Utils getCurrentLanguage]]) {
        //Выводим сообщение что нужно обновить базу чтобы получить ее на текущем языке
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.warning", nil) message:NSLocalizedString(@"alert.message.lang_not_found", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"button.ok", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        //Удаляем чтобы больше не сообщать пользователю о необходимости обновиться
        [PSParamModel deleteValueWithKey:PARAM_LANGUAGE];
    }
    
    //Указываем заголовок
	self.title = NSLocalizedString(@"PSCountryController.title", nil);
    
    //Подгружаем данные со странами
    self.objects = [PSCountryModel newList];
    
    //Указываем дату последнего обновления
    [self refreshlastUpdateLabel];    
    
    //Название кнопки загрузки данных с сервера
    NSString *str = NSLocalizedString(@"PSCountryController.downloadButton.title", nil);
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
    //Проверяем наличие соединение с Интернетом
    Reachability *r = [Reachability  reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if (internetStatus != ReachableViaWiFi && internetStatus != ReachableViaWWAN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.warning", nil) message:NSLocalizedString(@"alert.message.network_not_connected", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"button.ok", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //Получаем папку куда закачаем наш файл
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/database_new.db"];    
    
    //Определяем строку запроса    
    NSString *lang = [Utils getCurrentLanguage];        
    NSString *ver = [PSParamModel getValueByKey:PARAM_VERSION];
    NSString *str = [NSString stringWithFormat:@"http://tricks4trips.com/price_data/get_archive?locale=%@&version=%@", lang, ver];
    NSURL *url = [NSURL URLWithString:str];    
    
    //Отправляем запрос на сервер    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:path];    
    [request startSynchronous];
    NSError *error = [request error];    
    if (error) {
        //int statusCode = [request responseStatusCode];
        NSString *statusMessage = [request responseStatusMessage];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.error", nil) message:statusMessage delegate:nil  cancelButtonTitle:NSLocalizedString(@"button.ok", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];  
        return;
    }
    
    //Проверяем что скачали    
    NSFileManager *fileManager = [NSFileManager defaultManager];    
    //Если файл существует
    BOOL isDownloaded = [fileManager fileExistsAtPath:path];
    //Проверяем размер
    if (isDownloaded) {
        error = nil;
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
        if (error) {
            printf("Error: %s\n", [[Utils getErrorMessage:@"Неудалось получить атибуты загруженного файла." withError:error] UTF8String]);														
            isDownloaded = NO;
        } else if (fileAttributes.fileSize < 10) { //меньше 10 байт
            isDownloaded = NO;
        }
        //Если размер слишком мал - считает что база не была получена
        if (!isDownloaded) {
            [Utils deleteFile:path];
        }
    }
    
    //Если файл не был получен - сообщаем что база самая новая
    if (!isDownloaded) {        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.info", nil) message:NSLocalizedString(@"alert.message.is_no_update", nil) delegate:nil  cancelButtonTitle:NSLocalizedString(@"button.ok", nil) otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        return;
    }
    
    //Заменяем старую базу новой
    DBManager *dbManager = [DBManager getInstance];
    NSString *databasePath = dbManager.databasePath;
    [dbManager closeDB];
    [Utils deleteFile:databasePath];					
    error = nil;
    BOOL isMoved = [fileManager moveItemAtPath:path toPath:databasePath error:&error];
    if (!isMoved) {                
        //Выводим сообщение
        NSString *message = [error description];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.error", nil) message:message delegate:nil  cancelButtonTitle:NSLocalizedString(@"button.ok", nil) otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        //Удаляем за собой скаченную базу
        [Utils deleteFile:path];        
        return;
    }
    
    //Записываем дату скачивания
    NSString *currentDate = [Utils stringFromDate:[NSDate date]];
    [PSParamModel insertValue:currentDate withKey:PARAM_LAST_UPDATE];
    
    //Запоминаем на каком языке база
    [PSParamModel insertValue:lang withKey:PARAM_LANGUAGE];
    
    //Обновляем отображаемые данные
    [self refreshlastUpdateLabel];
    self.objects = [PSCountryModel newList];
    [self.countryTableView reloadData];    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        PSTariffsController *controller = [[[PSTariffsController alloc] initWithNibName:@"PSTariffsController" bundle:nil] autorelease];          
        self.detailNavigationController.viewControllers = [NSArray arrayWithObject:controller];
        controller.country = nil;
        [controller refreshTableView];
    }  
    
    //Выводим сообщение об успешном обновлении
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.info", nil) message:NSLocalizedString(@"alert.message.successfull", nil) delegate:nil  cancelButtonTitle:NSLocalizedString(@"button.ok", nil) otherButtonTitles:nil];
    [alert show];
    [alert release]; 
    
}

+ (void)setPopoverController:(UIPopoverController *)popover {
    _popoverController = popover;
}

+ (UIPopoverController *)getPopoverController {
    return _popoverController;
}

- (void)onShowTariffsList:(UISegmentedControl *)sender {
    
    PSCountryModel *object = [_objects objectAtIndex:sender.tag];
        
    PSTariffsController *controller = [[[PSTariffsController alloc] initWithNibName:@"PSTariffsController" bundle:nil] autorelease];
    controller.country = object;    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {	    
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        self.detailNavigationController.viewControllers = [NSArray arrayWithObject:controller];
        [controller refreshTableView];
    }
    
}

- (void)onShowCountryInfo:(PSCountryModel *)country {
    PSCountryInfoController *controller = [[[PSCountryInfoController alloc] initWithNibName:@"PSCountryInfoController" bundle:nil] autorelease];
    controller.country = country;    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {	    
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        self.detailNavigationController.viewControllers = [NSArray arrayWithObject:controller];
        [controller reloadInputViews];
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
    
    PSCountryModel *object = [_objects objectAtIndex:indexPath.row];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    BOOL isShowButton = (cell.accessoryView != nil);
    if (isShowButton && !object.isTariffsExists) {
        cell.accessoryView = nil;
    } else if (!isShowButton && object.isTariffsExists) {            
        UISegmentedControl *btn = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:NSLocalizedString(@"PSCountryController.gotoTariffsListButton.title", nil)]];
        btn.frame = CGRectMake(0, 0, 90, 26);
        btn.tag = indexPath.row;
        btn.segmentedControlStyle = UISegmentedControlStyleBar;
        btn.momentary = YES;        
        //btn.tintColor = [UIColor darkGrayColor];
        [btn addTarget:self action:@selector(onShowTariffsList:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = btn;
        [btn release];
    }
    
    cell.tag = indexPath.row;
    cell.textLabel.text = object.name;
    cell.imageView.image = [UIImage imageNamed:@"provider.png"];

    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];	
	[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSCountryModel *object = [_objects objectAtIndex:indexPath.row];
    [self onShowCountryInfo:object];
        
}

@end
