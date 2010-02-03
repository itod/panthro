//
//  FNString.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNString.h>
#import <Exedore/XPContext.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPStringValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNString

- (NSString *)name {
    return @"string";
}


- (NSInteger)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    NSUInteger num = [self checkArgumentCountForMin:0 max:1];
    
    if (1 == num) {
        id arg0 = [[args objectAtIndex:0] simplify];
        [args replaceObjectAtIndex:0 withObject:arg0];
        
        if (XPDataTypeString == [arg0 dataType]) {
            return arg0;
        }
        if ([arg0 isValue]) {
            return [XPStringValue stringValueWithString:[arg0 asString]];
        }
    }
    
    return self;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        return [[args objectAtIndex:0] evaluateAsStringInContext:ctx];
    } else {
        return [[ctx contextNodeInfo] stringValue];
    }
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPStringValue stringValueWithString:[self evaluateAsStringInContext:ctx]];
}


- (NSUInteger)dependencies {
    if (1 == [self numberOfArguments]) {
        return [(XPExpression *)[args objectAtIndex:0] dependencies];
    } else {
        return XPDependenciesContextNode;
    }
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        FNString *f = [[[FNString alloc] init] autorelease];
        [f addArgument:[[args objectAtIndex:0] reduceDependencies:dep inContext:ctx]];
        [f setStaticContext:[self staticContext]];
        return [f simplify];
    } else {
        if (dep & XPDependenciesContextNode) {
            return [self evaluateInContext:nil];
        } else {
            return self;
        }
    }
}

@end
