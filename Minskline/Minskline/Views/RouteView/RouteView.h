//
//  RouteView.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/16/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MORoute;

@interface RouteView : UIView
{
    __weak IBOutlet UILabel *labelFrom;
    __weak IBOutlet UILabel *labelTo;
    __weak IBOutlet UIButton *buttonFavorite;
    
    MORoute *route;
}

+ (RouteView *)loadViewWithRoute:(MORoute *)route;

@end
