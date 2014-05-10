//
//  XPNodeInfo.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPUtils.h>
#import <XPath/XPAxis.h>

@protocol XPAxisEnumeration;
@protocol XPDocumentInfo;
@class XPNodeTest;

@protocol XPNodeInfo <NSObject>

- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other;

/**
 * Return the type of node.
 * @return one of the values Node.ELEMENT, Node.TEXT, Node.ATTRIBUTE, etc.
 */

@property (nonatomic, assign, readonly) XPNodeType nodeType;


/**
 * Determine whether this is the same node as another node. <br />
 * Note: a.isSameNodeInfo(b) if and only if generateId(a)==generateId(b)
 * @return true if this Node object and the supplied Node object represent the
 * same node in the tree.
 */

- (BOOL)isSameNodeInfo:(id <XPNodeInfo>)other;


/**
 * Return the string value of the node. The interpretation of this depends on the type
 * of node. For an element it is the accumulated character content of the element,
 * including descendant elements.
 * @return the string value of the node
 */

@property (nonatomic, copy, readonly) NSString *stringValue;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *localName;
@property (nonatomic, copy, readonly) NSString *prefix;


/**
 * Get the NodeInfo object representing the parent of this node
 */

- (id <XPNodeInfo>)parent;

/**
 * Find the value of a given attribute of this node. <BR>
 * This method is defined on all nodes to meet XSL requirements, but for nodes
 * other than elements it will always return null.
 * @param uri the namespace uri of an attribute ("" if no namespace)
 * @param localName the local name of the attribute
 * @return the value of the attribute, if it exists, otherwise null
 */

- (NSString *)attributeValueForURI:(NSString *)uri localName:(NSString *)localName;


/**
 * Get the root (document) node
 * @return the DocumentInfo representing the containing document
 */

- (id <XPDocumentInfo>)documentRoot;


/**
 * Return an enumeration over the nodes reached by the given axis from this node
 * @param axisNumber the axis to be followed (a constant in class {@link Axis})
 * @param nodeTest A pattern to be matched by the returned nodes
 * @return a NodeEnumeration that scans the nodes reached by the axis in turn.
 */

- (id <XPAxisEnumeration>)enumerationForAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest;

@end
