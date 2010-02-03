//
//  FNNumber.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNNumber.h>
#import <Exedore/XPContext.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPNumericValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNNumber

- (NSString *)name {
    return @"number";
}


- (NSInteger)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    NSUInteger numArgs = [self checkArgumentCountForMin:0 max:1];
    if (1 == numArgs) {
        id arg0 = [[args objectAtIndex:0] simplify];
        [args replaceObjectAtIndex:0 withObject:arg0];
        
        if (XPDataTypeNumber == [arg0 dataType]) {
            return arg0;
        }
        
        if ([arg0 isValue]) {
            return [XPNumericValue numericValueWithNumber:[arg0 asNumber]];
        }
    }
    
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        return [[args objectAtIndex:0] evaluateAsNumberInContext:ctx];
    } else {
        return XPNumberFromString([[ctx contextNodeInfo] stringValue]);
    }
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPNumericValue numericValueWithNumber:[self evaluateAsNumberInContext:ctx]];
}


- (NSUInteger)dependencies {
    return [(XPExpression *)[args objectAtIndex:0] dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        FNNumber *f = [[[FNNumber alloc] init] autorelease];
        [f addArgument:[[args objectAtIndex:0] reduceDependencies:dep inContext:ctx]];
        [f setStaticContext:[self staticContext]];
        return [f simplify];
    } else {
        if (dep & XPDependenciesContextNode) {
            return [self evaluateInContext:ctx];
        } else {
            return self;
        }
    }
}

@end
