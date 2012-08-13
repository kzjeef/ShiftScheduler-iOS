//
//  SSShareObject.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSShareObject.h"
#import "SSAppDelegate.h"
#import "SSShareProfileListViewController.h"
#import "KalViewController.h"
#import "UIImage+CaptureView.h"

@interface SSShareResult ()
{
    int _result;
    NSString *_failedReason;
}

@end

@implementation SSShareResult

@synthesize result = _result;
@synthesize failedReason = _failedReason;

@end

@interface SSShareController () 
{
    KalViewController *_kal;
    SSAppDelegate *_appDelegate;
    SSShareProfileListViewController *_profileListVC;
}
@end

@implementation SSShareController

- (id) initWithProfilesVC:(SSShareProfileListViewController *)profilelist
        withKalController:(KalViewController *)kal
{
    self = [super init];
    
    _kal = kal;
    _profileListVC = profilelist;
    
    return self;
}

- (NSString *)shiftOverviewStr
{
    NSString *shiftMonthstr = [_kal selecedMonthNameAndYear];
    
    return [NSString stringWithFormat:@"%@-%@", 
            NSLocalizedString(@"Shift Scheduler", ""),
            shiftMonthstr];
}

- (NSString *)shiftThinkNoteStr
{
    NSString *shiftMonthstr = [_kal selecedMonthNameAndYear];
   NSString *template = NSLocalizedString(@"My shift schedule at %@, the following images are shift calendar and shift profile.", "shift Str of think Note");
    return [NSString stringWithFormat:template,
            shiftMonthstr];
}

- (NSString *) shiftDetailEmailStr
{
    NSString *emailBody = NSLocalizedString(@"Hi, <p> I want to share you with my shift schedule, here is my shift schedule at %@, you can check the shift of this month by attachment: \"%@\", and each shift's work time by attachment: \"%@\". <p> <p> About Shift Sheduler：<a href='http://itunes.apple.com/en/app//id482061308?mt=8'>Click Here</a>");
    
    NSString *shiftMonthstr = [_kal selecedMonthNameAndYear];
    
    return [NSString stringWithFormat:emailBody,
            shiftMonthstr,
            NSLocalizedString(@"Shift Scheduler", ""),
            self.shiftListImageName];
    
}

- (UIImage *)shiftCalImage
{
    UIImage *image = [_kal captureCalendarView];
    if (!image) {
        NSLog(@"shift Cal image generate failed\n");
        return nil;
    }
    return image;
}

- (NSString *) shiftCalImageName
{
    NSString *shiftMonthstr = [_kal selecedMonthNameAndYear];

    return [NSString stringWithFormat:@"%@ @ %@.%@", 
            NSLocalizedString(@"Shift Scheduler", ""),
                     shiftMonthstr, @"jpg"];
}

- (UIImage *) shiftListImage
{
    NSAssert(_profileListVC != nil, @"shareProfileViewController == nil");
    UIImage *listImage = [UIImage imageWithView:_profileListVC.view];
    return listImage;
}

- (NSString *) shiftListImageName
{
    return [NSString stringWithFormat:@"%@.%@", 
                     NSLocalizedString(@"Shift-On-Off Time", "on-off time in mail attachment"),
                     @"jpg"];
}

@end