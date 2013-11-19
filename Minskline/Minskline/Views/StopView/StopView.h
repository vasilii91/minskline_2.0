//
//  StopView.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 11/17/13.
//  Copyright (c) 2013 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOStop;

@interface StopView : UIView
{
    __weak IBOutlet UILabel *labelStop;
    
    MOStop *stop;
}

+ (StopView *)loadViewWithStop:(MOStop *)stop;

@end
