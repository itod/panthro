//
//  FNRound.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/FNRound.h>
#import <XPath/XPValue.h>
#import <XPath/XPNumericValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNRound

- (NSString *)name {
    return @"round";
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    if ([arg0 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    return round([self.args[0] evaluateAsNumberInContext:ctx]);
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPNumericValue numericValueWithNumber:[self evaluateAsNumberInContext:ctx]];
}


- (NSUInteger)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNRound *f = [[[FNRound alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
