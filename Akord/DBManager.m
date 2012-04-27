//
//  DBManager.m
//  SQLLite
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
@synthesize dbPath;

-(NSMutableArray*) getClustersFromDB:(NSDate*) startDate andEndDate:(NSDate *)endDate
{  
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    dbPath = @"/Users/kickdgrass/Dropbox/akord/EmailData.sqlite";
    struct sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        //NSString *querySQL = [NSString stringWithFormat: @"SELECT clusters.clusterID, clusters.peopleList, clusters.numberOfMessages FROM clusters, messages WHERE messages.mDate >= \"%d\" AND messages.mDate <= \"%d\" AND messages.mClusterID = clusters.clusterID", [startDate timeIntervalSince1970], [endDate timeIntervalSince1970]];
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT clusters.clusterID, clusters.peopleList, clusters.numberOfMessages FROM clusters, messages WHERE  messages.mClusterID = clusters.clusterID"];
        
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"Query: %s", query_stmt);
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, query_stmt, -1, &selectstmt, NULL) == SQLITE_OK) {
            NSLog(@"Query Successful");
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                Cluster *c = [[Cluster alloc] init];
                int clusterID = sqlite3_column_int(selectstmt, 0);
                //TODO split list into an array
                NSString *peopleList = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                int numMessages = sqlite3_column_int(selectstmt, 2);
                c.clusterId = clusterID;
                c.emailAddresses = [peopleList componentsSeparatedByString: @","];
                c.numberOfMessages = numMessages;
                //NSLog(@"People List: %@", peopleList);
                
                [retVal addObject:c];
                
            }
        }
        else
        {
            NSLog(@"Mysql error: %s", sqlite3_errmsg(database));
        }
    }
    else
    {
        NSLog(@"Mysql error: %@", sqlite3_errmsg(database));
    }
    
    sqlite3_close(database); //Release the object
    return  retVal;
}

@end
