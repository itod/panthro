//
//  XPUtils.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
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


extern BOOL XPNameIsNCName(NSString *name);
extern BOOL XPNameIsQName(NSString *name);
extern BOOL XPNameGetPrefix(NSString *qname);
extern BOOL XPNameGetLocalName(NSString *qname);
