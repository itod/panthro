//
//  XPLibXmlNodeImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPLibXmlNodeImpl.h"
#import "XPLibXmlDocumentImpl.h"
#import "XPAxis.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPNodeTest.h"
#import "XPNodeSetValue.h"
#import "XPEmptyNodeSet.h"
#import "XPLocalOrderComparer.h"

#import <libxml/tree.h>

#define XPSTR(zstr) [NSString stringWithUTF8String:(const char *)(zstr)];

static NSUInteger XPIndexInParent(xmlNodePtr node) {
    xmlNodePtr parent = node->parent;
    
    NSUInteger idx = 0;
    for (xmlNodePtr child = parent->children; NULL != child; ++idx, child = child->next) {
        if (child == node) {
            break;
        }
    }
    
    return idx;
}

@interface XPLibXmlNodeImpl ()
@property (nonatomic, assign) xmlNodePtr node;
@property (nonatomic, retain) id <XPNodeInfo>parent;
@end

@implementation XPLibXmlNodeImpl

+ (id <XPNodeInfo>)nodeInfoWithNode:(void *)inNode {
    xmlNodePtr node = (xmlNodePtr)inNode;
    Class cls = (XML_DOCUMENT_NODE == node->type) ? [XPLibXmlDocumentImpl class] : [XPLibXmlNodeImpl class];
    id <XPNodeInfo>nodeInfo = [[[cls alloc] initWithNode:node] autorelease];
    return nodeInfo;
}


- (id <XPNodeInfo>)initWithNode:(void *)node {
    NSParameterAssert(node);
    self = [super init];
    if (self) {
        self.node = node;
        [[self class] incrementInstanceCount];
    }
    return self;
}


- (void)dealloc {
    if (_node) {
        //xmlFreeNode(_node);
        _node = NULL;
    }
    self.parent = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@ %@>", [self class], self, XPNodeTypeName[self.nodeType], self.name];
}


- (BOOL)isSameNodeInfo:(id <XPNodeInfo>)other {
    XPAssert(!other || [other isKindOfClass:[XPBaseNodeInfo class]]);
    return other == self || [(id)other node] == (void *)_node;
}


- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other {
    XPAssert([other isKindOfClass:[XPLibXmlNodeImpl class]]);
    
    NSComparisonResult result = NSOrderedSame;
    
    // are they the same node?
    if ([self isSameNodeInfo:other]) {
        return result;
    }

    XPLibXmlNodeImpl *that = (id)other;

    // are they siblings (common case)
    if ([self.parent isSameNodeInfo:other.parent]) {
        return XPIndexInParent(_node) - XPIndexInParent(that.node);
    }
    
    // find the depths of both nodes in the tree
    
    NSUInteger depth1 = 0;
    NSUInteger depth2 = 0;
    id <XPNodeInfo>p1 = nil;
    id <XPNodeInfo>p2 = nil;
    while (p1) {
        depth1++;
        p1 = p1.parent;
    }
    while (p2) {
        depth2++;
        p2 = p2.parent;
    }
    
    // move up one branch of the tree so we have two nodes on the same level
    
    p1 = self;
    while (depth1>depth2) {
        p1 = p1.parent;
        if ([p1 isSameNodeInfo:that]) {
            return NSOrderedDescending;
        }
        depth1--;
    }
    
    p2 = that;
    while (depth2>depth1) {
        p2 = p2.parent;
        if ([p2 isSameNodeInfo:self]) {
            return NSOrderedAscending;
        }
        depth2--;
    }
    
    // now move up both branches in sync until we find a common parent
    while (1) {
        id <XPNodeInfo>par1 = p1.parent;
        id <XPNodeInfo>par2 = p2.parent;
        if (!par1 || !par2) {
            [NSException raise:@"NullPointerException" format:@"NSXML Tree Compare - internal error"];
        }
        if ([par1 isSameNodeInfo:par2]) {
            return XPIndexInParent(((XPLibXmlNodeImpl *)p1).node) - XPIndexInParent(((XPLibXmlNodeImpl *)p2).node);
        }
        p1 = par1;
        p2 = par2;
    }

    return result;
}


- (XPNodeType)nodeType {
    XPAssert(_node);
    XPNodeType type = XPNodeTypeNone;
    
    xmlElementType kind = _node->type;
    switch (kind) {
        case XML_DOCUMENT_NODE:
            type = XPNodeTypeRoot;
            break;
        case XML_ELEMENT_NODE:
            type = XPNodeTypeElement;
            break;
        case XML_ATTRIBUTE_NODE:
            type = XPNodeTypeAttribute;
            break;
        case XML_NAMESPACE_DECL:
            type = XPNodeTypeNamespace;
            break;
        case XML_PI_NODE:
            type = XPNodeTypePI;
            break;
        case XML_COMMENT_NODE:
            type = XPNodeTypeComment;
            break;
        case XML_TEXT_NODE:
            type = XPNodeTypeText;
            break;
        case XML_CDATA_SECTION_NODE:
        case XML_ENTITY_REF_NODE:
        case XML_ENTITY_NODE:
        case XML_DOCUMENT_TYPE_NODE:
        case XML_DOCUMENT_FRAG_NODE:
        case XML_NOTATION_NODE:
        case XML_HTML_DOCUMENT_NODE:
        case XML_DTD_NODE:
        case XML_ELEMENT_DECL:
        case XML_ATTRIBUTE_DECL:
        case XML_ENTITY_DECL:
        case XML_XINCLUDE_START:
        case XML_XINCLUDE_END:
        default:
            type = XPNodeTypeNone;
            break;
    }
    
    return type;
}


- (NSString *)stringValue {
    XPAssert(_node);
    xmlChar *zstr = _node->content;
    return XPSTR(zstr);
}


- (NSString *)name {
    XPAssert(_node);
    return XPSTR(_node->name);
}


- (NSString *)localName {
    XPAssert(_node);
    return XPSTR(_node->name);
}


- (NSString *)prefix {
    XPAssert(_node);
    return XPSTR(_node->ns->prefix);
}


- (id <XPNodeInfo>)parent {
    XPAssert(_node);
    
    if (!_parent) {
        xmlNodePtr parent = _node->parent;
        if (parent) {
            self.parent = [[self class] nodeInfoWithNode:parent];
        }
    }
    
    return _parent;
}


- (id <XPDocumentInfo>)documentRoot {
    XPAssert(_node);
    xmlDocPtr doc = _node->doc;
    return [[[XPLibXmlDocumentImpl alloc] initWithNode:doc] autorelease];
}


- (NSString *)attributeValueForURI:(NSString *)uri localName:(NSString *)localName {
    XPAssert(XPNodeTypeElement == self.nodeType);
    
    NSString *res = nil;
    for (xmlAttrPtr attr = _node->properties; NULL != attr; attr = attr->next) {
        if (0 == strcmp((char *)attr->name, [localName UTF8String])) {
            xmlNodePtr val = attr->children;
            if (val) {
                res = XPSTR(val->content);
            }
            break;
        }
    }

    return res;
}


- (NSString *)namespaceURIForPrefix:(NSString *)prefix {
    XPAssert(_node);
    
    NSString *res = nil;
    
    for (xmlNsPtr ns = _node->nsDef; NULL != ns; ns = ns->next) {
        if (0 == strcmp((char *)ns->prefix, [prefix UTF8String])) {
            res = XPSTR(ns->href);
        }
    }
    return res;
}


- (NSArray *)nodesForSelfAxis:(XPNodeTest *)nodeTest {
    NSArray *result = nil;
    
    if ([nodeTest matches:self]) {
        result = @[self];
    }
    
    return result;
}


- (NSArray *)descendantNodesFromParent:(xmlNodePtr)parent nodeTest:(XPNodeTest *)nodeTest {
    NSMutableArray *result = [NSMutableArray array];
    
    for (xmlNodePtr child = parent->children; NULL != child; child = child->next) {
    
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:child];
        
        if ([nodeTest matches:node]) {
            [result addObject:node];
        }

        [result addObjectsFromArray:[self descendantNodesFromParent:child nodeTest:nodeTest]];
    }
    
    return result;
}


- (NSArray *)nodesForDescendantOrSelfAxis:(XPNodeTest *)nodeTest {
    NSMutableArray *result = [NSMutableArray array];
    
    if ([nodeTest matches:self]) {
        [result addObject:self];
    }
    
    [result addObjectsFromArray:[self descendantNodesFromParent:self.node nodeTest:nodeTest]];
    
    return result;
}


- (NSArray *)nodesForDescendantAxis:(XPNodeTest *)nodeTest {
    NSMutableArray *nodes = [NSMutableArray array];
    
    [nodes addObjectsFromArray:[self descendantNodesFromParent:self.node nodeTest:nodeTest]];
    
    return nodes;
}


- (NSArray *)nodesForAncestorOrSelfAxis:(XPNodeTest *)nodeTest {
    NSMutableArray *result = [NSMutableArray array];
    
    if ([nodeTest matches:self]) {
        [result addObject:self];
    }
    
    [result addObjectsFromArray:[self nodesForAncestorAxis:nodeTest]];
    
    return result;
}


- (NSArray *)nodesForAncestorAxis:(XPNodeTest *)nodeTest {
    XPAssert(_node);
    
    NSMutableArray *result = nil;
    
    xmlNodePtr parent = _node->parent;
    while (parent) {
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:parent];
        
        if ([nodeTest matches:node]) {
            if (!result) {
                result = [NSMutableArray array];
            }
            [result addObject:node];
        }
        
        parent = parent->parent;
    }
    
    return result;
}


- (NSArray *)nodesForParentAxis:(XPNodeTest *)nodeTest {
    XPAssert(_node);
    xmlNodePtr parent = _node->parent;

    id <XPNodeInfo>node = [[self class] nodeInfoWithNode:parent];
    
    NSArray *result = nil;
    
    if ([nodeTest matches:node]) {
        result = @[node];
    }
    
    return result;
}


- (NSArray *)nodesForChildAxis:(XPNodeTest *)nodeTest {
    XPAssert(_node);
    NSMutableArray *result = nil;
    
    for (xmlNodePtr child = _node->children; NULL != child; child = child->next) {
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:child];
        
        if ([nodeTest matches:node]) {
            if (!result) {
                result = [NSMutableArray array];
            }
            [result addObject:node];
        }
    }
    
    return result;
}


- (NSArray *)nodesForAttributeAxis:(XPNodeTest *)nodeTest {
    XPAssert(_node);
    NSMutableArray *result = nil;

    if (XPNodeTypeElement == self.nodeType) {

        for (xmlAttrPtr attr = _node->properties; NULL != attr; attr = attr->next) {
            id <XPNodeInfo>node = [[self class] nodeInfoWithNode:attr];
            
            if ([nodeTest matches:node]) {
                if (!result) {
                    result = [NSMutableArray array];
                }
                [result addObject:node];
            }
        }
    }
    
    return result;
}


- (NSArray *)nodesForFollowingSiblingAxis:(XPNodeTest *)nodeTest includeDescendants:(BOOL)includeDescendants {
    XPAssert(_node);
    NSMutableArray *result = [NSMutableArray array];

    xmlNodePtr parent = _node->parent;

    BOOL found = NO;
    for (xmlNodePtr child = parent->children; NULL != child; child = child->next) {
        if (!found) {
            found = child == _node;
        }
        if (!found) {
            continue;
        }
        
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:child];
        
        if ([nodeTest matches:node]) {
            [result addObject:node];
        }
        
        if (includeDescendants) {
            [result addObjectsFromArray:[self descendantNodesFromParent:child nodeTest:nodeTest]];
        }
    }
    
    return result;
}


- (NSArray *)nodesForPrecedingSiblingAxis:(XPNodeTest *)nodeTest includeDescendants:(BOOL)includeDescendants  {
    XPAssert(_node);
    NSMutableArray *result = [NSMutableArray array];
    
    xmlNodePtr parent = _node->parent;
    
    BOOL found = NO;
    for (xmlNodePtr child = parent->last; NULL != child; child = child->prev) {
        if (!found) {
            found = child == _node;
        }
        if (!found) {
            continue;
        }
        
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:child];
        
        if ([nodeTest matches:node]) {
            [result addObject:node];
        }

        if (includeDescendants) {
            [result addObjectsFromArray:[self descendantNodesFromParent:child nodeTest:nodeTest]];
        }
    }
    
    return result;
}

@end
