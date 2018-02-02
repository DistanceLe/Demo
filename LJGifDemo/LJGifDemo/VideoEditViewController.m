//
//  VideoEditViewController.m
//  LJGifDemo
//
//  Created by LiJie on 2018/1/31.
//  Copyright © 2018年 LiJie. All rights reserved.
//

#import "VideoEditViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "VideoFrameCell.h"

#import "LJGif.h"
#import "LJPhotoOperational.h"
#import "YYCache.h"

@interface VideoEditViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;//主图片

@property (weak, nonatomic) IBOutlet UIImageView *indexImageView;//手势操纵的 指针图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexCenterConstraint;//指针图片 的中心
@property (weak, nonatomic) IBOutlet UIView *panView;//手势添加的视图


@property (weak, nonatomic) IBOutlet UICollectionView *frameCollectionView;//每一秒的首帧


/**  每一秒最前的帧的图片 */
//@property (nonatomic, strong)NSMutableDictionary* frameImages;//每一秒的首帧
//@property (nonatomic, strong)NSMutableDictionary* allImages;//所有的帧图片
//@property (nonatomic, strong)NSMutableDictionary* frameIndexs;//

@property (nonatomic, strong)YYCache* imageCache;

/**  帧率， 每秒多少针  一般 25帧 或者 30帧 */
@property (nonatomic, assign)NSInteger fps;
/**  视频的长度，单位秒 */
@property (nonatomic, assign)CGFloat videoDuration;

@property (nonatomic, strong)NSURL* videoURL;

/**  index的偏移值 */
@property (nonatomic, assign)CGFloat gestureOffset;
@property (nonatomic, assign)CGFloat beginIndexOffset;
@property (nonatomic, assign)CGFloat shouldIndexOffset;
@property (nonatomic, assign)CGFloat scrollOffset;

@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
    [self initUI];
}
-(void)dealloc{
    DLog(@"dealloc Viedo edit");
}
-(void)initData{
    self.videoURL = [[LJPhotoOperational shareOperational]getOriginDataURLPathWithFileName:self.videoName];
//    UIImage* frameIamge = [LJGif getVideoPreViewImageWithURL:self.videoURL];
    
//    self.frameImages = [NSMutableDictionary dictionary];
//    self.allImages = [NSMutableDictionary dictionary];
//    self.frameIndexs = [NSMutableDictionary dictionary];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
    
    //帧率， 每秒多少针  一般 25帧 或者 30帧
    self.fps = (NSInteger)[[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
    
    CMTime duration = asset.duration;
    //视频的长度，单位秒
    self.videoDuration = duration.value*1.0f/duration.timescale;
    
    DLog(@"fps:%ld   duration time:%.2f value:%lld timescales:%d", self.fps, self.videoDuration, duration.value, duration.timescale );
    
    [ProgressHUD show:@"视频处理中..." autoStop:NO];
    
    CGFloat frameTime = 1.0/self.fps;
    
    self.imageCache = [YYCache cacheWithName:self.videoName];
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    
    for (NSInteger i = 0; i < 4000; i++) {
        CGFloat currentTime = i*frameTime;
        if (currentTime > self.videoDuration) {
            break;
        }
        /**  即 一秒最多 100帧， 保留两位小数 */
        NSString* timeStr = [NSString stringWithFormat:@"%.2f", currentTime];
        DLog(@"循环 %@", timeStr);
        if ([self.imageCache.diskCache containsObjectForKey:timeStr]) {
            if ([timeStr floatValue]>=self.videoDuration ||
                [timeStr floatValue]+(1.0/self.fps) > self.videoDuration ||
                [timeStr floatValue]+0.01 > self.videoDuration ||
                i==4000) {
                DLog(@"完成：%@ ✌️", timeStr);
                self.contentImageView.image = (UIImage*)[self.imageCache.diskCache objectForKey:@"0.00"];
                [ProgressHUD dismiss];
                [self.frameCollectionView reloadData];
                break;
            }
        }else{
            [LJGif getVideoFrameAsyncWithGenerator:assetImageGenerator atTime:currentTime complete:^(UIImage *image) {
                DLog(@"得到图片 %@", timeStr);
                [self.imageCache.diskCache setObject:image forKey:timeStr];
                self.contentImageView.image = image;
                if ([timeStr floatValue]>=self.videoDuration || [timeStr floatValue]+(1.0/self.fps) > self.videoDuration || i==4000) {
                    DLog(@"完成：%@ ✌️", timeStr);
                    self.contentImageView.image = (UIImage*)[self.imageCache.diskCache objectForKey:@"0.00"];
                    [ProgressHUD dismiss];
                    [self.frameCollectionView reloadData];
                }
            }];
        }
    }
}

-(void)initUI{
    
    [self setIndexImageLocationOffset:-(IPHONE_WIDTH/2.0-20) animation:1];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandler:)];
    [self.panView addGestureRecognizer:panGesture];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(60, 60);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.frameCollectionView.delegate = self;
    self.frameCollectionView.dataSource = self;
    self.frameCollectionView.collectionViewLayout = layout;
    [self.frameCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoFrameCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentify];
    [self.frameCollectionView reloadData];
}

/**  指标的图片位置  offset表示 图片对于屏幕左右移动的偏移 正负*/
-(void)setIndexImageLocationOffset:(CGFloat)offset animation:(CGFloat)animation{
    
    CGFloat totalLength = IPHONE_WIDTH - 40;
    //CGFloat perLength= totalLength/100.0f;
    
    CGFloat minimOffset = -totalLength/2.0;
    
    offset = (offset<minimOffset?minimOffset:offset);
    offset = (offset>-minimOffset?-minimOffset:offset);
    
    [UIView animateWithDuration:animation animations:^{
        self.indexCenterConstraint.constant = offset;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)stepperClick:(UIStepper *)sender {
    
    
}

- (IBAction)saveToAlbum:(UIButton *)sender {
    
    
}

- (IBAction)saveToMainPage:(UIButton *)sender {
    
    
}

-(void)refreshFrame{
    CGFloat currentIndex = (self.indexCenterConstraint.constant + IPHONE_WIDTH/2.0 - 20)/60.0;
    CGFloat scrollOffsetIndex = self.scrollOffset/60.0;
    
    CGFloat currentFrameTime = currentIndex + scrollOffsetIndex;
    
    NSString* frameKey = [NSString stringWithFormat:@"%.2f", currentFrameTime];
//    if ([self.allImages valueForKey:frameKey]) {
//        DLog(@"refresh %@", frameKey);
//        self.contentImageView.image = [self.allImages valueForKey:frameKey];
//    }
    if ([self.imageCache.diskCache objectForKey:frameKey]) {
        DLog(@"refresh %@", frameKey);
        self.contentImageView.image = (UIImage*)[self.imageCache.diskCache objectForKey:frameKey];
    }
}

-(void)panGestureHandler:(UIPanGestureRecognizer*)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
        //手势开始
        CGPoint currentPoint = [pan locationInView:self.view];
        self.gestureOffset = currentPoint.x;
        self.beginIndexOffset = self.indexCenterConstraint.constant;
        self.shouldIndexOffset = self.indexCenterConstraint.constant;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        //手势改变
        CGPoint currentPoint = [pan locationInView:self.view];
        //手势开始 到现在的偏移X
        CGFloat offset = currentPoint.x - self.gestureOffset;
        
        CGFloat minFramOffset = 1.0f/self.fps;
        if (fabs(offset+self.beginIndexOffset - self.shouldIndexOffset) >= minFramOffset) {
            self.shouldIndexOffset = offset+self.beginIndexOffset;
            
            [self refreshFrame];
        }
        [self setIndexImageLocationOffset:offset+self.beginIndexOffset animation:0];
    }else if (pan.state > UIGestureRecognizerStateChanged){
        //手势结束
        
    }
}

#pragma mark - ================ Delegate ==================
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [@(self.videoDuration)integerValue]+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoFrameCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    
    if ([self.imageCache.diskCache containsObjectForKey:[NSString stringWithFormat:@"%.2f", @(indexPath.item).floatValue]]){
        cell.contentImageView.image = (UIImage*)[self.imageCache.diskCache objectForKey:[NSString stringWithFormat:@"%.2f", @(indexPath.item).floatValue]];
    }
    
    
//    if ([self.frameImages valueForKey:@(indexPath.item).stringValue]){
//        cell.contentImageView.image = [self.frameImages valueForKey:@(indexPath.item).stringValue];
//    }
//    else{
//        if (![self.frameIndexs valueForKey:@(indexPath.item).stringValue]) {
//            [LJGif getVideoFrameAsyncForVideo:self.videoURL atTime:indexPath.item complete:^(UIImage *image) {
//                if (image) {
//                    [self.frameImages setValue:image forKey:@(indexPath.item).stringValue];
//                    cell.contentImageView.image = image;
//                }else{
//                    [self.frameIndexs removeObjectForKey:@(indexPath.item).stringValue];
//                }
//            }];
//        }
//        [self.frameIndexs setValue:@"" forKey:@(indexPath.item).stringValue];
//    }
    return cell;
}

#pragma mark - ================ Scroll ==================
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    DLog(@"scroll...%.2f", self.scrollOffset);
    offsetX = (offsetX<0?0:offsetX);
    
    CGFloat minFramOffset = 1.0f/self.fps;
    if (fabs(offsetX - self.scrollOffset) >= minFramOffset) {
        self.scrollOffset = offsetX;
        [self refreshFrame];
    }
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    DLog(@"...memory 不够了");
}




@end
