//
//  UserSettings.h
//  Locker
//
//  Created by Vasilii Kasnitski on 11/23/12.
//  Copyright (c) 2012 OCSICO. All rights reserved.
//

#import <Foundation/Foundation.h>
  
@interface UserSettings : NSObject

+ (UserSettings *)sharedSingleton;

@property (nonatomic, assign) NSInteger interval;

@end
