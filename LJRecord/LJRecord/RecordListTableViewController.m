//
//  RecordListTableViewController.m
//  LJRecord
//
//  Created by LiJie on 16/5/20.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "RecordListTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RecordListTableViewCell.h"

@interface RecordListTableViewController ()<AVAudioPlayerDelegate>

@property(nonatomic, strong)AVAudioPlayer*      audioPlayer;//音频播放器，用于播放录音文件

@property(nonatomic, strong)NSMutableArray* recordFileNames;
@property(nonatomic, strong)NSMutableArray* records;
@property(nonatomic, strong)NSMutableArray* recordTimes;
@property(nonatomic, strong)NSIndexPath*    playingIndexPath;

@end

@implementation RecordListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _records=[NSMutableArray array];
    _recordTimes=[NSMutableArray array];
    self.tableView.rowHeight=50;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshData];
}

-(void)refreshData
{
    self.recordFileNames=[NSMutableArray arrayWithArray:[self getRecordFileNames]];
    [self.recordTimes removeAllObjects];
    for (NSString* fileName in self.recordFileNames) {
        [self.recordTimes addObject:[self getRecordTime:fileName]];
    }
    [self.tableView reloadData];
}



#pragma mark - ================ Action ==================
-(NSArray*)getRecordFileNames
{
    NSArray* pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* urlStr=[pathArray lastObject];
    NSArray* files=[[NSFileManager defaultManager]subpathsAtPath:urlStr];
    return files;
}

-(NSURL*)getFileURL:(NSString*)fileName
{
    NSArray* pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* urlStr=[pathArray lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:fileName];
    NSURL* url=[NSURL fileURLWithPath:urlStr];
    return url;
}

-(NSString*)getRecordTime:(NSString*)fileName
{
    AVAudioPlayer* tempPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[self getFileURL:fileName] error:nil];
    if (tempPlayer) {
        return [NSString stringWithFormat:@"%.1f",tempPlayer.duration];
    }
    return @"0";
}

-(AVAudioPlayer*)getAutioPlayerWithName:(NSString*)fileName
{
    NSURL* url=[self getFileURL:fileName];
    NSError* error=nil;
    AVAudioPlayer* tempPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    tempPlayer.numberOfLoops=0;
    tempPlayer.delegate=self;
    [tempPlayer prepareToPlay];
    if (error) {
        NSLog(@".......%@",error.localizedDescription);
        return nil;
    }
    return tempPlayer;
}
- (IBAction)clearnRecord:(UIBarButtonItem *)sender
{
    UIAlertController* alertController=[UIAlertController alertControllerWithTitle:@"清空录音记录" message:@"清空后，不可恢复，确定要清空？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* clearnAction=[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearnAllRecord];
    }];
    [alertController addAction:clearnAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordFileNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text=self.recordFileNames[indexPath.row];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ s",self.recordTimes[indexPath.row]];
    cell.recordTime=[self.recordTimes[indexPath.row] floatValue];
    cell.currentRecordTime=0;
    if ([_audioPlayer isPlaying] && indexPath==_playingIndexPath) {
        cell.currentRecordTime=_audioPlayer.currentTime;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSFileManager* fileManger=[NSFileManager defaultManager];
        if([fileManger removeItemAtURL:[self getFileURL:self.recordFileNames[indexPath.row]] error:nil]){
            [self.recordFileNames removeObjectAtIndex:indexPath.row];
            [self.recordTimes removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            NSLog(@"删除失败");
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }   
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordListTableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([_audioPlayer isPlaying]) {
        if (_playingIndexPath==indexPath) {
            [_audioPlayer pause];
            [cell stopPlay];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else{
            RecordListTableViewCell* oldCell=[tableView cellForRowAtIndexPath:_playingIndexPath];
            [oldCell stopPlay];
            [_audioPlayer stop];
            _audioPlayer=[self getAutioPlayerWithName:self.recordFileNames[indexPath.row]];
            [_audioPlayer play];
            [cell startPlay];
            _playingIndexPath=indexPath;
        }
    }else{
        _audioPlayer=[self getAutioPlayerWithName:self.recordFileNames[indexPath.row]];
        [_audioPlayer play];
        [cell startPlay];
        _playingIndexPath=indexPath;
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"====播放完成");
    [self.tableView deselectRowAtIndexPath:_playingIndexPath animated:YES];
}

#pragma mark - ================ 删除录音 ==================
-(void)clearnAllRecord
{
    NSArray* pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* urlStr=[pathArray lastObject];
    NSFileManager* fileManger=[NSFileManager defaultManager];
    NSError* error=nil;
    [fileManger removeItemAtPath:urlStr error:&error];
    [self.recordFileNames removeAllObjects];
    [self.recordTimes removeAllObjects];
    [self.tableView reloadData];
}

@end
