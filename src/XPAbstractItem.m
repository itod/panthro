//
//  XPAbstractItem.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/4/14.
//
//

#import "XPAbstractItem.h"

@implementation XPAbstractItem

- (NSString *)stringValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id <XPItem>)head {
    XPAssert(0);
    return nil;
}


- (id <XPSequenceEnumeration>)enumerate {
    XPAssert(0);
    return nil;
}

@end
