//
//  ViewController.m
//  CIImageDemo
//
//  Created by LiJie on 2017/1/12.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import <Accelerate/Accelerate.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *originImageView;
@property (weak, nonatomic) IBOutlet UIImageView *currentImageView;

@end

@implementation ViewController


/** ========= 性能与选择 =========
 在真正使用的时候，如果要考虑到性能，最好用vImage (#import <Accelerate/Accelerate.h>)；
 否则可以用GPUImage，因为性能比Core Image好，功能也全面；
 如果是ios8，那么最好使用UIVisualEffectView来完成 */

- (void)viewDidLoad {
    [super viewDidLoad];
//    kCIAttributeTypeDistance
//    [self getResource];
    
//    [self visualEffectViewResult];
//    self.currentImageView.image = [self blurryImage:self.originImageView.image withBlurLevel:0.3];
//    [self setGaussianBlur];
    [self test];
}

/**  使用UIVisualEffectView来完成IOS中滤镜效果（ios8以上版本） */
-(void)visualEffectViewResult{
    
    self.currentImageView.image = self.originImageView.image;
    //设置模糊，效果为BlurEffectStyleLight
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIVisualEffectView *ruVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        ruVisualEffectView.frame = self.currentImageView.bounds;
        ruVisualEffectView.alpha = 0.9;
        [self.currentImageView addSubview:ruVisualEffectView];
    });
}

/**  使用vImage API来完成IOS中滤镜效果 ,image:原图片， blur:模糊度*/
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    /**  
     Accelerate这个framework主要是用来做数字信号处理、图像处理相关的向量、矩阵运算的库。
     我们可以认为我们的图像都是由向量或者矩阵数据构成的，Accelerate里既然提供了高效的数学运算API，
     自然就能方便我们对图像做各种各样的处理 */
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }//判断曝光度
    int boxSize = (int)(blur * 100);//放大100，就是小数点之后两位有效
    boxSize = boxSize - (boxSize % 2) + 1;//如果是偶数，+1，变奇数
    
    CGImageRef img = image.CGImage;//获取图片指针
    
    vImage_Buffer inBuffer, outBuffer;//获取缓冲区
    vImage_Error error;//一个错误类，在后调用画图函数的时候要用
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);//放回一个图片供应者信息
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);//拷贝数据，并转化
    
    inBuffer.width = CGImageGetWidth(img);//放回位图的宽度
    inBuffer.height = CGImageGetHeight(img);//放回位图的高度
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);//放回位图的
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);//填写图片信息
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));//创建一个空间
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,//这个数一定要是奇数的，因此我们一开始的时候需要转化
                                       boxSize,//这个数一定要是奇数的，因此我们一开始的时候需要转化
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //将刚刚得出的数据，画出来。
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    
    
    return returnImage;
}

/**  毛玻璃 */
-(void)setGaussianBlur{
    //获取毛玻璃图片
    CIImage* inputImage = [CIImage imageWithCGImage:self.originImageView.image.CGImage];
    //获取滤镜，并设置（使用KVO键值输入）
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage, @"inputRadius", @1.0f, nil];
    //从滤镜中获取图片
    CIImage *result = filter.outputImage;
    self.currentImageView.image = [UIImage imageWithCIImage:result];
    //将图片添加到filterImageView上
    //self.filterImageView.image = filterImage;
}

-(void)test{
    
    //1、输入的源图 ->  先得到CGImage -> 再得到CIImage
    CIImage* inputImage = [CIImage imageWithCGImage:self.originImageView.image.CGImage];
    
    //   2、添加滤镜 ，以及设置滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    //    kCIInputImageKey -> 通过 打印可以设置的属性里面 得到可以设置  inputImage -> 在接口文件里面 查找得到一个KEY
    [filter setValue:inputImage forKey:kCIInputImageKey];
    //  通过查询的属性设置滤镜
    [filter setValue:[[CIColor alloc] initWithColor:[UIColor colorWithRed:0.472 green:1.000 blue:0.197 alpha:1.000]] forKey:kCIInputColorKey];
    
    [filter setValue:@0.5 forKey:kCIInputIntensityKey];
    
    //  3、CIContext 图像上下文,合并成一个包含原图 和滤镜效果的图像
    //    image -> 滤镜输出的图像
    //   fromRect -> 合成之后图像的尺寸 ： 图像.extent
    CIImage *outPutImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef image = [context createCGImage:outPutImage fromRect:outPutImage.extent];
    _currentImageView.image = [UIImage imageWithCGImage:image];
    ;
    
    CGImageRelease(image);
}

/**  滤镜链的使用 */
- (void)addFilterLinkerWithImage:(CIImage *)image{
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    
    [filter setValue:image forKey:kCIInputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef resultImage = [context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    _currentImageView.image = [UIImage imageWithCGImage:resultImage];
    //   把添加好滤镜效果的图片 保存到相册  不可以直接保存 outPutImage -> 这是一个没有把滤镜效果和原图合成的图像
    UIImageWriteToSavedPhotosAlbum(_currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    CGImageRelease(resultImage);
}
//保存照片的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
}


/**  在第一次添加滤镜的方法里调用这个方法，并且不创建图像上下文的对象 */
- (void)addColorFilter{
    
    //    1、源图
    CIImage *inputImage = [CIImage imageWithCGImage:_originImageView.image.CGImage];
    
    //    2、滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    
    [filter setValue:[[CIColor alloc] initWithColor:[UIColor colorWithRed:0.472 green:1.000 blue:0.197 alpha:1.000]] forKey:kCIInputColorKey];
    
    [filter setValue:@0.5 forKey:kCIInputIntensityKey];
    //
    [filter setValue:inputImage forKey:kCIInputImageKey];
    NSLog(@"%@",filter.attributes);
    
    
    //   3、CIContext 图像上下文
    
    CIImage *outPutImage = filter.outputImage;
    [self addFilterLinkerWithImage:outPutImage];
}










#pragma mark - ================ 获取所有的分类，及其所有的滤镜 ==================
-(void)getResource{
    
    /**  
     kCICategoryDistortionEffect 扭曲效果，比如bump、旋转、hole
     kCICategoryGeometryAdjustment 几何开着调整，比如仿射变换、平切、透视转换
     kCICategoryCompositeOperation 合并，比如源覆盖（source over）、最小化、源在顶（source atop）、色彩混合模式
     kCICategoryHalftoneEffect Halftone效果，比如screen、line screen、hatched
     kCICategoryColorAdjustment 色彩调整，比如伽马调整、白点调整、曝光
     kCICategoryColorEffect 色彩效果，比如色调调整、posterize
     kCICategoryTransition 图像间转换，比如dissolve、disintegrate with mask、swipe
     kCICategoryTileEffect 瓦片效果，比如parallelogram、triangle
     kCICategoryGenerator 图像生成器，比如stripes、constant color、checkerboard
     kCICategoryReduction NS_AVAILABLE(10_5, 5_0);
     kCICategoryGradient 渐变，比如轴向渐变、仿射渐变、高斯渐变
     kCICategoryStylize 风格化，比如像素化、水晶化
     kCICategorySharpen 锐化、发光
     kCICategoryBlur 模糊，比如高斯模糊、焦点模糊、运动模糊
     (2)按使用场景分类：
     kCICategoryStillImage 用于静态图像
     kCICategoryVideo 用于视频
     kCICategoryInterlaced 用于交错图像
     kCICategoryNonSquarePixels 用于非矩形像素
     kCICategoryHighDynamicRange 用于HDR 
     kCICategoryBuiltIn;
     kCICategoryFilterGenerator NS_AVAILABLE(10_5, 9_0);*/
    
    NSArray* categoryArray = @[kCICategoryDistortionEffect,     kCICategoryGeometryAdjustment,
                               kCICategoryCompositeOperation,   kCICategoryHalftoneEffect,
                               kCICategoryColorAdjustment,      kCICategoryColorEffect,
                               kCICategoryTransition,           kCICategoryTileEffect,
                               kCICategoryGenerator,            kCICategoryReduction,
                               kCICategoryGradient,             kCICategoryStylize,
                               kCICategorySharpen,              kCICategoryBlur,
                               kCICategoryStillImage,           kCICategoryVideo,
                               kCICategoryInterlaced,           kCICategoryNonSquarePixels,
                               kCICategoryHighDynamicRange,     kCICategoryBuiltIn,
                               kCICategoryFilterGenerator];
    for (NSString* categoryStr in categoryArray) {
        
        NSLog(@"\n=====%@+++++++++++\n", categoryStr);
        
        NSArray* filterNames = [CIFilter filterNamesInCategory:categoryStr];
        for (NSString* name in filterNames) {
            CIFilter *filter = [CIFilter filterWithName:name];
            NSLog(@"---%@\n~~~%@~~~~~~", name, filter.attributes);
        }
        
        
    }
}







@end
