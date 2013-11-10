//
//  DatabaseManager.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "DatabaseManager.h"
#import "MORoute.h"
#import "MOStop.h"
#import "MOTimetable.h"

static NSString *fTransportNumber = @"transportNumber";
static NSString *fTypeOfTransport = @"typeOfTransport";

@implementation DatabaseManager

static DatabaseManager *_sharedMySingleton = nil;

- (id)init
{
    self = [super init];
    if (self) {
        currentManagedObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    
    return self;
}

+ (DatabaseManager *)sharedMySingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[DatabaseManager alloc] init];
        }
    }
    
    return _sharedMySingleton;
}

- (NSManagedObject *)createEntityByClass:(Class)klass
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(klass) inManagedObjectContext:currentManagedObjectContext];
}

- (MORoute *)newRoute
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([MORoute class]) inManagedObjectContext:currentManagedObjectContext];
}

- (MOStop *)newStop
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([MOStop class]) inManagedObjectContext:currentManagedObjectContext];
}

- (MOTimetable *)newTimetable
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([MOTimetable class]) inManagedObjectContext:currentManagedObjectContext];
}

- (void)saveAll
{
    NSError *error = nil;
    [currentManagedObjectContext save:&error];
}

- (NSArray *)allRoutes
{
    return [MORoute MR_findAll];
}

- (NSArray *)allRoutesByType:(TypeOfTransportEnum)typeOfTransport
{
    NSArray *routes = [MORoute MR_findByAttribute:fTypeOfTransport withValue:@(typeOfTransport) inContext:currentManagedObjectContext];
    
    return routes;
}
//
//- (NSArray *)allAttemptsByIsWasShown:(BOOL)isWasShown
//{
//    return [Attempts findByAttribute:@"isWasShown" withValue:@(isWasShown) inContext:currentManagedObjectContext];
//}
//
//- (NSArray *)allContacts
//{
//    BOOL isDecoy = [[UserSettings sharedSingleton] isDecoy];
//    NSArray *contacts = [Contacts findByAttribute:@"isDecoy" withValue:@(isDecoy) andOrderBy:@"orderNumber" ascending:YES inContext:currentManagedObjectContext];
//    
//    return contacts;
//}
//
//- (NSArray *)allNotes
//{
//    BOOL isDecoy = [[UserSettings sharedSingleton] isDecoy];
//    NSArray *notes = [Notes findByAttribute:@"isDecoy" withValue:@(isDecoy) andOrderBy:@"orderNumber" ascending:YES inContext:currentManagedObjectContext];
//    
//    return notes;
//}

@end
