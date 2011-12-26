//
//  OneJob.h
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#include "ShiftDay.h"


@interface OneJob : NSManagedObject {
     NSCalendar *curCalender;
    NSCalendar *timezoneCalender;
    
}
@property (nonatomic, strong) NSString * jobName;       // the job's name
@property (nonatomic, strong) NSString * jobDescription; //the detail describe of this job
@property (nonatomic, strong) NSNumber * jobOnDays; // how long works once
@property (nonatomic, strong) NSNumber * jobOffDays; // how long rest once.
@property (nonatomic, strong) NSDate * jobStartDate;
@property (nonatomic, strong) NSDate * jobFinishDate;

@property (nonatomic, strong) NSCalendar *curCalender;



// init the work date generator with these input.
- (id) initWithWorkConfigWithStartDate: (NSDate *) startDate
                     workdayLengthWith: (int) workdaylength
                     restdayLengthWith: (int) restdayLength
                         lengthOfArray: (int) lengthOfArray
                              withName: (NSString *)name;

- (NSArray *) returnWorkdaysWithInStartDate:(NSDate *) startDate endDate: (NSDate *) endDate;
- (BOOL) isDayWorkingDay:(NSDate *)theDate;
- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

@property (nonatomic, strong) NSSet *shiftdays;
@end

@interface OneJob (CoreDataGeneratedAccessors)

//  should check whether the shiftday is allowed. if the shift day is now allowed, return -Error Code;

//  eg, if the shift day is exchange shift day, one of "From" or "To" must has one "on day"
//      in a overwork shift day: it must added to a "off day"
//      in a vacation shift day: it must be on a "on day"

// return value:
// failed: return -X; is error number
// success: return 0;
- (NSInteger)addShiftdaysObject:(ShiftDay *)value;

- (void)removeShiftdaysObject:(ShiftDay *)value;
- (void)addShiftdays:(NSSet *)values;
- (void)removeShiftdays:(NSSet *)values;

@end



