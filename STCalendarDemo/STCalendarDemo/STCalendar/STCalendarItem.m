//
//  STCalendarItem.m
//  STCalendarDemo
//
//  Created by rkxt_ios on 15/12/17.
//  Copyright © 2015年 ST. All rights reserved.
//

#import "STCalendarItem.h"

@implementation STCalendarItem

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
             colorNormalTitle:(UIColor *)colorNormalTitle
           colorSelectedTitle:(UIColor *)colorSelectedTitle
                       center:(CGPoint)center
{
    STCalendarItem *calendarItem = [[STCalendarItem alloc]initWithFrame:frame];
    [calendarItem setTitle:title forState:UIControlStateNormal];
    [calendarItem setTitleColor:colorNormalTitle forState:UIControlStateNormal];
    [calendarItem setTitleColor:colorSelectedTitle forState:UIControlStateSelected];
    [calendarItem setCenter:center];
    return calendarItem;
}

+ (instancetype)calendarItemWithFrame:(CGRect)frame
                                title:(NSString *)title
                     colorNormalTitle:(UIColor *)colorNormalTitle
                   colorSelectedTitle:(UIColor *)colorSelectedTitle
                               center:(CGPoint)center {
    return [[STCalendarItem alloc]initWithFrame:frame
                                          title:title
                               colorNormalTitle:colorNormalTitle
                             colorSelectedTitle:(UIColor *)colorSelectedTitle
                                         center:center];
}
@end
