//
//  GifGenerateViewController.m
//  LJGifDemo
//
//  Created by LiJie on 2017/12/21.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "GifGenerateViewController.h"

#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

#import "LJFileOperation.h"
#import "LJPhotoOperational.h"
#import "LJPHPhotoTools.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GifGenerateViewController ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UILabel *gifInfoLabel;
@property (nonatomic, strong)LJFileOperation* fileOperational;

@end

@implementation GifGenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.gifInfoLabel.text = @"图片尺寸:0*0\n图片大小:0MB";
    self.fileOperational = [LJFileOperation shareOperationWithDocument:@"gif"];
}

/**  生成Gif图片 */
- (IBAction)generateClick:(UIButton *)sender {
    [self makeAnimatedGif];
}

- (IBAction)saveToAlbum:(UIButton *)sender {
    
}

-(void)showGif{
    NSData* gifData = [self.fileOperational readObjectWithName:gifName];
    FLAnimatedImage* gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    if (gifImage) {
        self.gifImageView.animatedImage = gifImage;
        CGFloat sizeData = gifData.length/1024.0/1024.0;
        self.gifInfoLabel.text = [NSString stringWithFormat:@"图片尺寸:%.0f*%.0f\n图片大小:%.2fMB",gifImage.size.width, gifImage.size.height, sizeData];
    }else{
        self.gifInfoLabel.text = @"图片尺寸:0*0\n图片大小:0MB";
        self.gifImageView.animatedImage = nil;
    }
}

-(void)makeAnimatedGif{
    [ProgressHUD show:@"处理中..."];
    LJPhotoOperational* operational = [LJPhotoOperational shareOperational];
    
    NSUInteger kFrameCount = operational.imageNames.count;
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @(operational.roopTimes), // 0 means loop forever
                                             }
                                     };
    
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @(operational.frameInterval), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
    //NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
//    NSURL *documentsDirectoryURL = [NSURL URLWithString:[self.fileOperational readFilePath:gifName]];
//    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:gifName];
    
    NSURL *fileURL = [self.fileOperational getUrlFilePathComponent:gifName];
    
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (NSUInteger i = 0; i < kFrameCount; i++) {
        @autoreleasepool {
            //            UIImage *image = frameImage(CGSizeMake(300, 300), M_PI * 2 * i / kFrameCount);
            UIImage* image = [operational getOriginImageWithIndex:i];
            CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    NSLog(@"url=%@", fileURL);
    [self showGif];
    [ProgressHUD dismiss];
}










@end
