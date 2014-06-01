//
//  XPLibxmlNamespaceImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPLibxmlNamespaceImpl.h"

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
    NSString *localName = @"";
    xmlChar *zstr = (void *)self.node->children; // for some reason, libxml ns nodes store their ns uri in their 'children' pointer
    if (zstr) {
        localName = [NSString stringWithUTF8String:(char *)zstr];
    }
    return localName;
}


- (NSString *)prefix {
    return @"";
}


- (NSString *)namespaceURI {
    return @"";
}

@end
