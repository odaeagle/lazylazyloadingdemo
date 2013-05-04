//
//  IWDSettingViewController.m
//  LazyLoadingImageBlogPost
//
//  Created by Eagle Diao on 3/22/13.
//  Copyright (c) 2013 intelliware. All rights reserved.
//

#import "IWDSettingViewController.h"

@interface IWDSettingViewController ()

@end

@implementation IWDSettingViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSNumber* lazyOn = [user objectForKey:@"lazyon"];
    NSNumber* imageType = [user objectForKey:@"imagetype"];
    
    UISegmentedControl* segControl = (UISegmentedControl*)[self.view viewWithTag:1001];
    UISwitch* switchControl = (UISwitch*)[self.view viewWithTag:1000];
    
    if( lazyOn == nil || lazyOn.integerValue == 0 ) {
        switchControl.on = NO;
    } else {
        switchControl.on = YES;
    }
    
    if(imageType == nil || imageType.integerValue == 0) {
        segControl.selectedSegmentIndex = 0;
    } else {
        segControl.selectedSegmentIndex = 1;
    }
    
}

- (IBAction)onSwitch:(UISwitch*)sender {
    NSNumber* value = nil;
    if( sender.on == YES) {
        value = [NSNumber numberWithInt:1];
    } else {
        value = [NSNumber numberWithInt:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"lazyon"];
}

- (IBAction)onSeq:(UISegmentedControl*)sender {
    NSNumber* value = nil;
    if( sender.selectedSegmentIndex == 1) {
        value = [NSNumber numberWithInt:1];
    } else {
        value = [NSNumber numberWithInt:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"imagetype"];
}

@end
