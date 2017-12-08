//
//  ViewController.m
//  RememberDemo
//
//  Created by LiJie on 16/9/19.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary* dic=[[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSLog(@"%@", dic);
    /**  
     NSFileSystemSize =         59088064512;
     NSFileSystemFreeSize =     34351345664;
     NSFileSystemFreeNodes =    4294571060;
     NSFileSystemNodes =        4294967279;
     NSFileSystemNumber =       16777218;
     */
}



@end
