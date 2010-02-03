//
//  XPFunction.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPFunction.h>
#import "NSError+XPAdditions.h"

@interface XPFunction ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation XPFunction

- (void)dealloc {
    self.args = nil;
    [super dealloc];
}


- (void)addArgument:(XPExpression *)expr {
    if (!args) {
        self.args = [NSMutableArray arrayWithCapacity:6];
    }
    [args addObject:expr];
}


- (NSUInteger)numberOfArguments {
    return [args count];
}


- (NSString *)name {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


#pragma mark -
#pragma mark Protected

- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max {
    NSUInteger num = [self numberOfArguments];
    if (min == max && num != min) {
        [NSException raise:@"XPathException" format:@"Invalid numer of args supplied to %@() function. %d expected. %d given", [self name], min, num];
    }
    if (num < min) {
        [NSException raise:@"XPathException" format:@"Invalid numer of args supplied to %@() function. at least %d expected. %d given", [self name], min, num];
    }
    if (num > max) {
        [NSException raise:@"XPathException" format:@"Invalid numer of args supplied to %@() function. only %d accepted. %d given", [self name], min, num];
    }
    return num;
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@boolean (%@)", [self indent:level], [self asString]);
}

@synthesize args;
@end
