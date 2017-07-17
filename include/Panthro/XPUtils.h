//
//  XPUtils.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPSortable;

typedef NS_ENUM(NSUInteger, XPNodeType) {
    
    // Node types. "NODE" means any type.
    
    XPNodeTypeNode = 0,       // matches any kind of node
    XPNodeTypeElement = 1,
    XPNodeTypeAttribute = 2,
    XPNodeTypeText = 3,
    XPNodeTypePI = 4,
    XPNodeTypeComment = 5,
    XPNodeTypeRoot = 6,
    XPNodeTypeNamespace = 7,
    XPNodeTypeNumberOfTypes = 8,
    XPNodeTypeNone = 9,    // a test for this node type will never be satisfied
};

extern NSString *XPSTR(const void *zstr);

extern const NSString *XPNodeTypeName[];

extern BOOL XPNameIsNCName(NSString *name);
extern BOOL XPNameIsQName(NSString *name);
extern NSString *XPNameGetPrefix(NSString *qname);
extern NSString *XPNameGetLocalName(NSString *qname);

extern void XPQuickSort(id <XPSortable>a, NSInteger lo0, NSInteger hi0);
