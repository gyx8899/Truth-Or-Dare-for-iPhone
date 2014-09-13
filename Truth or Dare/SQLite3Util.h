//
//  SQLite3Util.h
//  Truth or Dare
//
//  Created by YQ-010 on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Question.h"

#define kFileName @"TruthorDare.sqlite"

@interface SQLite3Util : NSObject{
    sqlite3_stmt *stmt;
    sqlite3 *database;
}

- (NSString *)dataFilePath;
- (int)getCountOfDB;
- (BOOL)insertOrUpdateTruthOrDare:(NSString *)sql;
- (BOOL)deleteQuestion:(NSString *)sql;
- (NSMutableArray *)getTruthOrDares:(BOOL)isTruthOrDare;
- (Question *)getQuestion:(NSInteger)questionId;
- (BOOL)openDatabase;
- (void)closeDatabase;
@end
