//
//  ViewController.m
//  RACDemo
//
//  Created by celink on 15/10/8.
//  Copyright © 2015年 celink. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

#import <objc/runtime.h>
#import <objc/message.h>
//#import "RACEXTScope.h"
#import "ReactiveCocoa.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(nonatomic, strong)RACCommand* conmmand;

@property(nonatomic, strong)UIButton* btn;
@property(nonatomic, strong)UITextField* textField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self oneTest];
//    [self twoTest];
//    [self threeTest];
//    [self fiveTest];
//    [self sixTest];
    [self sevenTest];
    
//    NSLog(@"%@",11531156880613611030UL); //打印：aidian
//    NSLog(@"----%@", 13413134112414UL); //崩溃
}



-(void)oneTest
{
//   [[self.userNameTextField.rac_textSignal filter:^BOOL(id value) {
//       
//       NSString* text=value;
//       return text.length>3;
//       
//    }]subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
    
    @weakify(self)
    [[[self.userNameTextField.rac_textSignal map:^id(NSString* value) {
        
        self_weak_.passwordTextField.backgroundColor=[UIColor orangeColor];
        return @(value.length);
    }]
    filter:^BOOL(NSNumber* value) {
        return [value integerValue]>3;
    }]
    subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}

#pragma mark   RACSignal使用步骤：
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.发送信号 - (void)sendNext:(id)value
// 3.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock

// RACSignal底层实现：
// 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
// 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
// 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
// 2.1 subscribeNext内部会调用siganl的didSubscribe
// 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
// 3.1 sendNext底层其实就是执行subscriber的nextBlock
-(void)twoTest
{
    //1.创建信号：
    RACSignal* signal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        //2.发送信号
        [subscriber sendNext:@10];
        
        //如果不在发送数据了，最好发送完成，会自动调用[RACDisposable disposable]取消订阅
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁");
        }];
    }];
    
    //3.订阅信号，才能激活信号
    [signal subscribeNext:^(id x) {
        NSLog(@"收到信号:%@",x);
    }];
    
}

#pragma mark RACSubject 和 RACReplaySubject
//RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
//RACReplaySubject:重复提供信号者，RACSubject的子类。
-(void)threeTest
{
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    // 1.创建信号
    RACSubject* subject=[RACSubject subject];
    
    //2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者:%@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者:%@",x);
    }];
    
    //3.发送信号
    [subject sendNext:@"234"];
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    //1.创建信号
    RACReplaySubject* replaySubject=[RACReplaySubject subject];
    
    //2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    //3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者收到的数据:%@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者收到的数据:%@",x);
    }];
}

#pragma mark  字典转模型
//6.6RACTuple:元组类,类似NSArray,用来包装值.
//6.7RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
-(void)fourTest
{
    
    // 1.遍历数组
    NSArray* numbers=@[@1, @2, @3, @4];
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary* dict=@{@"name":@"xiaoming", @"age":@14};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString* key, NSString* value)=x;
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        NSLog(@"key=%@,  value=%@", key, value);

    }];
    
    // 3.字典转模型
    // 3.1 OC写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    NSMutableArray *items = [NSMutableArray array];
//    for (NSDictionary *dict in dictArr)
//    {
//        NSObject* obj=[[NSObject alloc]init];
//        [obj setValuesForKeysWithDictionary:dict];
//        [items addObject:obj];
//    }
    
    // 3.2 RAC写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    
//    NSMutableArray *flags = [NSMutableArray array];
//    
//    _flags = flags;
//    
//    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
//    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
//        // 运用RAC遍历字典，x：字典
//        
//        FlagItem *item = [FlagItem flagWithDict:x];
//        
//        [flags addObject:item];
//        
//    }];
    
    // 3.2 RAC高级写法
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
//    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
    
//        return [FlagItem flagWithDict:value];
        
//    }] array];
    
//    [[dictArr.rac_sequence map:^id(id value) {
//        return nil;
//    }]array];
    
}

#pragma mark RACSubject替换代理
// 需求:
// 1.给当前控制器添加一个按钮，modal到另一个控制器界面
// 2.另一个控制器view中有个按钮，点击按钮，通知当前控制器
- (IBAction)buttonClick:(id)sender
{
    SecondViewController* secondVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"second"];
//    SecondViewController* secondVC=[[SecondViewController alloc]init];
    secondVC.delegateSignal=[RACSubject subject];
    [secondVC.delegateSignal subscribeNext:^(id x) {
        NSLog(@"收到second界面的点击事件了");
    }];
    
//    UIStoryboardSegue* pushSegue=[UIStoryboardSegue segueWithIdentifier:@"myPush" source:self destination:[SecondViewController alloc] performHandler:^{
//        
//    }];
    
    //跳转：
    [self.navigationController pushViewController:secondVC animated:YES];
    
    
}



#pragma mark  处理事件（点击，网络请求）
-(void)fiveTest
{
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    
    // 1.创建命令
    RACCommand* command=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
       
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _conmmand = command;
    // 3.执行命令
    [self.conmmand execute:@1];
    
    // 4.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
        }];
        
    }];
    
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 5.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
}

//Multicast 多点传送
#pragma mark RACMulticastConnection简单使用
//6.9RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
//使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
-(void)sixTest
{
    // RACMulticastConnection使用步骤:
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.创建连接 RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
    // 4.连接 [connect connect]
    
    // RACMulticastConnection底层原理:
    // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
    // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
    // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
    // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
    // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
    // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
    // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
    
    
    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    
    // 1.创建请求信号
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        
//        NSLog(@"发送请求");
//        
//        return nil;
//    }];
//    // 2.订阅信号
//    [signal subscribeNext:^(id x) {
//        
//        NSLog(@"接收数据");
//        
//    }];
//    // 2.订阅信号
//    [signal subscribeNext:^(id x) {
//        
//        NSLog(@"接收数据");
//        
//    }];
    
    // 3.运行结果，会执行两遍发送请求，也就是每次订阅都会发送一次请求
    
    
    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 2.创建连接
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者一信号");
        
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者二信号");
        
    }];
    
    // 4.连接,激活信号
    [connect connect];
}
/*
 6.10 RACScheduler:RAC中的队列，用GCD封装的。
 
 6.11 RACUnit :表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.
 
 6.12 RACEvent: 把数据包装成信号事件(signal event)。它主要通过RACSignal的-materialize来使用，然并卵。
 */



#pragma mark  7.ReactiveCocoa开发中常见用法。
/*
 7.1 代替代理:
 rac_signalForSelector：用于替代代理。
 
 7.2 代替KVO :
 rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
 
 7.3 监听事件:
 rac_signalForControlEvents：用于监听某个事件。
 
 7.4 代替通知:
 rac_addObserverForName:用于监听某个通知。
 
 7.5 监听文本框文字改变:
 rac_textSignal:只要文本框发出改变就会发出这个信号。
 
 7.6 处理当界面有多次请求时，需要都获取到数据时，才能展示界面
 rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。
 
 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
 */

-(void)sevenTest
{
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    UIView* redV=[[UIView alloc]init];
    [[redV rac_signalForSelector:@selector(buttonClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    // 5.监听文本框的文字改变
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        NSLog(@"11111%@",[subscriber description]);
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        NSLog(@"222222%@",[subscriber description]);
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    NSLog(@"---%@",[request1 description]);
    NSLog(@"====%@",[request2 description]);
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
    
    
}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}


#pragma mark 8.ReactiveCocoa常见宏。
/**
 8.1 RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
 
 // 只要文本框文字改变，就会修改label的文字
 RAC(self.labelView,text) = _textField.rac_textSignal;
 8.2 RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
 
 [RACObserve(self.view, center) subscribeNext:^(id x) {
 
 NSLog(@"%@",x);
 }];
 8.3  @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。
 
 8.4 RACTuplePack：把数据包装成RACTuple（元组类）
 
 // 把参数中的数据包装成元组
 RACTuple *tuple = RACTuplePack(@10,@20);
 8.5 RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
 
 // 把参数中的数据包装成元组
 RACTuple *tuple = RACTuplePack(@"xmg",@20);
 
 // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
 // name = @"xmg" age = @20
 RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
 */



@end
