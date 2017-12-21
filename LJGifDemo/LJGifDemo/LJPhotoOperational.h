//
//  LJPhotoOperational.h
//  LJGifDemo
//
//  Created by LiJie on 2017/12/19.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJPhotoOperational : NSObject

/**  选中的所以图片名字，按顺序排列 */
@property(nonatomic, strong)NSMutableArray* imageNames;

/**  获取图片操作的单例 */
+(instancetype)shareOperational;

/**  根据图片名字获取 缩略图片 */
-(UIImage*)getImageWithIndex:(NSInteger)index;

/**  获取所有的 原图片 */
-(NSArray<UIImage*>*)getAllOriginImages;

/**  保持原始图片 */
-(void)saveOriginImageData:(id)data imageName:(NSString*)name;
/**  保存缩略图 */
-(void)saveThumbnailImageData:(id)data imageName:(NSString*)name;


/**  删除选中的图片 */
-(void)deleteImageWithName:(NSString*)name;
-(void)deleteImageWithIndex:(NSInteger)index;

/**  清空所以得图片 */
-(void)deleteAllImages;

@end
