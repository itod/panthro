//
//  XPNodeInfo.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPNodeType.h>

@protocol XPAxisEnumerator;
@class XPNodeTest;

@protocol XPNodeInfo <NSObject>

- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other;

/**
 * Return the type of node.
 * @return one of the values Node.ELEMENT, Node.TEXT, Node.ATTRIBUTE, etc.
 */

@property (nonatomic, assign, readonly) XPNodeType nodeType;


/**
 * Return the string value of the node. The interpretation of this depends on the type
 * of node. For an element it is the accumulated character content of the element,
 * including descendant elements.
 * @return the string value of the node
 */

- (NSString *)stringValue;


/**
 * Return an enumeration over the nodes reached by the given axis from this node
 * @param axisNumber the axis to be followed (a constant in class {@link Axis})
 * @param nodeTest A pattern to be matched by the returned nodes
 * @return a NodeEnumeration that scans the nodes reached by the axis in turn.
 */

- (id <XPAxisEnumerator>)enumeratorForAxis:(NSUInteger)axis nodeTest:(XPNodeTest *)nodeTest;

@end
