//
//  XPSingletonNodeSet.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPSingletonNodeSet.h"
#import "XPNodeInfo.h"
#import "XPEmptyNodeSet.h"
#import "XPSingletonEnumeration.h"

@interface XPSingletonNodeSet ()
@property (nonatomic, retain) id <XPNodeInfo>node;
@end

@implementation XPSingletonNodeSet

- (instancetype)init {
    self = [self initWithNode:nil];
    return self;
}


- (instancetype)initWithNode:(id <XPNodeInfo>)node {
    self = [super init];
    if (self) {
        self.node = node;
        self.generalUseAllowed = YES;
    }
    return self;
}


- (void)dealloc {
    self.node = nil;
    [super dealloc];
}


/**
 * Simplify the expression
 */

- (XPExpression *)simplify {
    if (!_node) {
        return [XPEmptyNodeSet emptyNodeSet];
    } else {
        return self;
    }
}


/**
 * Evaluate the Node Set. This guarantees to return the result in sorted order.
 * @param context The context for evaluation (not used)
 */

- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return self;
}


/**
 * Evaluate an expression as a NodeSet.
 * @param context The context in which the expression is to be evaluated
 * @return the value of the expression, evaluated in the current context
 */

- (XPNodeSetValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    return self;
}


/**
 * Set a flag to indicate whether the nodes are sorted. Used when the creator of the
 * node-set knows that they are already in document order.
 * @param isSorted true if the caller wishes to assert that the nodes are in document order
 * and do not need to be further sorted
 */


- (void)setSorted:(BOOL)sorted {}


/**
 * Test whether the value is known to be sorted
 * @return true if the value is known to be sorted in document order, false if it is not
 * known whether it is sorted.
 */

- (BOOL)isSorted {
    return YES;
}


/**
 * Convert to string value
 * @return the value of the first node in the node-set if there
 * is one, otherwise an empty string
 */

- (NSString *)asString {
    if (_node) {
        return [_node stringValue];
    } else {
        return @"";
    }
}


/**
 * Evaluate as a boolean.
 * @return true if the node set is not empty
 */

- (BOOL)asBoolean {
    return _node != nil;
}


/**
 * Count the nodes in the node-set. Note this will sort the node set if necessary, to
 * make sure there are no duplicates.
 */

- (NSUInteger)count {
    return (_node ? 1 : 0);
}


/**
 * Sort the nodes into document order.
 * This does nothing if the nodes are already known to be sorted; to force a sort,
 * call setSorted(false)
 * @return the same NodeSetValue, after sorting. (Historic)
 */

- (XPNodeSetValue *)sort {
    return self;
}


/**
 * Get the first node in the nodeset (in document order)
 * @return the first node
 */

- (id <XPNodeInfo>)firstNode {
    return _node;
}


/**
 * Test whether a nodeset "equals" another Value
 */

- (BOOL)isEqualToValue:(XPValue *)other {
    
    if (!_node) {
        if ([other isBooleanValue]) {
            return ![other asBoolean];
        } else {
            return NO;
        }
    }
    
    if ([other isStringValue] ||
//        other instanceof FragmentValue ||
//        other instanceof TextFragmentValue ||
        [other isObjectValue]) {
        return [[_node stringValue] isEqualToString:[other asString]];
        
    } else if ([other isNodeSetValue]) {
        
        // see if there is a node in A with the same string value as a node in B
        
        @try {
            NSString *value = [_node stringValue];
            id <XPNodeEnumeration>e2 = [(XPNodeSetValue *)other enumerate];
            while ([e2 hasMoreObjects]) {
                if ([[[e2 nextObject] stringValue] isEqualToString:value]) return YES;
            }
            return NO;
        } @catch (NSException *err) {
            [err raise];
        }
        
    } else if ([other isNumericValue]) {
        return XPNumberFromString([_node stringValue]) == [other asNumber];
        
    } else if ([other isBooleanValue]) {
        return [other asBoolean];
        
    } else {
        [NSException raise:@"InternalError" format:@"Unknown data type in a relational expression"];
    }
}


/**
 * Test whether a nodeset "not-equals" another Value
 */

- (BOOL)isNotEqualToValue:(XPValue *)other {
    
    if (!_node) {
        if ([other isBooleanValue]) {
            return [other asBoolean];
        } else {
            return NO;
        }
    }
    
    if ([other isStringValue] ||
//        other instanceof FragmentValue ||
//        other instanceof TextFragmentValue ||
        [other isObjectValue]) {
        return ![[_node stringValue] isEqualToString:[other asString]];
        
    } else if ([other isNodeSetValue]) {
        
        @try {
            NSString *value = [_node stringValue];
            
            id <XPNodeEnumeration>e2 = [(XPNodeSetValue *)other enumerate];
            while ([e2 hasMoreObjects]) {
                if (![[[e2 nextObject] stringValue] isEqualToString:value]) return YES;
            }
            return NO;
        } @catch (NSException *err) {
            [err raise];
        }
        
    } else if ([other isNumericValue]) {
        return XPNumberFromString([_node stringValue]) != [other asNumber];
        
    } else if ([other isBooleanValue]) {
        return ![other asBoolean];
        
    } else {
        [NSException raise:@"InternalError" format:@"Unknown data type in a relational expression"];
        
    }
}


/**
 * Return an enumeration of this nodeset value.
 */

- (id <XPNodeEnumeration>)enumerate {
    return [[[XPSingletonEnumeration alloc] initWithNode:_node] autorelease];
}

@end
