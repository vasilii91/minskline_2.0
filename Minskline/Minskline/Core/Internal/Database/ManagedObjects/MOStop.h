//
//  MOStop.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MORoute, MOTimetable;

@interface MOStop : NSManagedObject

@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * ordinalNumberInRoute;
@property (nonatomic, retain) NSString * stopId;
@property (nonatomic, retain) NSString * stopName;
@property (nonatomic, retain) MORoute *route;
@property (nonatomic, retain) NSSet *timetables;
@end

@interface MOStop (CoreDataGeneratedAccessors)

- (void)addTimetablesObject:(MOTimetable *)value;
- (void)removeTimetablesObject:(MOTimetable *)value;
- (void)addTimetables:(NSSet *)values;
- (void)removeTimetables:(NSSet *)values;

@end
