//
//  SCViewController.m
//  SCKit
//
//  Created by Sebastian Celis on 12/22/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import "SCViewController.h"

@implementation SCViewController

@synthesize allowedInterfaceOrientations = _allowedInterfaceOrientations;

#pragma mark - Controller Lifecycle


#pragma mark - Rotation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([_allowedInterfaceOrientations count] > 0)
    {
        return [_allowedInterfaceOrientations containsObject:[NSNumber numberWithInt:toInterfaceOrientation]];
    }
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)allowAllInterfaceOrientations
{
    NSSet *orientations = [NSSet setWithObjects:
                           @(UIInterfaceOrientationPortrait),
                           @(UIInterfaceOrientationPortraitUpsideDown),
                           @(UIInterfaceOrientationLandscapeLeft),
                           @(UIInterfaceOrientationLandscapeRight),
                           nil];
    [self setAllowedInterfaceOrientations:orientations];
}

@end
