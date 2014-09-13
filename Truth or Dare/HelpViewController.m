//
//  HelpViewController.m
//  Truth or Dare
//
//  Created by YQ-010 on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>


#define kDuration 0.75   // 动画持续时间(秒)

@implementation UINavigationBar (CustomImage)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: @"nav_bg.png"];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}
@end

@implementation HelpViewController

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

- (IBAction)homeBtnPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)contactBtnPressed:(id)sender {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    [picker setSubject:@"Pocket Truth or Dare Support"];
    
    // Custom NavgationBar background
    picker.navigationBar.tintColor = [UIColor colorWithRed:209.0/255 green:183.0/255 blue:126.0/255 alpha:1.0];
//    picker.navigationBar.tintColor = [UIColor colorWithRed:178.0/255 green:173.0/255 blue:170.0/255 alpha:1.0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"maxwellsoftware@gmail.com"]; 
	
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
    struct utsname device_info;
    uname(&device_info);
    NSString *emailBody = [NSString 
            stringWithFormat:@"Model: %s\nVersion: %@\nApp: %@\nFeedback here:\n",device_info.machine, 
            [[UIDevice currentDevice] systemVersion],
            [[[NSBundle mainBundle] infoDictionary]
             objectForKey:@"CFBundleShortVersionString"]];
    
	[picker setMessageBody:emailBody isHTML:NO];
   
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg   
{  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_   
                                                    message:msg   
                                                   delegate:nil   
                                          cancelButtonTitle:@"Sure"   
                                          otherButtonTitles:nil];  
    [alert show];  
    [alert release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
//    NSString *title = @"Mail";
//    NSString *msg;
//    switch (result)  
//    {  
//        case MFMailComposeResultCancelled:  
//            msg = @"Mail canceled";//@"邮件发送取消";  
//            break;  
//        case MFMailComposeResultSaved:  
//            msg = @"Mail saved";//@"邮件保存成功";  
//            [self alertWithTitle:title msg:msg];  
//            break;  
//        case MFMailComposeResultSent:  
//            msg = @"Mail sent";//@"邮件发送成功";  
//            [self alertWithTitle:title msg:msg];  
//            break;  
//        case MFMailComposeResultFailed:  
//            msg = @"Mail failed";//@"邮件发送失败";  
//            [self alertWithTitle:title msg:msg];  
//            break;  
//        default: 
//            msg = @"Mail not sent";
//            [self alertWithTitle:title msg:msg];
//            break;  
//    }  
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - UIAlertView 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:maxwellsoftware@gmail.com&subject=Pocket Truth or Dare Support";
	NSString *body = @"&body=email body!";
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg.png"]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 135, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor yellowColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = @"Help";
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 35, 35);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_home.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(homeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = homeBtn;
    [homeBtn release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
