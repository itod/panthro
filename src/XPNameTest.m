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


- (BOOL)matches:(id <XPNodeInfo>)node {
    BOOL matches = NO;
    if (_isWildcard || [_name isEqualToString:node.nodeName]) {
        matches = YES;
    }
    return matches;
}


- (BOOL)matches:(XPNodeType)nodeType name:(NSString *)nodeName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}

@end
