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


- (NSString *)prefix {
    return @"";
}


- (NSString *)namespaceURI {
    return @"";
}

@end
