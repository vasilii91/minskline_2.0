//
//  MORoute.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOStop;

@interface MORoute : NSManagedObject

@property (nonatomic, retain) NSString * endName;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * routeId;
@property (nonatomic, retain) NSString * routeName;
@property (nonatomic, retain) NSString * startName;
@property (nonatomic, retain) NSString * transportNumber;
@property (nonatomic, retain) NSNumber * typeOfTransport;
@property (nonatomic, retain) NSSet *stops;
@end

@interface MORoute (CoreDataGeneratedAccessors)

- (void)addStopsObject:(MOStop *)value;
- (void)removeStopsObject:(MOStop *)value;
- (void)addStops:(NSSet *)values;
- (void)removeStops:(NSSet *)values;

@end
