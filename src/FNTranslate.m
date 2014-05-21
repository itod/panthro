//
//  FNTranslate.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNTranslate.h"
#import "XPValue.h"
#import "XPStringValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNTranslate

+ (NSString *)name {
    return @"translate";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:3 max:3];

    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;

    id arg1 = [self.args[1] simplify];
    self.args[1] = arg1;
    
    id arg2 = [self.args[2] simplify];
    self.args[2] = arg2;
    
    BOOL fixed = [arg0 isValue] && [arg1 isValue] && [arg2 isValue];
    
    if (fixed) {
        result = [self evaluateInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *src = [self.args[0] evaluateAsStringInContext:ctx];
    NSString *old = [self.args[1] evaluateAsStringInContext:ctx];
    NSString *new = [self.args[2] evaluateAsStringInContext:ctx];

    NSUInteger srcLen = [src length];
    //NSUInteger oldLen = [old length];
    NSUInteger newLen = [new length];
    NSMutableString *buf = [NSMutableString stringWithCapacity:srcLen];
    
    for (NSUInteger i = 0; i < srcLen; ++i) {
        NSString *c = [src substringWithRange:NSMakeRange(i, 1)];
        NSUInteger j = [old rangeOfString:c].location;
        if (NSNotFound == j || j < newLen) {
            [buf appendString:( NSNotFound == j ? c : [new substringWithRange:NSMakeRange(j, 1)])];
        }
    }

    return [[buf copy] autorelease];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPStringValue stringValueWithString:[self evaluateAsStringInContext:ctx]];
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNTranslate *f = [[[FNTranslate alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
