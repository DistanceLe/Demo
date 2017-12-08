//
//  UIScrollView+LJRefresh.m
//  LJRefresh
//
//  Created by LiJie on 16/8/19.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "UIScrollView+LJRefresh.h"
#import "LJRefreshView.h"
#import <objc/runtime.h>

static  NSString* const scrollViewClass = @"scrollViewClass";

static  NSString* const offsetKeyPath   = @"contentOffset";
static  NSString* const sizeKeyPath     = @"contentSize";
static  NSString* const observerOffset  = @"observerOffset";

static  NSString* const headHandler     = @"headHandler";
static  NSString* const footHandler     = @"footHandler";

static  NSString* const headRefreshing  = @"headRefreshing";
static  NSString* const footRefreshing  = @"footRefreshing";

@interface UIScrollView ()

@property(nonatomic, strong)NSMutableDictionary* ljRefreshDic;
@property(nonatomic, strong)LJRefreshView* ljRefreshHeadView;
@property(nonatomic, strong)LJRefreshView* ljRefreshFootView;

@end

@implementation UIScrollView (LJRefresh)

#pragma mark - ================ init Method ==================
static char refreshKey;
-(void)setLjRefreshDic:(NSMutableDictionary *)ljRefreshDic{
    objc_setAssociatedObject(self, &refreshKey, ljRefreshDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary *)ljRefreshDic{
    return objc_getAssociatedObject(self, &refreshKey);
}

static char refreshHeadKey;
-(void)setLjRefreshHeadView:(UIView *)ljRefreshHeadView{
    objc_setAssociatedObject(self, &refreshHeadKey, ljRefreshHeadView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)ljRefreshHeadView{
    return objc_getAssociatedObject(self, &refreshHeadKey);
}

static char refreshFootKey;
-(void)setLjRefreshFootView:(UIView *)ljRefreshFootView{
    objc_setAssociatedObject(self, &refreshFootKey, ljRefreshFootView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)ljRefreshFootView{
    return  objc_getAssociatedObject(self, &refreshFootKey);
}


#pragma mark - ================ Public Method ==================
-(void)addLJHeadRefresh:(RefreshHeadBlock)handler{
    
    [self initDataWithHandler:handler isHead:YES];
    [self setHeadUI];
}

-(void)addLJFootRefresh:(RefreshFootBlock)handler{
    [self initDataWithHandler:handler isHead:NO];
    [self setFootUI];
}

-(void)endLJRefresh{
    if ([[self.ljRefreshDic valueForKey:headRefreshing]boolValue]) {
        [self.ljRefreshDic setObject:@(NO) forKey:headRefreshing];
        [self.ljRefreshHeadView endRefresh];
    }
    
    if ([[self.ljRefreshDic valueForKey:footRefreshing]boolValue]) {
        [self.ljRefreshDic setObject:@(NO) forKey:footRefreshing];
        [self.ljRefreshFootView endRefresh];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

-(void)beginHeadRefresh{
    if (![[self.ljRefreshDic valueForKey:headRefreshing]boolValue]) {
        RefreshHeadBlock headCallBack=[self.ljRefreshDic valueForKey:headHandler];
        if (headCallBack) {
            headCallBack();
        }
        [self.ljRefreshHeadView refresh];
        [UIView animateWithDuration:0.3 animations:^{
            self.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.ljRefreshHeadView.bounds) , 0, 0, 0);
        } completion:nil];
        [self.ljRefreshDic setObject:@(YES) forKey:headRefreshing];
    }
}

-(void)beginFootRefresh{
    if (![[self.ljRefreshDic valueForKey:footRefreshing]boolValue]) {
        RefreshFootBlock footCallBack=[self.ljRefreshDic valueForKey:footHandler];
        if (footCallBack) {
            footCallBack();
        }
        [self.ljRefreshFootView refresh];
        [UIView animateWithDuration:0.3 animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.ljRefreshFootView.bounds), 0);
        } completion:nil];
        [self.ljRefreshDic setObject:@(YES) forKey:footRefreshing];
    }
}

-(void)initDataWithHandler:(RefreshFootBlock)handler isHead:(BOOL)isHead{
    if (!self.ljRefreshDic) {
        self.ljRefreshDic=[NSMutableDictionary dictionary];
    }
    if (isHead && handler) {
        [self.ljRefreshDic setObject:handler forKey:headHandler];
    }else{
        [self.ljRefreshDic setObject:handler forKey:footHandler];
    }
    
    if (![[self.ljRefreshDic valueForKey:observerOffset] boolValue]) {
        
        [self addObserver:self
               forKeyPath:offsetKeyPath
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:@"LJObserverContext"];
        
        [self addObserver:self
               forKeyPath:sizeKeyPath
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:@"LJObserverContext"];
        
        [self.ljRefreshDic setObject:NSStringFromClass([self class])
                              forKey:scrollViewClass];
        
        [self.ljRefreshDic setObject:@(YES)
                              forKey:observerOffset];
    }
}

-(void)dealloc{
    
    /**  因为是ScrollView的 类别，所以UITableViewWrapperView 也就是TableView的子类也会走该方法，需要筛别出去。 */
    Class scrollClass=NSClassFromString([self.ljRefreshDic objectForKey:scrollViewClass]);
    if ([self isKindOfClass:scrollClass]) {
        [self removeObserver:self forKeyPath:offsetKeyPath context:@"LJObserverContext"];
        [self removeObserver:self forKeyPath:sizeKeyPath context:@"LJObserverContext"];
    }
}

-(void)setHeadUI{
    if (!self.ljRefreshHeadView) {
        self.ljRefreshHeadView=[[LJRefreshView alloc]initWithFrame:CGRectMake(0, -100, CGRectGetWidth(self.bounds), 100)];
        self.ljRefreshHeadView.backgroundColor=[UIColor redColor];
        [self addSubview:self.ljRefreshHeadView];
    }
}

-(void)setFootUI{
    if (!self.ljRefreshFootView) {
        self.ljRefreshFootView=[[LJRefreshView alloc]initWithFrame:CGRectMake(0, self.contentSize.height, CGRectGetWidth(self.bounds), 100)];
        self.ljRefreshFootView.backgroundColor=[UIColor greenColor];
        [self addSubview:self.ljRefreshFootView];
        self.ljRefreshFootView.hidden=YES;
    }
}


#pragma mark - ================ 监听ScrollView位移量 ==================
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:offsetKeyPath]) {
        CGPoint contentOffset=[[change valueForKey:NSKeyValueChangeNewKey]CGPointValue];
        CGSize contentSize=[[self.ljRefreshDic valueForKey:sizeKeyPath] CGSizeValue];
        CGFloat pullDistance=CGRectGetHeight(self.ljRefreshHeadView.bounds);
        NSLog(@"%@....", NSStringFromCGPoint(contentOffset));
        if (contentOffset.y<=0) {
            //开始下拉
            CGFloat progress=MAX(0.0, MIN(fabs(contentOffset.y)/pullDistance, 1.0));
            self.ljRefreshHeadView.refreshProgress=progress;
            if (!self.tracking) {
                if (progress>0.9) {
                    [self beginHeadRefresh];
                }
            }
        }
        if (contentOffset.y>=(contentSize.height-CGRectGetHeight(self.bounds))) {
            //开始上拉
            CGFloat progress=MAX(0.0, MIN((contentOffset.y-(contentSize.height - CGRectGetHeight(self.bounds))) / pullDistance, 1.0));
            NSLog(@"progress= %.2f", progress);
            self.ljRefreshFootView.refreshProgress=progress;
            if (!self.tracking) {
                if (progress>0.9) {
                    [self beginFootRefresh];
                }
            }
        }
    }else if ([keyPath isEqualToString:sizeKeyPath]){
        CGSize contentSize=[[change valueForKey:NSKeyValueChangeNewKey]CGSizeValue];
        [self.ljRefreshDic setObject:[change valueForKey:NSKeyValueChangeNewKey]
                              forKey:sizeKeyPath];
        NSLog(@"========%@", NSStringFromCGSize(contentSize));
        if (self.ljRefreshFootView) {
            if (contentSize.height>0.0) {
                self.ljRefreshFootView.hidden=NO;
            }
            CGRect frame=self.ljRefreshFootView.frame;
            frame.origin.y=contentSize.height;
            self.ljRefreshFootView.frame=frame;
        }
    }
}
















@end
