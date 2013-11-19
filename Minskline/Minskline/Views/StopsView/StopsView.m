//
//  StopsView.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/17/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "StopsView.h"
#import "StopView.h"
#import "MORoute.h"
#import "DatabaseManager.h"

@implementation StopsView


#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (StopsView *)loadViewWithRoute:(MORoute *)route
{
    NSString *nibName = @"StopsView";
    StopsView *stopsView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    stopsView->route = route;
    [stopsView initLabelTitle];
    [stopsView initScrollViewStops];
    
    return stopsView;
}


#pragma mark - Private methods

- (void)initLabelTitle
{
    NSString *title = [NSString stringWithFormat:@"%@ %@", [CoreMethods nameByTypeOfTransport:[route.typeOfTransport integerValue]], route.transportNumber];
    labelTitle.text = title;
}

- (void)initScrollViewStops
{
    NSArray *allStops = [[DatabaseManager sharedMySingleton] allStopsByRoute:route];
    
    NSInteger scrollViewHeight = 0;
    
    clock_t start = clock(); // перед входом в участок кода

    for (int i = 0; i < [allStops count]; i++) {
        StopView *stopView = [StopView loadViewWithStop:allStops[i]];
        stopView.frame = CGRectMake(0,
                                    ViewHeight(stopView) * i + DELTA_BETWEEN_BUTTONS * i,
                                    ViewWidth(stopView),
                                    ViewHeight(stopView));
        
        [scrollViewStops addSubview:stopView];
        
        scrollViewHeight += ViewHeight(stopView) + DELTA_BETWEEN_BUTTONS;
    }
    
    clock_t finish = clock(); // на выходе из участка кода
    clock_t duration = finish - start;
    double durInSec = (double)duration / CLOCKS_PER_SEC; // время в секундах
    NSLog(@"%lu - %f", duration, durInSec);
    
    scrollViewStops.contentSize = CGSizeMake(scrollViewStops.frame.size.width,
                                              scrollViewHeight);
    scrollViewStops.backgroundColor = [UIColor clearColor];
}

@end
