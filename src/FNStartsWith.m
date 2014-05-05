//
//  FNStartsWith.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/FNStartsWith.h>
#import <XPath/XPValue.h>
#import <XPath/XPBooleanValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNStartsWith

- (NSString *)name {
    return @"starts-with";
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:2 max:2];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    id arg1 = [self.args[1] simplify];
    self.args[1] = arg1;
    
    if ([arg0 isValue] && [arg1 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    if ([arg1 isValue] && [[arg1 asString] isEqualToString:@""]) {
        return [XPBooleanValue booleanValueWithBoolean:YES];
    }
    
    return self;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    NSString *s0 = [self.args[0] evaluateAsStringInContext:ctx];
    NSString *s1 = [self.args[1] evaluateAsStringInContext:ctx];
    return [s0 hasPrefix:s1];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPBooleanValue booleanValueWithBoolean:[self evaluateAsBooleanInContext:ctx]];
}


- (NSUInteger)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNStartsWith *f = [[[FNStartsWith alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
