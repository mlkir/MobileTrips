//
//  PSHomePageController.m
//  MobileBroadband
//
//  Created by Медведь on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSHomePageController.h"

#import "PSCountryController.h"
#import "PSSettingsController.h"
#import "PSWebViewController.h"


//Количество шагов по работе с приложением
#define STEP_COUNT 4

//Количество кнопок в одном ряду
#define BTN_COLS 3
//Количество рядов с кнопками
#define BTN_ROWS 2



@interface PSHomePageController ()

@end

@implementation PSHomePageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Указываем заголовок
	self.title = NSLocalizedString(@"PSHomePageController.title", nil);
    
    //Регистрируем жест Swipe для перехода к выбору стран
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    [swipeLeft release];  
    
    //Создаю жест касания
    UITapGestureRecognizer *gestureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];    
    
    //Определяем на каком девайсе запустили
    BOOL isIPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
       
    //Создаем вьюху на которой будем размещать все элементы так, чтобы они находились в центре экрана
    CGRect rect = (isIPhone) ? CGRectMake(0, 0 , 270, 270) : CGRectMake(0, 0 , 600, 600);
    UIView *bgView = [[UIView alloc] initWithFrame:rect];    
    bgView.backgroundColor = [UIColor clearColor];
    bgView.alpha = 1.0f;
    bgView.autoresizesSubviews = YES;
    bgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:bgView];
    [bgView release];
    
    //Пазмещаем в центре экрана
    bgView.center = self.view.center;
    
    //Определяем отступы от края слева и справа
    CGFloat offsetLeftRight = round(rect.size.width * 0.05);
        
    //Подгружаем картинку для кнопки
    UIImage *imgButton = [UIImage imageNamed:@"homepage_rect_border"];
    
    //Выводим кнопки
    CGFloat offset = offsetLeftRight;
    CGFloat width = round((rect.size.width  - 2 * offsetLeftRight -  (BTN_COLS - 1) * offset)/ BTN_COLS);
    CGFloat height = round(width * imgButton.size.height / imgButton.size.width);
    CGRect rectButton = CGRectMake(0.0f, 0.0f, width, height);    
    CGFloat y = rect.size.height - (BTN_ROWS * rectButton.size.height + offsetLeftRight + (BTN_ROWS - 1) * offset);
    CGFloat bottomSteps = y - offsetLeftRight;
    int tag = 0;
    for (int row = 0; row < BTN_ROWS - 1; row++) {
        CGFloat x = offsetLeftRight;
        for (int col = 0; col < BTN_COLS; col++) {
            //Выводим кнопку
            rectButton.origin = CGPointMake(x, y);
            UIButton *btn = [[UIButton alloc] initWithFrame:rectButton];
            btn.tag = tag;
            btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
            [btn setBackgroundImage:imgButton forState:UIControlStateNormal];                        
            [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            [btn release];
            
            //Выводим надпись            
            CGRect rectLabel = CGRectMake(0.0f, height / 2, width, height / 2);
            UILabel *lbl = [[UILabel alloc] initWithFrame:rectLabel];
            lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            lbl.textAlignment = UITextAlignmentCenter;
            lbl.backgroundColor = [UIColor clearColor];
            lbl.font = [UIFont boldSystemFontOfSize:(isIPhone ? 10.0f : 14.0f)];
            NSString *keyButton = [NSString stringWithFormat:@"PSHomePageController.button%d.title", tag];
            lbl.text = NSLocalizedString(keyButton, nil);    
            lbl.numberOfLines = 0;
            [btn addSubview:lbl];
            [lbl release];
            
            //Пересчитываем следующее положение по оси Х
            x += rectButton.size.width + offset;
            tag++;
        }        
        y += rectButton.size.height + offset;
    }
    
    //Выводим заголоовк для картинки c описание "шагов" по работе с прогой
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rect.size.width, 20.0f)];
    lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:(isIPhone ? 10.0f : 18.0f)];
    lbl.text = NSLocalizedString(@"PSHomePageController.steps.header", nil);    
    [bgView addSubview:lbl];
    [lbl release];
    
    
    //Подгружаем картинку для отобраджения "шагов"    
    UIImage *imgStep = [UIImage imageNamed:@"homepage_elipse_border"];
        
    //Выводим картинки с "шагами"
    offsetLeftRight = 2.0f;
    offset = 10.0f;
    width = round((rect.size.width  - 2 * offsetLeftRight -  (STEP_COUNT - 1) * offset) / STEP_COUNT);
    height = round(width * imgStep.size.height / imgStep.size.width);
    CGRect rectStep = CGRectMake(0.0f, 0.0f, width, height);    
    CGFloat x = offsetLeftRight;
    y = lbl.frame.origin.y + lbl.frame.size.height;
    y += round((bottomSteps - y) / 2.0f - height / 2.0f);
    for (int i = 0; i < STEP_COUNT; i++) {
        //Выводим картинку
        rectStep.origin = CGPointMake(x, y);
        UIImageView *stepView = [[UIImageView alloc] initWithFrame:rectStep];
        stepView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        stepView.image = imgStep;
        [bgView addSubview:stepView];
        [stepView release];
        
        //Выводим надпись
        rectStep.origin = CGPointZero;
        UILabel *lbl = [[UILabel alloc] initWithFrame:rectStep];
        lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = [UIFont systemFontOfSize:(isIPhone ? 7.0f : 12.0f)];
        NSString *keyStep = [NSString stringWithFormat:@"PSHomePageController.step%d.text", i];
        lbl.text = NSLocalizedString(keyStep, nil);    
        [stepView addSubview:lbl];
        [lbl release];
        
        //Для первого шага регистрируем касание
        if (i == 0) {
            [stepView setUserInteractionEnabled:YES];
            [stepView addGestureRecognizer:gestureTap];            
        }
        
        //Пересчитываем следующее положение по оси Х
        x += rectStep.size.width + offset;
    } 
    
    //Чистим жест
    [gestureTap release];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


/* Событие по кнопке из менюшки */
- (void)onTapButton:(UIButton *)btn {
    switch (btn.tag) {
        //Переход к выбору страны    
        case 0:{
            PSCountryController *controller = [[[PSCountryController alloc] initWithNibName:@"PSCountryController" bundle:nil] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        } break;  
        //Переход к About
        case 1: {
            PSWebViewController *controller = [[[PSWebViewController alloc] initWithNibName:@"PSWebViewController" bundle:nil] autorelease];
            NSString *key = [NSString stringWithFormat:@"PSHomePageController.button%d.title", btn.tag];
            controller.title = NSLocalizedString(key, nil);   
            [self.navigationController pushViewController:controller animated:YES];
        } break;  
        //Переход к Settings
        case 2: {
            PSSettingsController *controller = [[[PSSettingsController alloc] initWithNibName:@"PSSettingsController" bundle:nil] autorelease];
            NSString *key = [NSString stringWithFormat:@"PSHomePageController.button%d.title", btn.tag];
            controller.title = NSLocalizedString(key, nil);   
            [self.navigationController pushViewController:controller animated:YES];
        } break;  
            
        //Переход к Help    
        case 3: {
            PSWebViewController *controller = [[[PSWebViewController alloc] initWithNibName:@"PSWebViewController" bundle:nil] autorelease];
            NSString *key = [NSString stringWithFormat:@"PSHomePageController.button%d.title", btn.tag];
            controller.title = NSLocalizedString(key, nil);   
            [self.navigationController pushViewController:controller animated:YES];
        } break;  
            
        default:
            break;
    }
}

/* Переход к списку стран */
-(void)didGesture:(UIGestureRecognizer*)gesture {
    PSCountryController *controller = [[[PSCountryController alloc] initWithNibName:@"PSCountryController" bundle:nil] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
