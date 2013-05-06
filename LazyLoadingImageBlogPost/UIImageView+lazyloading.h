//
//  UIImageView+lazyloading.h
//  LazyLoadingImageBlogPost
//
//  Created by Eagle Diao on 2013-03-08.
//  Copyright (c) 2013 intelliware. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImageView (lazyloading)

-(void) setupImageReceiver;
-(void) setImageUrl:(NSString*)url;
-(void) loadImage:(BOOL)small;

@end
