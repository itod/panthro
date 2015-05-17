//
//  XPBaseEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import "XPBaseEnumeration.h"
#import "XPItem.h"
#import "XPException.h"
#import "XPNodeInfo.h"

@implementation XPBaseEnumeration

- (BOOL)isSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)isReverseSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)hasMoreItems {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (id <XPItem>)nextItem {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id <XPNodeInfo>)nextNodeInfo {
    id <XPItem>item = [self nextItem];

    id <XPNodeInfo>node = nil;
    if ([item conformsToProtocol:@protocol(XPNodeInfo)]) {
        node = (id)item;
    } else {
        [XPException raiseWithFormat:@"Expecting a Node but found an Atomic Value instead: %@", item];
    }
    
    return node;
}


- (BOOL)isPeer {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
//    NSUInteger count = 0;
//    
//    id <XPItem>node = nil;
//    
//    if (0 == state->state) {
//        node = [self nextItem];
//    } else {
//        node = (id <XPItem>)state->state;
//    }
//    
//    while (node && count < len) {
//        stackbuf[count] = node;
//        node = [self nextItem];
//        count++;
//    }
//    
//    state->state = (unsigned long)node;
//    state->itemsPtr = stackbuf;
//    state->mutationsPtr = (unsigned long *)self;
//    
//    return count;
//}

@end
