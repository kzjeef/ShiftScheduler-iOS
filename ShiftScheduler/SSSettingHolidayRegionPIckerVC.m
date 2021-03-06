//
//  SSSettingHolidayRegionPIckerVC.m
//  ShiftScheduler
//
//  Created by Jiejing Zhang on 13-2-22.
//
//

#import "SSSettingHolidayRegionPIckerVC.h"
#import "SSDefaultConfigName.h"
#import "SSLunarDate/SSHolidayManager.h"
#import "I18NStrings.h"

@interface SSSettingHolidayRegionPIckerVC ()
{
    NSArray *_regionList;
    NSMutableArray *_regionCheckList;
}

/*
 SSHolidayRegionChina = 0,
 SSHolidayRegionHongkong,
 SSHolidayRegionMocao,
 SSHolidayRegionTaiwan,
 SSHolidayRegionUS,
 SSHolidayRegionCanadia,
 SSHolidayRegionUK,
 */


@property (readonly) NSArray *regionList;
@property (nonatomic, strong) NSMutableArray *regionCheckList;

@end



@implementation SSSettingHolidayRegionPIckerVC

- (NSArray *)regionList
{
    if (_regionList == nil) {
        _regionList = [NSArray arrayWithObjects:
                        REGION_NAME_CHINA,
                        REGION_NAME_HK,
                        REGION_NAME_TAIWAN,
                        REGION_NAME_US,
                        REGION_NAME_CANADIA,
                        REGION_NAME_UK,
                        nil];
    }
    return _regionList;
}

- (NSMutableArray *)regionCheckList
{
    if (!_regionCheckList) {
        _regionCheckList = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.regionList.count; i++) {
            [_regionCheckList addObject:[NSNumber numberWithBool:NO]];
        }
        NSArray *storedCheck = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_CONFIG_HOLIDAY_REGION];
        for (int i = 0; i < storedCheck.count && i < _regionCheckList.count; i++)
            [_regionCheckList replaceObjectAtIndex:i withObject:[storedCheck objectAtIndex:i]];
    }
    return  _regionCheckList;
}

#pragma mark - UIViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClick)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Done Button

- (void) doneButtonClick
{
    NSArray *a = self.regionCheckList;
    [[NSUserDefaults standardUserDefaults] setObject:a forKey:USER_CONFIG_HOLIDAY_REGION];
    [[NSNotificationCenter defaultCenter] postNotificationName:HOLIDAY_REGION_CHANGED_NOTICE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.regionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.regionList objectAtIndex:indexPath.row];
    
    NSNumber *n = [self.regionCheckList objectAtIndex:indexPath.row];
    if (n != nil && n.integerValue != NO)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *n = [self.regionCheckList objectAtIndex:indexPath.row];
    
    if (n == nil)
        n = [NSNumber numberWithBool:YES];
    else {
        // flip it.
        n = [NSNumber numberWithBool:!n.integerValue];
    }
    [self.regionCheckList replaceObjectAtIndex:indexPath.row withObject:n];
    [self.tableView reloadData];
    
    
    [SSTrackUtil logEvent:kLogEventSettingChooseHoliday param:@{@"region": [NSNumber numberWithInteger:indexPath.row],
                                                                @"enable" : n,
                                                                @"string"   : [self.regionList objectAtIndex:indexPath.row]}];
}

@end
