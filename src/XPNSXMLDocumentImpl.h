//
//  XPNSXMLDocumentImpl.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import <XPath/XPDocumentInfo.h>

@interface XPNSXMLDocumentImpl : NSObject <XPDocumentInfo>

- (instancetype)initWithNode:(NSXMLDocument *)doc;
@end
