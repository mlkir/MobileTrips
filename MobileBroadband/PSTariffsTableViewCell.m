//
//  PSTariffsTableViewCell.m
//  MobileBroadband
//
//  Created by Медведь on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSTariffsTableViewCell.h"
#import "Utils.h"


#define HEIGHT_DETAIL       14.0f

#define WIDTH_PROVIDER      60.0f 
#define WIDTH_TRAFFIC_TYPE  25  
#define WIDTH_PRICE         30
#define WIDTH_SPEED         20
#define WIDTH_LIMIT         25



@interface PSTariffsTableViewCell () {
    
}

@property (nonatomic, retain) UIImageView *providerLogo;
@property (nonatomic, retain) UILabel *providerName;
@property (nonatomic, retain) UILabel *trafficType;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UILabel *speed;
@property (nonatomic, retain) UILabel *limit;
@property (nonatomic, retain) UILabel *detail;

@end



@implementation PSTariffsTableViewCell

@synthesize object = _object;

@synthesize providerLogo = _providerLogo;
@synthesize providerName = _providerName;
@synthesize trafficType = _trafficType;
@synthesize price = _price;
@synthesize speed = _speed;
@synthesize limit = _limit;
@synthesize detail = _detail;


+ (CGRect)getFrameForColumn:(int)column withRowContentFrame:(CGRect)contentRect {
    //Расчитываем все размеры 
    static int count = 5;       //Кол-во столбцов
    static CGFloat dx = 2.0f;   //Промежутки между словами    
    CGFloat contentWidth = contentRect.size.width;
    CGFloat contentHeight = contentRect.size.height;
    
    //Остаток ширины которую необходимо распределить между оставшимися полями
    CGFloat width = contentWidth - WIDTH_PROVIDER - dx * (count - 2);
        
    CGRect rect0 = CGRectMake(0.0f, 0.0f, WIDTH_PROVIDER, contentHeight);
    
    CGFloat x = rect0.origin.x + rect0.size.width;
    CGFloat w = width * WIDTH_TRAFFIC_TYPE / 100;
    CGRect rect1 = CGRectMake(x, 0.0f, w, contentHeight);
    
    x = rect1.origin.x + rect1.size.width + dx;
    w = width * WIDTH_PRICE / 100;
    CGRect rect2 = CGRectMake(x, 0.0f, w, contentHeight);
    
    x = rect2.origin.x + rect2.size.width + dx;
    w = width * WIDTH_SPEED / 100;
    CGRect rect3 = CGRectMake(x, 0.0f, w, contentHeight);
    
    x = rect3.origin.x + rect3.size.width + dx;
    w = width * WIDTH_LIMIT / 100;
    CGRect rect4 = CGRectMake(x, 0.0f, w, contentHeight);
    
    switch (column) {
        case 0: return rect0;
        case 1: return rect1;
        case 2: return rect2;
        case 3: return rect3;
        case 4: return rect4;
        default: return CGRectZero;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //Определяем размеры шрифтов
        BOOL isIPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
        UIFont *fontForCommonData = [UIFont systemFontOfSize:(isIPhone ? 12.0f : 14.0f)];
        UIFont *fontForDetalData = [UIFont systemFontOfSize:(isIPhone ? 10.0f : 12.0f)];
        UIColor *colorForDetailData = [UIColor darkGrayColor];       
        
        _providerLogo = [[UIImageView alloc] init];
        _providerLogo.contentMode = UIViewContentModeCenter; //UIViewContentModeScaleAspectFit;
        [self addSubview:_providerLogo];
        
        _providerName = [[UILabel alloc] init];
        _providerName.font = fontForDetalData;
        _providerName.textColor = colorForDetailData;
        _providerName.textAlignment = UITextAlignmentCenter;
        _providerName.backgroundColor = [UIColor clearColor];
        [self addSubview:_providerName];        
                
        _trafficType = [[UILabel alloc] init];
        _trafficType.font = fontForCommonData;
        _trafficType.textAlignment = UITextAlignmentCenter;
        _trafficType.backgroundColor = [UIColor clearColor];
        [self addSubview:_trafficType];
        
        _price = [[UILabel alloc] init];
        _price.font = fontForCommonData;
        _price.textAlignment = UITextAlignmentCenter;
        _price.backgroundColor = [UIColor clearColor];
        [self addSubview:_price];
        
        _speed = [[UILabel alloc] init];
        _speed.font = fontForCommonData;
        _speed.textAlignment = UITextAlignmentCenter;
        _speed.backgroundColor = [UIColor clearColor];
        [self addSubview:_speed];
        
        _limit = [[UILabel alloc] init];
        _limit.font = fontForCommonData;
        _limit.backgroundColor = [UIColor clearColor];
        [self addSubview:_limit];
        
        _detail = [[UILabel alloc] init];
        _detail.font = fontForDetalData;
        _detail.textColor = colorForDetailData;
        //_detail.textAlignment = UITextAlignmentRight;
        _detail.backgroundColor = [UIColor clearColor];
        [self addSubview:_detail];  
        
    }
    return self;
}

- (void)dealloc 
{
    [_providerLogo release];
    [_providerName release];
    [_trafficType release];
    [_price release];
    [_speed release];
    [_limit release];
    [_detail release];
        
    [super dealloc];
}

- (void)setObject:(PSTariffModel *)object {
    [_object release];
    _object = [object retain];
    
    self.providerLogo.image = [UIImage imageNamed:@"provider.png"];    
    self.providerName.text = object.provaderName;
    self.trafficType.text = object.trafficType;
    self.price.text = object.price;
    self.speed.text = object.speed;
    self.limit.text = object.dataLimit;
    self.detail.text = object.bonus; 
}


- (void)layoutSubviews {
    [super layoutSubviews];
        
    //Размещаем логотип и название провайдера
    CGRect rect = [PSTariffsTableViewCell getFrameForColumn:0 withRowContentFrame:self.contentView.frame];
    CGRect rectLogo = rect;
    rectLogo.size.height -= HEIGHT_DETAIL;
    self.providerLogo.frame = rectLogo;
    CGRect rectName = rect;
    rectName.origin.y = rectLogo.size.height;
    rectName.size.height = HEIGHT_DETAIL;
    self.providerName.frame = rectName;
    
    //Размещаем тип трафика
    self.trafficType.frame = [PSTariffsTableViewCell getFrameForColumn:1 withRowContentFrame:self.contentView.frame];    
    //Размещаем стоимость 
    self.price.frame = [PSTariffsTableViewCell getFrameForColumn:2 withRowContentFrame:self.contentView.frame];    
    //Размещаем скорость 
    self.speed.frame = [PSTariffsTableViewCell getFrameForColumn:3 withRowContentFrame:self.contentView.frame];    
    //Размещаем лимит
    self.limit.frame = [PSTariffsTableViewCell getFrameForColumn:4 withRowContentFrame:self.contentView.frame];    
    
    //Если поле с деталями не заполнено
    if ([Utils isEmptyString:self.detail.text]) {         
        self.detail.frame = CGRectZero;
    } else {
        //rect.origin.x = self.trafficType.frame.origin.x;
        //rect.origin.y = self.trafficType.frame.size.height - HEIGHT_DETAIL;
        //rect.size.width = self.limit.frame.origin.x + self.limit.frame.size.width - rect.origin.x;
        //rect.size.height = HEIGHT_DETAIL;
        
        rect = self.limit.frame;
        //rect.size.height -= HEIGHT_DETAIL;
        //self.limit.frame = rect;
        
        rect.origin.y = rect.size.height - HEIGHT_DETAIL;
        rect.size.height = HEIGHT_DETAIL;
        self.detail.frame = rect;
    }
}

@end
