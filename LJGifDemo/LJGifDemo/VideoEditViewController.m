//
//  VideoEditViewController.m
//  LJGifDemo
//
//  Created by LiJie on 2018/1/31.
//  Copyright © 2018年 LiJie. All rights reserved.
//

#import "VideoEditViewController.h"

#import "VideoFrameCell.h"

#import "LJGif.h"
#import "LJPhotoOperational.h"

@interface VideoEditViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *indexImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *frameCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexCenterConstraint;

@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSURL* videoPath = [[LJPhotoOperational shareOperational]getOriginDataURLPathWithFileName:self.videoName];
    UIImage* frameIamge = [LJGif getVideoPreViewImageWithURL:videoPath];
    self.contentImageView.image = frameIamge;
    //float fps = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
    
    [self initUI];
}

-(void)initUI{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(60, 60);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.frameCollectionView.delegate = self;
    self.frameCollectionView.dataSource = self;
    self.frameCollectionView.collectionViewLayout = layout;
    [self.frameCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoFrameCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentify];
}

- (IBAction)stepperClick:(UIStepper *)sender {
    
    
}

- (IBAction)saveToAlbum:(UIButton *)sender {
    
    
}

- (IBAction)saveToMainPage:(UIButton *)sender {
    
    
}

#pragma mark - ================ Delegate ==================
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoFrameCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    
    cell.contentImageView.image = [UIImage imageNamed:@"photoSelected"];
    return cell;
}




@end
