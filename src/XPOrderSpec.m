//
//  XPOrderSpec.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import "XPOrderSpec.h"

@implementation XPOrderSpec

+ (instancetype)orderSpecWithValue:(XPValue *)val modifier:(NSComparisonResult)mod {
    XPOrderSpec *spec = [[[XPOrderSpec alloc] init] autorelease];
    spec.value = val;
    spec.modifier = mod;
    return spec;
}


- (void)dealloc {
    self.value = nil;
    [super dealloc];
}

@end
