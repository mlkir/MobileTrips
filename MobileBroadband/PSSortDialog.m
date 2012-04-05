//
//  PSSortDialog.m
//  MobileBroadband
//
//  Created by Медведь on 30.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSSortDialog.h"


@interface PSSortDialog ()  {
    id _target;
    SEL _action;
}

@property (nonatomic, retain) UIBarButtonItem *barButtonItem;
@property (nonatomic, retain) NSArray *objects;

@end;


@implementation PSSortDialog


@synthesize barButtonItem = _barButtonItem;
@synthesize objects = _objects;


- (id)initWithTitle:(NSString *)title 
{
    self = [super initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"button.cancel", @"") destructiveButtonTitle:nil otherButtonTitles:@"A", @"B", @"C", @"D", nil];
    if (self) {
        [self setActionSheetStyle:UIActionSheetStyleAutomatic];    
        
        self.objects = [[NSArray alloc] initWithObjects:
                        NSLocalizedString(@"PSTariffsController.tableHeader.providerName", nil),
                        NSLocalizedString(@"PSTariffsController.tableHeader.trafficType", nil),
                        NSLocalizedString(@"PSTariffsController.tableHeader.price", nil),
                        NSLocalizedString(@"PSTariffsController.tableHeader.speed", nil),
                        NSLocalizedString(@"PSTariffsController.tableHeader.limit", nil),
                        nil];
        
    }
    return self;
}

- (void)dealloc 
{
    [_barButtonItem release];
    [_objects release];
    
    [super dealloc];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated {
    //Запоминаем и блокируем кнопку по которой был вызов
    self.barButtonItem = item;
    self.barButtonItem.enabled = NO;
    
    [super showFromBarButtonItem:item animated:animated];
}

- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}

#pragma mark - Action sheet delegate

/* Событие перед выводом на экран */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    //Определям верхнюю и нижнюю кнопки, поверх которых будет выведен WebView    
    int firstIndex = 0;
    int lastIndex = self.subviews.count - 2;
    UIView *btnFirst = [self.subviews objectAtIndex:firstIndex];    
    UIView *btnLast = [self.subviews objectAtIndex:lastIndex];
    
    //Определяем размеры для вывода WebView    
    CGRect rect = btnFirst.frame;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rect.origin.x -= 6;
        rect.origin.y += 10;
        rect.size.width += 12;
        rect.size.height = btnLast.frame.origin.y + btnLast.frame.size.height - btnFirst.frame.origin.y; 
    } else {
        rect.origin.x -= 10;
        rect.origin.y = 1;
        rect.size.width += 20;
        rect.size.height = btnLast.frame.origin.y + btnLast.frame.size.height - btnFirst.frame.origin.y; 
    }
    
    //Удаляем кнопки
    for (int i = lastIndex; i >= firstIndex; i--) {
        UIView *btn = [self.subviews objectAtIndex:firstIndex];   
        [btn removeFromSuperview];
    }
    
    //Создаем список
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    tableView.rowHeight = 37.0f;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [tableView setSectionHeaderHeight:0.0f];
    [tableView setSectionFooterHeight:0.0f];     
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self addSubview:tableView];
    [tableView release];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //Снимаем блокировку с кнопки
    self.barButtonItem.enabled = YES;

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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                
    }

    cell.textLabel.text = [_objects objectAtIndex:indexPath.row];    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];	
	[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_target) [_target performSelector:_action withObject:indexPath];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
