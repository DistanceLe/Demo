//
//  ViewController.m
//  LJGifDemo
//
//  Created by LiJie on 2017/12/15.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import "LJPhotoAlbumTableViewController.h"

#import "LJPhotoCollectionViewCell.h"


#import "LJPhotoOperational.h"

@interface ViewController ()
@property(weak, nonatomic) IBOutlet UIBarButtonItem *rightBar;

//@property(nonatomic, strong)UICollectionView* collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initUI];
    [self initData];
}

-(void)initData{
    @weakify(self);
    [[NSNotificationCenter defaultCenter]addObserverForName:photoSavedName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self refreshData];
    }];
}

-(void)initUI{
    
    UICollectionViewFlowLayout* layout=[[UICollectionViewFlowLayout alloc]init];
    NSInteger itemWidth=(IPHONE_WIDTH-9)/4;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
    
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LJPhotoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentify];
    
    
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBut setTitle:@"相册" forState:UIControlStateNormal];
    [rightBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    @weakify(self);
    [rightBut addTargetClickHandler:^(UIButton *but, id obj) {
        @strongify(self);
        LJPhotoAlbumTableViewController* albumVC = [[LJPhotoAlbumTableViewController alloc]init];
        [self.navigationController pushViewController:albumVC animated:YES];
    }];
    self.rightBar.customView = rightBut;
    
    
}

-(void)refreshData{
    [self.collectionView reloadData];
}

#pragma mark - ================ Delegate ==================
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [LJPhotoOperational shareOperational].imageNames.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJPhotoCollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    
    cell.headImageView.image=[[LJPhotoOperational shareOperational]getImageWithIndex:indexPath.item];
    cell.playImageView.hidden = YES;
    
    //@weakify(self);
    //[cell longTapGestureHandler:^(id sender, id status) {
        //@strongify(self);
        //[self deletePhotoIndex:indexPath.item];
    //}];
    cell.selectButton.hidden=YES;
    //cell.selectButton.selected=[self.selectedIndex[indexPath.item] boolValue];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.isEdit) {
//        LJPhotoCollectionViewCell* cell=(LJPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.selectButton.selected=!cell.selectButton.selected;
//        [self.selectedIndex replaceObjectAtIndex:indexPath.item withObject:@(cell.selectButton.selected)];
//        return;
//    }
//    LJPhotoCollectionViewCell* cell=(LJPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.selectButton.selected=!cell.selectButton.selected;
//
//    CGPoint pointTo=[cell convertPoint:CGPointMake(cell.lj_width/2, cell.lj_height/2) toView:self.view];
//
//    LJLookImageView* imageLookView=[[LJLookImageView alloc]initWithShowPoint:pointTo size:cell.lj_size];
//    imageLookView.superVC = self;
//    imageLookView.imageNameArray=self.photosName;
//    imageLookView.tapIndex=indexPath.item;
//    [imageLookView showLookView];
//    @weakify(self);
//    [imageLookView requestTheHidePoint:^CGPoint(NSInteger index) {
//        @strongify(self);
//        BOOL isExit=NO;
//        for (NSIndexPath* visibleIndexPath in self.collectionView.indexPathsForVisibleItems) {
//            if (visibleIndexPath.item==index) {
//                isExit=YES;
//                break;
//            }
//        }
//        if (!isExit) {
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
//        }
//        LJPhotoCollectionViewCell* cell=(LJPhotoCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//
//        CGPoint pointTo=[cell convertPoint:CGPointMake(cell.lj_width/2, cell.lj_height/2) toView:self.view];
//
//        return pointTo;
//    }];
//
//    [imageLookView removeSelfHandler:^(id sender, id status) {
//        @strongify(self);
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//    }];
//    [self.view addSubview:imageLookView];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


@end
