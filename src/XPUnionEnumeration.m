//
//  XPUnionEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPUnionEnumeration.h"
#import "XPNodeSetExtent.h"
#import "XPLocalOrderComparer.h"

@interface XPUnionEnumeration ()
@property (nonatomic, retain) id <XPSequenceEnumeration>p1;
@property (nonatomic, retain) id <XPSequenceEnumeration>p2;
@property (nonatomic, retain) id <XPSequenceEnumeration>e1;
@property (nonatomic, retain) id <XPSequenceEnumeration>e2;
@property (nonatomic, retain) id <XPNodeInfo>nextNode1;
@property (nonatomic, retain) id <XPNodeInfo>nextNode2;
@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@end

@implementation XPUnionEnumeration

- (instancetype)initWithLhs:(id <XPSequenceEnumeration>)lhs rhs:(id <XPSequenceEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer {
    XPAssert(lhs);
    XPAssert(rhs);
    XPAssert(comparer);
    self = [super init];
    if (self) {
        self.p1 = lhs;
        self.p2 = rhs;
        self.comparer = comparer;
        self.e1 = _p1;
        self.e2 = _p2;
        
        if (![_e1 isSorted]) {
            self.e1 = [[[[[XPNodeSetExtent alloc] initWithEnumeration:_e1 comparer:_comparer] autorelease] sort] enumerate];
        }
        if (![_e2 isSorted]) {
            self.e2 = [[[[[XPNodeSetExtent alloc] initWithEnumeration:_e2 comparer:_comparer] autorelease] sort] enumerate];
        }
        
        if ([_e1 hasMoreItems]) {
            self.nextNode1 = [_e1 nextNodeInfo];
        }
        if ([_e2 hasMoreItems]) {
            self.nextNode2 = [_e2 nextNodeInfo];
        }
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
    self.comparer = nil;
    [super dealloc];
}


- (BOOL)isSorted {
    return YES;
}


- (BOOL)isReverseSorted {
    return NO;
}


- (BOOL)isPeer {
    return NO;
}


- (BOOL)hasMoreItems {
    return _nextNode1 != nil || _nextNode2 != nil;
}


- (id <XPNodeInfo>)nextItem {
    // main merge loop: take a value from whichever set has the lower value
    
    if (_nextNode1 && _nextNode2) {
        NSInteger res = [_comparer compare:_nextNode1 to:_nextNode2];
        if (res < 0) {
            id <XPNodeInfo>next = _nextNode1;
            if ([_e1 hasMoreItems]) {
                self.nextNode1 = [_e1 nextNodeInfo];
            } else {
                self.nextNode1 = nil;
            }
            return next;
            
        } else if (res > 0) {
            id <XPNodeInfo>next = _nextNode2;
            if ([_e2 hasMoreItems]) {
                self.nextNode2 = [_e2 nextNodeInfo];
            } else {
                self.nextNode2 = nil;
            }
            return next;
            
        } else {
            id <XPNodeInfo>next = _nextNode2;
            if ([_e2 hasMoreItems]) {
                self.nextNode2 = [_e2 nextNodeInfo];
            } else {
                self.nextNode2 = nil;
            }
            if ([_e1 hasMoreItems]) {
                self.nextNode1 = [_e1 nextNodeInfo];
            } else {
                self.nextNode1 = nil;
            }
            return next;
        }
    }
    
    // collect the remaining nodes from whichever set has a residue
    
    if (_nextNode1) {
        id <XPNodeInfo>next = _nextNode1;
        if ([_e1 hasMoreItems]) {
            self.nextNode1 = [_e1 nextNodeInfo];
        } else {
            self.nextNode1 = nil;
        }
        return next;
    }
    if (_nextNode2) {
        id <XPNodeInfo>next = _nextNode2;
        if ([_e2 hasMoreItems]) {
            self.nextNode2 = [_e2 nextNodeInfo];
        } else {
            self.nextNode2 = nil;
        }
        return next;
    }
    return nil;
}

@end
