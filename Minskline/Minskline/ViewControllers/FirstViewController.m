//
//  FirstViewController.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/8/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "FirstViewController.h"
#import "DownloadManager.h"
#import "DatabaseManager.h"
#import "MORoute.h"

@interface FirstViewController ()

@end

@implementation FirstViewController


#pragma mark - ViewController's lifestyle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
//    [[DownloadManager sharedMySingleton] downloadTimetableFromMinsktrans];
    
    [self initializeComponentsWithTypeOfTransport:BUS];
}

- (void)initializeComponentsWithTypeOfTransport:(TypeOfTransportEnum)typeOfTransport
{
    NSArray *allRoutes = [[DatabaseManager sharedMySingleton] allRoutesByType:typeOfTransport];
    
    for (int i = 0; i < [allRoutes count]; i++) {
        
        MORoute *route = allRoutes[i];
        NSInteger indexInRow = i % 5;
        NSInteger row = i / 5;
        NSInteger buttonDimension = IDEVICE_WIDTH / 5;
        
        UIButton *buttonRoute = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonRoute setBackgroundColor:[UIColor yellowColor]];
        buttonRoute.frame = CGRectMake(indexInRow * buttonDimension,
                                       row * buttonDimension,
                                       buttonDimension,
                                       buttonDimension);
        [buttonRoute setTitle:route.transportNumber forState:UIControlStateNormal];
        
        LOG(@"%@, %@", route.transportNumber, route.routeName);
        [self.view addSubview:buttonRoute];
    }
//    LOG(@"%@", allRoutes);
}


#pragma mark -

@end
