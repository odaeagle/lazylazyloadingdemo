//
//  UIView+receiptThumbnail.m
//  HelloReceipts
//
//  Created by Eagle Diao on 2/12/13.
//  Copyright (c) 2013 Intelliware Development Inc. All rights reserved.
//

#import "UIImageView+receiptImage.h"
#import "IWDReceiptDataBank.h"

@implementation UIImageView (receiptThumbnail)

-(void) setupThumbnailReceiver
{
    NSString* key = [NSString stringWithFormat:@"%d",self.hash];
    id ob = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_GET_THUMBNAIL object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary* dict = note.userInfo;
        NSData* data = [dict valueForKey:@"data"];
        NSString* receiptId = [dict valueForKey:@"id"];
        
       
        Receipt* receipt = [[IWDReceiptDataBank sharedInstance].viewToReceipts valueForKey:key];
        
        if( [receiptId isEqual:receipt.receiptId] ) {
            [self loadImageNamed:data quality:0 receiptId:receiptId];
        }
    }];
    [[IWDReceiptDataBank sharedInstance].viewToObservers setValue:ob forKey:key];
}

-(void) setupPreviewReceiver
{
    NSString* key = [NSString stringWithFormat:@"%d",self.hash];
    id ob = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_GET_PREVIEW object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary* dict = note.userInfo;
        NSData* data = [dict valueForKey:@"data"];
        NSString* receiptId = [dict valueForKey:@"id"];
        Receipt* receipt = [[IWDReceiptDataBank sharedInstance].viewToReceipts valueForKey:key];
        
        if( [receiptId isEqual:receipt.receiptId] ) {
            [self loadImageNamed:data quality:1 receiptId:receiptId];
        }
    }];
    [[IWDReceiptDataBank sharedInstance].viewToObservers setValue:ob forKey:key];
}

-(void) setupFullSourceReceiver
{
    NSString* key = [NSString stringWithFormat:@"%d",self.hash];
    id ob = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_GET_FULL_SOURCE object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary* dict = note.userInfo;
        NSData* data = [dict valueForKey:@"data"];
        NSString* receiptId = [dict valueForKey:@"id"];
        
        Receipt* receipt = [[IWDReceiptDataBank sharedInstance].viewToReceipts valueForKey:key];
        
        if( [receiptId isEqual:receipt.receiptId] ) {
            [self loadImageNamed:data quality:2 receiptId:receiptId];
        }
    }];
    [[IWDReceiptDataBank sharedInstance].viewToObservers setValue:ob forKey:key];
}

-(void)dealloc
{
    NSString* key = [NSString stringWithFormat:@"%d",self.hash];
    [[IWDReceiptDataBank sharedInstance].viewToObservers removeObjectForKey:key];
}

-(void) setReceipt:(Receipt *)receipt
{
    NSString* key = [NSString stringWithFormat:@"%d",self.hash];
    [[IWDReceiptDataBank sharedInstance].viewToReceipts setValue:receipt forKey:key];
}

-(void) loadThumbnail
{
    NSString* key = [NSString stringWithFormat:@"%d",self.hash];
    Receipt* receipt = [[IWDReceiptDataBank sharedInstance].viewToReceipts valueForKey:key];
    UIImage* image = [[IWDReceiptDataBank sharedInstance].thumbnailImageCache objectForKey:receipt.receiptId];
    if( image == nil ) {
        [[IWDReceiptDataBank sharedInstance] getThumbnailWithReceiptId:receipt];
    } else {
        self.image = image;
    }
}

-(void) loadPreview
{
    NSString* key = [NSString stringWithFormat:@"%d",self.hash];
    Receipt* receipt = [[IWDReceiptDataBank sharedInstance].viewToReceipts valueForKey:key];
    UIImage* image = [[IWDReceiptDataBank sharedInstance].previewImageCache objectForKey:receipt.receiptId];
    if( image == nil) {
        [[IWDReceiptDataBank sharedInstance] getPreviewWithReceiptId:receipt];
    } else {
        self.image = image;
    }    
}

-(void) loadFullSource
{
    NSString* key = [NSString stringWithFormat:@"%d",self.hash];
    Receipt* receipt = [[IWDReceiptDataBank sharedInstance].viewToReceipts valueForKey:key];
    [[IWDReceiptDataBank sharedInstance] getFullSourceWithReceiptId:receipt];

}

- (void)loadImageNamed:(NSData *)data quality:(NSInteger)quality receiptId:(NSString*)receiptId{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *imageData = data;
        CGImageRef decompressedImage = NULL;
        if (imageData) {
            CGDataProviderRef imageDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData);
            CGImageRef image = CGImageCreateWithJPEGDataProvider(imageDataProvider, NULL, NO, kCGRenderingIntentDefault);
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
                if( quality == 0 ) {
                    [[IWDReceiptDataBank sharedInstance].thumbnailImageCache setObject:image forKey:receiptId];
                     self.alpha = 0;
                    [UIView animateWithDuration:0.12 animations:^{
                        self.alpha = 1;
                    }];
                } else if( quality == 1) {
                    [[IWDReceiptDataBank sharedInstance].previewImageCache setObject:image forKey:receiptId];
                    self.alpha = 0;
                    [UIView animateWithDuration:0.12 animations:^{
                        self.alpha = 1;
                    }];
                }
               
            }
        });
        
        if (decompressedImage) {
            CGImageRelease(decompressedImage);
        }
    });
}


@end
