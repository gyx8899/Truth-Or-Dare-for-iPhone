//
//  QuestionsViewController.h
//  Truth or Dare
//
//  Created by YQ-010 on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "SQLite3Util.h"
#import "Question.h"
#import "BSSegmentedControl.h"

#define kFilename    @"TruthorDare.sqlite"

@interface QuestionsViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
    NSInteger quesType;
}
@property (nonatomic, retain) IBOutlet UITableView *yQTableView;
@property (nonatomic, retain) BSSegmentedControl *truthOrDare;
@property (nonatomic, retain) NSMutableArray *truthArray;
@property (nonatomic, retain) NSMutableArray *dareArray;
@property (nonatomic, retain) NSArray *listData;
- (IBAction)homeBtnPressed:(id)sender;
- (IBAction)addBtnPressed:(id)sender;
- (IBAction)switchTruthOrDare:(UISegmentedControl *)segmentedControl;

- (void)initView;
- (void)refresh:(NSNotification *)notifi;
@end
