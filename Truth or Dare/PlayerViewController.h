//
//  PlayerViewController.h
//  Truth or Dare
//
//  Created by YQ-010 on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Question.h"
#import "SQLite3Util.h"

#define truthType  0
#define dareType   1
#define randomType 2

@interface PlayerViewController : UIViewController<UIAccelerometerDelegate>{
    UIAccelerometer *accelerometer;
    BOOL isCanShake;
}
@property (nonatomic, retain) IBOutlet UIButton *truthButton;
@property (nonatomic, retain) IBOutlet UIButton *dareButton;
@property (nonatomic, retain) IBOutlet UIButton *randomButton;
@property (nonatomic, assign) BOOL allow;

@property int playerId;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) IBOutlet UIImageView *hintImage;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSString *playerName;
@property (nonatomic, retain) Question *truthOrDareQuestion;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)truthPressed:(id)sender;
- (IBAction)darePressed:(id)sender;
- (IBAction)randomPressed:(id)sender;
- (Question *)getQuestionByType:(int)type;
//- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
- (UIImage *)scaleImage:(UIImage *)image;
@end
