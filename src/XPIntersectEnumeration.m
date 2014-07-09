//
//  XPIntersectEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPIntersectEnumeration.h"
#import "XPNodeSetExtent.h"
#import "XPLocalOrderComparer.h"

@interface XPUnionEnumeration ()
@property (nonatomic, retain) id <XPNodeInfo>nextNode1;
@property (nonatomic, retain) id <XPNodeInfo>nextNode2;
@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@end

@interface XPIntersectEnumeration ()
@property (nonatomic, retain) id <XPNodeInfo>nextNode;
@end

@implementation XPIntersectEnumeration

- (instancetype)initWithLhs:(id <XPSequenceEnumeration>)lhs rhs:(id <XPSequenceEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer {
    XPAssert(lhs);
    XPAssert(rhs);
    XPAssert(comparer);
    self = [super initWithLhs:lhs rhs:rhs comparer:comparer];
    if (self) {
        
        // move to the first node in p1 that isn't in p2
        [self advance];
        
    }
    return self;
}


- (void)dealloc {
    self.nextNode = nil;
    [super dealloc];
}


- (NSString *)operator {
    return @"intersect";
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
    // main merge loop: iterate whichever set has the lower value, returning when a pair
    // is found that match.
    
    while (self.nextNode1 && self.nextNode2) {
        NSInteger res = [self.comparer compare:self.nextNode1 to:self.nextNode2];
        if (res < 0) {
            if ([self.e1 hasMoreItems]) {
                self.nextNode1 = [self nextNodeFromLhs];
            } else {
                self.nextNode1 = nil;
                self.nextNode = nil;
            }
            
        } else if (res > 0) {
            if ([self.e2 hasMoreItems]) {
                self.nextNode2 = [self nextNodeFromRhs];
            } else {
                self.nextNode2 = nil;
                self.nextNode = nil;
            }
            
        } else {                                                        // keys are equal
            self.nextNode = self.nextNode1; // which is the same as nextNode2
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
            
            return;
        }
    }
    
    self.nextNode = nil;
}

@end
