//
//  LJGif.h
//  TestDemoString
//
//  Created by LiJie on 2017/12/14.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJGif : NSObject


+(UIImage*)getGifImage;

/**  根据视频的路径获取 某一帧 */
+(UIImage*)getVideoPreViewImageWithURL:(NSURL*)videoPath;

/**  根据视频的路径，一个时间点，获取 某一帧 */
+(UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end
