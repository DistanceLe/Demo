//
//  LJPhotoAlbumDetailCollectionViewController.m
//  LJSecretMedia
//
//  Created by LiJie on 16/8/1.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "LJPhotoAlbumDetailCollectionViewController.h"

#import "LJPhotoCollectionViewCell.h"

#import "LJPHPhotoTools.h"
#import "LJImageTools.h"
#import "LJPhotoOperational.h"
#import "TimeTools.h"


@interface LJPhotoAlbumDetailCollectionViewController ()

@property(nonatomic, strong)NSArray* images;
@property(nonatomic, strong)NSMutableArray* selectedIndex;

@end

@implementation LJPhotoAlbumDetailCollectionViewController

/**  相册 详情，具体的所有相片 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)dealloc{
    DLog(@"detail dealloc");
}

-(void)initData{
    
    self.images=[LJPHPhotoTools getAssetsInCollection:self.collection];
    self.selectedIndex=[NSMutableArray array];
    for (NSInteger i=0; i<self.images.count; i++) {
        [self.selectedIndex addObject:@(NO)];
    }
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

-(void)initUI{
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LJPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self initData];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"确认选择" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)]];
}

-(void)rightClick{
    [ProgressHUD show:@"正在获取图片..." autoStop:NO];
    __block NSInteger index=0;
    for (NSNumber* obj in self.selectedIndex) {
        if ([obj boolValue]) {
            index++;
        }
    }
    __block long long timestamp = [TimeTools getCurrentTimestamp];
    [self.selectedIndex enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj boolValue]) {
            PHAsset* asset=self.images[idx];
            NSString* tempName = [@((timestamp++)) stringValue];
            DLog(@"tempName  == %@", tempName);
            
            //保存原始图片
            [LJPHPhotoTools getImageDataWithAsset:asset handler:^(NSData *imageData, NSString* imageName) {

                DLog(@"origin~~~~~~imageName=%@", tempName);
                UIImage* image = [UIImage imageWithData:imageData];
                imageData = UIImageJPEGRepresentation(image, 1);
                image = [LJImageTools changeImage:[UIImage imageWithData:imageData] toRatioSize:CGSizeMake(IPHONE_WIDTH*2, IPHONE_WIDTH*2)];
                
                [[LJPhotoOperational shareOperational]saveOriginImageData:image imageName:tempName];
            }];
//            [LJPHPhotoTools getImageWithAsset:asset imageSize:CGSizeMake(IPHONE_WIDTH*2, IPHONE_WIDTH*2) handler:^(UIImage *image) {
//                [[LJPhotoOperational shareOperational]saveOriginImageData:image imageName:tempName];
//            }];
            
            
            //保存缩略图
            [LJPHPhotoTools getThumbnailImagesWithAssets:@[asset] imageSize:CGSizeMake(IPHONE_WIDTH/1.5, IPHONE_WIDTH/1.5) handler:^(NSArray<UIImage*>* imageArray) {
                index--;
                DLog(@"thumbnail-----------------imageName=%@", tempName);
                [[LJPhotoOperational shareOperational]saveThumbnailImageData:imageArray.firstObject imageName:tempName];
                if (index==0) {//保存完成，发送通知，刷新首页面
                    [ProgressHUD dismiss];
                    [[NSNotificationCenter defaultCenter]postNotificationName:photoSavedName object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LJPhotoCollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PHAsset* sourceAsset = self.images[indexPath.item];
//    if (sourceAsset.duration > 0) {
//        cell.videoDurationTimeLabel.text = [TimeTools timestampChangeTimeStyle:sourceAsset.duration];
//        cell.videoDurationTimeLabel.hidden = NO;
//    }else{
//        cell.videoDurationTimeLabel.hidden = YES;
//    }
    cell.selectButton.hidden=NO;
    [LJPHPhotoTools getAsyncImageWithAsset:sourceAsset imageSize:CGSizeMake(IPHONE_WIDTH/1.5, IPHONE_WIDTH/1.5) handler:^(UIImage *image) {
        cell.headImageView.image=image;
    }];
    
    //判断是不是Gif图片
    [LJPHPhotoTools getImageDataWithAsset:sourceAsset handler:^(NSData *imageData, NSString* imageName) {
        //创建异步加载：
        dispatch_queue_t asyncQueue = dispatch_queue_create("asyncQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(asyncQueue, ^{
            BOOL isGif = [LJImageTools isGifImageWithData:imageData];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (isGif) {
                    cell.gifImageView.hidden = NO;
                    cell.selectButton.hidden = YES;
                }else{
                    cell.gifImageView.hidden = YES;
                    cell.selectButton.hidden = NO;
                }
            });
        });
    }];
    cell.selectButton.selected=[self.selectedIndex[indexPath.item] boolValue];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJPhotoCollectionViewCell* cell=(LJPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.selectButton.hidden) {
        return;
    }
    cell.selectButton.selected=!cell.selectButton.selected;
    [self.selectedIndex replaceObjectAtIndex:indexPath.item withObject:@(cell.selectButton.selected)];
}

@end
