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

@interface XPIntersectEnumeration ()
@property (nonatomic, retain) id <XPNodeEnumeration>p1;
@property (nonatomic, retain) id <XPNodeEnumeration>p2;
@property (nonatomic, retain) id <XPNodeEnumeration>e1;
@property (nonatomic, retain) id <XPNodeEnumeration>e2;
@property (nonatomic, retain) id <XPNodeInfo>nextNode1;
@property (nonatomic, retain) id <XPNodeInfo>nextNode2;
@property (nonatomic, retain) id <XPNodeInfo>nextNode;
@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@end

@implementation XPIntersectEnumeration

- (instancetype)initWithLhs:(id <XPNodeEnumeration>)lhs rhs:(id <XPNodeEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer {
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
        
        if ([_e1 hasMoreObjects]) {
            self.nextNode1 = [_e1 nextObject];
        }
        if ([_e2 hasMoreObjects]) {
            self.nextNode2 = [_e2 nextObject];
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


- (BOOL)isSorted {
    return YES;
}


- (BOOL)isReverseSorted {
    return NO;
}


- (BOOL)isPeer {
    return NO;
}


- (BOOL)hasMoreObjects {
    return _nextNode != nil;
}


- (id <XPNodeInfo>)nextObject {
    id <XPNodeInfo>current = _nextNode;
    [self advance];
    return current;
}


- (void)advance {
    // main merge loop: iterate whichever set has the lower value, returning when a pair
    // is found that match.
    
    if (_nextNode1 && _nextNode2) {
        NSInteger res = [_comparer compare:_nextNode1 to:_nextNode2];
        if (res < 0) {
            if ([_e1 hasMoreObjects]) {
                self.nextNode1 = [_e1 nextObject];
            } else {
                self.nextNode1 = nil;
                self.nextNode = nil;
            }
            
        } else if (res > 0) {
            if ([_e2 hasMoreObjects]) {
                self.nextNode2 = [_e2 nextObject];
            } else {
                self.nextNode2 = nil;
                self.nextNode = nil;
            }
            
        } else {                                                        // keys are equal
            self.nextNode = _nextNode2; // which is the same as nextNode1
            if ([_e2 hasMoreObjects]) {
                self.nextNode2 = [_e2 nextObject];
            } else {
                self.nextNode2 = nil;
            }
            if ([_e1 hasMoreObjects]) {
                self.nextNode1 = [_e1 nextObject];
            } else {
                self.nextNode1 = nil;
            }
            
            return;
        }
    }
    
    self.nextNode = nil;
}

@end
