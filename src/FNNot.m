//
//  FNNot.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/FNNot.h>
#import <XPath/XPValue.h>
#import <XPath/XPBooleanValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNNot

- (NSString *)name {
    return @"not";
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    if ([arg0 isValue]) {
        return [XPBooleanValue booleanValueWithBoolean:![arg0 asBoolean]];
    }
    
    return self;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    return ![self.args[0] evaluateAsBooleanInContext:ctx];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL res = [self evaluateAsBooleanInContext:ctx];
    return [XPBooleanValue booleanValueWithBoolean:res];
}


- (NSUInteger)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNNot *f = [[[FNNot alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    return [f simplify];
}

@end
