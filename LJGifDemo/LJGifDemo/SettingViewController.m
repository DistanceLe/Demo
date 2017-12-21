//
//  SettingViewController.m
//  LJGifDemo
//
//  Created by LiJie on 2017/12/21.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "SettingViewController.h"
#import "LJPhotoOperational.h"

@interface SettingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *roopLabel;
@property (weak, nonatomic) IBOutlet UILabel *frameTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gifSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoPersentLabel;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

/**  每帧间隔 */
- (IBAction)frameIntervalTimes:(UISlider *)sender {
    self.frameTimeLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    [LJPhotoOperational shareOperational].frameInterval = [self.frameTimeLabel.text floatValue];
}

/**  gif图片尺寸 */
- (IBAction)gifSize:(UISlider *)sender {
    self.gifSizeLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    [LJPhotoOperational shareOperational].gifSize = [self.gifSizeLabel.text floatValue];
}

/**  图片压缩比例 */
- (IBAction)photoPersent:(UISlider *)sender {
    self.photoPersentLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    [LJPhotoOperational shareOperational].photoPercent = [self.photoPersentLabel.text floatValue];
}

#pragma mark - ================ Delegate ==================
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger num = [textField.text integerValue];
    textField.text = @(num).stringValue;
    self.roopLabel.text = textField.text;
    [LJPhotoOperational shareOperational].roopTimes = num;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
