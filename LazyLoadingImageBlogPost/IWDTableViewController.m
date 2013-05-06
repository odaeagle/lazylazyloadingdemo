//
//  IWDTableViewController.m
//  LazyLoadingImageBlogPost
//
//  Created by Eagle Diao on 2013-03-08.
//  Copyright (c) 2013 intelliware. All rights reserved.
//

#import "IWDTableViewController.h"
#import "UIImageView+lazyloading.h"

@interface IWDTableViewController ()

@end

@implementation IWDTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 150;
}

-(BOOL) shouldDoSmallImage
{
    NSNumber* value = [[NSUserDefaults standardUserDefaults] objectForKey:@"imagetype"];
    return value.integerValue == 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1000];
    UILabel* textView = (UILabel*)[cell viewWithTag:1001];
    
    if( [self shouldDoSmallImage]) {
        textView.text = [NSString stringWithFormat:@"cell load small image %d",indexPath.row];
    } else {
        textView.text = [NSString stringWithFormat:@"cell load big image %d", indexPath.row];
    }
    [imageView loadImage:[self shouldDoSmallImage]];
    
    return cell;
}

@end
