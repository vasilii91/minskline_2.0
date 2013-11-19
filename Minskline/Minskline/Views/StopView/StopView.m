//
//  StopView.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/17/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "StopView.h"
#import "MOStop.h"
#import "DatabaseManager.h"

@implementation StopView


#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (StopView *)loadViewWithStop:(MOStop *)stop
{
    NSString *nibName = @"StopView";
    StopView *stopView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
//    MOStop *stopFromMainRoute = [[DatabaseManager sharedMySingleton] stopFromMainRouteByStopId:stop.stopId];
    stopView->labelStop.text = stop.stopName;
    
    [stopView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:stopView action:@selector(tapOnStopView)]];
    
    return stopView;
}


#pragma mark - Actions

- (void)tapOnStopView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_SELECTED_STOP object:stop];
}

@end
