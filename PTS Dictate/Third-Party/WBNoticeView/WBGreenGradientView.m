//
//  WBGreenGradientView.m
//  EO Coimbatore
//
//  Created by ANGLEREIT on 07/11/14.
//  Copyright (c) 2014 ANGLER EIT. All rights reserved.
//

#import "WBGreenGradientView.h"

@implementation WBGreenGradientView

- (void)drawRect:(CGRect)rect
{
    UIColor *redTop = UIColorFromHEXA(0x0D810D);
    UIColor *redBot = UIColorFromHEXA(0x0D810D);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)redTop.CGColor,
                       (id)redBot.CGColor,
                       nil];
    
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.7],
                          nil];
    
    [self.layer insertSublayer:gradient atIndex:0];
    self.layer.needsDisplayOnBoundsChange = YES;
}

@end
