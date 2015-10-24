//
//  XPLibxmlNamespaceImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPLibxmlNamespaceImpl.h"
#import <Panthro/XPUtils.h>

@implementation XPLibxmlNamespaceImpl

- (XPNodeType)nodeType {
    return XPNodeTypeNamespace;
}


- (BOOL)isSameNodeInfo:(id <XPNodeInfo>)other {
    XPAssert(!other || [other isKindOfClass:[XPLibxmlNodeImpl class]]);
    BOOL isSame = [super isSameNodeInfo:other];
    
    // ok, I had to patch up the parent nodes of NS NodeInfos, because the parent pointer of xmlNsPtr is always nil.
    // Seems like libxml will represent ghost ns nodes on lots of elements as a single object in memory with no parent pointer.
    // That's reasonable, but not good for XPath 1.0, in which all those nodes are distinct. so check for diff parents here:
    if (isSame && XPNodeTypeNamespace == other.nodeType) {
        isSame = self.parent == other.parent;
    }
    
    return isSame;
}


- (NSString *)name {
    return self.localName;
}


- (NSString *)localName {
    XPAssert(self.node);
    NSString *localName = XPSTR((xmlChar *)self.node->children); // WTF???
    
    // note: in libxml,
    // ->name contains the url string-value of the namespace (the namespaceURI)
    // ->children contains the name of the namespace (the prefix. foo in `xmlns:foo`)
    // we don't need to override -stringValue as xmlNodeGetContent() does the right thing for ns nodes.
    // WTF.

    return localName;
}


- (NSString *)prefix {
    return @"";
}


- (NSString *)namespaceURI {
    return @"";
}

@end
