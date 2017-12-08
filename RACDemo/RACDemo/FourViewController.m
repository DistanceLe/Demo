//
//  FourViewController.m
//  RACDemo
//
//  Created by LiJie on 2016/10/12.
//  Copyright © 2016年 celink. All rights reserved.
//

#import "FourViewController.h"
#import "ReactiveCocoa.h"
#import "UIControl+RACSignalSupport.h"


typedef int(^intFunc)(int a);
typedef int(^FoldFunction)(int runnint, int next);


@interface FourViewController ()

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor= [UIColor redColor];
    
    testAddx();
}

#pragma mark - ================ 第四天 ==================



#pragma mark - ================ 第三天 ==================
-(void)complexOperation{
    /**  高阶操作，信号的值也是信号 */
    RACSignal* signal=[RACSignal return:@1];
    
    RACSignal* signalHigh=[RACSignal return:signal];
    RACSignal* signalAnother=[signal map:^id(id value) {
        return [RACSignal return:value];
    }];
    
    /**  订阅高阶信号 */
    RACSignal* signal1=@[@1, @2, @3, @4].rac_sequence.signal;
    RACSignal* highSignal=[signal1 map:^id(id value) {
        return [RACSignal return:value];
    }];
    
    [highSignal subscribeNext:^(RACSignal* x) {
        [x subscribeNext:^(id x) {
            
        }];
    }];
    
    /**  switchToLatests */
    UIButton* autoBut=[UIButton buttonWithType:UIButtonTypeCustom];
    autoBut.backgroundColor=[UIColor orangeColor];
    [autoBut setTitle:@"auto" forState:UIControlStateNormal];
    autoBut.frame=CGRectMake(10, 100, 60, 40);
    
    UIButton* stepBut=[UIButton buttonWithType:UIButtonTypeCustom];
    stepBut.backgroundColor=[UIColor blueColor];
    [stepBut setTitle:@"step" forState:UIControlStateNormal];
    stepBut.frame=CGRectMake(80, 100, 60, 40);
    [self.view addSubview:autoBut];
    [self.view addSubview:stepBut];
    
    RACSignal* autoClickSignal=[autoBut rac_signalForControlEvents:UIControlEventTouchUpInside];
    RACSignal* stepClickSignal=[stepBut rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    RACSignal* idSiganl=[RACSignal return:@1.1];
    RACSignal* timerSignal=[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]];
    
    autoClickSignal=[autoClickSignal mapReplace:idSiganl];
    stepClickSignal=[stepClickSignal mapReplace:timerSignal];
    RACSignal* controlSignal=[autoClickSignal merge:stepClickSignal];
    
    controlSignal=[controlSignal switchToLatest];
    //============================================
    
    UITextField* textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 150, 100, 40)];
    [self.view addSubview:textField];
    RACSignal* searchSignal=[textField rac_textSignal];
    RACSignal* requestSignal=[searchSignal map:^id(NSString* value) {
        NSString* urlStr=[NSString stringWithFormat:@"http://xxx.xx.xxx/?q=%@", value];
        NSURL* url=[NSURL URLWithString:urlStr];
        NSURLRequest* request=[NSURLRequest requestWithURL:url];
        return [NSURLConnection rac_sendAsynchronousRequest:request];
    }];
    requestSignal=[requestSignal switchToLatest];

    
    /**  降阶操作if then else, switch case default */
    /**  flatten：扁平化*/
    //flatten 相当于 merge
    //flatten 2，同时订阅两个信号
    //flatten 1，相当于concat
    
    /**  flattenMap */
}



#pragma mark - ================ 第二天 ==================

-(void)getSignal{
    
    UIButton* tempButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tempButton.frame=CGRectMake(20, 40, 100, 40);
    tempButton.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:tempButton];
    
    /**  获得一个信号: */
    /**  单元信号 */
    RACSignal* signal1=[RACSignal return:@"some Value"];
    RACSignal* signal2=[RACSignal error:[NSError errorWithDomain:NULL code:0 userInfo:nil]];
    RACSignal* signal3=[RACSignal empty];
    RACSignal* signal4=[RACSignal never];
    
    /**  动态信号*/
    RACSignal* signal5=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendError:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    /**  1.cocoa桥接 */
    RACSignal* signal6=[tempButton rac_signalForSelector:@selector(setFrame:)];
    RACSignal* signal7=[tempButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    RACSignal* signal8=[tempButton rac_willDeallocSignal];
    RACSignal* signal9=RACObserve(tempButton, backgroundColor);
    
    /**  2.信号变换 */
    RACSignal* signal10=[signal1 map:^id(id value) {
        return [value substringFromIndex:1];
    }];
    
    /**  3.序列转换 */
    RACSequence* sequence=@[@1, @2, @3].rac_sequence;
    RACSignal* signal11=sequence.signal;
    
    
    
    
    /**  订阅一个信号： */
    /**  1.订阅方法 */
    [signal1 subscribeNext:^(id x) {
        NSLog(@"next value is %@", x);
    } error:^(NSError *error) {
        NSLog(@"error is %@", error);
    } completed:^{
        NSLog(@"complete");
    }];
    
    /**  2.绑定 */
    RAC(tempButton, backgroundColor) = signal2;
    
    /**  3.cocoa桥接 */
    [tempButton rac_liftSelector:@selector(convertPoint:toView:) withSignals:signal1, signal2, nil];
    [tempButton rac_liftSelector:@selector(convertRect:toView:) withSignalsFromArray:@[signal3, signal4]];
    [tempButton rac_liftSelector:@selector(convertRect:toLayer:) withSignalOfArguments:signal5];
}

-(void)getSequence{
    /**  创建 */
    RACSequence* sequence1=[RACSequence return:@1];
    RACSequence* sequence2=[RACSequence sequenceWithHeadBlock:^id{
        return @2;
    } tailBlock:^RACSequence *{
        return sequence1;
    }];
    RACSequence* sequence3=@[@1, @2, @3].rac_sequence;
    
    /**  变换 */
    RACSequence* mappedSequence=[sequence1 map:^id(id value) {
        return @([value integerValue]*3);
    }];
    RACSequence* concatedSequence=[sequence2 concat:mappedSequence];
    RACSequence* mergedSequence=[RACSequence zip:@[concatedSequence, sequence3]];
    
    /**  遍历 */
    NSLog(@"head:%@", mergedSequence.head);
    for (id value in mergedSequence) {
        NSLog(@"value is %@", value);
    }
}

-(void)other{
    
    /**  元组 */
    RACTuple* tuple=RACTuplePack(@1, @"haha");
    id first=tuple.first;
    id second=tuple.second;
    id last=tuple.last;
    id index1=tuple[1];
    //直接拿到 值
    RACTupleUnpack(NSNumber* num, NSString* str)=tuple;
    
    
    /**  无限递增信号 */
    RACSignal* repeat1=[[RACSignal return:@1] repeat];
    RACSignal* signalA=[repeat1 scanWithStart:@0 reduce:^id(NSNumber* running, NSNumber* next) {
        return @(running.integerValue + next.integerValue);
    }];
    
    /**  斐波那契数列 */
    RACSignal* signalB=[repeat1 scanWithStart:RACTuplePack(@1, @1) reduce:^id(RACTuple* running, id _) {
        NSNumber* next=@([running.first integerValue]+[running.second integerValue]);
        return RACTuplePack(running.second, next);
    }];
    
    /**  时间操作 */
    RACSignal* interval=[[[RACSignal return:@1] delay:1] repeat];
}

/**  折叠函数 */
int fold(int* array, int count, FoldFunction func, int start){
    int current= array[0];
    int running= func(start, current);
    if (count==1) {
        return running;
    }
    return fold(array+1, count-1, func, running);
}

void foldTest(){
    int arr[]={1, 2, 3, 4, 5};
    int result=fold(arr, 5, ^int(int running, int next){
        return running+next;
    }, 0);
}

-(void)singleOperation{
    /**  值操作Map: 遇到错误则直接发送错误 */
    RACSignal* signalA=[RACSignal return:@[@1, @2, @3, @4, @5]];
    RACSignal* signalB=[signalA map:^id(NSNumber* value) {
        return @(value.integerValue *2);
    }];
    /**  将每个值都 改为8 */
    RACSignal* signalC=[signalA mapReplace:@8];
    
    /**  ReduceEach ，tuple类型转为 单一类型，block可以自定义有多个值*/
    RACSignal* signalD=[signalA reduceEach:^id(NSNumber* one, NSNumber* two){
        return @(one.integerValue + two.integerValue);
    }];
    
    /**  reduceApply,materialize,dematerialize, not, and, or */
    
    
    /**  数量操作：filter, ignore直接忽略该值，  */
    RACSignal* signalE=[signalA filter:^BOOL(NSNumber* value) {
        return value.integerValue>3;
    }];
    
    /**  ignoreValues忽略所有值，只有错误和结束，distinctUntilChanged去重复 */
    /**  take 2， 表示只要前两个。 skip 1, 表示跳过第一个。 any， all*/
    RACSignal* signalF=[signalA take:2];
    
    /**  startWith, 在前面加一个元素 */
    /**  repeat, ab -> ab, ab, ab, ab... 遇到错误终止，否则无限量。 或者使用retry */
    /**  collect，将每个值，收集成一个数组 */
    
    /**  Aggregate，  有一个初始值，无限信号的则没有值*/
    RACSignal* signalG=[signalA aggregateWithStart:@0 reduce:^id(NSNumber* running, NSNumber* next) {
        return @(running.integerValue + next.integerValue);//累加的意思，最终返回一个累加的值
    }];
    
    /**  Scan，和aggregate类似，只是每次累加 都会返回一个值 */
    RACSignal* signalH=[signalA scanWithStart:@0 reduce:^id(NSNumber* running, NSNumber* next) {
        return @(running.integerValue + next.integerValue);
    }];
    
    
    /**  副作用 doNext,原封不动返回，和map 直接返回value一样。 也叫副作用 */
    /**  doError， doCompleted， initially， finally */
    
    
    /**  时间操作，timeSignal */
    RACSignal* interval=[[[RACSignal return:@1] delay:1] repeat]; //每隔一秒钟一个信号
    
    /**  throttle，阀门 要有一个时间间隔，在该时间间隔内 没有新的值发出来，则获取该值。如：搜索时 */
    RACSignal* signalI=[signalA throttle:2];
}

-(void)multiOperation{
    /**  组合操作：concat, 先加A，A完成，再订阅B */
    RACSignal* signalA=[RACSignal return:@1];
    RACSignal* signalB=[RACSignal return:@2];
    RACSignal* signalC=[signalA concat:signalB];
    
    /**  Merge, 两个信号同时订阅，根据接收时间不同，依次增加 （时间线不变）*/
    RACSignal* signalF=[signalA merge:signalB];
    RACSignal* signalD=[RACSignal merge:@[signalA, signalB]];
    RACSignal* signalE=[RACSignal merge:RACTuplePack(signalA, signalB)];
    
    /**  Zip, 根据时间线打包成tuple, 奇数 则最后一个舍弃 */
    RACSignal* signalG=[signalA zipWith:signalB];
    RACSignal* signalH=[RACSignal zip:@[signalA, signalB]];
    RACSignal* signalI=[RACSignal zip:RACTuplePack(signalA, signalB)];
    
    /**  CombineLatest， 取最后一个值，根据时间线交叉组合 A信号截止，则B信号不停的发，只到A再发 */
    RACSignal* signalJ=[signalA combineLatestWith:signalB];
    RACSignal* signalK=[RACSignal combineLatest:@[signalA, signalB]];
    
    /**  sample，采样 获取最近一次的值。采样几次，即有几个值 */
    RACSignal* signalL=[signalA sample:signalB];//B 是采样信号，A是值信号。根据B来采取A
    
    /**  takeUntil， 到控制信号发送为止 */
    RACSignal* signalM=[signalA takeUntil:signalB];//到B发送时，即终止
    /**  takeUntilReplacement, 终止A，并用B来替换剩下的值。 */
    RACSignal* signalN=[signalA takeUntilReplacement:signalB];
}


#pragma mark - ================ 第一天 ==================
intFunc addX(int x){
    return ^int(int p){
        return x + p;
    };
}

intFunc other(intFunc intFunc1){
    return ^int(int p){
        return -intFunc1(p);
    };
}

void testAddx(){
    intFunc func1=addX(5);
    intFunc func2=other(func1);
    int result=func2(7);
    NSLog(@"result=%d", result);
    
    intFunc func3=transparent(func2);
    int result2=func3(7);
    int result3=func3(7);
    NSLog(@"result=%d %d", result2, result3);
}

/**  引用透明 */
intFunc transparent(intFunc origin){
    NSMutableDictionary* results=[NSMutableDictionary dictionary];
    return ^int(int p){
        if (results[@(p)]) {
            NSLog(@"已存在");
            return [results[@(p)] intValue];
        }
        results[@(p)]=@(origin(p));
        return [results[@(p)] intValue];
    };
}

void test1(){
    NSArray* a=@[@1, @2, @3];
    
    NSMutableArray* array=[NSMutableArray array];
    for (NSNumber* v in a) {
        [array addObject:@(v.integerValue * 10)];
    }
    id v=array[2];
}

/**  递推 */
void test2(){
    RACSignal* signal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendCompleted];
        return nil;
    }];
    
    __block int collection=0;
    [signal subscribeNext:^(id x) {
        collection+=[x integerValue];
    }];
    
    [signal aggregateWithStart:@0 reduce:^id(NSNumber* running, NSNumber* next) {
        return @(running.intValue + next.intValue);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"...%@ is the result", x);
    }];
    
}

int maxFunc(int* array, int count){
    if (count<1) {
        return INT_MIN;
    }
    if (count==1) {
        return array[0];
    }
    
    int temp=maxFunc(array+1, count-1);
    return temp > array[0] ? temp : array[0];
}


@end
