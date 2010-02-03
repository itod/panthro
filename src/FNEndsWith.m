//
//  FNEndsWith.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNEndsWith.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPBooleanValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNEndsWith

- (NSString *)name {
    return @"ends-with";
}


- (NSInteger)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:2 max:2];
    
    id arg0 = [[args objectAtIndex:0] simplify];
    [args replaceObjectAtIndex:0 withObject:arg0];
    
    id arg1 = [[args objectAtIndex:1] simplify];
    [args replaceObjectAtIndex:1 withObject:arg1];
    
    if ([arg0 isValue] && [arg1 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    if ([arg1 isValue] && [[arg1 asString] isEqualToString:@""]) {
        return [XPBooleanValue booleanValueWithBoolean:YES];
    }
    
    return self;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    NSString *s0 = [[args objectAtIndex:0] evaluateAsStringInContext:ctx];
    NSString *s1 = [[args objectAtIndex:1] evaluateAsStringInContext:ctx];
    return [s0 hasSuffix:s1];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPBooleanValue booleanValueWithBoolean:[self evaluateAsBooleanInContext:ctx]];
}


- (NSUInteger)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNEndsWith *f = [[[FNEndsWith alloc] init] autorelease];
    for (XPExpression *arg in args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
