//
//  XPPathEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 6/30/14.
//
//

#import "XPPathEnumeration.h"
#import "XPExpression.h"
#import "XPAxisStep.h"
#import "XPNodeInfo.h"
#import "XPContext.h"
#import "XPSingletonNodeSet.h"
#import "XPSingletonExpression.h"
#import "XPException.h"
#import "XPAxisStep.h"

@interface XPPathEnumeration ()
@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPAxisStep *step;
@property (nonatomic, retain) id <XPSequenceEnumeration>base;
@property (nonatomic, retain) id <XPSequenceEnumeration>tail;
@property (nonatomic, retain) id <XPNodeInfo>next;
@property (nonatomic, retain) XPContext *context;
@end

@implementation XPPathEnumeration

- (instancetype)initWithStart:(XPExpression *)start step:(XPAxisStep *)step context:(XPContext *)ctx {
    self = [super init];
    if (self) {
        if ([start isKindOfClass:[XPSingletonNodeSet class]]) {
            if (![(XPSingletonNodeSet *)start isGeneralUseAllowed]) {
                [XPException raiseIn:start format:@"To use a result tree fragment in a path expression, either use exsl:node-set() or specify version='1.1'"];
            }
        }

        self.start = start;
        self.step = step;
        self.context = [[ctx copy] autorelease];
        self.base = [start enumerateInContext:_context sorted:NO];
        self.next = [self nextNode];
    }
    return self;
}


- (void)dealloc {
    self.start = nil;
    self.step = nil;
    self.base = nil;
    self.tail = nil;
    self.next = nil;
    self.context = nil;
    [super dealloc];
}


- (BOOL)hasMoreItems {
    BOOL res = _next != nil;
    return res;
}


- (id <XPNodeInfo>)nextItem {
    id <XPNodeInfo>curr = _next;
    self.next = [self nextNode];
    return curr;
}


- (id <XPNodeInfo>)nextNode {
    id <XPNodeInfo>result = nil;

    // if we are currently processing a step, we continue with it. Otherwise,
    // we get the next base element, and apply the step to that.

    if (_tail && [_tail hasMoreItems]) {
        result = [_tail nextNodeInfo];
    } else {
        while ([_base hasMoreItems]) {
            id <XPNodeInfo>node = [_base nextNodeInfo];
            
            self.tail = [_step enumerate:node inContext:_context parent:_start];

            if ([_tail hasMoreItems]) {
                result = [_tail nextNodeInfo];
                break;
            }
        }
    }

    return result;
}


- (BOOL)isAxisStep {
    return [_step isKindOfClass:[XPAxisStep class]];
}


/**
* Determine if we can guarantee that the nodes are in document order. This is true if the
* start nodes are sorted peer nodes and the step is within the subtree rooted at each node.
* It is also true if the start is a singleton node and the axis is sorted.
*/

- (BOOL)isSorted {
    BOOL res = NO;
    if ([self isAxisStep]) {
        XPAxis axis = [(XPAxisStep *)_step axis];
        res = XPAxisIsForwards[axis] && (
             ([_start isKindOfClass:[XPSingletonExpression class]]) ||
             (_base.isSorted && _base.isPeer && XPAxisIsSubtreeAxis[axis]) ||
             (_base.isSorted && (axis == XPAxisAttribute || axis == XPAxisNamespace))
        );
    }
    return res;
}


/**
* Determine if the nodes are guaranteed to be in reverse document order. This is true if the
* base is singular (e.g. the root node or the current node) and the axis is a reverse axis
*/

- (BOOL)isReverseSorted {
    BOOL res = NO;
    if ([self isAxisStep]) {
        res = ([_start isKindOfClass:[XPSingletonExpression class]] || [_start isKindOfClass:[XPSingletonNodeSet class]]) && XPAxisIsReverse[[(XPAxisStep *)_step axis]];
    }
    return res;
}


/**
* Determine if the resulting nodes are peer nodes, that is, if no node is a descendant of any
* other. This is the case if the start nodes are peer nodes and the axis is a peer axis.
*/

- (BOOL)isPeer {
    if ([self isAxisStep]) {
        return (_base.isPeer && XPAxisIsPeerAxis[[(XPAxisStep *)_step axis]]);
    } else {
        return NO;
    }
}

@end
