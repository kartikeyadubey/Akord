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

-(id) initWithPath
{
    self = [super init];
    if(self)
    {
        self.dbPath = [[NSBundle mainBundle] pathForResource:@"EmailData-CMU" 
                                                       ofType:@"sqlite"];
    }
    return self;
}


/*
 * Get all clusters from the param specified start and end dates
 */
-(NSMutableArray*) getClustersFromStartDate:(NSDate*) startDate andEndDate:(NSDate *)endDate
{  
    NSMutableArray *retVal = [[NSMutableArray alloc] init];

    struct sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT clusters.clusterID, clusters.peopleList, clusters.numberOfMessages FROM clusters, messages WHERE messages.mClusterID = clusters.clusterID AND messages.mDate>%d AND messages.mDate<%d GROUP BY clusters.clusterID", (long)[startDate timeIntervalSince1970], (long)[endDate timeIntervalSince1970]];
        
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, query_stmt, -1, &selectstmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                Cluster *c = [[Cluster alloc] init];
                int clusterID = sqlite3_column_int(selectstmt, 0);
                
                NSString *peopleList = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                int numMessages = sqlite3_column_int(selectstmt, 2);
                c.clusterId = clusterID;
                c.emailAddresses = [peopleList componentsSeparatedByString: @","];
                c.numberOfMessages = numMessages;
                
                NSString *sizeSQL = [NSString stringWithFormat:@"SELECT AVG(mDate) FROM messages WHERE mClusterID=%d AND mDate>%d AND mDate<%d", clusterID, (long)[startDate timeIntervalSince1970], (long)[endDate timeIntervalSince1970]];
                
                const char *size_query = [sizeSQL UTF8String];
                sqlite3_stmt *size_stmt;
                if(sqlite3_prepare_v2(database, size_query, -1, &size_stmt, NULL) == SQLITE_OK){
                    while(sqlite3_step(size_stmt) == SQLITE_ROW){
                        int mSize = sqlite3_column_int(size_stmt, 0);
                        c.averageTime = mSize;
                    }
                }
                sqlite3_finalize(size_stmt);
                [retVal addObject:c];
            }
            sqlite3_finalize(selectstmt);
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

/*
 * Get the details of a cluster based on a clusterID
 */
-(Cluster*) getClusterWithId:(int)clusterID
{
    Cluster *retVal = [[Cluster alloc] init];
    
    struct sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {

        NSString *querySQL = [NSString stringWithFormat: @"SELECT peopleList, numberOfMessages FROM clusters WHERE clusterID = '\%d\'", clusterID];
        
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, query_stmt, -1, &selectstmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                int clusterID = sqlite3_column_int(selectstmt, 0);
                NSString *peopleList = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                int numMessages = sqlite3_column_int(selectstmt, 2);
                retVal.clusterId = clusterID;
                retVal.emailAddresses = [peopleList componentsSeparatedByString: @","];
                retVal.numberOfMessages = numMessages;                
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

/*
 * Get all the emails for a given clusterID within a given time period
 */
-(NSMutableArray*) getMessagesForClusterWithID:(int)clusterID fromStartDate:(NSDate *)startDate andEndDate :(NSDate *)endDate
{
    NSMutableArray* retVal = [[NSMutableArray alloc] init];
    struct sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {               
         NSString *querySQL = [NSString stringWithFormat: @"SELECT messages.mID, messages.mDate, messages.mSubject, messages.mBody, messages.mSize, messages.mIsUnread, clusters.peopleList FROM messages, clusters WHERE messages.mClusterID = '\%d\' AND messages.mDate>%d AND messages.mDate<%d", clusterID, (long)[startDate timeIntervalSince1970], (long)[endDate timeIntervalSince1970]];

        
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, query_stmt, -1, &selectstmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                Message *m = [[Message alloc] init];
                
                m.mId = sqlite3_column_int(selectstmt, 0);
                m.mDate = sqlite3_column_int(selectstmt, 1);
                m.mSubject = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                m.mBody = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                m.mSize = sqlite3_column_int(selectstmt, 5);
                m.mIsUnread = sqlite3_column_int(selectstmt, 6);   
                m.emailAddresses = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)] componentsSeparatedByString:@","];
                [retVal addObject:m];
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
    
    
    return retVal;
}


/*
 * Get all the messages for a given person within a given time period
 */
-(NSMutableArray*) getMessagesForPerson:(NSString*)emailAddress fromStartDate:(NSDate *)startDate andEndDate :(NSDate *)endDate
{
    NSMutableArray* retVal = [[NSMutableArray alloc] init];
    struct sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {               
        NSString *querySQL = [NSString stringWithFormat: @"SELECT messages.mDate FROM messages, emailAddresses WHERE emailAddresses.address = '\%@\' AND messages.mDate>=%d AND messages.mDate<=%d AND messages.mID = emailAddress.mID", emailAddress, (long)[startDate timeIntervalSince1970], (long)[endDate timeIntervalSince1970]];
        
        
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, query_stmt, -1, &selectstmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                Message *m = [[Message alloc] init];
                
                m.mId = sqlite3_column_int(selectstmt, 0);
                [retVal addObject:m];
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
    
    
    return retVal;
}



- (NSArray*) getMinAndMaxTime{

NSArray* retVal;
struct sqlite3 *database;
if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
    
    NSString *querySQL = @"SELECT MIN(mDate), MAX(mDate) FROM messages";
    
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *selectstmt;
    if(sqlite3_prepare_v2(database, query_stmt, -1, &selectstmt, NULL) == SQLITE_OK) {
        while(sqlite3_step(selectstmt) == SQLITE_ROW) {
            retVal = [NSArray arrayWithObjects:[NSNumber numberWithLong:sqlite3_column_int(selectstmt, 0)], [NSNumber numberWithLong:sqlite3_column_int(selectstmt, 1)], nil];
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

return retVal;
}

@end
