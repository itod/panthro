//
//  XPExceptEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPExceptEnumeration.h"
#import "XPNodeSetExtent.h"
#import "XPLocalOrderComparer.h"

@interface XPUnionEnumeration ()
@property (nonatomic, retain) id <XPNodeInfo>nextNode1;
@property (nonatomic, retain) id <XPNodeInfo>nextNode2;
@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@end

@interface XPExceptEnumeration ()
@property (nonatomic, retain) id <XPNodeInfo>nextNode;
@end

@implementation XPExceptEnumeration

- (instancetype)initWithLhs:(id <XPSequenceEnumeration>)lhs rhs:(id <XPSequenceEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer {
    XPAssert(lhs);
    XPAssert(rhs);
    XPAssert(comparer);
    self = [super initWithLhs:lhs rhs:rhs comparer:comparer];
    if (self) {
        self.operator = @"except";
        
        // move to the first node in p1 that isn't in p2
        [self advance];

    }
    return self;
}


- (void)dealloc {
    self.nextNode = nil;
    [super dealloc];
}


- (BOOL)hasMoreItems {
    return self.nextNode != nil;
}


- (id <XPNodeInfo>)nextItem {
    id <XPNodeInfo>current = self.nextNode;
    [self advance];
    return current;
}


- (void)advance {
    // main merge loop: if the node in p1 has a lower key value that that in p2, return it;
    // if they are equal, advance both nodesets; if p1 is higher, advance p2.
    
    while (self.nextNode1 && self.nextNode2) {
        NSInteger res = [self.comparer compare:self.nextNode1 to:self.nextNode2];
        if (res < 0) {                                                  // p1 is lower
            id <XPNodeInfo>next = self.nextNode1;
            if ([self.e1 hasMoreItems]) {
                self.nextNode1 = [self nextNodeFromLhs];
            } else {
                self.nextNode1 = nil;
                self.nextNode = nil;
            }
            self.nextNode = next;
            return;
            
        } else if (res > 0) {                                           // p1 is higher
            if ([self.e2 hasMoreItems]) {
                self.nextNode2 = [self nextNodeFromRhs];
            } else {
                self.nextNode2 = nil;
                self.nextNode = nil;
            }
            
        } else {                                                        // keys are equal
            if ([self.e1 hasMoreItems]) {
                self.nextNode1 = [self nextNodeFromLhs];
            } else {
                self.nextNode1 = nil;
            }
            if ([self.e2 hasMoreItems]) {
                self.nextNode2 = [self nextNodeFromRhs];
            } else {
                self.nextNode2 = nil;
            }
        }
    }
    
    // collect the remaining nodes from the residue of p1
    
    if (self.nextNode1) {
        self.nextNode = self.nextNode1;
        if ([self.e1 hasMoreItems]) {
            self.nextNode1 = [self nextNodeFromLhs];
        } else {
            self.nextNode1 = nil;
        }
        return;
    }
    
    self.nextNode = nil;
}

@end
