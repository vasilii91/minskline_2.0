//
//  RouteNumberView.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/15/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "RouteNumberView.h"
#import "MORoute.h"

@implementation RouteNumberView


#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (RouteNumberView *)loadViewWithRouteNumber:(NSString *)routeNumber typeOfTransport:(TypeOfTransportEnum)typeOfTransport
{
    NSString *nibName = @"RouteNumberView";
    RouteNumberView *routeNumberView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    routeNumberView->routeNumber = routeNumber;
    routeNumberView->typeOfTransport = typeOfTransport;
    [routeNumberView->buttonRouteNumber setTitle:routeNumber forState:UIControlStateNormal];
    
    return routeNumberView;
}

- (NSString *)routeNumber
{
    return routeNumber;
}


#pragma mark - Actions

- (IBAction)clickedOnButton:(id)sender
{
    [self.delegate clickedOnRouteNumber:routeNumber typeOfTransport:typeOfTransport];
}

@end
