//
//  SRMCalendarConstance.h
//  Cal
//
//  Created by Sorumi on 16/7/29.
//  Copyright © 2016年 Sorumi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

UIKIT_EXTERN CGFloat const SRMHeaderHeight;
UIKIT_EXTERN CGFloat const SRMMonthViewWeekdayHeight;
UIKIT_EXTERN CGFloat const SRMWeekViewWeekdayHeight;
UIKIT_EXTERN CGFloat const SRMWeekViewDayCircleRadius;

UIKIT_EXTERN CGFloat const SRMEventCellHeight;
UIKIT_EXTERN CGFloat const SRMEventCellSpacing;

typedef NS_ENUM(NSInteger, SRMCalendarViewMode) {
    SRMCalendarMonthViewMode    = 0,
    SRMCalendarWeekViewMode     = 1
};