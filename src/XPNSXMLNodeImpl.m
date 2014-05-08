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
#import "XPNodeSetValueEnumeration.h"
#import "XPNodeTest.h"
#import "XPNodeSetValue.h"
#import "XPLocalOrderComparer.h"

@interface XPNSXMLNodeImpl ()
@property (nonatomic, retain, readwrite) NSXMLNode *node;
@property (nonatomic, assign, readwrite) NSInteger sortIndex;
@end

@implementation XPNSXMLNodeImpl

- (instancetype)initWithNode:(NSXMLNode *)node sortIndex:(NSInteger)idx {
    self = [super init];
    if (self) {
        self.node = node;
        self.sortIndex = idx;
    }
    return self;
}


- (void)dealloc {
    self.node = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@ %@>", [self class], self, XPNodeTypeName[self.nodeType], self.name];
}


- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other {
    XPAssert([other isKindOfClass:[XPNSXMLNodeImpl class]]);
    XPNSXMLNodeImpl *node = (id)other;
    
    NSComparisonResult result = NSOrderedSame;
    if (_sortIndex < node->_sortIndex) {
        result = NSOrderedAscending;
    } else if (_sortIndex > node->_sortIndex) {
        result = NSOrderedDescending;
    }
    return result;
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


- (NSString *)name {
    XPAssert(_node);
    return [_node name];
}


- (NSString *)localName {
    XPAssert(_node);
    return [_node localName];
}


- (NSString *)prefix {
    XPAssert(_node);
    return [_node prefix];
}


- (NSString *)attributeValueForURI:(NSString *)uri localName:(NSString *)localName {
    XPAssert([_node isKindOfClass:[NSXMLElement class]]);
    NSXMLNode *attrNode = [(NSXMLElement *)_node attributeForLocalName:localName URI:uri];
    return [attrNode stringValue];
}


- (BOOL)isSameNodeInfo:(id <XPNodeInfo>)other {
    return other == self; // ??
}


- (id <XPDocumentInfo>)documentRoot {
    XPAssert(_node);
    return [[[XPNSXMLDocumentImpl alloc] initWithNode:[_node rootDocument] sortIndex:0] autorelease];
}


- (id <XPAxisEnumeration>)enumerationForAxis:(NSUInteger)axis nodeTest:(XPNodeTest *)nodeTest {
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
            nodes = [self nodesForAttributeAxis:nodeTest];
            break;
        case XPAxisChild:
            sorted = YES;
            nodes = [self nodesForChildAxis:nodeTest];
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
    
    XPAssert(nodes);
    XPNodeSetValue *nodeSet = [[[XPNodeSetValue alloc] initWithNodes:nodes comparer:[XPLocalOrderComparer instance]] autorelease];
    id <XPAxisEnumeration>enm = (id <XPAxisEnumeration>)[nodeSet enumerate];
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

    id <XPNodeInfo>node = [[[cls alloc] initWithNode:parent sortIndex:self.sortIndex-1] autorelease];
    
    NSArray *nodes = nil;
    
    if ([nodeTest matches:node]) {
        nodes = @[node];
    }
    
    return nodes;
}


- (NSArray *)nodesForChildAxis:(XPNodeTest *)nodeTest {
    NSArray *children = [self.node children];
    
    NSMutableArray *nodes = [NSMutableArray array];
    
    NSInteger sortIndex = self.sortIndex;
    
    for (NSXMLNode *child in children) {
        id <XPNodeInfo>node = [[[XPNSXMLNodeImpl alloc] initWithNode:child sortIndex:++sortIndex] autorelease];
        
        if ([nodeTest matches:node]) {
            [nodes addObject:node];
        }
    }
    
    return nodes;
}


- (NSArray *)nodesForAttributeAxis:(XPNodeTest *)nodeTest {
    XPAssert(XPNodeTypeElement == self.nodeType);
    
    NSArray *attrs = [(NSXMLElement *)self.node attributes];
    
    NSMutableArray *nodes = [NSMutableArray array];
    
    NSInteger sortIndex = self.sortIndex;
    
    for (NSXMLNode *attr in attrs) {
        id <XPNodeInfo>node = [[[XPNSXMLNodeImpl alloc] initWithNode:attr sortIndex:++sortIndex] autorelease];
        
        if ([nodeTest matches:node]) {
            [nodes addObject:node];
        }
    }
    
    return nodes;
}

@end
