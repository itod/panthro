//
//  XPNodeTest.h
//  XPath
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import <XPath/XPPattern.h>
#import <XPath/XPNodeInfo.h>
#import <XPath/XPContext.h>

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

- (BOOL)matches:(XPNodeType)nodeType name:(NSString *)nodeName;

/**
 * Test whether this node test is satisfied by a given node, in a given Context
 */

- (BOOL)matches:(id <XPNodeInfo>)node inContext:(XPContext *)ctx;

@end
