//
//  ViewController.m
//  WifiDemo
//
//  Created by LiJie on 2017/11/14.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "ViewController.h"

#import "SimplePing.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import "getgateway.h"


@interface ViewController ()<SimplePingDelegate>

@property(nonatomic, strong)SimplePing* pinger;
@property (weak, nonatomic) IBOutlet UITextField *hostNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation ViewController

/**
 iOS 中 ping失败后（即发送测试报文成功后，一直没后收到响应的报文）,
 不会有任何回调方法告知我们。而一般ping 一次的结果也不太准确，
 ping 花费的时间也非常短，所以我们一般会ping多次，发送一次ping 测试报文
 0.5s后检测一下这一次ping是否已经收到响应。0.5s后检测时，如果已经收到响应，
 则可以ping 通；如果没有收到响应，则视为超时。
 
 做法也有很多种，可以用NSTimer或者 {- (void)performSelector: withObject:afterDelay:}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Ping";
    self.hostNameTextField.text = @"www.baidu.com";
    
    [self fetchSSIDInfo];
    [self fetchWiFiName];
    [self getGatewayIpForCurrentWiFi];
    [self getLocalInfoForCurrentWiFi];
    [self getLocalIPAddressForCurrentWiFi];
}

#pragma mark - ================ Action ==================
- (IBAction)pingClick:(UIButton *)sender {
    [self.pinger stop];
    self.pinger.delegate = nil;
    
    SimplePing *pinger = [[SimplePing alloc] initWithHostName:self.hostNameTextField.text];
    self.pinger = pinger;
    pinger.delegate = self;
    pinger.addressStyle = SimplePingAddressStyleICMPv4;
    [pinger start];
}
- (IBAction)clearClick:(UIBarButtonItem *)sender {
    self.contentTextView.text = @"";
}

-(void)addLog:(NSString*)logString{
    self.contentTextView.text = [NSString stringWithFormat:@"%@\n%@", self.contentTextView.text, logString];
}

//获取WiFi 信息，返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
- (NSDictionary *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    //获取WiFi名称
    //NSString *WiFiName = info[@"SSID"];
    NSLog(@"info:%@", info);
    return info;
}

- (NSString *)fetchWiFiName {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    NSString *WiFiName = nil;
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            // 这里其实对应的有三个key:kCNNetworkInfoKeySSID、kCNNetworkInfoKeyBSSID、kCNNetworkInfoKeySSIDData，
            // 不过它们都是CFStringRef类型的
            WiFiName = [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            //            WiFiName = [info objectForKey:@"SSID"];
            break;
        }
    }
    NSLog(@"wifiName:%@", WiFiName);
    return WiFiName;
}

/**  获取网关的方法 */
- (NSString *)getGatewayIpForCurrentWiFi {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL) {
            /*/
             int i=255;
             while((i--)>0)
             //*/
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    //ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    //routerIP----192.168.1.255 广播地址
                    NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    //--192.168.1.106 本机地址
                    NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    //--255.255.255.0 子网掩码地址
                    NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    //--en0 端口地址
                    NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    in_addr_t i = inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x = &i;
    unsigned char *s = getdefaultgateway(x);
    NSString *ip=[NSString stringWithFormat:@"%d.%d.%d.%d",s[0],s[1],s[2],s[3]];
    free(s);
    NSLog(@"ip:%@", ip);
    return ip;
}

/**  获取本机在WiFi环境下的IP地址 */
- (NSString *)getLocalIPAddressForCurrentWiFi
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    NSLog(@"address:%@", address);
                    return address;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        freeifaddrs(interfaces);
    }
    return nil;
}

/**  获取广播地址、子网掩码、端口等，组装成一个字典 */
- (NSMutableDictionary *)getLocalInfoForCurrentWiFi {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    //----192.168.1.255 广播地址
                    NSString *broadcast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    if (broadcast) {
                        [dict setObject:broadcast forKey:@"broadcast"];
                    }
                    NSLog(@"broadcast address--%@",broadcast);
                    //--192.168.1.106 本机地址
                    NSString *localIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    if (localIp) {
                        [dict setObject:localIp forKey:@"localIp"];
                    }
                    NSLog(@"local device ip--%@",localIp);
                    //--255.255.255.0 子网掩码地址
                    NSString *netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    if (netmask) {
                        [dict setObject:netmask forKey:@"netmask"];
                    }
                    NSLog(@"netmask--%@",netmask);
                    //--en0 端口地址
                    NSString *interface = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    if (interface) {
                        [dict setObject:interface forKey:@"interface"];
                    }
                    NSLog(@"interface--%@",interface);
                    NSLog(@"mutiInfo:%@", dict);
                    return dict;
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    NSLog(@"mutiInfo:%@", dict);
    return dict;
}

#pragma mark - ================ delegate ==================
/**
 *  start成功，也就是准备工作做完后的回调
 */
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    // 发送测试报文数据
    [self.pinger sendPingWithData:nil];
}
- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    [self addLog:[NSString stringWithFormat:@"didFailWithError:%@",error]];
    [self.pinger stop];
}



// 发送测试报文成功的回调方法
- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    [self addLog:[NSString stringWithFormat:@"#%u sent %zu", sequenceNumber, (unsigned long)packet.length]];
}
//发送测试报文失败的回调方法
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    [self addLog:[NSString stringWithFormat:@"#%u send failed: %@", sequenceNumber, error]];
}
// 接收到ping的地址所返回的数据报文回调方法
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    [self addLog:[NSString stringWithFormat:@"#%u received, size=%zu", sequenceNumber, (unsigned long)packet.length]];
}
- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    [self addLog:[NSString stringWithFormat:@"#%s",__func__]];
}

@end
