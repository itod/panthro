//
//  XPAbstractItem.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/4/14.
//
//

#import "XPAbstractItem.h"

@implementation XPAbstractItem

- (id <XPItem>)head {
    XPAssert(0);
    return nil;
}


- (id <XPSequenceEnumeration>)enumerate {
    XPAssert(0);
    return nil;
}

@end
