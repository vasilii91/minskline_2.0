//
//  RouteNumberView.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/15/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RouteNumberViewDelegate <NSObject>

- (void)clickedOnRouteNumber:(NSString *)routeNumber typeOfTransport:(TypeOfTransportEnum)typeOfTransport;

@end


@interface RouteNumberView : UIView
{
    __weak IBOutlet UIButton *buttonRouteNumber;
    
    NSString *routeNumber;
    TypeOfTransportEnum typeOfTransport;
}

+ (RouteNumberView *)loadViewWithRouteNumber:(NSString *)routeNumber typeOfTransport:(TypeOfTransportEnum)typeOfTransport;
- (NSString *)routeNumber;


@property (nonatomic, assign) NSObject<RouteNumberViewDelegate> *delegate;

@end
