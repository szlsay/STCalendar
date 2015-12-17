//
//  ViewController.m
//  STCalendarDemo
//
//  Created by https://github.com/STShenZhaoliang/STCalendar on 15/12/17.
//  Copyright © 2015年 ST. All rights reserved.
//

#import "ViewController.h"
#import "STCalendar.h"
#import "NSCalendar+ST.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ViewController ()<STCalendarDelegate>
@property (nonatomic, weak, nullable)STCalendar *calender; //
@property (nonatomic, weak, nullable)UILabel *labelDate; //
@property (nonatomic, weak, nullable)UILabel *labelResult; //

@property ( nonatomic, weak, nullable) UIButton *buttonNext; //
@property ( nonatomic, weak, nullable) UIButton *buttonUp; //
@property ( nonatomic, weak, nullable) UIButton *buttonCurrent; //
@end

@implementation ViewController

#pragma mark - lift cycle 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *labelDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 44)];
    [labelDate setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelDate];
    self.labelDate = labelDate;
    
    UILabel *labelResult = [[UILabel alloc]initWithFrame:CGRectMake(0, 450, ScreenWidth, 44)];
    [labelResult setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelResult];
    self.labelResult = labelResult;
    
    CGFloat buttonW = ScreenWidth / 3;
    CGFloat buttonH = 44;
    CGFloat buttonX = 0;
    CGFloat buttonY = ScreenHeight - buttonH;
    
    UIButton *buttonNext = [[UIButton alloc]initWithFrame:CGRectMake(buttonX + 2 * buttonW,
                                                                     buttonY,
                                                                     buttonW,
                                                                     buttonH)];
    [buttonNext setTitle:@"下个月" forState:UIControlStateNormal];
    [buttonNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNext setBackgroundColor:[UIColor redColor]];
    [buttonNext addTarget:self
                   action:@selector(nextMonth:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNext];
    
    UIButton *buttonUp = [[UIButton alloc]initWithFrame:CGRectMake(buttonX,
                                                                     buttonY,
                                                                     buttonW,
                                                                     buttonH)];
    [buttonUp setTitle:@"上个月" forState:UIControlStateNormal];
    [buttonUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonUp setBackgroundColor:[UIColor redColor]];
    [buttonUp addTarget:self
                   action:@selector(upMonth:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonUp];
    
    UIButton *buttonCurrent = [[UIButton alloc]initWithFrame:CGRectMake(buttonX+ buttonW,
                                                                   buttonY,
                                                                   buttonW,
                                                                   buttonH)];
    [buttonCurrent setTitle:@"当前月" forState:UIControlStateNormal];
    [buttonCurrent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonCurrent setBackgroundColor:[UIColor blueColor]];
    [buttonCurrent addTarget:self
                 action:@selector(currentMonth:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCurrent];
    
    
    STCalendar *calender = [[STCalendar alloc]initWithFrame:CGRectMake(0,
                                                                       100,
                                                                       ScreenWidth,
                                                                       ScreenWidth)];
    [calender setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
        
    [calender returnDate:^(NSString * _Nullable stringDate) {
        self.labelDate.text = stringDate;
    }];
    calender.delegate = self;
    [calender setTextSelectedColor:[UIColor greenColor]];
    [self.view addSubview:calender];
    self.calender = calender;
    
    
    
}

#pragma mark - Delegate 视图委托


- (void)calendarResultWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate
{
    self.labelResult.text = [beginDate stringByAppendingString:endDate];
}
#pragma mark - event response 事件相应

- (void)nextMonth:(UIButton *)button
{
    ++self.calender.month;
}

- (void)upMonth:(UIButton *)button
{
    --self.calender.month;
}

- (void)currentMonth:(UIButton *)button
{
    self.calender.year = [NSCalendar currentYear];
    self.calender.month = [NSCalendar currentMonth];
}
#pragma mark - private methods 私有方法

#pragma mark - getters and setters 属性

@end
