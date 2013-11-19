//
//  TimetableViewController.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/15/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "TimetableViewController.h"
#import "DownloadManager.h"
#import "DatabaseManager.h"
#import "MORoute.h"

#import "RouteNumberView.h"
#import "RoutesView.h"
#import "StopsView.h"

@interface TimetableViewController ()

@end

@implementation TimetableViewController


#pragma mark - ViewController's lifestyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    [[DownloadManager sharedMySingleton] downloadTimetableFromMinsktrans];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUserSelectedRoute:)
                                                 name:USER_SELECTED_ROUTE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUserSelectedStop:)
                                                 name:USER_SELECTED_STOP
                                               object:nil];
    
    shownContainerRect = CGRectMake(ViewX(containerView),
                                    ViewY(containerView),
                                    ViewWidth(containerView),
                                    IDEVICE_HEIGHT - ViewY(containerView));
    hiddenLeftContainerRect = shownContainerRect;
    hiddenLeftContainerRect.origin.x = -IDEVICE_WIDTH;
    
    hiddenRightContainerRect = shownContainerRect;
    hiddenRightContainerRect.origin.x = IDEVICE_WIDTH;
    
    [self initializeComponentsWithTypeOfTransport:BUS];
    currentActiveView = scrollViewRouteNumbers;
}


#pragma mark - Actions

- (IBAction)clickOnTypeOfTransportButton:(UIButton *)sender
{
    TypeOfTransportEnum typeOfTransport = sender.tag;
    
    if (typeOfTransport == FAVORITIES) {
        [self initRoutesViewByRouteNumber:@"" typeOfTransport:FAVORITIES];
        [self showRoutesView];
    }
    else {
        [self initializeComponentsWithTypeOfTransport:typeOfTransport];
        [self showRouteNumbersScrollView];
    }
}

- (void)receiveUserSelectedRoute:(NSNotification *)notification
{
    MORoute *selectedRoute = (MORoute *)notification.object;
    [self initStopsViewByRoute:selectedRoute];
    [self showStopsView];
}

- (void)receiveUserSelectedStop:(NSNotification *)notification
{
    LOG(@"click on stop");
}


#pragma mark - @protocol RouteNumberViewDelegate <NSObject>

- (void)clickedOnRouteNumber:(NSString *)routeNumber typeOfTransport:(TypeOfTransportEnum)type
{
    [self initRoutesViewByRouteNumber:routeNumber typeOfTransport:type];
    [self showRoutesView];
}


#pragma mark - Private methods (init)

- (void)initializeComponentsWithTypeOfTransport:(TypeOfTransportEnum)typeOfTransport
{
    NSArray *allNumbers = [[DatabaseManager sharedMySingleton] allNumbersByType:typeOfTransport];
    
    for (UIView *view in [scrollViewRouteNumbers subviews]) {
        [view removeFromSuperview];
    }
    
    scrollViewRouteNumbers.frame = shownContainerRect;
    
    NSInteger countOfRows = [allNumbers count] / COUNT_OF_BUTTONS_IN_ROW;
    countOfRows = [allNumbers count] % COUNT_OF_BUTTONS_IN_ROW == 0 ? countOfRows : ++countOfRows;
    
    scrollViewRouteNumbers.contentSize = CGSizeMake(scrollViewRouteNumbers.frame.size.width,
                                                    countOfRows * BUTTON_DIMENSION + (countOfRows + 1) * DELTA_BETWEEN_BUTTONS);
    
    for (int i = 0; i < [allNumbers count]; i++) {
        
        NSInteger indexInRow = i % COUNT_OF_BUTTONS_IN_ROW;
        NSInteger row = i / COUNT_OF_BUTTONS_IN_ROW;
        
        RouteNumberView *routeNumberView = [RouteNumberView loadViewWithRouteNumber:allNumbers[i] typeOfTransport:typeOfTransport];
        routeNumberView.delegate = self;
        routeNumberView.frame = CGRectMake(indexInRow * BUTTON_DIMENSION + DELTA_BETWEEN_BUTTONS * indexInRow,
                                           row * BUTTON_DIMENSION + DELTA_BETWEEN_BUTTONS * row,
                                           BUTTON_DIMENSION,
                                           BUTTON_DIMENSION);
        
        [scrollViewRouteNumbers addSubview:routeNumberView];
    }
}

- (void)initRoutesViewByRouteNumber:(NSString *)routeNumber typeOfTransport:(TypeOfTransportEnum)type
{
    [routesView removeFromSuperview];
    routesView = [RoutesView loadViewWithRouteNumber:routeNumber typeOfTransport:type];
    routesView.frame = hiddenRightContainerRect;
    [self.view addSubview:routesView];
}

- (void)initStopsViewByRoute:(MORoute *)route
{
    [stopsView removeFromSuperview];
    stopsView = [StopsView loadViewWithRoute:route];
    stopsView.frame = hiddenRightContainerRect;
    [self.view addSubview:stopsView];
}


#pragma mark - Private methods (show)

- (void)showRouteNumbersScrollView
{
    if ([currentActiveView isEqual:scrollViewRouteNumbers] == NO) {
    
        scrollViewRouteNumbers.frame = hiddenLeftContainerRect;
        
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            
            scrollViewRouteNumbers.frame = shownContainerRect;
            currentActiveView.frame = hiddenRightContainerRect;
            
        } completion:^(BOOL finished) {
            currentActiveView = scrollViewRouteNumbers;
        }];
    }
}

- (void)showRoutesView
{
    routesView.frame = hiddenRightContainerRect;
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        
        currentActiveView.frame = hiddenLeftContainerRect;
        routesView.frame = shownContainerRect;
        
    } completion:^(BOOL finished) {
        currentActiveView = routesView;
    }];
}

- (void)showStopsView
{
    stopsView.frame = hiddenRightContainerRect;
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        
        currentActiveView.frame = hiddenLeftContainerRect;
        stopsView.frame = shownContainerRect;
        
    } completion:^(BOOL finished) {
        currentActiveView = stopsView;
    }];
}

@end
