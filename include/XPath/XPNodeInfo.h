//
//  XPNodeInfo.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XPNodeType) {
    
    // Node types. "NODE" means any type.
    // These node numbers should be kept aligned with those defined in the DOM.
    
    XPNodeTypeNode = 0,       // matches any kind of node
    XPNodeTypeElement = 1,
    XPNodeTypeAttribute = 2,
    XPNodeTypeText = 3,
    XPNodeTypePI = 7,
    XPNodeTypeComment = 8,
    XPNodeTypeRoot = 9,
    XPNodeTypeNamespace = 13,
    XPNodeTypeNumberOfTypes = 13,
    XPNodeTypeNone = 9999,    // a test for this node type will never be satisfied
};


//const NSString *XPNodetypeName[] =
//{
//    @"node",
//    @"element",
//    @"attribute",
//    @"text",
//    @"processing-instruction",
//    @"comment",
//    @"root",
//    @"namespace",
//    @"number-of-types",
//    @"none",
//};
//
//
@protocol XPNodeInfo <NSObject>

- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other;

/**
 * Return the type of node.
 * @return one of the values Node.ELEMENT, Node.TEXT, Node.ATTRIBUTE, etc.
 */

@property (nonatomic, assign, readonly) XPNodeType nodeType;

@end
