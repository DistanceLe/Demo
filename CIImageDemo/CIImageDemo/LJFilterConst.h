//
//  LJFilterConst.h
//  CIImageDemo
//
//  Created by LiJie on 2017/3/30.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <Foundation/Foundation.h>

/**  
 inputCenter -> CIVector
 inputPoint -> CIVector
 inputSize -> CIVector
 inputTexture -> CIImage
 */


#pragma mark - ================ CICategoryDistortionEffect(distortion 扭曲, 失真) ==================
/**  (bump 肿块，隆起) -> inputCenter, inputImage, inputRadius, inputScale*/
UIKIT_EXTERN NSString *const LJCIBumpDistortion;
/**  inputAngle, inputCenter inputImage  inputRadius  inputScale */
UIKIT_EXTERN NSString *const LJCIBumpDistortionLinear;
/**  (splash 斑点)inputCenter inputImage  inputRadius*/
UIKIT_EXTERN NSString *const LJCICircleSplashDistortion;
/**  (circularWrap 环形包) inputAngle  inputCenter inputImage  inputRadius*/
UIKIT_EXTERN NSString *const LJCICircularWrap;//iOS 9
/**  (displacement 代替 置换） inputDisplacementImage inputImage inputScale*/
UIKIT_EXTERN NSString *const LJCIDisplacementDistortion;//iOS 9
/**  (droste德罗斯特，一种递归的视觉形式)  inputImage  inputInsetPoint0  inputInsetPoint1  inputPeriodicity(周期数)  inputRotation  inputStrands  inputZoom*/
UIKIT_EXTERN NSString *const LJCIDroste;//iOS 9
/**  (glass 玻璃 inputImage  inputTexture(CIImage) inputCenter  inputScale) */
UIKIT_EXTERN NSString *const LJCIGlassDistortion;//iOS 8
/**  (lozenge 菱形玻璃) inputImage   inputPoint0   inputPoint1  inputRadius inputRefraction(折射) */
UIKIT_EXTERN NSString *const LJCIGlassLozenge;//iOS 9
/**  (hole孔 洞) inputImage  inputCenter  inputRadius */
UIKIT_EXTERN NSString *const LJCIHoleDistortion;
/**  (tunnel 时光隧道) inputImage  inputCenter   inputRotation  inputRadius*/
UIKIT_EXTERN NSString *const LJCILightTunnel;
/**  (stretch拉伸) inputBreakpoint0   inputBreakpoint1  inputGrowAmount  inputImage */
UIKIT_EXTERN NSString *const LJCINinePartStretched;//iOS 10
/**  (tiled 平铺) inputBreakpoint0  inputBreakpoint1  inputFlipYTiles  inputGrowAmount(CIVector[100 100]) inputImage*/
UIKIT_EXTERN NSString *const LJCINinePartTiled;//iOS 10
/**  (pinch 捏)  inputImage inputCenter  inputRadius  inputScale */
UIKIT_EXTERN NSString *const LJCIPinchDistortion;
/**  拉伸修剪  inputImage inputSize inputCropAmount inputCenterStretchAmount */
UIKIT_EXTERN NSString *const LJCIStretchCrop;//iOS 9
/**  (torus lens 圆环透镜) inputImage  inputCenter  inputRadius  inputWidth  inputRefraction */
UIKIT_EXTERN NSString *const LJCITorusLensDistortion;//iOS 9
/**  (twirl 螺旋)   inputImage  inputCenter  inputRadius  inputAngle */
UIKIT_EXTERN NSString *const LJCITwirlDistortion;
/**  (vortex 涡流) inputImage   inputCenter  inputRadius  inputAngle*/
UIKIT_EXTERN NSString *const LJCIVortexDistortion;


#pragma mark - ================ CICategoryGeometryAdjustment(几何 调整) ==================
/**  仿射变换 inputImage   inputTransform(NSValue) */
UIKIT_EXTERN NSString *const LJCIAffineTransform;
/**  修剪 inputImage  inputRectangle (CIVector[0 0 300 300]) */
UIKIT_EXTERN NSString *const LJCICrop;
/**  (lanczos算法：对称矩阵 -> 对称三对角矩阵) inputImage   inputScale inputAspectRatio */
UIKIT_EXTERN NSString *const LJCILanczosScaleTransform;
/**  透视 反转纠正，(四个点)inputImage  inputTopLeft  inputTopRight inputBottomRight inputBottomLeft */
UIKIT_EXTERN NSString *const LJCIPerspectiveCorrection;//iOS 8
/**  inputImage inputTopLeft  inputTopRight inputBottomRight inputBottomLeft */
UIKIT_EXTERN NSString *const LJCIPerspectiveTransform;
/**  inputExtent(CIAttributeTypeRectangle[0 0 300 300]) inputImage inputTopLeft  inputTopRight inputBottomRight inputBottomLeft */
UIKIT_EXTERN NSString *const LJCIPerspectiveTransformWithExtent;
/**  (straighten 变直) inputImage  inputAngle */
UIKIT_EXTERN NSString *const LJCIStraightenFilter;


#pragma mark - ================ CICategoryCompositeOperation(合成操作) ==================
/**  添加混合 inputImage  inputBackgroundImage */
UIKIT_EXTERN NSString *const LJCIAdditionCompositing;
/**  颜色混合   */
UIKIT_EXTERN NSString *const LJCIColorBlendMode;
/**  颜色灼烧混合  */
UIKIT_EXTERN NSString *const LJCIColorBurnBlendMode;
/**  dodge 避开 */
UIKIT_EXTERN NSString *const LJCIColorDodgeBlendMode;
/**  模糊 变黑  */
UIKIT_EXTERN NSString *const LJCIDarkenBlendMode;
/**  不同 */
UIKIT_EXTERN NSString *const LJCIDifferenceBlendMode;
/**  分开  */
UIKIT_EXTERN NSString *const LJCIDivideBlendMode;
/**  exclusion排除 */
UIKIT_EXTERN NSString *const LJCIExclusionBlendMode;
/**  硬光 */
UIKIT_EXTERN NSString *const LJCIHardLightBlendMode;
/**  hue 色度 */
UIKIT_EXTERN NSString *const LJCIHueBlendMode;
/**  明亮 */
UIKIT_EXTERN NSString *const LJCILightenBlendMode;
/**  线性灼烧 */
UIKIT_EXTERN NSString *const LJCILinearBurnBlendMode;
/**  线性 避开 */
UIKIT_EXTERN NSString *const LJCILinearDodgeBlendMode;
/**  luminosity 亮度 */
UIKIT_EXTERN NSString *const LJCILuminosityBlendMode;
/**  最大 */
UIKIT_EXTERN NSString *const LJCIMaximumCompositing;
/**  最小 取最小的那一张图片 */
UIKIT_EXTERN NSString *const LJCIMinimumCompositing;
/**  增加，乘 */
UIKIT_EXTERN NSString *const LJCIMultiplyBlendMode;
/**  叠加合成 保留一张 */
UIKIT_EXTERN NSString *const LJCIMultiplyCompositing;
/**  覆盖 */
UIKIT_EXTERN NSString *const LJCIOverlayBlendMode;
/**  针 */
UIKIT_EXTERN NSString *const LJCIPinLightBlendMode;
/**  saturation 饱和 */
UIKIT_EXTERN NSString *const LJCISaturationBlendMode;
/**  屏 */
UIKIT_EXTERN NSString *const LJCIScreenBlendMode;
/**  柔光 */
UIKIT_EXTERN NSString *const LJCISoftLightBlendMode;
/**  直接覆盖，不混合 */
UIKIT_EXTERN NSString *const LJCISourceAtopCompositing;
/**  保留重叠部分，且不混合 */
UIKIT_EXTERN NSString *const LJCISourceInCompositing;
/**  去除重叠部分，不混合 */
UIKIT_EXTERN NSString *const LJCISourceOutCompositing;
/**  直接覆盖，不混合 */
UIKIT_EXTERN NSString *const LJCISourceOverCompositing;
/**  减去 相同的颜色 */
UIKIT_EXTERN NSString *const LJCISubtractBlendMode;//iOS 8


#pragma mark - ================ CICategoryHalftoneEffect(中间色) ==================
/**  圆形半色调屏幕 inputImage  inputCenter  inputWidth  inputSharpness(锐度) */
UIKIT_EXTERN NSString *const LJCICircularScreen;
/**  inputImage  inputCenter  inputWidth  inputAngle   inputSharpness  inputGCR  inputUCR */
UIKIT_EXTERN NSString *const LJCICMYKHalftone;//iOS 9
/**  inputImage  inputCenter  inputAngle  inputWidth  inputSharpness */
UIKIT_EXTERN NSString *const LJCIDotScreen;
/**  hatched 影线 inputImage  inputCenter  inputAngle  inputWidth  inputSharpness */
UIKIT_EXTERN NSString *const LJCIHatchedScreen;
/**  inputImage  inputCenter  inputAngle  inputWidth  inputSharpness */
UIKIT_EXTERN NSString *const LJCILineScreen;


#pragma mark - ================ CICategoryColorAdjustment(颜色调节) ==================
///**  <#Description#> */
//UIKIT_EXTERN NSString *const LJ
