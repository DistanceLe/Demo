//
//  LJGif.m
//  TestDemoString
//
//  Created by LiJie on 2017/12/14.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "LJGif.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@implementation LJGif

static void headData(void){
    //memoryStream = new MemoryStream();
    Byte buf2[19];
    Byte buf3[8];
    
    buf2[0] = 33;  //extension introducer
    buf2[1] = 255; //application extension
    buf2[2] = 11;  //size of block
    buf2[3] = 78;  //N
    buf2[4] = 69;  //E
    buf2[5] = 84;  //T
    buf2[6] = 83;  //S
    buf2[7] = 67;  //C
    buf2[8] = 65;  //A
    buf2[9] = 80;  //P
    buf2[10] = 69; //E
    buf2[11] = 50; //2
    buf2[12] = 46; //.
    buf2[13] = 48; //0
    buf2[14] = 3;  //Size of block
    buf2[15] = 1;  //
    buf2[16] = 0;  //
    buf2[17] = 0;  //
    buf2[18] = 0;  //Block terminator
    
    buf3[0] = 33;  //Extension introducer
    buf3[1] = 249; //Graphic control extension
    buf3[2] = 4;   //Size of block
    buf3[3] = 9;   //Flags: reserved, disposal method, user input, transparent color
    buf3[4] = 10;  //Delay time low byte
    buf3[5] = 3;   //Delay time high byte
    buf3[6] = 255; //Transparent color index
    buf3[7] = 0;   //Block terminator
}

+(UIImage *)getGifImage{
    
    makeAnimatedGif();
    return nil;
}

//static UIImage *frameImage(CGSize size, CGFloat radians) {
//    UIGraphicsBeginImageContextWithOptions(size, YES, 1); {
//        [[UIColor whiteColor] setFill];
//        UIRectFill(CGRectInfinite);
//        CGContextRef gc = UIGraphicsGetCurrentContext();
//        CGContextTranslateCTM(gc, size.width / 2, size.height / 2);
//        CGContextRotateCTM(gc, radians);
//        CGContextTranslateCTM(gc, size.width / 4, 0);
//        [[UIColor redColor] setFill];
//        CGFloat w = size.width / 10;
//        CGContextFillEllipseInRect(gc, CGRectMake(-w / 2, -w / 2, w, w));
//    }
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}

static void makeAnimatedGif(void) {
    static NSUInteger kFrameCount = 2;
//    NSArray* imageName = @[@"start1", @"end1", @"start2", @"end2"];
    NSArray* imageName = @[@"ren0", @"ren1"];
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @.35f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (NSUInteger i = 0; i < kFrameCount; i++) {
        @autoreleasepool {
//            UIImage *image = frameImage(CGSizeMake(300, 300), M_PI * 2 * i / kFrameCount);
            UIImage* image = [UIImage imageNamed:imageName[i]];
            CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    NSLog(@"url=%@", fileURL);
}






+(UIImage*)getVideoPreViewImageWithURL:(NSURL*)videoPath{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
//    gen.requestedTimeToleranceAfter = kCMTimeZero;
//    gen.requestedTimeToleranceBefore = kCMTimeZero;
    
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    CMTime time = kCMTimeZero;
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}


+(UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}




@end
