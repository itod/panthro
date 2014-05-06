//
//  FNCount.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/FNCount.h>
#import <XPath/XPValue.h>
#import <XPath/XPNumericValue.h>
#import <XPath/XPNodeEnumeration.h>
#import <XPath/XPNodeSetValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNCount

- (NSString *)name {
    return @"count";
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
    NSInteger n = 0;
    id <XPNodeEnumeration>enm = [(XPNodeSetValue *)self.args[0] enumerateInContext:ctx sorted:YES];
    while ([enm hasMoreObjects]) {
        [enm nextObject];
        n++;
    }
    return (double)n;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double n = [self evaluateAsBooleanInContext:ctx];
    return [XPNumericValue numericValueWithNumber:n];
}


- (NSUInteger)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNCount *f = [[[FNCount alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    [f setStaticContext:[self staticContext]];
    return self;
}

@end
