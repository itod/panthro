//
//  XPTuple.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import "XPTuple.h"

@implementation XPTuple

+ (instancetype)tupeWithResultItems:(NSArray *)res groupSpecs:(NSArray *)groupSpecs orderSpecs:(NSArray *)orderSpecs {
    XPTuple *t = [[[XPTuple alloc] init] autorelease];
    t.resultItems = res;
    t.orderSpecs = groupSpecs;
    t.orderSpecs = orderSpecs;
    return t;
}


- (void)dealloc {
    self.resultItems = nil;
    self.groupSpecs = nil;
    self.orderSpecs = nil;
    [super dealloc];
}

@end
