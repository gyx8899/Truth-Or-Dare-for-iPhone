//
//  AddOrEditQuesController.m
//  Truth or Dare
//
//  Created by YQ-010 on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddOrEditQuesController.h"

@implementation AddOrEditQuesController
@synthesize textView;
@synthesize content;
@synthesize id;
@synthesize type;

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

- (IBAction)cancelBtnPressed:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (IBAction)saveBtnPressed:(id)sender{
    //Save truth or dare question of user add or edit.
    SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
    NSString *sql = [[[NSString alloc] init] autorelease];
    NSString *msg = [[[NSString alloc] init] autorelease];
    switch (type) {
        case 1://Add truth
            sql = [NSString stringWithFormat:@"INSERT INTO TruthorDare(content, TOrD, id) values('%@', '%@', %d)", self.textView.text, @"truth", [sqlUtil getCountOfDB] + 1];
            msg = @"Truth cannot be empty.";
            break;
        case 2://Add dare
            sql = [NSString stringWithFormat:@"INSERT INTO TruthorDare(content, TOrD, id) values('%@', '%@', %d)", self.textView.text, @"dare", [sqlUtil getCountOfDB] + 1];
            msg = @"Dare cannot be empty.";
            break;
        case 3://Edit truth
            sql = [NSString stringWithFormat:@"REPLACE INTO TruthorDare(content, TOrD, id) values('%@', '%@', %d)", self.textView.text, @"truth", self.id];
            msg = @"Truth cannot be empty.";
            break;
        case 4://Edit dare
            sql = [NSString stringWithFormat:@"REPLACE INTO TruthorDare(content, TOrD, id) values('%@', '%@', %d)", self.textView.text, @"dare", self.id];
            msg = @"Dare cannot be empty.";
            break;
        default:
            break;
    }
    if ([self.textView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        if ([sqlUtil insertOrUpdateTruthOrDare:sql]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
            [self.navigationController popViewControllerAnimated:YES]; 
        }
    }
    [sqlUtil release]; 
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
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = self.title;
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 5, 35, 35);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_cancel.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    [cancelBtn release];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10, 5, 35, 35);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_save.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = saveBtn;
    [saveBtn release];
    
    [self.textView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"textview_bg.png"]]];
    [self.textView setOpaque:NO];
    self.textView.text = content;
    [self.textView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.content = nil;
    self.textView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    [content release];
    [textView release];
    [super dealloc];
}
@end
