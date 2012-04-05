//
//  PSTariffsHederSectionView.m
//  MobileBroadband
//
//  Created by Медведь on 30.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSTariffsHederSectionView.h"
#import "PSTariffsTableViewCell.h"


@interface PSTariffsHederSectionView () {
    
}

@property (nonatomic, retain) UIImageView *providerLogo;
//@property (nonatomic, retain) UILabel *providerName;
@property (nonatomic, retain) UILabel *trafficType;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UILabel *speed;
@property (nonatomic, retain) UILabel *limit;

@end


@implementation PSTariffsHederSectionView



@synthesize providerLogo = _providerLogo;
@synthesize trafficType = _trafficType;
@synthesize price = _price;
@synthesize speed = _speed;
@synthesize limit = _limit;


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;            
        self.autoresizesSubviews = YES;
        
        //Подгружаем картинку заголовка
        UIImage *image = [UIImage imageNamed:@"table-header.png"];
        CGFloat topCapHeight = image.size.height / 2;
        self.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(topCapHeight, 0, topCapHeight, 0)];
        
        
        _providerLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"provider.png"]];
        _providerLogo.contentMode = UIViewContentModeCenter; //UIViewContentModeScaleAspectFit;
        [self addSubview:_providerLogo];
        
        BOOL isIPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
        UIFont *font = [UIFont boldSystemFontOfSize:(isIPhone ? 12.0f : 14.0f)];
        
        _trafficType = [[UILabel alloc] init];
        _trafficType.font = font;
        _trafficType.textAlignment = UITextAlignmentCenter;
        _trafficType.backgroundColor = [UIColor clearColor];
        _trafficType.text =  NSLocalizedString(@"PSTariffsController.tableHeader.trafficType", nil);   
        [self addSubview:_trafficType];
        
        _price = [[UILabel alloc] init];
        _price.font = font;
        _price.textAlignment = UITextAlignmentCenter;
        _price.backgroundColor = [UIColor clearColor];
        _price.text =  NSLocalizedString(@"PSTariffsController.tableHeader.price", nil);
        [self addSubview:_price];
        
        _speed = [[UILabel alloc] init];
        _speed.font = font;
        _speed.textAlignment = UITextAlignmentCenter;
        _speed.backgroundColor = [UIColor clearColor];
        _speed.text =  NSLocalizedString(@"PSTariffsController.tableHeader.speed", nil);
        [self addSubview:_speed];
        
        _limit = [[UILabel alloc] init];
        _limit.font = font;
        _limit.textAlignment = UITextAlignmentCenter;
        _limit.backgroundColor = [UIColor clearColor];
        _limit.text =  NSLocalizedString(@"PSTariffsController.tableHeader.limit", nil);
        [self addSubview:_limit];
    }
    return self;
}

- (void)dealloc {
        
    [_providerLogo release];
    [_trafficType release];
    [_price release];
    [_speed release];
    [_limit release];
    
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //Определяем размер как в ячейке
    CGRect rect = self.frame;
    rect.size.width -= 20.0f; //отступ от правого края на ширину стрелки (AccessoryDisclosureIndicator)
    
    //Размещаем логотип провайдера
    self.providerLogo.frame = [PSTariffsTableViewCell getFrameForColumn:0 withRowContentFrame:rect];    
    //Размещаем тип трафика
    self.trafficType.frame = [PSTariffsTableViewCell getFrameForColumn:1 withRowContentFrame:rect];    
    //Размещаем стоимость 
    self.price.frame = [PSTariffsTableViewCell getFrameForColumn:2 withRowContentFrame:rect];    
    //Размещаем скорость 
    self.speed.frame = [PSTariffsTableViewCell getFrameForColumn:3 withRowContentFrame:rect];    
    //Размещаем лимит
    self.limit.frame = [PSTariffsTableViewCell getFrameForColumn:4 withRowContentFrame:rect];    
}

@end