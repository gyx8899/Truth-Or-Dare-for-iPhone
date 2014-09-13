//
//  ViewController.h
//  Truth or Dare
//
//  Created by YQ-010 on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUIPickerView.h"
#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController : UIViewController
<UIActionSheetDelegate, UIScrollViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAccelerometerDelegate>
{
    UIAccelerometer *accelerometer;
    NSTimer *timer;
    AVAudioPlayer *audioPlayer;
}
@property (nonatomic, retain) HUIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *playBtn;
@property (nonatomic, retain) IBOutlet UIButton *nextBtn;
@property (nonatomic, retain) IBOutlet UIButton *hiddenBtn;
@property (nonatomic, retain) UIButton *senderBtn;
@property (nonatomic, retain) UIImageView *selectBg;
@property (nonatomic, retain) NSString *defaultName;
@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) IBOutlet UIButton *nullBtn;
@property int numPlayers;
@property int playerId;
@property BOOL isCanShake;

- (IBAction)helpBtnPressed:(id)sender;
- (IBAction)questionsBtnPressed:(id)sender;
- (IBAction)playerPressed:(id)sender;
- (IBAction)hiddenPressed:(id)sender;
- (IBAction)hiddenDraged:(id)sender;

- (IBAction)leftBtnPressed:(id)sender;
- (IBAction)rightBtnPressed:(id)senderr;

- (IBAction)textFieldBegin:(id)sender;
- (IBAction)textFieldEnd:(id)sender;
- (IBAction)shakeOrPlay:(id)sender;
- (IBAction)nextBtnPressed:(id)sender;

- (void)addPlayer;
- (void)addMultiPlayer:(NSNotification *)notifi;
- (void)removePlayer;
- (void)removeMultiPlayer:(NSNotification *)notifi;
- (void)showAlert:(NSString *)msg;
- (void)showAlertView:(NSNotification *)notifi;
- (void)getPicture:(UIImagePickerControllerSourceType)type;
- (void)drawPlayer:(UIView *)player : (int)index;
- (void)showAllPlayers;
- (int)selectPlayer;
- (void)showPlayOrShakeBtn:(NSNotification *)notifi;
- (void)shakeDevice:(NSNotification *)notifi;
- (void)playMusic;
- (void)playAnimation:(UIView *)player;

-(void)canUseButton;
-(void)pressButton;


@end
