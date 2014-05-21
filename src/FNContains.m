//
//  FNContains.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNContains.h"
#import "XPValue.h"
#import "XPBooleanValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNContains

+ (NSString *)name {
    return @"contains";
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
    } else if ([arg1 isValue] && [[arg1 asString] isEqualToString:@""]) {
        result =[XPBooleanValue booleanValueWithBoolean:YES];
    }
    
    result.range = self.range;
    return result;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    NSString *s0 = [self.args[0] evaluateAsStringInContext:ctx];
    NSString *s1 = [self.args[1] evaluateAsStringInContext:ctx];
    return NSNotFound != [s0 rangeOfString:s1].location;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPBooleanValue booleanValueWithBoolean:[self evaluateAsBooleanInContext:ctx]];
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNContains *f = [[[FNContains alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
