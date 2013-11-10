//
//  DownloadManager.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DatabaseManager, TimetableManager;

@interface DownloadManager : NSObject<NSURLConnectionDelegate>
{
    DatabaseManager *databaseManager;
    TimetableManager *timetableManager;
}

+ (DownloadManager *)sharedMySingleton;
- (void)downloadTimetableFromMinsktrans;

@end
