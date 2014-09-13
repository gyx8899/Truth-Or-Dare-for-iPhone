//
//  AppRaterView.m
//  Period Planner
//
//  Created by SL02 on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppRaterView.h"
#import "Appirater.h"

@implementation AppRaterView
@synthesize titleImage;
@synthesize rateBtn;
@synthesize laterBtn;
@synthesize thankBtn;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    self.titleImage.image = [UIImage imageNamed:@"rate_bg.png"];
    [self.view addSubview:self.titleImage];
}
-(IBAction)BtnPressed:(id)sender
{
	UIButton * btn = (UIButton *)sender;
	if(btn.tag == 0)
	{	
		[Appirater BtnPressed:0];
	}
	else if(btn.tag == 1)
	{	
	}
	else 
	{
		[Appirater BtnPressed:2];
	}
	[self.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[rateBtn release];
	[laterBtn release];
	[thankBtn release];
	[titleImage release];
    [super dealloc];
}


@end
