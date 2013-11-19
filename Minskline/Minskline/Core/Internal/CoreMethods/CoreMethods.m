//
//  CoreMethods.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/17/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "CoreMethods.h"

@implementation CoreMethods

+ (NSString *)nameByTypeOfTransport:(TypeOfTransportEnum)type
{
    NSString *transportTypeName = nil;
    
    switch (type) {
        case BUS:
            transportTypeName = LOC(@"key.bus");
            break;
        case TROLLEYBUS:
            transportTypeName = LOC(@"key.trolleybus");
            break;
        case TRAMWAY:
            transportTypeName = LOC(@"key.tramway");
            break;
        case METRO:
            transportTypeName = LOC(@"key.metro");
            break;
        case FAVORITIES:
            transportTypeName = LOC(@"key.favorites");
            break;
    }
    
    return transportTypeName;
}

@end
