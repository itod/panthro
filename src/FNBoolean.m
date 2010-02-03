//
//  FNBoolean.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNBoolean.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPBooleanValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNBoolean

- (NSString *)name {
    return @"boolean";
}


- (NSInteger)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [[args objectAtIndex:0] simplify];
    [args replaceObjectAtIndex:0 withObject:arg0];
    
    if ([arg0 isValue]) {
        return [XPBooleanValue booleanValueWithBoolean:[arg0 asBoolean]];
    }
    
    return self;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    return [[args objectAtIndex:0] evaluateAsBooleanInContext:ctx];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL res = [self evaluateAsBooleanInContext:ctx];
    return [XPBooleanValue booleanValueWithBoolean:res];
}


- (NSUInteger)dependencies {
    return [(XPExpression *)[args objectAtIndex:0] dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNBoolean *f = [[[FNBoolean alloc] init] autorelease];
    [f addArgument:[[args objectAtIndex:0] reduceDependencies:dep inContext:ctx]];
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
