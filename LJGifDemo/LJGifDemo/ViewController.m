//
//  ViewController.m
//  LJGifDemo
//
//  Created by LiJie on 2017/12/15.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import "LJPhotoAlbumTableViewController.h"

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
    
}


@end
