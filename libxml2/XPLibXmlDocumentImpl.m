//
//  XPLibXmlDocumentImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPLibXmlDocumentImpl.h"

@implementation XPLibXmlDocumentImpl

- (XPNodeType)nodeType {
    return XPNodeTypeRoot;
}


- (id <XPDocumentInfo>)documentRoot {
    return self;
}

@end
