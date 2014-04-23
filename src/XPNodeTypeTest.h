//
//  XPNodeTypeTest.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <XPath/XPNodeTest.h>

@protocol XPNodeInfo;

@interface XPNodeTypeTest : XPNodeTest

- (instancetype)initWithNodeType:(XPNodeType)type;

/**
 * Determine the types of nodes to which this pattern applies. Used for optimisation.
 * @return the type of node matched by this pattern. e.g. NodeInfo.ELEMENT or NodeInfo.TEXT
 */

@property (nonatomic, assign) XPNodeType type;
@end
