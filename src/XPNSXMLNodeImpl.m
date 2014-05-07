//
//  XPNSXMLNodeImpl.m
//  XPath
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPNSXMLNodeImpl.h"
#import "XPNSXMLDocumentImpl.h"
#import "XPAxis.h"

@implementation XPNSXMLNodeImpl

- (instancetype)initWithNode:(NSXMLNode *)node {
    self = [super init];
    if (self) {
        self.node = node;
    }
    return self;
}


- (void)dealloc {
    self.node = nil;
    [super dealloc];
}


- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other {
    return NSOrderedSame;
}


- (XPNodeType)nodeType {
    XPAssert(_node);
    XPNodeType type = XPNodeTypeNone;
    
    switch ([self.node kind]) {
        case NSXMLDocumentKind:
            type = XPNodeTypeRoot;
            break;
        case NSXMLElementKind:
            type = XPNodeTypeElement;
            break;
        case NSXMLAttributeKind:
            type = XPNodeTypeAttribute;
            break;
        case NSXMLNamespaceKind:
            type = XPNodeTypeNamespace;
            break;
        case NSXMLProcessingInstructionKind:
            type = XPNodeTypePI;
            break;
        case NSXMLCommentKind:
            type = XPNodeTypeComment;
            break;
        case NSXMLTextKind:
            type = XPNodeTypeText;
            break;
        case NSXMLInvalidKind:
        case NSXMLDTDKind:
        case NSXMLEntityDeclarationKind:
        case NSXMLAttributeDeclarationKind:
        case NSXMLNotationDeclarationKind:
        case NSXMLElementDeclarationKind:
        default:
            type = XPNodeTypeNone;
            break;
    }
    
    return type;
}


- (NSString *)stringValue {
    XPAssert(_node);
    return [_node stringValue];
}


- (BOOL)isSameNodeInfo:(id <XPNodeInfo>)other {
    return other == self; // ??
}


- (id <XPDocumentInfo>)documentRoot {
    XPAssert(_node);
    return [[[XPNSXMLDocumentImpl alloc] initWithNode:[_node rootDocument]] autorelease];
}


- (id <XPNodeEnumeration>)enumerationForAxis:(NSUInteger)axis nodeTest:(XPNodeTest *)nodeTest {
    switch (axis) {
        case XPAxisAncestor:
            
            break;
        case XPAxisAncestorOrSelf:
            
            break;
        case XPAxisAttribute:
            
            break;
        case XPAxisChild:
            
            break;
        case XPAxisDescendant:
            
            break;
        case XPAxisDescendantOrSelf:
            
            break;
        case XPAxisFollowing:
            
            break;
        case XPAxisFollowingSibling:
            
            break;
        case XPAxisNamespace:
            
            break;
        case XPAxisParent:
            
            break;
        case XPAxisPreceding:
            
            break;
        case XPAxisPrecedingSibling:
            
            break;
        case XPAxisSelf:
            
            break;
        default:
            XPAssert(0);
            break;
    }
    
    
}

@end
