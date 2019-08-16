//
//  YSQRImageBuffer.m
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YSQRImageBuffer.h"

@implementation YSQRImageBuffer

+ (YSQRImageBuffer *)instance {
    static dispatch_once_t onceToken;
    static YSQRImageBuffer *once;
    dispatch_once(&onceToken, ^{
        once = [YSQRImageBuffer new];
    });
    return once;
}
//
//+ (NSData *)convertVideoSmapleBufferToYuvData:(CMSampleBufferRef)videoSample {
//    // 获取yuv数据
//    // 通过CMSampleBufferGetImageBuffer方法，获得CVImageBufferRef。
//    // 这里面就包含了yuv420(NV12)数据的指针
//    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(videoSample);
//    //表示开始操作数据
//    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//    //图像宽度（像素）
//    size_t pixelWidth = CVPixelBufferGetWidth(pixelBuffer);
//    //图像高度（像素）
//    size_t pixelHeight = CVPixelBufferGetHeight(pixelBuffer);
//    //yuv中的y所占字节数
//    size_t y_size = pixelWidth * pixelHeight;
//    //yuv中的uv所占的字节数
//    size_t uv_size = y_size / 2;
//    //    uint8_t *yuv_frame = malloc(uv_size + y_size);
//    //获取CVImageBufferRef中的y数据
//    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//    memcpy(y_frame, y_frame, y_size);
//    //获取CMVImageBufferRef中的uv数据
//    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
//    memcpy(uv_frame + uv_size, uv_frame, uv_size);
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
////    return uv_frame;
////    return [NSData dataWithBytesNoCopy:yuv_frame length:y_size + uv_size];
//    return [NSData dataWithBytesNoCopy:uv_frame length:uv_size];
//}


+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 1);

    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);

    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,1);

    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];

    // 释放Quartz image对象
    CGImageRelease(quartzImage);

    return image;
}

@end
