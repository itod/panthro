//
//  XPLibxmlDocumentImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPLibxmlDocumentImpl.h"

@implementation XPLibxmlDocumentImpl

- (XPNodeType)nodeType {
    return XPNodeTypeRoot;
}


- (id <XPDocumentInfo>)documentRoot {
    return self;
}


- (NSString *)name {
    return @"";
}


- (NSString *)localName {
    return @"";
}


- (NSString *)prefix {
    return @"";
}


- (NSString *)namespaceURI {
    return @"";
}


- (id <XPNodeInfo>)selectID:(NSString *)inId {
    XPAssert(self.node);
    XPAssert(self.parserCtx);
    XPAssert(XML_DOCUMENT_NODE == self.node->type || XML_HTML_DOCUMENT_NODE == self.node->type);
    
    id <XPNodeInfo>node = nil;
    
    if ([inId length]) {
        xmlDocPtr doc = (xmlDocPtr)self.node;
        xmlAttrPtr attr = xmlGetID(doc, (const xmlChar *)[inId UTF8String]);
        if (attr) {
            xmlNodePtr el = attr->parent;
            XPAssert(el);
            XPAssert(XML_ELEMENT_NODE == el->type);
            if (el && XML_ELEMENT_NODE == el->type) {
                node = [[[XPLibxmlNodeImpl alloc] initWithNode:el parserContext:self.parserCtx] autorelease];
            }
        }
    }
    return node;
}

@end
