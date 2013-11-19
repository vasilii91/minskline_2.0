//
//  RoutesView.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/16/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "RoutesView.h"
#import "DatabaseManager.h"
#import "RouteView.h"

@implementation RoutesView

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (RoutesView *)loadViewWithRouteNumber:(NSString *)routeNumber typeOfTransport:(TypeOfTransportEnum)typeOfTransport
{
    NSString *nibName = @"RoutesView";
    RoutesView *routesView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    routesView->routeNumber = routeNumber;
    routesView->typeOfTransport = typeOfTransport;
    [routesView initLabelTitle];
    [routesView initScrollViewRoutes];
    
    return routesView;
}


#pragma mark - Private methods

- (void)initLabelTitle
{
    NSString *title = [NSString stringWithFormat:@"%@ %@", [CoreMethods nameByTypeOfTransport:typeOfTransport], routeNumber];
    labelTitle.text = title;
}

- (void)initScrollViewRoutes
{
    NSArray *allRoutes = [[DatabaseManager sharedMySingleton] allRoutesByType:typeOfTransport routeNumber:routeNumber];
    
    NSInteger scrollViewHeight = 0;
    for (int i = 0; i < [allRoutes count]; i++) {
        RouteView *routeView = [RouteView loadViewWithRoute:allRoutes[i]];
        routeView.frame = CGRectMake(0,
                                     ViewHeight(routeView) * i + DELTA_BETWEEN_BUTTONS * i,
                                     ViewWidth(routeView),
                                     ViewHeight(routeView));
        
        [scrollViewRoutes addSubview:routeView];
        
        scrollViewHeight += ViewHeight(routeView) + DELTA_BETWEEN_BUTTONS;
    }
    
    scrollViewRoutes.contentSize = CGSizeMake(scrollViewRoutes.frame.size.width,
                                              scrollViewHeight);
    scrollViewRoutes.backgroundColor = [UIColor clearColor];
}

@end
