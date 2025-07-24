//
//  FNEmpty.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNEmpty.h"
#import <Panthro/XPValue.h>
#import "XPBooleanValue.h"

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNEmpty

+ (NSString *)name {
    return @"empty";
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    if ([arg0 isValue]) {
        result = [XPBooleanValue booleanValueWithBoolean:[self empty:arg0]];
    }
    
    result.range = self.range;
    return result;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    XPValue *v = [self.args[0] evaluateInContext:ctx];
    BOOL b = [self empty:v];
    return b;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    XPValue *val = [XPBooleanValue booleanValueWithBoolean:b];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNEmpty *f = [[[FNEmpty alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}


- (BOOL)empty:(XPValue *)v {
    XPAssert(v && [v isKindOfClass:[XPValue class]]);
    
    BOOL b = YES;
    
    if (v) {
        if ([v isSequenceValue]) {
            XPSequenceValue *seq = (XPSequenceValue *)v;
            b = ([seq count] == 0);
        } else {
            b = NO;
        }
    }
    
    return b;
}

@end
