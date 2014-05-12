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

@end
