//
//  FNEndsWith.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNEndsWith.h"
#import "XPValue.h"
#import "XPBooleanValue.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNEndsWith

+ (NSString *)name {
    return @"ends-with";
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:2 max:2];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    id arg1 = [self.args[1] simplify];
    self.args[1] = arg1;
    
    if ([arg0 isValue] && [arg1 isValue]) {
        result = [self evaluateInContext:nil];
    }
    
    if ([arg1 isValue] && [[arg1 asString] isEqualToString:@""]) {
        result = [XPBooleanValue booleanValueWithBoolean:YES];
    }
    
    result.range = self.range;
    return result;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    NSString *s0 = [self.args[0] evaluateAsStringInContext:ctx];
    NSString *s1 = [self.args[1] evaluateAsStringInContext:ctx];
    return [s0 hasSuffix:s1];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    XPValue *val = [XPBooleanValue booleanValueWithBoolean:b];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNEndsWith *f = [[[FNEndsWith alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
