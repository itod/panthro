//
//  FNBoolean.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNBoolean.h"
#import "XPValue.h"
#import "XPBooleanValue.h"

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNBoolean

+ (NSString *)name {
    return @"boolean";
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
        result = [XPBooleanValue booleanValueWithBoolean:[arg0 asBoolean]];
    }
    
    result.range = self.range;
    return result;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    return [self.args[0] evaluateAsBooleanInContext:ctx];
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
    FNBoolean *f = [[[FNBoolean alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
