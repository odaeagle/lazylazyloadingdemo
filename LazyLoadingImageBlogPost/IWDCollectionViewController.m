//
//  IWDCollectionViewController.m
//  LazyLoadingImageBlogPost
//
//  Created by Eagle Diao on 2013-03-08.
//  Copyright (c) 2013 intelliware. All rights reserved.
//

#import "IWDCollectionViewController.h"
#import "UIImageView+lazyloading.h"

@interface IWDCollectionViewController ()

@end

@implementation IWDCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldDoSmallImage
{
    NSNumber* value = [[NSUserDefaults standardUserDefaults] objectForKey:@"imagetype"];
    return value.integerValue == 0;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 150;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1000];
    
    [imageView loadImage:[self shouldDoSmallImage]];
    
    return cell;
}

@end
