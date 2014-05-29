//
//  XPNSXMLDocumentImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPNSXMLDocumentImpl.h"

@implementation XPNSXMLDocumentImpl

- (XPNodeType)nodeType {
    return XPNodeTypeRoot;
}


- (id <XPDocumentInfo>)documentRoot {
    return self;
}


- (id <XPNodeInfo>)selectID:(NSString *)identifier {
    XPAssert(0);
    return nil;
}


- (NSString *)name {
    return @"";
}


- (NSString *)prefix {
    return @"";
}


- (NSString *)namespaceURI {
    return @"";
}

@end
