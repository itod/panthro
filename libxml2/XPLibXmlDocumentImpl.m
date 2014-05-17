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

@end
