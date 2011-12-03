//
//  OneJob.m
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OneJob.h"
#import "NSDateAdditions.h"
#import "NSDate+JobInfo.h"

#define WORKDAY_TYPE_FULL 0
#define WORKDAY_TYPE_NOT  1
#define WORKDAY_TYPE_HALF 2
@interface WorkDay : NSObject {
@private
    int dayType;
    NSDate *theDate;
}

@property int dayType;
@property (strong) NSDate *theDate;
@end

@implementation WorkDay
@synthesize dayType;
@synthesize theDate;
@end


@implementation OneJob
@dynamic jobName;
@dynamic jobDescription;
@dynamic jobOnDays;
@dynamic jobOffDays;
@dynamic jobStartDate;
@dynamic jobFinishDate;

@synthesize curCalender;

- (NSCalendar *) curCalender
{
    if (!curCalender) {
        curCalender = [NSCalendar currentCalendar];
    }
    return curCalender;
}

- (id)init
{
    self = [super init];
    return self;
}

#define DAY_TO_SECONDS 60*60*24

// ideas1 ， 只储存所有工作的日期， 在这个workdays的数组里。
//            问题： 但是问题是， 这样做了以后无法调整， 要调班的时候无法做了。
// idea2, 储存所有的日期， 一年也就365个嘛， 一百年也没多少个。 所以放的下。 
//          这样就需要把nsdate做继承。 继承或者不继承。。 继承了不用改现有代码。
// 先选择2把。
- (id) initWithWorkConfigWithStartDate: (NSDate *) thestartDate
                     workdayLengthWith: (int) workdaylength
                     restdayLengthWith: (int) restdayLength
                         lengthOfArray: (int) lengthOfArray
                              withName:(NSString *)name
{
    self = [self init];

    self.jobName = name;
    self.jobOnDays = [NSNumber numberWithInt:workdaylength];
    self.jobOffDays = [NSNumber numberWithInt:restdayLength];
    self.jobStartDate = thestartDate;
    return self;
}


static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}


- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{

    NSDateComponents *difference = [self.curCalender components:NSDayCalendarUnit
                                                       fromDate:fromDateTime toDate:toDateTime options:0];
    
    return [difference day];
}

- (NSDate *) dateByMovingForwardDays:(NSInteger) i withDate:(NSDate *) theDate
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = i;
    return [self.curCalender dateByAddingComponents:c toDate:theDate options:0];
}


- (NSArray *)returnWorkdaysWithInStartDate:(NSDate *) beginDate endDate:(NSDate *) endDate
{
    
//     输入： 两个UTC的时间。
//     输出： 一个加上了时区的nsdate的数组。
//     注意的是： 这里经过nscalender计算以后，时间就变成了utc时间。    
    
    
    NSInteger timeZoneDiff = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:beginDate];
    // 1st, calulate a first array.
    
    // 计算的时候使用gmt时间， 在要把date加入到时区里面的时候， 加上时区的秒数。

    NSDate *jobStartGMT = [self.jobStartDate cc_dateByMovingToBeginningOfDayWithCalender:self.curCalender];
    
    NSInteger diffBeginAndJobStartGMT = [self daysBetweenDateV2:jobStartGMT andDate:beginDate];
    NSInteger diffEndAndJobStartGMT = [self daysBetweenDateV2:jobStartGMT  andDate:endDate];
    NSInteger range  = [self daysBetweenDateV2:beginDate andDate:endDate];
    
    // 如果说都早于工作开始的时间， 就返回空
    if (diffEndAndJobStartGMT < 0 && diffBeginAndJobStartGMT < 0)
        return  [NSArray array];
    
    NSMutableArray *matchedArray = [[NSMutableArray alloc] init];
    NSDate *workingDate = beginDate;
    
//    这个循环从第一天开始，中间每次循环计算一个从beginDate开始的临时时间和工作开始时间的差距，
//    然后用这个差距所算出来的时间来计算工作的类型。
//    目前只计算工作的天数， 半天的那种需要后面加上。
    for (int i = 0;
         i < range;
         i++, workingDate = [workingDate cc_dateByMovingToNextDayWithCalender:self.curCalender]) 
    {
//    先计算出当前这个临时时间和工作开始时间的差别    
        int days = [self daysBetweenDateV2:jobStartGMT andDate:workingDate];
//    如果这个临时时间小于工作开始的时间，就直接进行下一个
        if (days < 0)
            continue;
//     恰好是工作当天，就直接加上了
        if (days == 0) {
            [matchedArray addObject:[[workingDate copy] dateByAddingTimeInterval:timeZoneDiff]];
            continue;
        }
//      剩下就是最通常的情况，用余数来计算工作的天数，如果小雨jobOnDays，那天以前都是工作日。
        int t = days % ([self.jobOnDays intValue]+ [self.jobOffDays intValue]);
        if (t < [self.jobOnDays intValue]) {
            [matchedArray addObject:[[workingDate copy] dateByAddingTimeInterval:timeZoneDiff]];
        }
    }
    
//    NSDate *date = [self.curCalender ]; 
    
       
    // 2nd, apply the half work day, (if have any).
    // 3rd, apply the switch of the shift.
    
    return matchedArray;
    
}

- (BOOL) isDayWorkingDay:(NSDate *)theDate
{
    NSDate *jobStartGMT = [self.jobStartDate cc_dateByMovingToBeginningOfDayWithCalender:self.curCalender];
    int days = [self daysBetweenDateV2:jobStartGMT andDate:theDate];
   
    if (days < 0) return  NO;
    if (days == 0) return YES;
    
    int t = days % ([self.jobOnDays intValue]+ [self.jobOffDays intValue]);
    if (t < [self.jobOnDays intValue])
        return YES;
    else
        return NO;
}

@end