//
//  MainMenuTableViewController.m
//  ShiftScheduler
//
//  Created by Jiejing Zhang on 13-11-9.
//
//

#import "SSMainMenuTableViewController.h"
#import "SSAppDelegate.h"

@interface SSMainMenuTableViewController ()

@end

@implementation SSMainMenuTableViewController

- (id) initWithStyle:(UITableViewStyle)style nameArray: (NSArray *) nameArray iconArray: (NSArray *)iconArray
{
    self = [super initWithStyle:style];
    if (self) {
        self.menuItemIconPathList = iconArray;
        self.menuItemNameList = nameArray;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];

    if ([self.tableView respondsToSelector:@selector(separatorInset)])
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 7, 0, 7);

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];

    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"AppIcon.png"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = APP_NAME_STR;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItemNameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    if (indexPath.section == 0) {
        // -1 is to remove the first item, the big logo.
        cell.textLabel.text = [self.menuItemNameList objectAtIndex:(indexPath.row)];
        NSString *str = [self.menuItemIconPathList objectAtIndex:(indexPath.row)];

        if (str != NULL && str.length > 0) {
            UIImage *i = [UIImage imageWithContentsOfFile:str];
            cell.imageView.image = i;
        } else
            cell.imageView.image = NULL;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;

    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            navigationController.viewControllers = @[self.kalController];
        } else if (indexPath.row == 1) {
            navigationController.viewControllers = @[self.shiftListTVC];
        } else if (indexPath.row == 2) {
            navigationController.viewControllers = @[self.settingTVC];
        } else if (indexPath.row == 3) {
            if (self.shareDelegate) {
                navigationController.viewControllers = @[self.kalController];
                [self.shareDelegate SSMainMenuShareButtonClicked:self];
            }
        }
    }

    [self.frostedViewController hideMenuViewController];
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
