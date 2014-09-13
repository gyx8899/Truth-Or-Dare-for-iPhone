//
//  QuestionsViewController.m
//  Truth or Dare
//
//  Created by YQ-010 on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionsViewController.h"
#import "AddOrEditQuesController.h"

@implementation UINavigationBar (CustomImage)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: @"nav_bg.png"];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}

@end

@implementation QuestionsViewController

@synthesize yQTableView;
@synthesize truthOrDare;
@synthesize listData;
@synthesize truthArray;
@synthesize dareArray;

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

- (IBAction)addBtnPressed:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Truth", @"Add Dare", nil];
    [sheet showInView:self.view];
    [sheet release];
}
- (IBAction)homeBtnPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)switchTruthOrDare:(UISegmentedControl *)segmentedControl{
    NSInteger index = segmentedControl.selectedSegmentIndex;
//    NSLog(@"index = %d", index);
    if (index == 0) {//Truth is selected
        [self.truthOrDare setImage:[UIImage imageNamed:@"btn_truth_unselect.png"] forSegmentIndex:0];
        [self.truthOrDare setImage:[UIImage imageNamed:@"btn_dare_select.png"] forSegmentIndex:1];
        self.listData = self.truthArray;
        [self.yQTableView reloadData];
    }else{           //Dare is selected
        [self.truthOrDare setImage:[UIImage imageNamed:@"btn_truth_select.png"] forSegmentIndex:0];
        [self.truthOrDare setImage:[UIImage imageNamed:@"btn_dare_unselect.png"] forSegmentIndex:1];
        self.listData = self.dareArray;
        [self.yQTableView reloadData];
    }
}

//Refresh tableView after edit or add question.
- (void)refresh:(NSNotification *)notifi{
    [self.truthOrDare setHidden:NO];
    SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
    if (quesType == 1 || quesType == 3 ) {
        self.truthOrDare.selectedSegmentIndex = 0;
        self.truthArray = [sqlUtil getTruthOrDares:YES];
        self.listData = self.truthArray;
    }else{
        self.truthOrDare.selectedSegmentIndex = 1;
        self.dareArray = [sqlUtil getTruthOrDares:NO];
        self.listData = self.dareArray;
    }
    [self.yQTableView reloadData];
    [sqlUtil release];
//    NSLog(@"refreshing...");
}

//Init view
- (void)initView{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg.png"]];
    
    //Add UISegmentedControl
    self.truthOrDare = [[BSSegmentedControl alloc] init];
    NSArray *array = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"btn_truth_unselect.png"], [UIImage imageNamed:@"btn_dare_select.png"], nil];
    [self.truthOrDare initWithItems:array];
    [array release];
    [self.truthOrDare setSelectedSegmentIndex:0];
    [self.truthOrDare addTarget:self action:@selector(switchTruthOrDare:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:self.truthOrDare];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 5, 35, 35);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_home.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(homeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = homeBtn;
    [homeBtn release];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10, 5, 35, 35);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = addBtn;
    [addBtn release];
    
    [self.yQTableView setBackgroundColor:[UIColor clearColor]];
    
    SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
    self.truthArray = [sqlUtil getTruthOrDares:YES];
    self.dareArray = [sqlUtil getTruthOrDares:NO];
    self.listData = truthArray;
//    NSLog(@"truthArray.count = %d",truthArray.count);
    [sqlUtil release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init View.
    [self initView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.yQTableView = nil;
    self.truthOrDare = nil;
    self.truthArray = nil;
    self.dareArray = nil;
    self.listData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    [yQTableView release];
    [truthArray release];
    [truthOrDare release];
    [dareArray release];
    [listData release];
    [super dealloc];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *truthCellIdentifier = @"TruthCellIdentifier";
    static NSString *dareCellIdentifier  = @"DareCellIdentifier";
//    UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
    UITableViewCell *cell;
    if (self.truthOrDare.selectedSegmentIndex == 0) {//Truth button is selected
        cell = [tableView dequeueReusableCellWithIdentifier:truthCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:truthCellIdentifier];
        }
    }else{              //Dare button is selected
        cell = [tableView dequeueReusableCellWithIdentifier:dareCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dareCellIdentifier];
        }
    }
    UIImageView *backGround = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
    [cell setBackgroundView:backGround];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSInteger row = [indexPath section];
    [cell.textLabel setNumberOfLines:2];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Question *question = [self.listData objectAtIndex:row];
    cell.textLabel.text = question.content;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) { //Delete a row
        NSInteger row = [indexPath section];
        Question *question = [self.listData objectAtIndex:row];
        SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
        [sqlUtil deleteQuestion:[NSString stringWithFormat:@"DELETE FROM TruthorDare WHERE id=%d", question.id]];
        if (self.truthOrDare.selectedSegmentIndex == 1) {//Delete a dare questions
            [self.dareArray removeObjectAtIndex:row];
            self.listData = self.dareArray;
        
        }else{//Delete a truth question
            [self.truthArray removeObjectAtIndex:row];
            self.listData = self.truthArray;
        }
        [sqlUtil release];
        [self.yQTableView deleteSections:[NSIndexSet indexSetWithIndex:row] withRowAnimation:UITableViewRowAnimationFade];
    }
}
//Return section number of tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listData count];
}

//Return cell hight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath section];
    Question *question = [self.listData objectAtIndex:row];
    AddOrEditQuesController *editTrueOrDare = [[[AddOrEditQuesController alloc] initWithNibName:@"AddOrEditQuesController" bundle:nil] autorelease];
    if (self.truthOrDare.selectedSegmentIndex == 0) {//Edit truth
        editTrueOrDare.title = @"Edit Truth";
        quesType = editTrueOrDare.type = 3;
    }else{//Edit dare
        editTrueOrDare.title = @"Edit Dare";
        quesType = editTrueOrDare.type = 4;
    }
    editTrueOrDare.content = question.content;  
    editTrueOrDare.id = question.id;     //id is the index of the current content
    [self.truthOrDare setHidden:YES];
    [self.navigationController pushViewController:editTrueOrDare animated:YES];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AddOrEditQuesController *addTrueOrDare = [[[AddOrEditQuesController alloc] initWithNibName:@"AddOrEditQuesController" bundle:nil] autorelease];
    if (buttonIndex == [actionSheet firstOtherButtonIndex]) {
        addTrueOrDare.title = @"Add Truth";
        addTrueOrDare.content = @"";
        quesType = addTrueOrDare.type = 1;
        [self.truthOrDare setHidden:YES];
        [self.navigationController pushViewController:addTrueOrDare animated:YES];
//        [addTrueOrDare release];
    }
    if (buttonIndex == 1) {
        addTrueOrDare.title = @"Add Dare";
        addTrueOrDare.content = @"";
        quesType = addTrueOrDare.type = 2;
        [self.truthOrDare setHidden:YES];
        [self.navigationController pushViewController:addTrueOrDare animated:YES];
//        [addTrueOrDare release];
    }
}
@end
