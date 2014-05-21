//
//  FNCount.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNCount.h"
#import "XPValue.h"
#import "XPNumericValue.h"
#import "XPNodeEnumeration.h"
#import "XPNodeSetValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNCount

+ (NSString *)name {
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


- (XPDependencies)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNCount *f = [[[FNCount alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    f.staticContext = self.staticContext;
    f.range = self.range;
    return self;
}

@end
