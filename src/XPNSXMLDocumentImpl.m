//
//  XPNSXMLDocumentImpl.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPNSXMLDocumentImpl.h"

@interface XPNSXMLDocumentImpl ()
@end

@implementation XPNSXMLDocumentImpl


- (XPNodeType)nodeType {
    return XPNodeTypeRoot;
}


- (id <XPDocumentInfo>)documentRoot {
    return self;
}

@end
