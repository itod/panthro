//
//  XPTuple.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import "XPTuple.h"

@implementation XPTuple

+ (instancetype)tupeWithResultItems:(NSArray *)res orderSpecs:(NSArray *)specs {
    XPTuple *t = [[[XPTuple alloc] init] autorelease];
    t.resultItems = res;
    t.orderSpecs = specs;
    return t;
}


- (void)dealloc {
    self.resultItems = nil;
    self.orderSpecs = nil;
    [super dealloc];
}

@end
