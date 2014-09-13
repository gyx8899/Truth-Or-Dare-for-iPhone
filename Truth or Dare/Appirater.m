/*
 This file is part of Appirater.
 Copyright (c) 2010, Arash Payan
 All rights reserved.
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
/*
 * Appirater.m
 * appirater
 *
 * Created by Arash Payan on 9/5/09.
 * http://arashpayan.com
 * Copyright 2010 Arash Payan. All rights reserved.
 */

#import "Appirater.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "AppRaterView.h"
#import "AppDelegate.h"
//#import "passcodeEnterViewController.h"
#import "ViewController.h"

NSString *const kAppiraterLaunchDate = @"kAppiraterLaunchDate";
NSString *const kAppiraterLaunchCount = @"kAppiraterLaunchCount";
NSString *const kAppiraterCurrentVersion = @"kAppiraterCurrentVersion";
NSString *const kAppiraterRatedCurrentVersion = @"kAppiraterRatedCurrentVersion";
NSString *const kAppiraterDeclinedToRate = @"kAppiraterDeclinedToRate";

NSString *templateReviewURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";

@interface Appirater (hidden)
- (BOOL)connectedToNetwork;
@end

@implementation Appirater (hidden)
- (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[[NSURLConnection alloc] initWithRequest:testRequest delegate:self] autorelease];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

@end


@implementation Appirater
@synthesize successAlert;
+ (void)appLaunched {
	Appirater *appirater = [[Appirater alloc] init];
	[NSThread detachNewThreadSelector:@selector(_appLaunched) toTarget:appirater withObject:nil];
}

- (void)_appLaunched {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if (APPIRATER_DEBUG)
	{
		[self performSelectorOnMainThread:@selector(showPrompt) withObject:nil waitUntilDone:NO];
		
		return;
	}
	
	BOOL willShowPrompt = NO;
	
	// get the app's version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
	}
	
	if (APPIRATER_DEBUG)
        NSLog(@"APPIRATER Tracking version: %@", trackingVersion);
	if ([trackingVersion isEqualToString:version])
	{
		// get the launch date
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kAppiraterLaunchDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kAppiraterLaunchDate];
		}
		
		NSTimeInterval secondsSinceLaunch = [[NSDate date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
		double secondsUntilPrompt = 60 * 60 * 24 * DAYS_UNTIL_PROMPT;
		
		// get the launch count
		int launchCount = [userDefaults integerForKey:kAppiraterLaunchCount];
		launchCount++;
		[userDefaults setInteger:launchCount forKey:kAppiraterLaunchCount];
		if (APPIRATER_DEBUG)
			NSLog(@"APPIRATER Launch count: %d", launchCount);
		
		// have they previously declined to rate this version of the app?
		BOOL declinedToRate = [userDefaults boolForKey:kAppiraterDeclinedToRate];
		
		// have they already rated the app?
		BOOL ratedApp = [userDefaults boolForKey:kAppiraterRatedCurrentVersion];
//		NSInteger launchesCounts = LAUNCHES_UNTIL_PROMPT;
		if (secondsSinceLaunch > secondsUntilPrompt &&
			launchCount > LAUNCHES_UNTIL_PROMPT &&
			!declinedToRate &&
			!ratedApp)
		{
			if ([self connectedToNetwork]) // check if they can reach the app store
			{
				willShowPrompt = YES;
				[self performSelectorOnMainThread:@selector(showPrompt) withObject:nil waitUntilDone:NO];
			}
		}
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
		[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kAppiraterLaunchDate];
		[userDefaults setInteger:1 forKey:kAppiraterLaunchCount];
		[userDefaults setBool:NO forKey:kAppiraterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
	}
	[userDefaults synchronize];
	if (!willShowPrompt)
		[self autorelease];
	
	[pool release];
}

- (void)showPrompt {
	AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
	AppRaterView * raterView = [[[AppRaterView alloc] initWithNibName:@"AppRaterView" bundle:nil] autorelease];
    CGRect f = CGRectOffset(raterView.view.frame, 0.0, 20.0);
    raterView.view.frame = f;
    [appDelegate.window addSubview:raterView.view];
}
+(void)BtnPressed:(int)btnIndex
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if(btnIndex == 0)
	{
		NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:APPIRATER_APP_ID];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
		
		[userDefaults setBool:YES forKey:kAppiraterRatedCurrentVersion];
	}
	else if(btnIndex == 2)
	{
		[userDefaults setBool:YES forKey:kAppiraterDeclinedToRate];
	}
	[userDefaults synchronize];
	[self release];
}


@end