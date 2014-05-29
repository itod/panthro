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
@property (nonatomic, assign) BOOL isInNullNamespace;
@property (nonatomic, assign) BOOL isWildcard;
@end

@implementation XPNameTest

- (instancetype)initWithNamespaceURI:(NSString *)nsURI localName:(NSString *)localName {
    self = [super init];
    if (self) {
        self.namespaceURI = nsURI;
        self.localName = localName;
        self.isInNullNamespace = 0 == [nsURI length];
        self.isWildcard = [localName isEqualToString:@"*"];
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
    if (_isInNullNamespace) {
        return _localName;
    } else {
        return [NSString stringWithFormat:@"%@:%@", _namespaceURI, _localName];
    }
}


- (BOOL)matches:(XPNodeType)nodeType namespaceURI:(NSString *)nsURI localName:(NSString *)localName {
    BOOL nsURIMatches = NO;
    BOOL localNameMatches = NO;
    BOOL typeMatches = (XPNodeTypeNode == nodeType || self.nodeType == nodeType);
    
    if (typeMatches) {
        nsURIMatches = (_isInNullNamespace && 0 == [nsURI length]) || [_namespaceURI isEqualToString:nsURI];
        if (nsURIMatches) {
            localNameMatches = _isWildcard || [_localName isEqualToString:localName];
        }
    }
    
    BOOL matches = typeMatches && nsURIMatches && localNameMatches;
    return matches;
}

@end
