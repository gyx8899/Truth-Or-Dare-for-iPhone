//
//  SQLite3Util.m
//  Truth or Dare
//  You can insert,update,query or delete data by this class.
//  Created by YQ-010 on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SQLite3Util.h"
@implementation SQLite3Util


//Return Database path
- (NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFileName];
}

//Insert or update data
- (BOOL)insertOrUpdateTruthOrDare:(NSString *)sql{
    if ([self openDatabase]) {
        if (sqlite3_exec(database, [sql UTF8String], nil, &stmt, nil) != SQLITE_OK) {
            return NO;
        }else{
//            sqlite3_finalize(stmt);
            return YES;
        }
        sqlite3_close(database);
    }
    return NO;
}

//Delete a question from database
- (BOOL)deleteQuestion:(NSString *)sql{
    if ([self openDatabase]) {
        if (sqlite3_exec(database, [sql UTF8String], nil, &stmt, nil) != SQLITE_OK) {
            return NO;
        }else{
            sqlite3_finalize(stmt);
            return YES;
        }
        sqlite3_close(database);
    }
    return NO;
}
//Get truth or dare questions
- (NSMutableArray *)getTruthOrDares:(BOOL)isTruthOrDare{
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    NSString *sql = [[[NSString alloc]init]autorelease];
    //Get truth questions
    if (isTruthOrDare == YES) {
        sql = [NSString stringWithFormat:@"SELECT * FROM TruthorDare WHERE TOrD = 'truth'"]; 
    }
    //Get dare questions
    if (isTruthOrDare == NO) {
        sql = [NSString stringWithFormat:@"SELECT * FROM TruthorDare WHERE TOrD = 'dare'"]; 
    }
    if ([self openDatabase]) {
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                Question *question = [[Question alloc] init];
                char *content = (char *)sqlite3_column_text(stmt, 0);
                [question setContent:[NSString stringWithUTF8String:content]];
                char *truthOrDare = (char *)sqlite3_column_text(stmt, 1);
                [question setTruthOrDare:[NSString stringWithUTF8String:truthOrDare]];
                char *index = (char *)sqlite3_column_text(stmt, 2);
                [question setId:[[NSString stringWithUTF8String:index] intValue]];
                [questions addObject: question];
            }
            sqlite3_finalize(stmt);
        }
    }
    sqlite3_close(database);
    return questions;
}

//Get count of the TruthOrDare table
- (int)getCountOfDB{
    int count = 0;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM TruthorDare"]; 
    if ([self openDatabase]) {
        int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil);
        if (result == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                count ++;
            }
            sqlite3_finalize(stmt);
        } else {
        }
    }
    return count;
}

- (Question *)getQuestion:(NSInteger)questionId{
    Question *question = [[Question alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM TruthorDare WHERE id = %i", questionId];
    if ([self openDatabase]) {
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {

            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *content = (char *)sqlite3_column_text(stmt, 0);
                [question setContent:[NSString stringWithUTF8String:content]];
                char *truthOrDare = (char *)sqlite3_column_text(stmt, 1);
                [question setTruthOrDare:[NSString stringWithUTF8String:truthOrDare]];
                [question setId:questionId];
            }
            sqlite3_finalize(stmt);
        }
    }
    return question;
}

- (BOOL)openDatabase{
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
        return YES;
    }
    return NO;
}

- (void)closeDatabase{
    sqlite3_close(database);
}
@end
