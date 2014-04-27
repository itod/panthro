//
//  XPContext.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPContext.h>
#import <XPath/XPController.h>
#import <XPath/XPStaticContext.h>

@implementation XPContext

- (void)dealloc {
    self.contextNodeInfo = nil;
    self.controller = nil;
    self.staticContext = nil;
    [super dealloc];
}


//- (NSUInteger)last {
//    if (!lastPositionFinder) return 1;
//    return [lastPositionFinder lastPosition];
//}

@end
