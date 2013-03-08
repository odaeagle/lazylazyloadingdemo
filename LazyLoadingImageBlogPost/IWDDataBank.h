//
//  IWDDataBank.h
//  LazyLoadingImageBlogPost
//
//  Created by Eagle Diao on 2013-03-08.
//  Copyright (c) 2013 intelliware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWDDataBank : NSObject

+ (id) sharedInstance;

-(void) requestImage:(NSString*)imageUrl;

@end
