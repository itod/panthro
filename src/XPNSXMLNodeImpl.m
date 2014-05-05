//
//  XPNSXMLNodeImpl.m
//  XPath
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPNSXMLNodeImpl.h"
#import "XPNSXMLDocumentImpl.h"

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


- (id <XPAxisEnumeration>)EnumerationForAxis:(NSUInteger)axis nodeTest:(XPNodeTest *)nodeTest {
    return nil;
}

@end
