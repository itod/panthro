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

@interface XPExceptEnumeration ()
@property (nonatomic, retain) id <XPNodeInfo>nextNode1;
@property (nonatomic, retain) id <XPNodeInfo>nextNode2;
@property (nonatomic, retain) id <XPNodeInfo>nextNode;
@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@end

@implementation XPExceptEnumeration

- (instancetype)initWithLhs:(id <XPSequenceEnumeration>)lhs rhs:(id <XPSequenceEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer {
    XPAssert(lhs);
    XPAssert(rhs);
    XPAssert(comparer);
    self = [super init];
    if (self) {
        self.operator = @"except";
        self.p1 = lhs;
        self.p2 = rhs;
        self.comparer = comparer;
        self.e1 = self.p1;
        self.e2 = self.p2;
        
        if (![self.e1 isSorted]) {
            self.e1 = [[[[[XPNodeSetExtent alloc] initWithEnumeration:self.e1 comparer:_comparer] autorelease] sort] enumerate];
        }
        if (![self.e2 isSorted]) {
            self.e2 = [[[[[XPNodeSetExtent alloc] initWithEnumeration:self.e2 comparer:_comparer] autorelease] sort] enumerate];
        }
        
        if ([self.e1 hasMoreItems]) {
            self.nextNode1 = [self nextNodeFromLhs];
        }
        if ([self.e2 hasMoreItems]) {
            self.nextNode2 = [self nextNodeFromRhs];
        }
        
        // move to the first node in p1 that isn't in p2
        [self advance];

    }
    return self;
}


- (void)dealloc {
    self.p1 = nil;
    self.p2 = nil;
    self.e1 = nil;
    self.e2 = nil;
    self.nextNode1 = nil;
    self.nextNode2 = nil;
    self.nextNode = nil;
    self.comparer = nil;
    [super dealloc];
}


- (BOOL)hasMoreItems {
    return _nextNode != nil;
}


- (id <XPNodeInfo>)nextItem {
    id <XPNodeInfo>current = _nextNode;
    [self advance];
    return current;
}


- (void)advance {
    // main merge loop: if the node in p1 has a lower key value that that in p2, return it;
    // if they are equal, advance both nodesets; if p1 is higher, advance p2.
    
    while (_nextNode1 && _nextNode2) {
        NSInteger res = [_comparer compare:_nextNode1 to:_nextNode2];
        if (res < 0) {                                                  // p1 is lower
            id <XPNodeInfo>next = _nextNode1;
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
    
    if (_nextNode1) {
        self.nextNode = _nextNode1;
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
