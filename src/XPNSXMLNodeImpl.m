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
#import "XPEnumeration.h"
#import "XPNodeTest.h"

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


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@ %@>", [self class], self, XPNodeTypeName[self.nodeType], self.nodeName];
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


- (NSString *)nodeName {
    XPAssert(_node);
    return [_node name];
}


- (BOOL)isSameNodeInfo:(id <XPNodeInfo>)other {
    return other == self; // ??
}


- (id <XPDocumentInfo>)documentRoot {
    XPAssert(_node);
    return [[[XPNSXMLDocumentImpl alloc] initWithNode:[_node rootDocument]] autorelease];
}


- (id <XPNodeEnumeration>)enumerationForAxis:(NSUInteger)axis nodeTest:(XPNodeTest *)nodeTest {
    NSArray *nodes = nil;
    BOOL sorted = NO;
    
    switch (axis) {
        case XPAxisAncestor:
            sorted = NO;
            break;
        case XPAxisAncestorOrSelf:
            sorted = NO;
            break;
        case XPAxisAttribute:
        sorted = YES;
            break;
        case XPAxisChild:
            sorted = YES;
            break;
        case XPAxisDescendant:
            sorted = YES;
            break;
        case XPAxisDescendantOrSelf:
            sorted = YES;
            break;
        case XPAxisFollowing:
            sorted = YES;
            break;
        case XPAxisFollowingSibling:
            sorted = YES;
            break;
        case XPAxisNamespace:
            sorted = YES;
            break;
        case XPAxisParent:
            sorted = YES;
            nodes = [self nodesForParentAxis:nodeTest];
            break;
        case XPAxisPreceding:
            sorted = NO;
            break;
        case XPAxisPrecedingSibling:
            sorted = NO;
            break;
        case XPAxisSelf:
            sorted = YES;
            nodes = [self nodesForSelfAxis:nodeTest];
            break;
        default:
            XPAssert(0);
            break;
    }
    
    id <XPNodeEnumeration>enm = [[[XPEnumeration alloc] initWithNodes:nodes isSorted:sorted] autorelease];
    return enm;
}


- (NSArray *)nodesForSelfAxis:(XPNodeTest *)nodeTest {
    NSArray *nodes = nil;
    
    if ([nodeTest matches:self]) {
        nodes = @[self];
    }

    return nodes;
}


- (NSArray *)nodesForParentAxis:(XPNodeTest *)nodeTest {
    NSXMLNode *parent = [self.node parent];
    Class cls = (NSXMLDocumentKind == [parent kind]) ? [XPNSXMLDocumentImpl class] : [XPNSXMLNodeImpl class];

    id <XPNodeInfo>node = [[[cls alloc] initWithNode:parent] autorelease];
    
    NSArray *nodes = nil;
    
    if ([nodeTest matches:node]) {
        nodes = @[node];
    }
    
    return nodes;
}

@end
