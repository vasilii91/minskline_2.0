//
//  StopsView.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/17/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MORoute;

@interface StopsView : UIView
{
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UIScrollView *scrollViewStops;
    
    MORoute *route;
}

+ (StopsView *)loadViewWithRoute:(MORoute *)route;

@end
