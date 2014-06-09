//
//  XPNodeTest.h
//  Panthro
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPPattern.h"
#import "XPContext.h"
#import "XPUtils.h"

@protocol XPNodeInfo;

/**
 * A NodeTest is a simple kind of pattern that enables a context-free test of whether
 * a node has a particular
 * name. There are five kinds of name test: a full name test, a prefix test, and an
 * "any node of a given type" test, an "any node of any type" test, and a "no nodes"
 * test (used, e.g. for "@comment()")
 *
 * @author Michael H. Kay
 */

@interface XPNodeTest : XPPattern
    
/**
 * Test whether this node test is satisfied by a given node
 */

- (BOOL)matches:(id <XPNodeInfo>)node;

/**
 * Test whether this node test is satisfied by a given node
 * @param nodeType The type of node to be matched
 * @param fingerprint identifies the expanded name of the node to be matched.
 * The value should be -1 for a node with no name.
 */

- (BOOL)matches:(XPNodeType)nodeType namespaceURI:(NSString *)nsURI localName:(NSString *)localName;

/**
 * Test whether this node test is satisfied by a given node, in a given Context
 */

- (BOOL)matches:(id <XPNodeInfo>)node inContext:(XPContext *)ctx;

/**
 * Determine the types of nodes to which this pattern applies. Used for optimisation.
 * @return the type of node matched by this pattern. e.g. NodeInfo.ELEMENT or NodeInfo.TEXT
 */

@property (nonatomic, assign) XPNodeType nodeType;
@end
