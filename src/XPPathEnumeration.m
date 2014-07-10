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

#if PAUSE_ENABLED
#import "XPStaticContext.h"
#import "XPNodeSetExtent.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPSingletonEnumeration.h"
#endif

@interface XPPathEnumeration ()
@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPStep *step;
@property (nonatomic, retain) id <XPSequenceEnumeration>base;
@property (nonatomic, retain) id <XPSequenceEnumeration>tail;
@property (nonatomic, retain) id <XPNodeInfo>next;
@property (nonatomic, retain) XPContext *context;

#if PAUSE_ENABLED
@property (nonatomic, retain) NSMutableArray *contextNodes;
@property (nonatomic, retain) NSArray *resultNodes;
#endif
@end

@implementation XPPathEnumeration

- (instancetype)initWithStart:(XPExpression *)start step:(XPStep *)step context:(XPContext *)ctx {
    self = [super init];
    if (self) {
        if ([start isKindOfClass:[XPSingletonNodeSet class]]) {
            if (![(XPSingletonNodeSet *)start isGeneralUseAllowed]) {
                [XPException raiseIn:start format:@"To use a result tree fragment in a path expression, either use exsl:node-set() or specify version='1.1'"];
            }
        }

#if PAUSE_ENABLED
        self.contextNodes = [NSMutableArray array];
        self.resultNodes = [NSMutableArray array];
#endif

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

#if PAUSE_ENABLED
    self.contextNodes = nil;
    self.resultNodes = nil;
#endif
    
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

    // if we are currently processing a step, we continue with it. Otherwise,
    // we get the next base element, and apply the step to that.

    if (_tail && [_tail hasMoreItems]) {
        id <XPNodeInfo>result = [_tail nextNodeInfo];
        return result;
    }
    
    while ([_base hasMoreItems]) {
        id <XPNodeInfo>node = [_base nextNodeInfo];

        self.tail = [_step enumerate:node inContext:_context];

#if PAUSE_ENABLED
        if (_context.staticContext.debug) {
            [self addContextNode:node];
            
            if ([_tail conformsToProtocol:@protocol(XPPauseHandler)]) {
                self.resultNodes = [(id <XPPauseHandler>)_tail currentResultNodes];
                [self pause];
            }
        }
        
#endif
        
        if ([_tail hasMoreItems]) {

            id <XPNodeInfo>result = [_tail nextNodeInfo];
            return result;
        }
    }

    return nil;
}


#if PAUSE_ENABLED
- (void)addContextNode:(id <XPNodeInfo>)node {
    XPAssert(node);

    XPAssert(_contextNodes);
    [_contextNodes removeAllObjects];
    [_contextNodes addObject:node];
}


- (void)pause {
    if (_resultNodes && _context.staticContext.debug) {
        XPNodeSetValue *contextNodeSet = [[[XPNodeSetExtent alloc] initWithNodes:_contextNodes comparer:nil] autorelease];
        [contextNodeSet sort];
        
        XPNodeSetValue *resultNodeSet = [[[XPNodeSetExtent alloc] initWithNodes:_resultNodes comparer:nil] autorelease];
        [resultNodeSet sort];
        
        [_context.staticContext pauseFrom:_start withContextNodes:contextNodeSet result:resultNodeSet range:_step.range done:NO];

        self.resultNodes = nil; // ok, we've blown our load. don't allow another pause.
    }
}
#endif


/**
* Determine if we can guarantee that the nodes are in document order. This is true if the
* start nodes are sorted peer nodes and the step is within the subtree rooted at each node.
* It is also true if the start is a singleton node and the axis is sorted.
*/

- (BOOL)isSorted {
    XPAxis axis = _step.axis;
    BOOL res = XPAxisIsForwards[axis] && (
         ([_start isKindOfClass:[XPSingletonExpression class]]) ||
         (_base.isSorted && _base.isPeer && XPAxisIsSubtreeAxis[axis]) ||
         (_base.isSorted && (axis == XPAxisAttribute || axis == XPAxisNamespace))
    );
    return res;
}


/**
* Determine if the nodes are guaranteed to be in reverse document order. This is true if the
* base is singular (e.g. the root node or the current node) and the axis is a reverse axis
*/

- (BOOL)isReverseSorted {
    BOOL res = [_start isKindOfClass:[XPSingletonExpression class]] && XPAxisIsReverse[_step.axis];
    return res;
}


/**
* Determine if the resulting nodes are peer nodes, that is, if no node is a descendant of any
* other. This is the case if the start nodes are peer nodes and the axis is a peer axis.
*/

- (BOOL)isPeer {
    return (_base.isPeer && XPAxisIsPeerAxis[_step.axis]);
}

@end
