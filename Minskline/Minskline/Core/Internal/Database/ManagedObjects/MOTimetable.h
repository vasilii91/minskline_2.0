//
//  MOTimetable.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/10/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOStop;

@interface MOTimetable : NSManagedObject

@property (nonatomic, retain) NSNumber * dayOfWeek;
@property (nonatomic, retain) NSDate * lastModifiedDate;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * urlToTimetable;
@property (nonatomic, retain) MOStop *stop;

@end
