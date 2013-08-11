//
//  SSDayEventUTC.h
//  ShiftScheduler
//
//  Created by Jiejing Zhang on 13-7-3.
//
//

#import <UIKit/UIKit.h>

@interface SSDayEventUTC : UITableViewCell
{
     UITextView *_lunarTextView;
    //     UITextView *_holidayTextView;
    UILabel *_holidayLable;

}

@property (strong, nonatomic) IBOutlet UITextView *lunarTextView;
//@property (strong, nonatomic) IBOutlet UITextView *holidayTextView;
@property (strong, nonatomic) IBOutlet UILabel *holidayLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lunarImage;


@end