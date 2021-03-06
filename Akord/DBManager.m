//
//  DBManager.m
//  SQLLite
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "DBManager.h"

static DBManager *manager = nil;

@implementation DBManager
@synthesize dbPath;

+ (id)sharedManager {
    @synchronized(self) {
        if (manager == nil)
            manager = [[self alloc] initWithPath];
    }
    return manager;
}

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
         NSString *querySQL = [NSString stringWithFormat: @"SELECT messages.mID, messages.mDate, messages.mSize FROM messages WHERE messages.mClusterID = '\%d\' AND messages.mDate>%d AND messages.mDate<%d", clusterID, (long)[startDate timeIntervalSince1970], (long)[endDate timeIntervalSince1970]];

        
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, query_stmt, -1, &selectstmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                Message *m = [[Message alloc] init];
                
                
                m.mId = sqlite3_column_int(selectstmt, 0);
                
                NSString *typeQuerySQL = [NSString stringWithFormat: @"SELECT type, address FROM emailAddresses WHERE mID = '\%d\'", m.mId, (long)[startDate timeIntervalSince1970], (long)[endDate timeIntervalSince1970]];
                const char *query_type_stmt = [typeQuerySQL UTF8String];
                sqlite3_stmt *selectQueryStmt;
                if(sqlite3_prepare_v2(database, query_type_stmt, -1, &selectQueryStmt, NULL) == SQLITE_OK) {
                    while(sqlite3_step(selectQueryStmt) == SQLITE_ROW) {
                        int type = sqlite3_column_int(selectQueryStmt, 0);
                        switch (type) {
                            case 0:
                                [m.tos addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(selectQueryStmt, 1)]];
                                break;
                                case 2: m.froms = [NSString stringWithFormat:@"%s", sqlite3_column_text(selectQueryStmt, 1)];
                                break;
                                case 3: [m.ccs addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(selectQueryStmt, 1)]];
                                break;
                                
                            default:
                                break;
                        }
                        
                        
                    }
                    
                    sqlite3_finalize(selectQueryStmt);
                }
                
                
                m.mDate = sqlite3_column_int(selectstmt, 1);
                m.mSize = sqlite3_column_int(selectstmt, 2);
                [retVal addObject:m];
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
        NSString *querySQL = [NSString stringWithFormat: @"SELECT messages.mDate FROM messages, emailAddresses WHERE emailAddresses.address = '\%@\' AND messages.mDate>=%d AND messages.mDate<=%d AND messages.mID = emailAddresses.mID", emailAddress, (long)[startDate timeIntervalSince1970], (long)[endDate timeIntervalSince1970]];
        
        NSLog(@"%@", querySQL);
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, query_stmt, -1, &selectstmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                Message *m = [[Message alloc] init];
                
                m.mDate = sqlite3_column_int(selectstmt, 0);
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
