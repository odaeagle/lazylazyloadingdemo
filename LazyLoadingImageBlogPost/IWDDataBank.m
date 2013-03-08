//
//  IWDDataBank.m
//  LazyLoadingImageBlogPost
//
//  Created by Eagle Diao on 2013-03-08.
//  Copyright (c) 2013 intelliware. All rights reserved.
//

#import "IWDDataBank.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"

@implementation IWDDataBank

static IWDDataBank* instance = nil;

+ (IWDDataBank*) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void) requestImage:(NSString*)imageUrl
{
    NSMutableDictionary* para = [[NSMutableDictionary alloc] init];
     NSURL *url = [NSURL URLWithString:imageUrl];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest* request = [client requestWithMethod:@"GET" path:@"" parameters:para];
    [request setHTTPShouldHandleCookies:NO];

    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get image %@",request);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    [op start];
}

@end
