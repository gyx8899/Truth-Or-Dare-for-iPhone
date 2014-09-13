//
//  PlayerViewController.m
//  Truth or Dare
//
//  Created by YQ-010 on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"

@implementation PlayerViewController
@synthesize playerId;
@synthesize icon;
@synthesize playerName;
@synthesize hintImage;
@synthesize textView;
@synthesize truthButton;
@synthesize dareButton;
@synthesize randomButton;
@synthesize truthOrDareQuestion;
@synthesize allow = _allow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)backBtnPressed:(id)sender{
//    isCanShake = true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPlayOrShakeBtn" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)truthPressed:(id)sender{
    @autoreleasepool {
        [UIView animateWithDuration:0.6 animations:^(void){
            [self.dareButton setCenter:CGPointMake(self.dareButton.center.x, self.dareButton.center.y + 300)];
            [self.randomButton setCenter:CGPointMake(self.randomButton.center.x, self.randomButton.center.y + 300)];
            [self.hintImage setCenter:CGPointMake(self.hintImage.center.x, self.hintImage.center.y - 90)];
            [self.textView setCenter:CGPointMake(160, self.textView.center.y)];
            
        }];
    }
    self.truthOrDareQuestion = [self getQuestionByType:truthType];
    self.textView.text = self.truthOrDareQuestion.content;
    [self.truthButton removeTarget:self action:@selector(truthPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)darePressed:(id)sender{
    @autoreleasepool {
        [UIView animateWithDuration:0.6 animations:^(void){
            [self.dareButton setCenter:CGPointMake(self.dareButton.center.x, self.dareButton.center.y - 130)];
            [self.truthButton setCenter:CGPointMake(self.truthButton.center.x, self.truthButton.center.y - 150)];
            [self.randomButton setCenter:CGPointMake(self.randomButton.center.x, self.randomButton.center.y + 300)];
            [self.hintImage setCenter:CGPointMake(self.hintImage.center.x, self.hintImage.center.y - 90)];
            [self.textView setCenter:CGPointMake(160, self.textView.center.y)];
        }];
    }
    self.truthOrDareQuestion = [self getQuestionByType:dareType];
    self.textView.text = self.truthOrDareQuestion.content;
    [self.dareButton removeTarget:self action:@selector(darePressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)randomPressed:(id)sender{
    self.truthOrDareQuestion = [self getQuestionByType:randomType];
    @autoreleasepool {
        [UIView animateWithDuration:0.6 animations:^(void){
            [self.randomButton setCenter:CGPointMake(self.randomButton.center.x, self.randomButton.center.y + 300)];
            [self.hintImage setCenter:CGPointMake(self.hintImage.center.x, self.hintImage.center.y - 90)];
            [self.textView setCenter:CGPointMake(160, self.textView.center.y)];
            if ([self.truthOrDareQuestion.truthOrDare isEqualToString:@"dare"]) {
                [self.dareButton setCenter:CGPointMake(self.dareButton.center.x, self.dareButton.center.y - 130)];
                [self.truthButton setCenter:CGPointMake(self.truthButton.center.x, self.truthButton.center.y - 150)];
                [self.dareButton removeTarget:self action:@selector(darePressed::) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [self.dareButton setCenter:CGPointMake(self.truthButton.center.x, self.truthButton.center.y + 500)];
                [self.truthButton removeTarget:self action:@selector(truthPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
        }];
    }
    self.textView.text = self.truthOrDareQuestion.content;
}

//Get a question with a type
//type includes truth,dare and random.
- (Question *)getQuestionByType:(int)type{
    SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
    Question *question = [[[Question alloc] init] autorelease];
    NSMutableArray *array;
    int count;
    switch (type) {
        case truthType:
            array = [sqlUtil getTruthOrDares:YES];
            int truthId = arc4random()%[array count];
            question = [array objectAtIndex:truthId];
            break;
        case dareType:
            array = [sqlUtil getTruthOrDares:NO];
            int dareId = arc4random()%[array count];
//            NSLog(@"dareId = %d",dareId);
            question = [array objectAtIndex:dareId];
            break;  
        case randomType:
            count = [sqlUtil getCountOfDB];
            int randomId = arc4random()%count;
            question = [sqlUtil getQuestion:randomId];
//            NSLog(@"Random Type ------>:%@",question.truthOrDare);
            [sqlUtil closeDatabase];
            break;
        default:
            break;
    }
    //
//    question = [sqlUtil getQuestion:2];
    [sqlUtil release];
    isCanShake = true;
    return question;
}

//zoom photo
- (UIImage*)scaleImage:(UIImage *)image{
    UIGraphicsBeginImageContext(CGSizeMake(32, 32));
    [image drawInRect:CGRectMake(1, 1, 32, 32)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    return scaledImage;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg.png"]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 135, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor yellowColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset =CGSizeMake(1, 1);
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = self.playerName;
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 35, 35);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backBtn;
    [backBtn release];
    
    UIView *playerImage = [[UIView alloc]initWithFrame:CGRectMake(10, 8, 36, 36)];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_frame.png"]];
    [backgroundImage setFrame:CGRectMake(0, 0, 36, 36)];
    [playerImage addSubview:backgroundImage];
    [backgroundImage release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
    [imageView setFrame:CGRectMake(2, 2, 32, 32)];
    [playerImage addSubview:imageView];
    [imageView release];
    
    UIBarButtonItem *imageButton = [[UIBarButtonItem alloc] initWithCustomView:playerImage];
    [playerImage release];
    
    self.navigationItem.rightBarButtonItem = imageButton;
    [imageButton release];
    
    [self.textView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"textview_bg"]]];
    [self.textView setOpaque:NO];
    [self.textView setEditable:NO];
    
    accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 0.1;
    accelerometer.delegate = self;
    
    isCanShake = false;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.allow = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isCanShake = true;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.playerName = nil;
    self.textView = nil;
    self.hintImage = nil;
    self.truthOrDareQuestion = nil;
    self.truthButton = nil;
    self.dareButton = nil;
    self.randomButton = nil;
    self.icon = nil;
}

- (void)dealloc{
    [playerName release];
    [hintImage release];
    [textView release];
    [truthOrDareQuestion release];
    [truthButton release];
    [dareButton release];
    [randomButton release];
    [icon release];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIAccelerometer delegate methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    if (fabsf(acceleration.x > 1.5) || fabsf(acceleration.y > 1.5) || fabsf(acceleration.z > 1.5)) {        //1.5 shake lightly, 2.0 
        if (isCanShake == true && self.allow) {
            isCanShake = false;
            [NSThread detachNewThreadSelector:@selector(backBtnPressed:) toTarget:self withObject:nil];
            self.allow = NO;
            [NSThread sleepForTimeInterval:0.8];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shakeDevice" object:nil];
        }
    }
}
@end
