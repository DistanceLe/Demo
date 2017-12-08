//
//  LJFilterEffect.m
//  CIImageDemo
//
//  Created by LiJie on 2017/3/30.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "LJFilterEffect.h"

@implementation LJFilterEffect

/**  根据滤镜名 和 图片来初始化一个 滤镜 */
+(CIFilter*)getFilterWithName:(NSString*)filterName inputImage:(UIImage*)inputImage{
    CIFilter* filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, inputImage, nil];
    return filter;
}

/**  根据 滤镜来获取 图片 */
+(UIImage*)getImageFromFilter:(CIFilter*)filter{
    CIImage* outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef image = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage* returnImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    return returnImage;
}

/**  根据 滤镜来获取 CG图片 */
+(CGImageRef)getCGImageRefFromFilter:(CIFilter*)filter{
    CIImage* outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef image = [context createCGImage:outputImage fromRect:outputImage.extent];
    return image;
}

@end
