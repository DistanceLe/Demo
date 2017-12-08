//
//  LJFilterConst.m
//  CIImageDemo
//
//  Created by LiJie on 2017/3/30.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "LJFilterConst.h"

#pragma mark - ================ CICategoryDistortionEffect(distortion 扭曲, 失真) ==================
/**  (bump 肿块，隆起) -> inputCenter, inputImage, inputRadius, inputScale*/
NSString *const LJCIBumpDistortion = @"CIBumpDistortion";
/**  inputAngle, inputCenter inputImage  inputRadius  inputScale */
NSString *const LJCIBumpDistortionLinear = @"CIBumpDistortionLinear";
/**  (splash 斑点)inputCenter inputImage  inputRadius*/
NSString *const LJCICircleSplashDistortion = @"CICircleSplashDistortion";
/**  (circularWrap 环形包) inputAngle  inputCenter inputImage  inputRadius*/
NSString *const LJCICircularWrap = @"CICircularWrap";//iOS 9
/**  (displacement 代替 置换） inputDisplacementImage inputImage inputScale*/
NSString *const LJCIDisplacementDistortion = @"CIDisplacementDistortion";//iOS 9
/**  (droste德罗斯特，一种递归的视觉形式)  inputImage  inputInsetPoint0  inputInsetPoint1  inputPeriodicity(周期数)  inputRotation  inputStrands  inputZoom*/
NSString *const LJCIDroste = @"CIDroste";//iOS 9
/**  (glass 玻璃 inputImage  inputTexture(CIImage) inputCenter  inputScale) */
NSString *const LJCIGlassDistortion = @"CIGlassDistortion";//iOS 8
/**  (lozenge 菱形玻璃) inputImage   inputPoint0   inputPoint1  inputRadius inputRefraction(折射) */
NSString *const LJCIGlassLozenge = @"CIGlassLozenge";//iOS 9
/**  (hole孔 洞) inputImage  inputCenter  inputRadius */
NSString *const LJCIHoleDistortion = @"CIHoleDistortion";
/**  (tunnel 时光隧道) inputImage  inputCenter   inputRotation  inputRadius*/
NSString *const LJCILightTunnel = @"CILightTunnel";
/**  (stretch拉伸) inputBreakpoint0   inputBreakpoint1  inputGrowAmount  inputImage */
NSString *const LJCINinePartStretched = @"CINinePartStretched";//iOS 10
/**  (tiled 平铺) inputBreakpoint0  inputBreakpoint1  inputFlipYTiles  inputGrowAmount(CIVector[100 100]) inputImage*/
NSString *const LJCINinePartTiled = @"CINinePartTiled";//iOS 10
/**  (pinch 捏)  inputImage inputCenter  inputRadius  inputScale */
NSString *const LJCIPinchDistortion = @"CIPinchDistortion";
/**  拉伸修剪  inputImage inputSize inputCropAmount inputCenterStretchAmount */
NSString *const LJCIStretchCrop = @"CIStretchCrop";//iOS 9
/**  (torus lens 圆环透镜) inputImage  inputCenter  inputRadius  inputWidth  inputRefraction */
NSString *const LJCITorusLensDistortion = @"CITorusLensDistortion";//iOS 9
/**  (twirl 螺旋)   inputImage  inputCenter  inputRadius  inputAngle */
NSString *const LJCITwirlDistortion = @"CITwirlDistortion";
/**  (vortex 涡流) inputImage   inputCenter  inputRadius  inputAngle*/
NSString *const LJCIVortexDistortion = @"CIVortexDistortion";


#pragma mark - ================ CICategoryGeometryAdjustment(几何 调整) ==================
/**  仿射变换 inputImage   inputTransform(NSValue) */
NSString *const LJCIAffineTransform = @"CIAffineTransform";
/**  修剪 inputImage  inputRectangle (CIVector[0 0 300 300]) */
NSString *const LJCICrop = @"CICrop";
/**  (lanczos算法：对称矩阵 -> 对称三对角矩阵) inputImage   inputScale inputAspectRatio */
NSString *const LJCILanczosScaleTransform = @"CILanczosScaleTransform";
/**  透视 反转纠正，(四个点)inputImage  inputTopLeft  inputTopRight inputBottomRight inputBottomLeft */
NSString *const LJCIPerspectiveCorrection = @"CIPerspectiveCorrection";//iOS 8
/**  inputImage inputTopLeft  inputTopRight inputBottomRight inputBottomLeft */
NSString *const LJCIPerspectiveTransform = @"CIPerspectiveTransform";
/**  inputExtent(CIAttributeTypeRectangle[0 0 300 300]) inputImage inputTopLeft  inputTopRight inputBottomRight inputBottomLeft */
NSString *const LJCIPerspectiveTransformWithExtent = @"CIPerspectiveTransformWithExtent";
/**  (straighten 变直) inputImage  inputAngle */
NSString *const LJCIStraightenFilter = @"CIStraightenFilter";


#pragma mark - ================ CICategoryCompositeOperation(合成操作) ==================
/**  添加混合 inputImage  inputBackgroundImage */
NSString *const LJCIAdditionCompositing = @"CIAdditionCompositing";
/**  颜色混合   */
NSString *const LJCIColorBlendMode = @"CIColorBlendMode";
/**  颜色灼烧混合  */
NSString *const LJCIColorBurnBlendMode = @"CIColorBurnBlendMode";
/**  dodge 避开 */
NSString *const LJCIColorDodgeBlendMode = @"CIColorDodgeBlendMode";
/**  模糊 变黑  */
NSString *const LJCIDarkenBlendMode = @"CIDarkenBlendMode";
/**  不同 */
NSString *const LJCIDifferenceBlendMode = @"CIDifferenceBlendMode";
/**  分开  */
NSString *const LJCIDivideBlendMode = @"CIDivideBlendMode";
/**  exclusion排除 */
NSString *const LJCIExclusionBlendMode = @"CIExclusionBlendMode";
/**  硬光 */
NSString *const LJCIHardLightBlendMode = @"CIHardLightBlendMode";
/**  hue 色度 */
NSString *const LJCIHueBlendMode = @"CIHueBlendMode";
/**  明亮 */
NSString *const LJCILightenBlendMode = @"CILightenBlendMode";
/**  线性灼烧 */
NSString *const LJCILinearBurnBlendMode = @"CILinearBurnBlendMode";
/**  线性 避开 */
NSString *const LJCILinearDodgeBlendMode = @"CILinearDodgeBlendMode";
/**  luminosity 亮度 */
NSString *const LJCILuminosityBlendMode = @"CILuminosityBlendMode";
/**  最大 */
NSString *const LJCIMaximumCompositing = @"CIMaximumCompositing";
/**  最小 取最小的那一张图片 */
NSString *const LJCIMinimumCompositing = @"CIMinimumCompositing";
/**  增加，乘 */
NSString *const LJCIMultiplyBlendMode = @"CIMultiplyBlendMode";
/**  叠加合成 保留一张 */
NSString *const LJCIMultiplyCompositing = @"CIMultiplyCompositing";
/**  覆盖 */
NSString *const LJCIOverlayBlendMode = @"CIOverlayBlendMode";
/**  针 */
NSString *const LJCIPinLightBlendMode = @"CIPinLightBlendMode";
/**  saturation 饱和 */
NSString *const LJCISaturationBlendMode = @"CISaturationBlendMode";
/**  屏 */
NSString *const LJCIScreenBlendMode = @"CIScreenBlendMode";
/**  柔光 */
NSString *const LJCISoftLightBlendMode = @"CISoftLightBlendMode";
/**  直接覆盖，不混合 */
NSString *const LJCISourceAtopCompositing = @"CISourceAtopCompositing";
/**  保留重叠部分，且不混合 */
NSString *const LJCISourceInCompositing = @"CISourceInCompositing";
/**  去除重叠部分，不混合 */
NSString *const LJCISourceOutCompositing = @"CISourceOutCompositing";
/**  直接覆盖，不混合 */
NSString *const LJCISourceOverCompositing = @"CISourceOverCompositing";
/**  减去 相同的颜色 */
NSString *const LJCISubtractBlendMode = @"CISubtractBlendMode";//iOS 8


#pragma mark - ================ CICategoryHalftoneEffect(中间色) ==================
/**  圆形半色调屏幕 inputImage  inputCenter  inputWidth  inputSharpness(锐度) */
NSString *const LJCICircularScreen = @"CICircularScreen";
/**  inputImage  inputCenter  inputWidth  inputAngle   inputSharpness  inputGCR  inputUCR */
NSString *const LJCICMYKHalftone = @"CICMYKHalftone";//iOS 9
/**  inputImage  inputCenter  inputAngle  inputWidth  inputSharpness */
NSString *const LJCIDotScreen = @"CIDotScreen";
/**  hatched 影线 inputImage  inputCenter  inputAngle  inputWidth  inputSharpness */
NSString *const LJCIHatchedScreen = @"CIHatchedScreen";
/**  inputImage  inputCenter  inputAngle  inputWidth  inputSharpness */
NSString *const LJCILineScreen = @"CILineScreen";
