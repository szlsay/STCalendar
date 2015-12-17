//
//  STCalendarItem.h
//  STCalendarDemo
//
//  Created by rkxt_ios on 15/12/17.
//  Copyright © 2015年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  1.这个类型的继承最好是UIView,可以对日历单元定制
 */
@interface STCalendarItem : UIButton
+ (instancetype)calendarItemWithFrame:(CGRect)frame
                                title:(NSString *)title
                     colorNormalTitle:(UIColor *)colorNormalTitle
                   colorSelectedTitle:(UIColor *)colorSelectedTitle
                               center:(CGPoint)center;
@end
