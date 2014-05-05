//
//  XPNSXMLDocumentImpl.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPNSXMLDocumentImpl.h"

@interface XPNSXMLDocumentImpl ()
@property (nonatomic, retain) NSXMLDocument *node;
@end

@implementation XPNSXMLDocumentImpl

- (instancetype)initWithNode:(NSXMLDocument *)doc {
    self = [super init];
    if (self) {
        self.node = doc;
    }
    return self;
}


- (void)dealloc {
    self.node = nil;
    [super dealloc];
}

@end
