//
//  XPGroupSpec.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import "XPGroupSpec.h"

@implementation XPGroupSpec

+ (instancetype)groupSpecWithValue:(XPValue *)val {
    XPGroupSpec *spec = [[[XPGroupSpec alloc] init] autorelease];
    spec.value = val;
    return spec;
}


- (void)dealloc {
    self.value = nil;
    [super dealloc];
}

@end
