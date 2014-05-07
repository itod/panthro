//
//  XPNameTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPNameTest.h"

@interface XPNameTest ()
@property (nonatomic, copy, readwrite) NSString *name;
@end

@implementation XPNameTest

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
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

@end
