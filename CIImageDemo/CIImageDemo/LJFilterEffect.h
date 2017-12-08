//
//  LJFilterEffect.h
//  CIImageDemo
//
//  Created by LiJie on 2017/3/30.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJFilterEffect : NSObject

/**  根据滤镜名 和 图片来初始化一个 滤镜 */
+(CIFilter*)getFilterWithName:(NSString*)filterName inputImage:(UIImage*)inputImage;

/**  根据 滤镜来获取 图片 */
+(UIImage*)getImageFromFilter:(CIFilter*)filter;

/**  根据 滤镜来获取 CG图片 */
+(CGImageRef)getCGImageRefFromFilter:(CIFilter*)filter;

@end
