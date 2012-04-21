//
//  DBManager.m
//  SQLLite
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

-(void) displayData:(NSString*) dbPath
{
    struct sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        const char *sql = "SELECT mFrom FROM inbox";
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                NSString *receivedSubject = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                NSLog(@"Subject: %@", receivedSubject);
                
            }
        }
    }
    sqlite3_close(database); //Release the object
}


-(NSMutableArray*) getClustersFromDB:(NSString*) dbPath
{
    NSMutableArray *retVal = [[NSMutableArray alloc]init];
    
    struct sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        const char *sql = "SELECT * FROM clusters";
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //Extract cluster information and make a Cluster object              
                int clusterID = sqlite3_column_int(selectstmt, 0);
                NSString *peopleList = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                int numberOfMessages = sqlite3_column_int(selectstmt, 2);
                Cluster *c = [[Cluster alloc] initWithEmailAddress:[peopleList componentsSeparatedByString:@","] andClusterId:clusterID andNumberOfMessages:numberOfMessages];
                
                [retVal addObject:c];                
            }
        }
    }
    sqlite3_close(database); //Release the object
    
    return retVal;
}

@end
