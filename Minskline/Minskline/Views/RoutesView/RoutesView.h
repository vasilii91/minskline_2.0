//
//  RoutesView.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/16/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoutesView : UIView
{
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UIScrollView *scrollViewRoutes;
    
    NSString *routeNumber;
    TypeOfTransportEnum typeOfTransport;
}

+ (RoutesView *)loadViewWithRouteNumber:(NSString *)routeNumber typeOfTransport:(TypeOfTransportEnum)typeOfTransport;

@end
