//
//  XPNameTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPNameTest.h"
#import "XPNodeInfo.h"

@interface XPNameTest ()
@property (nonatomic, copy, readwrite) NSString *namespaceURI;
@property (nonatomic, copy, readwrite) NSString *localName;
@property (nonatomic, assign) BOOL isNamespaceURIWildcard;
@property (nonatomic, assign) BOOL isLocalNameWildcard;
@end

@implementation XPNameTest

- (instancetype)initWithNamespaceURI:(NSString *)nsURI localName:(NSString *)localName {
    self = [super init];
    if (self) {
        self.namespaceURI = nsURI ? nsURI : @"";
        self.localName = localName;

        self.isLocalNameWildcard = [localName isEqualToString:@"*"];
        self.isNamespaceURIWildcard = [nsURI isEqualToString:@"*"] || (_isLocalNameWildcard && 0 == [_namespaceURI length]);
        
        self.nodeType = XPNodeTypeNode;
    }
    return self;
}


- (void)dealloc {
    self.namespaceURI = nil;
    self.localName = nil;
    [super dealloc];
}


- (NSString *)description {
    if ([_namespaceURI length]) {
        return [NSString stringWithFormat:@"%@:%@", _namespaceURI, _localName];
    } else {
        return _localName;
    }
}


- (BOOL)matches:(XPNodeType)nodeType namespaceURI:(NSString *)nsURI localName:(NSString *)localName {
    XPAssert(nsURI);
    XPAssert(localName);
    
    BOOL nsURIMatches = NO;
    BOOL localNameMatches = NO;
    BOOL typeMatches = (XPNodeTypeNode == nodeType || self.nodeType == nodeType);
    
    if (typeMatches) {
        nsURIMatches = _isNamespaceURIWildcard || [_namespaceURI isEqualToString:nsURI];
        if (nsURIMatches) {
            localNameMatches = _isLocalNameWildcard || [_localName isEqualToString:localName];
        }
    }
    
    BOOL matches = typeMatches && nsURIMatches && localNameMatches;
    return matches;
}

@end
