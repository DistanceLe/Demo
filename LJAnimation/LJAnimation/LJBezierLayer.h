//
//  LJBezierLayer.h
//  LJAnimation
//
//  Created by LiJie on 16/7/21.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface LJBezierLayer : CALayer

/**  三次方贝塞尔曲线 */
@property(nonatomic, assign)BOOL isCubeCurve;


/**  起始点 */
@property(nonatomic, assign)CGPoint beginPoint;

/**  终点 */
@property(nonatomic, assign)CGPoint endPoint;



/**  第一控制点 */
@property(nonatomic, assign)CGPoint firstPoint;

/**  第二控制点 */
@property(nonatomic, assign)CGPoint secondPoint;


@end
