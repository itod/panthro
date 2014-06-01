//
//  XPLibxmlNamespaceImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPLibxmlNamespaceImpl.h"

static NSString *XPSTR(const xmlChar *zstr) {
    NSString *res = @"";
    if (zstr) {
        res = [NSString stringWithUTF8String:(const char *)zstr];
    }
    return res;
}

@implementation XPLibxmlNamespaceImpl

- (void)dealloc {
    self.parent = nil;
    [super dealloc];
}


- (XPNodeType)nodeType {
    return XPNodeTypeNamespace;
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
