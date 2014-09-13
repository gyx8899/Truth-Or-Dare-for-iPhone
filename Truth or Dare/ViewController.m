//
//  ViewController.m
//  Truth or Dare
//
//  Created by YQ-010 on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "HelpViewController.h"
#import "QuestionsViewController.h"

@implementation UINavigationBar (CustomImage)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: @"nav_bg.png"];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}
@end

//Override UITextField to move down the textRect against the bottom.
@interface MYTextField : UITextField
@end

@implementation MYTextField

//Move down textRect and lessen the width
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y + 2, bounds.size.width , bounds.size.height);
}
//Set bounds of editRect
-(CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 0, bounds.origin.y + 2, bounds.size.width - 0, bounds.size.height);
}
@end

@implementation ViewController

@synthesize pickerView;
@synthesize scrollView;
@synthesize playBtn;
@synthesize nextBtn;
@synthesize hiddenBtn;
@synthesize senderBtn;
@synthesize selectBg;
@synthesize defaultName;
@synthesize accelerometer;
@synthesize timer;
@synthesize audioPlayer;
@synthesize nullBtn;
@synthesize numPlayers;
@synthesize playerId;
@synthesize isCanShake;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)helpBtnPressed:(id)sender{
    
    HelpViewController *helpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:helpViewController] autorelease];
    [self presentModalViewController:navController animated:YES];
    [helpViewController release];
}

- (IBAction)questionsBtnPressed:(id)sender{
    QuestionsViewController *questionsViewController = [[QuestionsViewController alloc] initWithNibName:@"QuestionsViewController" bundle:nil];
    UINavigationController *n = [[[UINavigationController alloc] initWithRootViewController:questionsViewController]autorelease];
    [self presentModalViewController:n animated:YES];
    [questionsViewController release];
}

- (IBAction)playerPressed:(id)sender{
    //If keyboard is available,resign it.
    [self.view endEditing:YES];
    
    //Show all players, when the player or player name is pressed.
    [self showAllPlayers];
    
    //Create an ActionSheet and waiting user to select image for player
    self.senderBtn = (UIButton *)sender;
    UIView *playerView = self.senderBtn.superview;
    [self.selectBg setCenter:CGPointMake(playerView.center.x, playerView.center.y)];
    @autoreleasepool {
        [UIView animateWithDuration:0.5 animations:^(void){
            int rowSelectPlayer = (playerView.tag%4) ? (playerView.tag/4 + 1) :(playerView.tag/4);
            [self.scrollView setContentOffset:CGPointMake(0, (rowSelectPlayer-1)*112)];
        }];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    { 
        UIActionSheet *playerIconSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
        [playerIconSheet showInView:self.view];
        [playerIconSheet release];
    }else {
        UIActionSheet *playerIconSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo",nil];
        [playerIconSheet showInView:self.view];
        [playerIconSheet release];
    }
}

- (IBAction)hiddenPressed:(id)sender{
    if (!self.hiddenBtn.hidden) {
        //If keyboard is available,resign it.
        [self.view endEditing:YES];
        
        self.hiddenBtn.hidden = YES;
        [self.hiddenBtn setHighlighted:YES];
        @autoreleasepool {
            [UIView beginAnimations:@"Hidden" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [self.hiddenBtn setCenter:CGPointMake(self.hiddenBtn.center.x, 85 + 70)];
            self.scrollView.frame = CGRectMake(0, 20, 320, 250);
            [self.pickerView setCenter:CGPointMake(self.pickerView.center.x, 60)];
            [self.scrollView setCenter:CGPointMake(self.scrollView.center.x, 145 + 65)];
            [UIView commitAnimations];
        }
    }
}

- (IBAction)hiddenDraged:(id)sender {
    if (!self.hiddenBtn.hidden) {
        //If keyboard is available,resign it.
        [self.view endEditing:YES];
        
        self.hiddenBtn.hidden = YES;
        [self.hiddenBtn setHighlighted:YES];
        @autoreleasepool {
            [UIView beginAnimations:@"Drag" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [self.hiddenBtn setCenter:CGPointMake(self.hiddenBtn.center.x, 85 + 70)];
            self.scrollView.frame = CGRectMake(0, 20, 320, 250);
            [self.pickerView setCenter:CGPointMake(self.pickerView.center.x, 60)];
            [self.scrollView setCenter:CGPointMake(self.scrollView.center.x, 145 + 65)];
            [UIView commitAnimations];
        }
    }
}

- (IBAction)leftBtnPressed:(id)sender{  //Left button pressed
    [self removePlayer];
}

- (IBAction)rightBtnPressed:(id)sender{  //Right button pressed
    [self addPlayer];
}

- (IBAction)textFieldBegin:(id)sender{
    if (self.hiddenBtn.isHidden) {
        [self showAllPlayers];
    }
    MYTextField *playerName = (MYTextField *)sender;
    UIView *playerView = playerName.superview;
    [self.selectBg setCenter:CGPointMake(playerView.center.x, playerView.center.y)];
    @autoreleasepool {
        [UIView animateWithDuration:0.5 animations:^(void){
            int rowSelectPlayer = (playerView.tag%4) ? (playerView.tag/4 + 1) :(playerView.tag/4);
            [self.scrollView setContentOffset:CGPointMake(0, (rowSelectPlayer-1)*112)];
        }];
    }
    self.defaultName = playerName.text;
}
- (IBAction)textFieldEnd:(id)sender{
    [self adjustScrollViewHeight];
    MYTextField *playerName = (MYTextField *)sender;
    @autoreleasepool {
        [UIView animateWithDuration:0.5 animations:^(void){
            self.scrollView.frame = CGRectMake(0, 20, 320, 315);
        }];
    }
    if ([playerName.text isEqualToString:@""]) {
        playerName.text = self.defaultName;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:@"Player name cannot be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        [sender resignFirstResponder];
    }
} 

- (IBAction)shakeOrPlay:(id)sender{
    if (self.isCanShake) {
        if (self.nextBtn.hidden == YES) {
            self.nullBtn.hidden = NO;
            self.isCanShake = NO;
            
            if (self.hiddenBtn.isHidden) {
                [NSThread detachNewThreadSelector:@selector(showAllPlayers) toTarget:self withObject:nil];
                [NSThread sleepForTimeInterval:0.3]; 
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(nextBtnPressed:) userInfo:nil repeats:NO];
            self.playerId = [self selectPlayer];
            
            [self performSelector:@selector(canUseButton) withObject:nil afterDelay:1.0f];
        }
    }
}

- (IBAction)nextBtnPressed:(id)sender{
    self.playBtn.enabled = YES;
    //Stop timer
    [timer invalidate];
    //Stop audioPlayer
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
        [audioPlayer setCurrentTime:0];
    }
    PlayerViewController *playerView = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    playerView.playerId = self.playerId + 1;
    UIView *player = [self.scrollView.subviews objectAtIndex:self.playerId];
    UIButton *button = [player.subviews objectAtIndex:0];
    playerView.icon =  button.imageView.image;
    MYTextField *playerName = [player.subviews objectAtIndex:2];
    playerView.playerName = playerName.text;
    [self.navigationController pushViewController:playerView animated:YES];

}

- (void)showPlayOrShakeBtn:(NSNotification *)notifi{
    [self.hiddenBtn setEnabled:YES];
//    self.playBtn.hidden = NO;
//    self.nextBtn.hidden = YES;
}

- (void)shakeDevice:(NSNotification *)notifi{
    if (self.isCanShake) {
//        self.isCanShake = NO;
        if (!self.playBtn.hidden) {
            self.nullBtn.hidden = NO;
            if (self.hiddenBtn.isHidden) {
                [NSThread detachNewThreadSelector:@selector(showAllPlayers) toTarget:self withObject:nil];
                [NSThread sleepForTimeInterval:0.3];
            }else {
                //If keyboard is available,resign it.
                [self.view endEditing:YES];
            }
            
            timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(nextBtnPressed:) userInfo:nil repeats:NO];
            self.playerId = [self selectPlayer];
            
            [self performSelector:@selector(canUseButton) withObject:nil afterDelay:1.0f];
        }
    }
}

-(void)canUseButton{
    self.nullBtn.hidden = YES;
    self.playBtn.hidden = YES;
    self.nextBtn.hidden = NO;
    self.nextBtn.enabled = YES;
}

//Select a player randomly
- (int)selectPlayer{

    [self playMusic];
    [self.hiddenBtn setEnabled:NO];
    int count = [self.pickerView getIndex];
    int player_index;
    for (int i = 0; i < 15; i++) {
        int index = arc4random()%count + 1;
        UIView *player = [self.scrollView.subviews objectAtIndex:index - 1];
        [NSThread detachNewThreadSelector:@selector(playAnimation:) toTarget:self withObject:player];
        if (i < 14) {
            [NSThread sleepForTimeInterval:0.3];
        }
        if (i == 14) {
            player_index = index - 1;
        }
    }
    return player_index;
}

- (void)playAnimation:(UIView *)player{
    @autoreleasepool {
        [UIView animateWithDuration:0.3 animations:^(void){
            [self.selectBg setCenter:CGPointMake(player.center.x, player.center.y)];
            //Auto scroll to the selected player
            if (fabs(self.scrollView.contentOffset.y - player.center.y) > 30) {
                if (player.center.y > 150) {
                    [self.scrollView setContentOffset:CGPointMake(0, self.selectBg.center.y - 150) animated:NO];
                }else{
                    [self.scrollView setContentOffset:CGPointMake(0, self.selectBg.center.y - 60) animated:NO]; 
                }
            }
        }];
    }
    
}
- (void)playMusic{
    //Play background music
    if (![audioPlayer isPlaying]) {
        [audioPlayer play];
    }
}

- (void)showAllPlayers{
    if ([self.hiddenBtn isHidden]) {
        @autoreleasepool {
            [UIView animateWithDuration:0.3 animations:^(void){
                [self.pickerView setCenter:CGPointMake(self.pickerView.center.x, -60)];
                self.hiddenBtn.hidden = NO;
                [self.hiddenBtn setCenter:CGPointMake(self.hiddenBtn.center.x, 20)];
                self.scrollView.frame = CGRectMake(0, 90, 320, 315);
                [self.scrollView setCenter:CGPointMake(self.scrollView.center.x, 247.5 - 70)];
            }];
        }
    }
}

-(void)pressButton{
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_title.png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg.png"]];
    self.pickerView = [[HUIPickerView alloc] initWithFrame:CGRectMake(0, 10, 320, 100) row:7];
    [self.pickerView.leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView.rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pickerView];
    
    self.hiddenBtn.hidden = YES;
    UIImageView *backGroud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_pull.png"]];
    [self.hiddenBtn addSubview:backGroud];
    
    numPlayers = 1;
    //Draw players ,player number is 4
    for (int j = 1; j < 5; j++) {
        UIView *player = [[UIView alloc] initWithFrame:CGRectMake(78*(j - 1) + 8, 10, 70, 100)];
        player.tag = j;
        [self drawPlayer:player :j];
        if (j == 2) {
            self.selectBg = [[UIImageView alloc] initWithFrame:CGRectMake(78*(j - 1) + 5, 8, 75, 105)];
            self.selectBg.image = [UIImage imageNamed:@"photo_select.png"];
            [self.scrollView addSubview:self.selectBg];
        }
    }
    
    //Draw left button of the nav
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 5, 35, 35);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_question.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(questionsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *questionsBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = questionsBtn;
    [questionsBtn release];
    //Draw right button of the nav
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10, 5, 35, 35);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_help.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(helpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = helpBtn;
    [helpBtn release];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.contentSize = CGSizeMake(320, 110);
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    
    self.nextBtn.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlayOrShakeBtn:) name:@"showPlayOrShakeBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeDevice:) name:@"shakeDevice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMultiPlayer:) name:@"addMultiPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMultiPlayer:) name:@"removeMultiPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertView:) name:@"showAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNulBtn:) name:@"hideNulBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNulBtn:) name:@"displayNulBtn" object:nil];
    
    accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 0.1;
    accelerometer.delegate = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chooseplayer" ofType:@"mp3"];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *musicURL = [NSURL fileURLWithPath:path];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
        [audioPlayer setVolume:1.0];
        [audioPlayer setNumberOfLoops:0];
        [audioPlayer prepareToPlay];
    }
    
    UISwipeGestureRecognizer *dragDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenDraged:)] autorelease];
    dragDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.hiddenBtn addGestureRecognizer:dragDown];
    
    
    [self.nullBtn addTarget:self action:@selector(pressButton) forControlEvents:UIControlEventTouchUpInside];
}


- (void)viewDidUnload
{
    [self setNullBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.pickerView = nil;
    self.scrollView = nil;
    self.playBtn = nil;
    self.nextBtn = nil;
    self.hiddenBtn = nil;
    self.senderBtn = nil;
    self.selectBg = nil;
    self.defaultName = nil;
    self.accelerometer = nil;
    self.timer = nil;
    self.audioPlayer = nil;
}

- (void)dealloc{
    [hiddenBtn release];
    [playBtn release];
    [pickerView release];
    [scrollView release];
    [senderBtn release];
    [selectBg release];
    [nextBtn release];
    [timer release];
    [audioPlayer release];
    [defaultName release];
    [accelerometer release];
    [nullBtn release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isCanShake = YES;
    self.playBtn.hidden = NO;
    self.nextBtn.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    self.isCanShake = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (void)hideNulBtn:(NSNotification *)notification
{
    self.nullBtn.hidden = YES;
}

- (void)displayNulBtn:(NSNotification *)notification
{
    self.nullBtn.hidden = NO;
}

- (void)addPlayer{  //add player
    int centerX = self.pickerView.playerPicker.contentOffset.x + 52;
    if (centerX < 52*49) //而非centerX < 52*51 
    {
        //Selected index's color changed.
        int index = self.pickerView.playerPicker.contentOffset.x/52;
        UILabel *label1 = [self.pickerView.playerPicker.subviews objectAtIndex:index+2];
        label1.textColor = [UIColor colorWithRed:7/255.0 green:53/255.0 blue:69/255.0 alpha:1.0];
        UILabel *label2 = [self.pickerView.playerPicker.subviews objectAtIndex:index+3];
        label2.textColor = [UIColor colorWithRed:220/255.0 green:255/255.0 blue:142/255.0 alpha:1.0];
        
        [self.pickerView.playerPicker setContentOffset:CGPointMake(centerX, self.pickerView.playerPicker.contentOffset.y) animated:NO];
        //animated:YES 时，self.pickerView.playerPicker.contentOffset.x 不是即时修改，而是等动画结束时才更改。
        int count = [self.pickerView getIndex];// + 1;
        int row = 0;
        if (count%4 == 0) {
            row = count/4;
        }else{
            row = count/4 + 1;
        }
        UIView *player = [[UIView alloc] initWithFrame:CGRectMake(78*(count - (row - 1)*4 - 1) + 8, 112*(row - 1) + 10, 70, 100)];
        @autoreleasepool {
            [UIView animateWithDuration:0.7 animations:^(void){
                [self drawPlayer:player :count];
            }];
        }
    }else
    {
        [self showAlert:@"Number of players has reached its maximum."];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}

- (void)addMultiPlayer:(NSNotification *)notifi{
    int count = [self.pickerView getIndex];
    for (int i = 1; i <= self.pickerView.temp; i++) {
        int row = 0;
        int playerIndex = count - self.pickerView.temp + i;
        if (playerIndex%4 == 0) {
            row = playerIndex/4;
        }else{
            row = playerIndex/4 + 1;
        }
        UIView *player = [[UIView alloc] initWithFrame:CGRectMake(78*(playerIndex - (row - 1)*4 - 1) + 8, 112*(row - 1) + 10, 70, 100)];
        @autoreleasepool {
            [UIView animateWithDuration:0.7 animations:^(void){
                [self drawPlayer:player :playerIndex];
            }];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}
- (void)removePlayer{//Remove a player
    int centerX = self.pickerView.playerPicker.contentOffset.x - 52;
    if (centerX >= 0) 
    {
        //Selected index's color changed.
        int index = self.pickerView.playerPicker.contentOffset.x/52;
        UILabel *label1 = [self.pickerView.playerPicker.subviews objectAtIndex:index+2];
        label1.textColor = [UIColor colorWithRed:7/255.0 green:53/255.0 blue:69/255.0 alpha:1.0];
        UILabel *label2 = [self.pickerView.playerPicker.subviews objectAtIndex:index+1];
        label2.textColor = [UIColor colorWithRed:220/255.0 green:255/255.0 blue:142/255.0 alpha:1.0];
        
        [self.pickerView.playerPicker setContentOffset:CGPointMake(centerX, self.pickerView.playerPicker.contentOffset.y) animated:NO];//此处的animated:也要改为NO
        [[self.scrollView.subviews objectAtIndex:[self.pickerView getIndex]] removeFromSuperview];
        //
        numPlayers = numPlayers - 1;
    }else{
        [self showAlert:@"Number of players has reached its minimum."];
    }
    //调整ScrollView时，select背景框选择默认的Player2
    [self.selectBg setCenter:CGPointMake(120.5, 60.5)];
    [self adjustScrollViewHeight];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}

- (void)removeMultiPlayer:(NSNotification *)notifi{
    int count = [self.pickerView getIndex];
    int temp = -self.pickerView.temp;
    int playerIndex = 0;
    int i ;
    for (i = 1; i <= temp; i++) {
        playerIndex = count + temp - i;
        [[self.scrollView.subviews objectAtIndex:playerIndex] removeFromSuperview];
        numPlayers = numPlayers - 1;
    }
    //调整ScrollView时，select背景框选择默认的Player2
    [self.selectBg setCenter:CGPointMake(120.5, 60.5)];
    [self adjustScrollViewHeight];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}

//Draw a player with index
- (void)drawPlayer:(UIView *)player :(int)index{
    
    // Set player's tag
    player.tag = index;
    
    UIButton *player_icon = [UIButton buttonWithType:UIButtonTypeCustom];
    player_icon.frame = CGRectMake(2, 3, 66, 68);
    [player_icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"photo_%d.png", index]] forState:UIControlStateNormal];
    [player_icon addTarget:self action:@selector(playerPressed:) forControlEvents:UIControlEventTouchUpInside];
    [player insertSubview:player_icon atIndex:0];
    
    UIImageView *backGround = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_bg.png"]]autorelease];
    [player insertSubview:backGround atIndex:1];
    
    MYTextField *textName = [[[MYTextField alloc] initWithFrame:CGRectMake(5, 74, 60, 22)]autorelease];
    [textName setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"name_bg.png"]]];
    [textName setOpaque:NO];
    [textName setReturnKeyType:UIReturnKeyDone];
    textName.textAlignment = UITextAlignmentCenter;
    textName.font = [UIFont systemFontOfSize:13];
    textName.textColor = [UIColor blackColor];
    textName.text = [NSString stringWithFormat:@"Player %d", index];
    [textName addTarget:self action:@selector(textFieldEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textName addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [player insertSubview:textName atIndex:2];
    
    //判断是否在index处，再add player
    if (numPlayers == index) {
        [self.scrollView insertSubview:player atIndex:index - 1];
        numPlayers = numPlayers + 1;
    }
    [self adjustScrollViewHeight];
}

- (void)adjustScrollViewHeight
{
    //Scroll View的高度应根据所选择玩家数量动态调整
    int index = [self.pickerView getIndex];  
    int rowOfScroolView = index%4 ? index/4+1 : index/4;
    [self.scrollView setContentSize:CGSizeMake(320, rowOfScroolView*112)];
    [self.scrollView reloadInputViews];
}

//Show a alet with a msg
- (void)showAlert:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)showAlertView:(NSNotification *)notification{
    if ([self.pickerView getIndex] <= 2) {
        [self showAlert:@"Number of players has reached its minimum."];
    }
    if ([self.pickerView getIndex] >= 50) {
        [self showAlert:@"Number of players has reached its maximum."];
    }
    
}

//Get a picture by camera or PhotoLibrary
- (void)getPicture:(UIImagePickerControllerSourceType)type{
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        pickerImage.sourceType = type;
        [self presentModalViewController:pickerImage animated:YES];
        [pickerImage release];
    }
}

#pragma mark UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
}

#pragma mark UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //Take photo by camera
        [self getPicture:UIImagePickerControllerSourceTypeCamera];
    }
    if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //Chose photo from PhotoLibary
        [self getPicture:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    if (buttonIndex == 0 && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self getPicture:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [self adjustScrollViewHeight];
    @autoreleasepool {
        [UIView animateWithDuration:0.5 animations:^(void){
            self.scrollView.frame = CGRectMake(0, 20, 320, 315);
        }];
    }
}

#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    if (image != nil) {
        [self.senderBtn setImage:image forState:UIControlStateNormal];
    }
    [self adjustScrollViewHeight];
    @autoreleasepool {
        [UIView animateWithDuration:0.5 animations:^(void){
            self.scrollView.frame = CGRectMake(0, 20, 320, 315);
        }];
    }
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self adjustScrollViewHeight];
    @autoreleasepool {
        [UIView animateWithDuration:0.5 animations:^(void){
            self.scrollView.frame = CGRectMake(0, 20, 320, 315);
        }];
    }
    [picker dismissModalViewControllerAnimated:YES];
}   

#pragma mark UIAccelerometer delegate methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    if (fabsf(acceleration.x > 1.5) || fabsf(acceleration.y > 1.5) || fabsf(acceleration.z > 1.5)) {        //1.5 shake lightly, 2.0 
        if (self.isCanShake) {
            if (self.nextBtn.hidden == YES) {
                if (self.hiddenBtn.isHidden) {
                    [NSThread detachNewThreadSelector:@selector(showAllPlayers) toTarget:self withObject:nil];
                    [NSThread sleepForTimeInterval:0.3];
                }else {
                    //If keyboard is available,resign it.
                    [self.view endEditing:YES];
                }
                self.nullBtn.hidden = NO;
                self.isCanShake = NO;
                timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(nextBtnPressed:) userInfo:nil repeats:NO];
                self.playerId = [self selectPlayer];
                
                [self performSelector:@selector(canUseButton) withObject:nil afterDelay:1.0f];
            }
        }
    }
}
@end
