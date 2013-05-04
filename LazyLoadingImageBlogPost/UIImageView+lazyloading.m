//
//  UIImageView+lazyloading.m
//  LazyLoadingImageBlogPost
//
//  Created by Eagle Diao on 2013-03-08.
//  Copyright (c) 2013 intelliware. All rights reserved.
//

#import "UIImageView+lazyloading.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@implementation UIImageView (lazyloading)

-(void) setupImageReceiver
{
    
}

-(void) setImageUrl:(NSString*)url
{
    
}

-(BOOL) shouldLazyLoad
{
    NSNumber* value = [[NSUserDefaults standardUserDefaults] objectForKey:@"lazyon"];
    return value.integerValue == 1;
}

-(BOOL) shouldDoJpeg
{
    NSNumber* value = [[NSUserDefaults standardUserDefaults] objectForKey:@"imagetype"];
    return value.integerValue == 0;
}

-(void) loadImage
{
    AFHTTPClient* client = [[AFHTTPClient alloc] init];
    client.operationQueue.maxConcurrentOperationCount = 1;
    
    NSMutableURLRequest* request = [client requestWithMethod:@"GET" path:@"http://www.digitaltrends.com/wp-content/uploads/2012/07/android-tethering.png" parameters:nil];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Data received
        if( [self shouldLazyLoad]) {
            [self loadImageWithData:responseObject];
        } else {
            self.image = [UIImage imageWithData:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // data not received
        NSLog(@"data not received");
    }];
    [op start];
}

- (void)loadImageWithData:(NSData *)data {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *imageData = data;
        CGImageRef decompressedImage = NULL;
        if (imageData) {
            CGDataProviderRef imageDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData);
            CGImageRef image = CGImageCreateWithPNGDataProvider(imageDataProvider, NULL, NO, kCGRenderingIntentDefault);
            CGContextRef bitmapContext = CGBitmapContextCreate(NULL, CGImageGetWidth(image), CGImageGetHeight(image), CGImageGetBitsPerComponent(image), CGImageGetWidth(image) * 4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
            CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
            decompressedImage = CGBitmapContextCreateImage(bitmapContext);
            
            CGDataProviderRelease(imageDataProvider);
            CGImageRelease(image);
            CGContextRelease(bitmapContext);
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (decompressedImage) {
                
                UIImage* image = [UIImage imageWithCGImage:decompressedImage];
                self.image = image;
            }
        });
        
        if (decompressedImage) {
            CGImageRelease(decompressedImage);
        }
    });
}


@end
