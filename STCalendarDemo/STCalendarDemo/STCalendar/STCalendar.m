//
//  STCalendar.m
//  STCalendarDemo
//
//  Created by https://github.com/STShenZhaoliang/STCalendar on 15/12/17.
//  Copyright © 2015年 ST. All rights reserved.
//

#import "STCalendar.h"
#import "NSCalendar+ST.h"
#import "STCalendarItem.h"

#define WidthCalendar  self.frame.size.width
#define HeightCalendar self.frame.size.height

// 每周的天数
static NSInteger const DaysCount = 7;

@interface STCalendar()

/** 1.开始的日期元件器 */
@property (nonatomic, strong, nullable)NSDateComponents *componentsBegin;
/** 2.结束的日期元件器 */
@property (nonatomic, strong, nullable)NSDateComponents *componentsEnd;
/** 3.已选择的日期元件器数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCalendarSelected;

@end

@implementation STCalendar
/**
 *  1.初始化方法
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultData];
        [self addGestureRecognizer];
        [self reloadData];
    }
    return self;
}

/**
 *  2.设置默认值
 */
- (void)setupDefaultData
{
    _year = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _diameter = 34;
    _textNormalColor = [UIColor lightGrayColor];
    _textSelectedColor = [UIColor redColor];
    _backgroundNormalColor = [UIColor whiteColor];
    _backgroundSelectedColor = [UIColor orangeColor];
}

/**
 *  3.重载数据
 */
- (void)reloadData
{
    
    // 1.获取指定年月的第一天是周几和这个月的天数
    NSInteger firstWeekday = [NSCalendar getFirstWeekdayWithYear:self.year month:self.month];
    NSInteger daysMonth = [NSCalendar getDaysWithYear:self.year month:self.month];
    
    // 2.移除子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 3.设置子视图
    CGFloat itemW = self.diameter;
    CGFloat itemH = itemW;
    CGFloat widthRow = WidthCalendar / DaysCount;
    CGFloat heightRow = HeightCalendar / DaysCount;
    
    for (NSInteger i = firstWeekday-1; i < daysMonth + firstWeekday-1; i++) {
        
        NSString *stringDay = [NSString stringWithFormat:@"%d", i - firstWeekday+2];
        
        CGFloat itemCenterX = (i % DaysCount + 0.5) * widthRow;
        CGFloat itemCenterY = (i / DaysCount + 0.5) * heightRow;
        STCalendarItem *calendarItem = [STCalendarItem calendarItemWithFrame:CGRectMake(0,
                                                                                        0,
                                                                                        itemW,
                                                                                        itemH)
                                                                       title:stringDay
                                                            colorNormalTitle:self.textNormalColor
                                                          colorSelectedTitle:self.textSelectedColor
                                                                      center:CGPointMake(itemCenterX,
                                                                                         itemCenterY)];
        [calendarItem setBackgroundColor:self.backgroundNormalColor];
        [calendarItem.layer setCornerRadius:self.diameter/2];
        
        [calendarItem addTarget:self
                         action:@selector(selectedDay:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self.arrayCalendarSelected enumerateObjectsUsingBlock:^(NSDateComponents *obj,
                                                                 NSUInteger idx,
                                                                 BOOL * _Nonnull stop) {
            NSDateComponents *dateComponents = obj;
            if (dateComponents.year == self.year &&
                dateComponents.month == self.month &&
                dateComponents.day == stringDay.integerValue) {
                [calendarItem setSelected:YES];
                [calendarItem setBackgroundColor:self.backgroundSelectedColor];
            }
        }];
        
        [self addSubview:calendarItem];
    }
    
    NSString *stringDate = [NSString stringWithFormat:@"%d年%d月", self.year, self.month];
    if (self.block) {
        self.block(stringDate);
    }
    
    [self setResultStyle];
}

/**
 *  设置返回数据的样式
 */
- (void)setResultStyle
{
    NSString *beginDate = @"";
    if (self.componentsBegin.year > 0) {
        beginDate = [NSString stringWithFormat:@"%d年%d月%d日", self.componentsBegin.year, self.componentsBegin.month, self.componentsBegin.day];
    }
    
    NSString *endDate = @"";
    if (self.componentsEnd.year > 0) {
        endDate = [NSString stringWithFormat:@" - %d年%d月%d日", self.componentsEnd.year, self.componentsEnd.month, self.componentsEnd.day];
    }
    
    [self.delegate calendarResultWithBeginDate:beginDate
                                       endDate:endDate];
}

- (void)returnDate:(ReturnDateBlock)block
{
    self.block = block;
}
/**
 *  4.日期的点击事件
 *
 *  @param calendarItem <#calendarItem description#>
 */
- (void)selectedDay:(STCalendarItem *)calendarItem
{
    [calendarItem setSelected:!calendarItem.selected];
    
    NSString *day = calendarItem.titleLabel.text;
    NSString *stringSeleted = [NSString stringWithFormat:@"%ld-%ld-%@", (long)self.year, (long)self.month, day];
    NSDateComponents *components = [NSCalendar dateComponentsWithString:stringSeleted];
    
    if (calendarItem.selected) {
        [self addSelectedDataWithComponents:components];
    }else {
        [self subtractSelectedDataWithComponents:components];
    }
}

/**
 *  下面两个逻辑方法，需要加上描述，逻辑太费劲了，累死宝宝我了
 *
 *  @param components <#components description#>
 */
- (void)addSelectedDataWithComponents:(NSDateComponents *)components
{
    
    if (!self.componentsBegin.year) {
        self.componentsBegin = components;
    }else if (self.componentsBegin.year && !self.componentsEnd.year) {
        if ([NSCalendar compareWithComponentsOne:components
                                   componentsTwo:self.componentsBegin] == NSOrderedAscending) {
            NSDateComponents *componentsChanger = self.componentsBegin;
            self.componentsEnd = componentsChanger;
            self.componentsBegin = components;
        } else {
            self.componentsEnd = components;
        }
    }else {
        if ([NSCalendar compareWithComponentsOne:self.componentsBegin
                                   componentsTwo:self.componentsEnd] == NSOrderedDescending) {
            NSDateComponents *components = self.componentsEnd;
            self.componentsEnd = self.componentsBegin;
            self.componentsBegin = components;
        }
        
        
        if ([NSCalendar compareWithComponentsOne:components
                                   componentsTwo:self.componentsBegin] == NSOrderedAscending) {
            self.componentsBegin = components;
        } else {
            self.componentsEnd = components;
        }
    }
    
    [self.arrayCalendarSelected removeAllObjects];
    
    if (!self.componentsEnd.year) {
        [self.arrayCalendarSelected addObject:self.componentsBegin];
    } else {
        self.arrayCalendarSelected =  [NSCalendar arrayComponentsWithComponentsOne:self.componentsBegin
                                                                     componentsTwo:self.componentsEnd];
    }
    
    [self reloadData];
}

- (void)subtractSelectedDataWithComponents:(NSDateComponents *)components
{
    [self.arrayCalendarSelected removeAllObjects];
    
    if ([NSCalendar compareWithComponentsOne:components
                               componentsTwo:self.componentsBegin] == NSOrderedSame) {
        self.componentsBegin = self.componentsEnd;
        self.componentsEnd = nil;
    }
    
    if ([NSCalendar compareWithComponentsOne:components
                               componentsTwo:self.componentsEnd] == NSOrderedSame) {
        self.componentsEnd = nil;
    }
    
    if (!self.componentsEnd.year && self.componentsBegin.year) {
        [self.arrayCalendarSelected addObject:self.componentsBegin];
    }
    
    
    if ([NSCalendar compareWithComponentsOne:components
                               componentsTwo:self.componentsBegin] == NSOrderedDescending &&
        [NSCalendar compareWithComponentsOne:components
                               componentsTwo:self.componentsEnd] == NSOrderedAscending) {
        self.componentsEnd = components;
        self.arrayCalendarSelected =  [NSCalendar arrayComponentsWithComponentsOne:self.componentsBegin
                                                                     componentsTwo:self.componentsEnd];
    }
    
    [self reloadData];
}

/**
 *  5.添加手势
 */
- (void)addGestureRecognizer
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(swipeView:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(swipeView:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight ];
    [self addGestureRecognizer:swipeRight];
}

/**
 *  6.手势的点击事件
 *
 *  @param swipe <#swipe description#>
 */
- (void)swipeView:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        ++self.month;
    } else {
       --self.month;
    }
}

/**
 *  7.数据的Set方法
 */
- (void)setMonth:(NSInteger)month
{
    if (month > 12) {
        ++self.year;
        month = 1;
    }
    
    if (month < 1) {
        --self.year;
        month = 12;
    }    
    _month = month;
    
    [self reloadData];
}

- (void)setYear:(NSInteger)year
{
    _year = year;
}

- (NSMutableArray *)arrayCalendarSelected
{
    if (!_arrayCalendarSelected) {
        _arrayCalendarSelected = [NSMutableArray array];
    }
    return _arrayCalendarSelected;
}
@end
