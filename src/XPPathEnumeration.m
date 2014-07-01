//
//  XPPathEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 6/30/14.
//
//

#import "XPPathEnumeration.h"
#import "XPExpression.h"
#import "XPNodeInfo.h"
#import "XPContext.h"
#import "XPSingletonNodeSet.h"
#import "XPSingletonExpression.h"
#import "XPException.h"
#import "XPStep.h"

@interface XPPathEnumeration ()
@property (nonatomic, retain) XPExpression *thisStart;
@property (nonatomic, retain) XPStep *step;
@property (nonatomic, retain) id <XPNodeEnumeration>base;
@property (nonatomic, retain) id <XPNodeEnumeration>thisStep;
@property (nonatomic, retain) id <XPNodeInfo>next;
@property (nonatomic, retain) XPContext *context;
@end

@implementation XPPathEnumeration

- (instancetype)initWithStart:(XPExpression *)start step:(XPStep *)step context:(XPContext *)ctx {
    self = [super init];
    if (self) {
        if ([start isKindOfClass:[XPSingletonNodeSet class]]) {
            if (!((XPSingletonNodeSet *)start).isGeneralUseAllowed) {
                [XPException raiseIn:start format:@"To use a result tree fragment in a path expression, either use exsl:node-set() or specify version='1.1'"];
            }
        }
        self.thisStart = start;
        self.step = step;
        self.context = [[ctx copy] autorelease]; // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        self.base = [start enumerateInContext:_context sorted:NO];
        self.next = [self nextNode];
    }
    return self;
}


- (void)dealloc {
    self.thisStart = nil;
    self.step = nil;
    self.base = nil;
    self.thisStep = nil;
    self.next = nil;
    self.context = nil;
    [super dealloc];
}


- (BOOL)hasMoreObjects {
    return _next != nil;
}


- (id <XPNodeInfo>)nextObject {
    id <XPNodeInfo>curr = _next;
    self.next = [self nextNode];
    return curr;
}


- (id <XPNodeInfo>)nextNode {

    // if we are currently processing a step, we continue with it. Otherwise,
    // we get the next base element, and apply the step to that.

    if (_thisStep && [_thisStep hasMoreObjects]) {
        return [_thisStep nextObject];
    }

    while ([_base hasMoreObjects]) {
        id <XPNodeInfo>node = [_base nextObject];
        self.thisStep = [_step enumerate:node inContext:_context];
        if ([_thisStep hasMoreObjects]) {
            return [_thisStep nextObject];
        }
    }

    return nil;

}

/**
* Determine if we can guarantee that the nodes are in document order. This is true if the
* start nodes are sorted peer nodes and the step is within the subtree rooted at each node.
* It is also true if the start is a singleton node and the axis is sorted.
*/

- (BOOL)isSorted {
    XPAxis axis = _step.axis;
    return XPAxisIsForwards[axis] && (
         ([_thisStart isKindOfClass:[XPSingletonExpression class]]) ||
         (_base.isSorted && _base.isPeer && XPAxisIsSubtreeAxis[axis]) ||
         (_base.isSorted && (axis == XPAxisAttribute || axis == XPAxisNamespace))
    );
}


/**
* Determine if the nodes are guaranteed to be in reverse document order. This is true if the
* base is singular (e.g. the root node or the current node) and the axis is a reverse axis
*/

- (BOOL)isReverseSorted {
    return [_thisStart isKindOfClass:[XPSingletonExpression class]] && XPAxisIsReverse[_step.axis];
}


/**
* Determine if the resulting nodes are peer nodes, that is, if no node is a descendant of any
* other. This is the case if the start nodes are peer nodes and the axis is a peer axis.
*/

- (BOOL)isPeer {
    return (_base.isPeer && XPAxisIsPeerAxis[_step.axis]);
}

@end
