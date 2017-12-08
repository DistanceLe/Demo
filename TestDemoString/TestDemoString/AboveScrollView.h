//
//  AboveScrollView.h
//  TestDemoString
//
//  Created by LiJie on 2017/12/6.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboveScrollView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic, weak)UIScrollView* backScrollView;

@end


