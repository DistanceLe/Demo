//
//  ViewController.m
//  LJRecord
//
//  Created by LiJie on 16/5/17.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import "LJVolumeView.h"

#import <AVFoundation/AVFoundation.h>
#import "TimeTools.h"


//#define kRecordAudioFile @"myRecord1.caf"

@interface ViewController ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property(nonatomic, strong)AVAudioRecorder*    audioRecorder;//音频录音机
@property(nonatomic, strong)AVAudioPlayer*      audioPlayer;//音频播放器，用于播放录音文件
@property(nonatomic, strong)NSTimer*            time;//录音声波监控
@property(nonatomic, strong)NSTimer*            playTime;//播放监控
@property(nonatomic, assign)CGFloat             audioTime;//录音时长
@property(nonatomic, assign)CGFloat             audioCurrentTime;
@property(nonatomic, assign)BOOL                isPause;

@property (weak, nonatomic) IBOutlet UIProgressView *recordPower;
@property (weak, nonatomic) IBOutlet UILabel *audioTimeLabel;

@property(nonatomic, strong)NSString* recordName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRecord];
}

#pragma mark - ================ 设置音频会话 ==================
-(void)initRecord
{
    AVAudioSession* audioSession=[AVAudioSession sharedInstance];
    //设置为录音和播放状态，录制后，可播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

//-(NSURL*)getSavePath
//{
//    NSArray* pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString* urlStr=[pathArray lastObject];
//    
////    NSArray* files=[[NSFileManager defaultManager]subpathsAtPath:urlStr];
////    NSLog(@"%@", files);
//    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
//    NSLog(@"file path=%@", urlStr);
//    NSURL* url=[NSURL fileURLWithPath:urlStr];
//    return url;
//}

-(NSString*)recordName
{
    if (!_recordName) {
        _recordName=[NSString stringWithFormat:@"%@.caf",[TimeTools getCurrentStandarTime]];
    }
    return _recordName;
}

-(NSURL*)getFileURL:(NSString*)fileName
{
    NSArray* pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* urlStr=[pathArray lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:fileName];
    NSLog(@"file path=%@", urlStr);
    NSURL* url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**  录音设置 */
-(NSDictionary*)getAudioSetting
{
    NSMutableDictionary* dicM=[NSMutableDictionary dictionary];
    //设置格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道，采用单通道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数，分别为8，16，24，32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dicM;
}

-(AVAudioRecorder*)audioRecorder
{
    if (!_audioRecorder) {
        NSURL* url=[self getFileURL:self.recordName];
        NSDictionary* setting=[self getAudioSetting];
        NSError* error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;
        if (error) {
            NSLog(@"======初始化录音机 错误%@", error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

-(AVAudioPlayer*)audioPlayer
{
    if (!_audioPlayer) {
        NSURL* url=[self getFileURL:self.recordName];
        NSError* error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@".......%@",error.localizedDescription);
        }
    }
    return _audioPlayer;
}

-(NSTimer*)time
{
    if (!_time) {
        _time=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _time;
}

-(NSTimer*)playTime
{
    if (!_playTime) {
        _playTime=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playChange) userInfo:nil repeats:YES];
    }
    return _playTime;
}


#pragma mark - ================ 录音。。。 ==================
- (IBAction)startRecord:(id)sender {
    
    if (![self.audioRecorder isRecording]) {
        if (!self.isPause) {
            self.playTime.fireDate=[NSDate distantFuture];
            self.audioTime=0.0;
            self.isPause=NO;
            _audioRecorder=nil;
            _recordName=nil;
            _recordPower.hidden=YES;
        }
        [self.audioRecorder record];//首次使用，提示是否允许录音
        self.time.fireDate=[NSDate distantPast];//开启（设置了开始时间）
    }
}

- (IBAction)pauseRecord:(id)sender {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.isPause=YES;
        self.time.fireDate=[NSDate distantFuture];//关闭
    }
}

- (IBAction)recoverRecord:(id)sender {
    [self startRecord:nil];
}

- (IBAction)stopRecord:(id)sender {
    [self.audioRecorder stop];
    self.time.fireDate=[NSDate distantFuture];
//    self.recordPower.progress=0.0;
}

#pragma mark - ================ 播放录音。。。 ==================
- (IBAction)playRecord:(id)sender {
    if (![self.audioPlayer isPlaying]) {
        if ([self.audioRecorder isRecording]) {
            [self stopRecord:nil];
        }
        
        self.audioPlayer=nil;
        [self.audioPlayer prepareToPlay];
        self.audioTime=self.audioPlayer.duration;
        if (self.audioTime<=0) {
            return;
        }
        self.recordPower.hidden=NO;
        self.recordPower.progress=0.0f;
        self.audioTimeLabel.text=[NSString stringWithFormat:@"0/%.f",  self.audioTime];
        [self.audioPlayer play];
        self.playTime.fireDate=[NSDate distantPast];
    }
}

-(void)audioPowerChange
{
    self.audioTime+=0.1;
    self.audioTimeLabel.text=[NSString stringWithFormat:@"%.1f", self.audioTime];
    [self.audioRecorder updateMeters];//更新测量值
    float power=[self.audioRecorder averagePowerForChannel:0];//取得第一通道音频
    //音频强度范围 -160 ~ 0
    CGFloat progress=(1.0/160.0)*(power+80);
//    NSLog(@"%f  %f", power,progress);
//    [self.recordPower setProgress:progress];
    [[LJVolumeView defaultVolumeView]playRecordWithProgress:progress];
}

-(void)playChange
{
    self.recordPower.progress=self.audioPlayer.currentTime/self.audioPlayer.duration;
    self.audioTimeLabel.text=[NSString stringWithFormat:@"%.f/%.1f",self.audioPlayer.currentTime,  self.audioTime];
}


#pragma mark - ================ Delegate ==================
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"....录音完成");
    [[LJVolumeView defaultVolumeView]stopPlay];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"====播放完成");
    
    self.playTime.fireDate=[NSDate distantFuture];
    self.recordPower.progress=1.0;
    self.audioTimeLabel.text=[NSString stringWithFormat:@"%.1f/%.1f",self.audioTime,  self.audioTime];
}




@end
