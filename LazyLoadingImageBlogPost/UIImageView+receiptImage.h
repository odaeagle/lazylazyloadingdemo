//
//  UIView+receiptThumbnail.h
//  HelloReceipts
//
//  Created by Eagle Diao on 2/12/13.
//  Copyright (c) 2013 Intelliware Development Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"

@interface UIImageView (receiptThumbnail)

// @property (weak,nonatomic) Receipt* receipt;

-(void) setupThumbnailReceiver;
-(void) setupPreviewReceiver;
-(void) setupFullSourceReceiver;
-(void) setReceipt:(Receipt*) receipt;
-(void) loadThumbnail;
-(void) loadPreview;
-(void) loadFullSource;

@end
