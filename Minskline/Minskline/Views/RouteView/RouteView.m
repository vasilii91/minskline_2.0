//
//  RouteView.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/16/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import "RouteView.h"
#import "MORoute.h"


@implementation RouteView


#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (RouteView *)loadViewWithRoute:(MORoute *)route
{
    NSString *nibName = @"RouteView";
    RouteView *routeView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    routeView->route = route;
    [routeView initRouteView];
    
    [routeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:routeView action:@selector(tapOnRouteView)]];
    
    return routeView;
}

- (void)initRouteView
{
    NSArray *startFinishDirections = [self startFinishDirections];
    labelFrom.text = startFinishDirections[0];
    labelTo.text = startFinishDirections[1];
    
    [self updateButtonFavorite];
}

- (void)updateButtonFavorite
{
    buttonFavorite.selected = [route.isFavorite boolValue];
}

#pragma mark - Actions

- (IBAction)clickOnFavoriteButton:(id)sender
{
    route.isFavorite = @(!route.isFavorite);
    [route.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    [self updateButtonFavorite];
}

- (void)tapOnRouteView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_SELECTED_ROUTE object:route];
    LOG(@"asdfafas");
}


#pragma mark - Private methods

- (NSArray *)startFinishDirections
{
    LOG(@"%@ - %@", route.transportNumber, route.routeName);
    
    NSString *routeName = route.routeName;
    if ([routeName isEqualToString:@"Аэропорт \"Минск-1\"-А/В Московский"]) {
        return @[@"Аэропорт \"Минск-1\"", @"А/В Московский"];
    }
    if ([routeName isEqualToString:@"Сухарево-6-Каменная горка"]) {
        return @[@"Сухарево-6", @"Каменная горка"];
    }
    
    NSArray *delimeters = @[@"  -  ", @" -  ", @"  - ", @" - ", @" -", @"- ", @"-", @" "];
    
    for (NSString *delimeter in delimeters) {
        NSRange range = [routeName rangeOfString:delimeter];
        if (range.location != NSNotFound) {
            return [routeName componentsSeparatedByString:delimeter];
        }
    }
    
    return @[routeName, routeName];
}

@end
