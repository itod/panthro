//
//  XPLibxmlNodeImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPLibxmlNodeImpl.h"
#import "XPLibxmlDocumentImpl.h"
#import "XPAxis.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPNodeTest.h"
#import "XPNodeSetValue.h"
#import "XPEmptyNodeSet.h"
#import "XPLocalOrderComparer.h"

#import <libxml/tree.h>

@interface XPNodeSetValue ()
@property (nonatomic, assign, readwrite, getter=isSorted) BOOL sorted;
@property (nonatomic, assign, readwrite, getter=isReverseSorted) BOOL reverseSorted;
@end

static NSString *XPSTR(const xmlChar *zstr) {
    NSString *res = nil;
    if (zstr) {
        res = [NSString stringWithUTF8String:(const char *)zstr];
    }
    return res;
}

static NSUInteger XPIndexInParent(xmlNodePtr node) {
    xmlNodePtr parent = node->parent;
    
    NSUInteger idx = 0;
    
    // not sure about this ns looping
    for (xmlNsPtr ns = parent->nsDef; NULL != ns; ++idx, ns = ns->next) {
        if (ns == (void *)node) {
            return idx;
        }
    }

    for (xmlAttrPtr attr = parent->properties; NULL != attr; ++idx, attr = attr->next) {
        if (attr == (void *)node) {
            return idx;
        }
    }
    
    for (xmlNodePtr child = parent->children; NULL != child; ++idx, child = child->next) {
        if (child == node) {
            return idx;
        }
    }
    
    return idx;
}

@interface XPLibxmlNodeImpl ()
@property (nonatomic, retain) id <XPNodeInfo>parent;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) NSInteger lineNumber;
@end

@implementation XPLibxmlNodeImpl {
    BOOL _foundRange;
}

+ (id <XPNodeInfo>)nodeInfoWithNode:(void *)inNode parserContext:(xmlParserCtxtPtr)parserCtx {
    xmlNodePtr node = (xmlNodePtr)inNode;
    if (XML_DTD_NODE == node->type) {
        NSLog(@"%@", self);
    }
    Class cls = (XML_DOCUMENT_NODE == node->type) ? [XPLibxmlDocumentImpl class] : [XPLibxmlNodeImpl class];
    id <XPNodeInfo>nodeInfo = [[[cls alloc] initWithNode:node parserContext:parserCtx] autorelease];
    return nodeInfo;
}


- (id <XPNodeInfo>)initWithNode:(void *)node parserContext:(xmlParserCtxtPtr)parserCtx {
    NSParameterAssert(node);
    self = [super init];
    if (self) {
        self.node = node;
        self.parserCtx = parserCtx;
        self.lineNumber = -1;
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
    XPAssert(!other || [other isKindOfClass:[XPLibxmlNodeImpl class]]);
    return other == self || [(id)other node] == (void *)_node;
}


- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other {
    XPAssert([other isKindOfClass:[XPLibxmlNodeImpl class]]);
    
    NSComparisonResult result = NSOrderedSame;
    
    // are they the same node?
    if ([self isSameNodeInfo:other]) {
        return result;
    }
    
    XPLibxmlNodeImpl *that = (id)other;

    // are they siblings (common case)
    if ([self.parent isSameNodeInfo:other.parent]) {
        return XPIndexInParent(_node) - XPIndexInParent(that.node);
    }
    
    // find the depths of both nodes in the tree
    
    NSUInteger depth1 = 0;
    NSUInteger depth2 = 0;
    id <XPNodeInfo>p1 = self;
    id <XPNodeInfo>p2 = other;
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
            [NSException raise:@"NullPointerException" format:@"libxml Tree Compare - internal error"];
        }
        if ([par1 isSameNodeInfo:par2]) {            
            return XPIndexInParent(((XPLibxmlNodeImpl *)p1).node) - XPIndexInParent(((XPLibxmlNodeImpl *)p2).node);
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
    NSString *res = @"";
    xmlChar *zstr = xmlNodeGetContent(_node);
    if (zstr) {
        res = [NSString stringWithUTF8String:(const char *)zstr];
        xmlFree(zstr);
    }
    return res;
}


- (NSString *)name {
    XPAssert(_node);
    NSString *res = nil;
    switch (self.nodeType) {
        case XPNodeTypeElement:
        case XPNodeTypeAttribute:
        case XPNodeTypePI:
        case XPNodeTypeNamespace:
            res = XPSTR(_node->name);
            break;
        case XPNodeTypeRoot:
        case XPNodeTypeComment:
        case XPNodeTypeText:
        case XPNodeTypeNode:
            break;
        default:
            XPAssert(0);
            break;
    }
    return res;
}


- (NSString *)localName {
    XPAssert(_node);
    return XPSTR(_node->name);
}


- (NSString *)prefix {
    XPAssert(_node);
    NSString *res = nil;
    
    if (_node->ns && _node->ns->prefix) {
        res = XPSTR(_node->ns->prefix);
    }

    return res;
}


- (NSRange)range {
    if (!_foundRange) {
        XPAssert(_parserCtx);
        
        NSUInteger loc = NSNotFound;
        NSUInteger len = 0;

        if (XPNodeTypeElement == self.nodeType) {
            
            const xmlParserNodeInfo *info = xmlParserFindNodeInfo(_parserCtx, _node);
            XPAssert(info);

            if (info) {
                loc = info->begin_pos;
                len = info->end_pos - loc;
            }
        }
        
        _foundRange = YES;
        self.range = NSMakeRange(loc, len);
    }

    return _range;
}


- (NSInteger)lineNumber {
    XPAssert(_node);
    if (-1 == _lineNumber) {
        _lineNumber = xmlGetLineNo(_node);
    }
    return _lineNumber;
}


- (id <XPNodeInfo>)parent {
    XPAssert(_node);
    
    if (!_parent) {
        xmlNodePtr parent = _node->parent;
        if (parent) {
            self.parent = [[self class] nodeInfoWithNode:parent parserContext:_parserCtx];
        }
    }
    
    return _parent;
}


- (id <XPDocumentInfo>)documentRoot {
    XPAssert(_node);
    xmlDocPtr doc = _node->doc;
    return [[[XPLibxmlDocumentImpl alloc] initWithNode:doc parserContext:_parserCtx] autorelease];
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
    
//    xmlSearchNs
//    xmlSearchNsByHref
//    xmlGetNsList
    
    
    NSString *res = nil;
    
    xmlNodePtr node = _node;
    
    while (node) {
        if (XML_ELEMENT_NODE == node->type) {
            for (xmlNsPtr ns = node->nsDef; NULL != ns; ns = ns->next) {
                if (ns->prefix && 0 == strcmp((char *)ns->prefix, [prefix UTF8String])) {
                    res = XPSTR(ns->href);
                }
            }
        }
        node = node->parent;
    }
    
    return res;
}


- (id <XPAxisEnumeration>)enumerationForAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest {
    NSArray *nodes = nil;
    BOOL sorted = NO;
    
    switch (axis) {
        case XPAxisAncestor:
            sorted = NO;
            nodes = [self nodesForAncestorAxis:nodeTest];
            break;
        case XPAxisAncestorOrSelf:
            sorted = NO;
            nodes = [self nodesForAncestorOrSelfAxis:nodeTest];
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
            nodes = [self nodesForDescendantAxis:nodeTest];
            break;
        case XPAxisDescendantOrSelf:
            sorted = YES;
            nodes = [self nodesForDescendantOrSelfAxis:nodeTest];
            break;
        case XPAxisFollowing:
            sorted = YES;
            nodes = [self nodesForFollowingSiblingAxis:nodeTest includeDescendants:YES];
            break;
        case XPAxisFollowingSibling:
            sorted = YES;
            nodes = [self nodesForFollowingSiblingAxis:nodeTest includeDescendants:NO];
            break;
        case XPAxisNamespace:
            sorted = YES;
            [NSException raise:@"XPathException" format:@"Namespace Axis not yet implemented."];
            break;
        case XPAxisParent:
            sorted = YES;
            nodes = [self nodesForParentAxis:nodeTest];
            break;
        case XPAxisPreceding:
            sorted = NO;
            nodes = [self nodesForPrecedingSiblingAxis:nodeTest includeDescendants:YES];
            break;
        case XPAxisPrecedingSibling:
            sorted = NO;
            nodes = [self nodesForPrecedingSiblingAxis:nodeTest includeDescendants:NO];
            break;
        case XPAxisSelf:
            sorted = YES;
            nodes = [self nodesForSelfAxis:nodeTest];
            break;
        default:
            XPAssert(0);
            break;
    }
    
    XPNodeSetValue *nodeSet = nil;
    
    if ([nodes count]) {
        nodeSet = [[[XPNodeSetValue alloc] initWithNodes:nodes comparer:[XPLocalOrderComparer instance]] autorelease];
        nodeSet.sorted = sorted;
        nodeSet.reverseSorted = !sorted;
    } else {
        nodeSet = [XPEmptyNodeSet emptyNodeSet];
    }
    
    id <XPAxisEnumeration>enm = (id <XPAxisEnumeration>)[nodeSet enumerate];
    return enm;
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
        if (XML_DTD_NODE == child->type) continue;
        
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:child parserContext:_parserCtx];
        
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
    
    [result addObjectsFromArray:[self descendantNodesFromParent:_node nodeTest:nodeTest]];
    
    return result;
}


- (NSArray *)nodesForDescendantAxis:(XPNodeTest *)nodeTest {
    NSMutableArray *nodes = [NSMutableArray array];
    
    [nodes addObjectsFromArray:[self descendantNodesFromParent:_node nodeTest:nodeTest]];
    
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
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:parent parserContext:_parserCtx];
        
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

    id <XPNodeInfo>node = [[self class] nodeInfoWithNode:parent parserContext:_parserCtx];
    
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
        if (XML_DTD_NODE == child->type) continue;

        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:child parserContext:_parserCtx];
        
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
            id <XPNodeInfo>node = [[self class] nodeInfoWithNode:attr parserContext:_parserCtx];
            
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
        if (XML_DTD_NODE == child->type) continue;

        if (!found) {
            found = child == _node;
            if (found) {
                continue;
            }
        }
        if (!found) {
            continue;
        }
        
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:child parserContext:_parserCtx];
        
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
        if (XML_DTD_NODE == child->type) continue;

        if (!found) {
            found = child == _node;
            if (found) {
                continue;
            }
        }
        if (!found) {
            continue;
        }
        
        id <XPNodeInfo>node = [[self class] nodeInfoWithNode:child parserContext:_parserCtx];
        
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
