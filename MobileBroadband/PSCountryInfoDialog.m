//
//  PSCountryInfoDialog.m
//  MobileBroadband
//
//  Created by Медведь on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSCountryInfoDialog.h"

@implementation PSCountryInfoDialog

@synthesize text  = _text;

- (id)init
{
    self = [super initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"button.cancel", @"") destructiveButtonTitle:nil otherButtonTitles:@"A", @"B", @"C", nil];
    if (self) {
        [self setActionSheetStyle:UIActionSheetStyleAutomatic];    

        /*CGRect rect = actionSheet.frame;
        rect.origin = CGPointZero;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
        [webView loadHTMLString:@"djhfgksjdhfgkjhsdfkj" baseURL:nil];
        [actionSheet addSubview:webView];
        [webView release];
        [actionSheet showInView:self.view];
        [actionSheet release];
    */
        
    }
    return self;
}

#pragma mark - Action sheet delegate

/* Событие перед выводом на экран */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    NSLog(@"!!!!!");
    
}

/* Вывод отсортированного списка * /
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Если нажали Cancel - выходим
    if (buttonIndex == BTN_CANCEL_INDEX) return;
    
    //Определяем столбец для сортировки
    UIPickerView *pickerView = (UIPickerView *)[actionSheet viewWithTag:TAG_PICKER_VIEW];
    sortColumn = [pickerView selectedRowInComponent:0];
    
    //Получаем список
    [self loadBroadbandWithSort:sortColumn];
    
    //Обновляем список
    [self.tableView reloadData];
    
    //Очищаем делегатов
    [pickerView setDelegate:nil];
    [pickerView setDataSource:nil];
}
 */

@end
