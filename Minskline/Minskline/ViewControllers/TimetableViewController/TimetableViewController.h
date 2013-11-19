//
//  TimetableViewController.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/15/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteNumberView.h"

@class RoutesView, StopsView;

@interface TimetableViewController : UIViewController<RouteNumberViewDelegate>
{
    __weak IBOutlet UIButton *buttonFavorite;
    __weak IBOutlet UIButton *buttonBus;
    __weak IBOutlet UIButton *buttonTrolleybus;
    __weak IBOutlet UIButton *buttonTramway;
    __weak IBOutlet UIButton *buttonMetro;
    __weak IBOutlet UIView *containerView;
    
    CGRect shownContainerRect;
    CGRect hiddenLeftContainerRect;
    CGRect hiddenRightContainerRect;
    
    UIView *currentActiveView;
    __weak IBOutlet UIScrollView *scrollViewRouteNumbers;
    RoutesView *routesView;
    StopsView *stopsView;
}

@end
