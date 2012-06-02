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
#import "PSHtmlDialog.h"
#import "PSTariffsController.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "SSZipArchive.h"


@interface PSCountryController () {
    
}

@property (nonatomic, retain) NSArray *objects;  

@end


@implementation PSCountryController



@synthesize objects = _objects;
@synthesize countryTableView = _countryTableView;   
@synthesize lastUpdateLabel = _lastUpdateLabel;
@synthesize hintImageView = _hintImageView;  
@synthesize hintLabel = _hintLabel;
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

//Указываем дату последнего обновления
- (void)refreshlastUpdateLabel {
    //Указываем дату последнего обновления        
    NSString *ver = [PSParamModel getValueByKey:PARAM_VERSION];
    NSString *lastUpdate = [PSParamModel getValueByKey:PARAM_LAST_UPDATE];
    NSString *str = LocalizedString(@"PSCountryController.lastUpdateLabel.text");
    self.lastUpdateLabel.text = [NSString stringWithFormat:str, lastUpdate, ver];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL isIPhone = [Utils isIPhone];
    
    //Указываем заголовок
	self.title = LocalizedString(@"PSCountryController.title");
    
    //Добавляем фон
    UIImageView *bg = [Utils newBackgroundView];
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    [bg release];
    
    //Подгружаем данные со странами
    self.objects = [PSCountryModel newList];
    
    //Указываем дату последнего обновления
    [self refreshlastUpdateLabel];    
    
    //Название кнопки загрузки данных с сервера
    NSString *str = LocalizedString(@"PSCountryController.downloadButton.title");
    [self.downloadButton setTitle:str forState:UIControlStateNormal];
    //[self.downloadButton setTitle:str forState:UIControlState];
    [self.downloadButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [self.downloadButton setTitleColor:[Utils getColorWithRed:28 green:36 blue:49] forState:UIControlStateNormal];    
    UIImage *img = [[UIImage imageNamed:@"btn_download.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    [self.downloadButton setBackgroundImage:img forState:UIControlStateNormal];
        
    //Выводим рамку под доп. информацию
    img = [[UIImage imageNamed:@"border_hint"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.0f, 9.0f, 9.0f, 9.0f)];    
    self.hintImageView.image = img;
    
    //Доп информация 
    self.hintLabel.text = LocalizedString(@"PSCountryController.commentLabel.text");
    self.hintLabel.font = [UIFont systemFontOfSize:(isIPhone ? 10.0f : 12.0f)];
    
    //Делаем прозрачным фон таблицы
    self.countryTableView.backgroundView = nil;
    self.countryTableView.backgroundColor = [UIColor clearColor];
    
    //Только для iPad
    if (!isIPhone) {        
        self.countryTableView.frame = CGRectInset(self.view.frame, -100.0f, 0.0f);
        self.countryTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.hintImageView.frame = CGRectInset(self.hintImageView.frame, 20.0f, 0.0f);
    }    
    
    
    
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"alert.title.warning") message:LocalizedString(@"alert.message.network_not_connected") delegate:nil cancelButtonTitle:LocalizedString(@"button.ok") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //Получаем папку куда закачаем наш файл
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/data.zip"];    
    
    //Определяем строку запроса    
    NSString *lang = [Utils getCurrentLanguage];        
    //NSString *ver = [PSParamModel getValueByKey:PARAM_VERSION];
    //NSString *str = [NSString stringWithFormat:@"http://tricks4trips.com/price_data/get_archive?locale=%@&version=%@", lang, ver];
    NSString *str = [NSString stringWithFormat:@"http://tricks4trips.com/current_%@.zip", lang];
    NSURL *url = [NSURL URLWithString:str];    
    
    //Отправляем запрос на сервер    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:path];    
    [request startSynchronous];
    NSError *error = [request error];    
    if (error) {
        //int statusCode = [request responseStatusCode];
        NSString *statusMessage = [request responseStatusMessage];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"alert.title.error") message:statusMessage delegate:nil  cancelButtonTitle:LocalizedString(@"button.ok") otherButtonTitles:nil];
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
            [Utils deletePath:path];
        }
    }
    
    //Если файл не был получен - сообщаем что база самая новая
    if (!isDownloaded) {        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"alert.title.info") message:LocalizedString(@"alert.message.is_no_update") delegate:nil  cancelButtonTitle:LocalizedString(@"button.ok") otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        return;
    }
    
    //Закрывем соединение
    DBManager *dbManager = [DBManager getInstance];
    [dbManager closeDB];
    
    //Удаляем старые данные
    NSString *pathWithResources = [Utils getPathInDocument:PATH_RESOURCE];
    [Utils deletePath:pathWithResources];
    
    //Распаковываем ресурсы для работы
    [SSZipArchive unzipFileAtPath:path toDestination:pathWithResources];        
    
    //Удаляем за собой скаченную базу
    [Utils deletePath:path];        
      
    //Записываем дату скачивания
    NSString *currentDate = [Utils stringFromDate:[NSDate date]];
    [PSParamModel insertValue:currentDate withKey:PARAM_LAST_UPDATE];
    
    //Запоминаем на каком языке база
    [PSParamModel insertValue:lang withKey:PARAM_LANGUAGE];
    
    //Перегружаем файл локализации
    [Utils loadLocalizableStrings];
    
    //Обновляем отображаемые данные
    [self refreshlastUpdateLabel];
    self.objects = [PSCountryModel newList];
    [self.countryTableView reloadData];    
    
    //Выводим сообщение об успешном обновлении
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"alert.title.info") message:LocalizedString(@"alert.message.successfull") delegate:nil  cancelButtonTitle:LocalizedString(@"button.ok") otherButtonTitles:nil];
    [alert show];
    [alert release]; 
    
}

- (void)onShowTariffsList:(UISegmentedControl *)sender {
    
    PSCountryModel *object = [_objects objectAtIndex:sender.tag];
        
    PSTariffsController *controller = [[[PSTariffsController alloc] initWithNibName:@"PSTariffsController" bundle:nil] autorelease];
    controller.country = object;    
    [self.navigationController pushViewController:controller animated:YES];    
}

- (void)onShowCountryInfo:(PSCountryModel *)country {
    PSCountryInfoController *controller = [[[PSCountryInfoController alloc] initWithNibName:@"PSCountryInfoController" bundle:nil] autorelease];
    controller.country = country;    
    [self.navigationController pushViewController:controller animated:YES];    
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
        UISegmentedControl *btn = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:LocalizedString(@"PSCountryController.gotoTariffsListButton.title")]];
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
    NSString *fileName = [Utils getPathContent:object.flag];
    UIImage *image = [UIImage imageWithContentsOfFile:fileName];
    if (image == nil) image = [UIImage imageNamed:@"country.png"];
    cell.imageView.image = image;

    
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
