//
//  XPFunction.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPFunction.h"
#import "XPValue.h"
#import "NSError+XPAdditions.h"

@interface XPFunction ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation XPFunction

- (void)dealloc {
    self.args = nil;
    [super dealloc];
}


- (NSString *)description {
    id str = [NSMutableString stringWithFormat:@"`%@(", [[self class] name]];
    NSUInteger i = 0;
    NSUInteger c = [self numberOfArguments];
    for (id arg in _args) {
        NSString *fmt = i++ == c - 1 ? @"%@" : @"%@, ";
        [str appendFormat:fmt, arg];
    }
    [str appendString:@")`"];
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, str];
}


- (void)addArgument:(XPExpression *)expr {
    NSParameterAssert(expr);
    if (!expr) return; // remove?
    
    if (!_args) {
        self.args = [NSMutableArray arrayWithCapacity:6];
    }
    [_args addObject:expr];
}


- (NSUInteger)numberOfArguments {
    return [_args count];
}


+ (NSString *)name {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


#pragma mark -
#pragma mark Protected

- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max {
    NSUInteger num = [self numberOfArguments];
    if (min == max && num != min) {
        [NSException raise:@"XPathException" format:@"Invalid numer of args supplied to %@() function. %lu expected. %lu given", [[self class] name], min, num];
    }
    if (num < min) {
        [NSException raise:@"XPathException" format:@"Invalid numer of args supplied to %@() function. at least %lu expected. %lu given", [[self class] name], min, num];
    }
    if (num > max) {
        [NSException raise:@"XPathException" format:@"Invalid numer of args supplied to %@() function. only %lu accepted. %lu given", [[self class] name], max, num];
    }
    return num;
}

@end
