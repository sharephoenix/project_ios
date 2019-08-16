//
//  YSQRImageBuffer.h
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YSQRImageBuffer : NSObject
+ (YSQRImageBuffer *)instance;

//+ (NSData *)convertVideoSmapleBufferToYuvData:(CMSampleBufferRef)videoSample;
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

