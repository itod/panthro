//
//  XPPattern.m
//  XPath
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPPattern.h"

@implementation XPPattern

- (void)dealloc {
    self.originalText = nil;
    [super dealloc];
}


- (double)defaultPriority {
    return 0.5;
}

@end
