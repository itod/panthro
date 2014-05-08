//
//  XPNameTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPNameTest.h"
#import "XPNodeInfo.h"

@interface XPNameTest ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, assign) BOOL isWildcard;
@end

@implementation XPNameTest

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.isWildcard = [name isEqualToString:@"*"];
        self.nodeType = XPNodeTypeNode;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    [super dealloc];
}


- (NSString *)description {
    return _name;
}


- (BOOL)matches:(XPNodeType)nodeType name:(NSString *)name {
    BOOL matches = NO;
    if ((XPNodeTypeNode == nodeType || self.nodeType == nodeType) && (_isWildcard || [_name isEqualToString:name])) {
        matches = YES;
    }
    return matches;
}

@end
