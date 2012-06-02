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
#import "Utils.h"


//Количество шагов по работе с приложением
#define STEP_COUNT 4

//Количество кнопок в одном ряду
#define BTN_COLS 3
//Количество рядов с кнопками
#define BTN_ROWS 2

//Размеры кнопки
#define BTN_SIZE_WIDTH  210.0f
#define BTN_SIZE_HEIGHT 211.0f

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
    
    //Определяем на каком девайсе запустили
    BOOL isIPhone = [Utils isIPhone];
    
    //Указываем заголовок
	self.title = NSLocalizedString(@"PSHomePageController.title", nil);
    
    //Создаем фон
    UIImageView *bg = [Utils newBackgroundView];
    [self.view addSubview:bg];
    [bg release];
        
    //Регистрируем жест Swipe для перехода к выбору стран
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    [swipeLeft release];  
        
    
    //Создаем вьюху на которой будем размещать все элементы так, чтобы они находились в центре экрана
    CGRect rect = (isIPhone) ? CGRectMake(0, 0 , 275, 275) : CGRectMake(0, 0 , 600, 600);
    UIView *bgView = [[UIView alloc] initWithFrame:rect];    
    bgView.backgroundColor = [UIColor clearColor];
    bgView.alpha = 1.0f;
    bgView.autoresizesSubviews = YES;
    bgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:bgView];
    [bgView release];
    
    //Пазмещаем в центре экрана
    CGPoint center = self.view.center;
    //center.y += (isIPhone) ? 50.0f : 50.0f;
    bgView.center = center;
    
    //Определяем отступы от края слева и справа
    CGFloat offsetLeftRight = round(rect.size.width * 0.05);
    
    //Выводим кнопки
    CGFloat offset = offsetLeftRight;
    CGFloat width = round((rect.size.width  - 2 * offsetLeftRight -  (BTN_COLS - 1) * offset)/ BTN_COLS);
    CGFloat height = round(width * BTN_SIZE_HEIGHT / BTN_SIZE_WIDTH);
    CGRect rectButton = CGRectMake(0.0f, 0.0f, width, height);    
    CGFloat y = rect.size.height - (BTN_ROWS * rectButton.size.height + offsetLeftRight + (BTN_ROWS - 1) * offset);
    CGFloat bottomSteps = y;
    int tag = 0;
    for (int row = 0; row < BTN_ROWS; row++) {
        CGFloat x = offsetLeftRight;
        for (int col = 0; col < BTN_COLS; col++) {
            
            //Подгружаем картинку для кнопки
            NSString *imgName = [NSString stringWithFormat:@"homepage_btn%d", tag];
            UIImage *imgButton = [UIImage imageNamed:imgName];
            
            //Получаем название кнопки
            NSString *keyButton = [NSString stringWithFormat:@"PSHomePageController.button%d.title", tag];
            NSString *titleButton = NSLocalizedString(keyButton, nil);
                        
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
            lbl.shadowColor = [UIColor whiteColor];
            lbl.shadowOffset = CGSizeMake(0.0f, 1.0f);                               
            lbl.backgroundColor = [UIColor clearColor];
            lbl.font = [UIFont boldSystemFontOfSize:(isIPhone ? 10.0f : 14.0f)];            
            lbl.text = titleButton;
            lbl.numberOfLines = 0;
            if (row == 0) {
                lbl.textColor = [Utils getColorWithRed:28 green:36 blue:49];
                btn.userInteractionEnabled = YES;
            } else {
                lbl.textColor = [Utils getColorWithRed:136 green:136 blue:136];
                btn.userInteractionEnabled = NO;
            }
            [btn addSubview:lbl];
            [lbl release];
            
            //Пересчитываем следующее положение по оси Х
            x += rectButton.size.width + offset;
            tag++;
        }        
        y += rectButton.size.height + offset;
    }
    
    //Выводим заголоовк для картинки c описание "шагов" по работе с прогой
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, offsetLeftRight, rect.size.width, (isIPhone ? 50.0f : 100.0f))];
    lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Utils getColorWithRed:225 green:227 blue:224];
    lbl.font = [UIFont boldSystemFontOfSize:(isIPhone ? 20.0f : 40.0f)];
    lbl.text = NSLocalizedString(@"PSHomePageController.view.title", nil);    
    lbl.numberOfLines = 0;
    [bgView addSubview:lbl];
    [lbl release];
                
    //Выводим рамку под описание последовательности действий (основных шагов по работе с прогой)
    UIImage *img = [[UIImage imageNamed:@"homepage_steps"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.0f, 9.0f, 9.0f, 9.0f)];    
    CGRect rectSteps = rect;
    rectSteps.origin.x = offsetLeftRight;
    rectSteps.size.width -= 2 * rectSteps.origin.x;
    rectSteps.size.height = (isIPhone) ? 28.0f : 50.0f;    
    rectSteps.origin.y = lbl.frame.origin.y + lbl.frame.size.height;
    rectSteps.origin.y += round((bottomSteps - rectSteps.origin.y - rectSteps.size.height) / 2.0f);
    UIImageView *stepsView = [[UIImageView alloc] initWithFrame:rectSteps];
    stepsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    stepsView.image = img;
    [bgView addSubview:stepsView];
    [stepsView release];

    //Определяем заголовки для вывода шагов и их ширину
    UIFont *font = [UIFont systemFontOfSize:(isIPhone ? 8.0f : 14.0f)];
    NSMutableArray *arrTitleSteps = [[NSMutableArray alloc] initWithCapacity:STEP_COUNT];
    CGFloat arrWidthSteps[STEP_COUNT];
    CGFloat widthTextWithAllSteps = 0.0f;
    for (int i = 0; i < STEP_COUNT; i++) {
        NSString *keyStep = [NSString stringWithFormat:@"PSHomePageController.step%d.text", i];
        NSString *title = NSLocalizedString(keyStep, nil);    
        [arrTitleSteps addObject:title];
        CGSize s = [title sizeWithFont:font];
        widthTextWithAllSteps += s.width;
        arrWidthSteps[i] = s.width;
    }
    
    
    //Выводим шаги по работе с прогой        
    offset = round((rectSteps.size.width - widthTextWithAllSteps) / (STEP_COUNT + 1));
    offsetLeftRight = offset;
    CGRect rectStep = CGRectMake(0.0f, 0.0f, 0.0f, rectSteps.size.height);
    CGFloat x = offsetLeftRight;
    for (int i = 0; i < STEP_COUNT; i++) {
        //Выводим надпись
        rectStep.origin.x = x;
        rectStep.size.width = arrWidthSteps[i];
        UILabel *lbl = [[UILabel alloc] initWithFrame:rectStep];
        lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [Utils getColorWithRed:225 green:227 blue:224];
        lbl.font = font;
        lbl.text = [arrTitleSteps objectAtIndex:i];    
        [stepsView addSubview:lbl];
        [lbl release];
        
        //Пересчитываем следующее положение по оси Х
        x += rectStep.size.width + offset;
        
        //Выводим стрелку
        if  (i < STEP_COUNT - 1) {
            //Выводим надпись
            CGRect r = rectStep;
            r.origin.x = x - offset;
            r.size.width = offset;
            UILabel *lbl = [[UILabel alloc] initWithFrame:r];
            lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            lbl.textAlignment = UITextAlignmentCenter;
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [Utils getColorWithRed:225 green:227 blue:224];
            lbl.font = [UIFont systemFontOfSize:(isIPhone ? 6.0f : 18.0f)];
            lbl.text = @"→";
            [stepsView addSubview:lbl];
            [lbl release];
        }
    }
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
