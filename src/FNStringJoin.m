//
//  FNStringJoin.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNStringJoin.h"
#import "XPValue.h"
#import "XPStringValue.h"
#import "XPSequenceValue.h"
#import "XPSequenceEnumeration.h"

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNStringJoin

+ (NSString *)name {
    return @"string-join";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:1 max:2];

    BOOL allKnown = YES;
    NSMutableArray *newArgs = [NSMutableArray arrayWithCapacity:[self.args count]];
    for (XPExpression *arg in self.args) {
        arg = [arg simplify];
        [newArgs addObject:arg];
        if (![arg isValue]) {
            allKnown = NO;
        }
    }
    
    self.args = newArgs;
    
    if (allKnown) {
        result = [self evaluateInContext:nil];
    }

    result.range = self.range;
    return result;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSMutableString *ms = [NSMutableString string];
    
    NSString *sep = @"";
    if ([self numberOfArguments] > 1) {
        sep = [self.args[1] evaluateAsStringInContext:ctx];
    }
    
    id <XPSequenceEnumeration>enm = [self.args[0] enumerateInContext:ctx sorted:YES];
    
    BOOL isEmpty = ![enm hasMoreItems];
    
    if (!isEmpty) {
        while ([enm hasMoreItems]) {
            [ms appendFormat:@"%@%@", [[enm nextItem] stringValue], sep];
        }
        
        NSUInteger sepLen = [sep length];
        if (sepLen) {
            [ms replaceCharactersInRange:NSMakeRange([ms length]-sepLen, sepLen) withString:@""];
        }
    }
    
    return [[ms copy] autorelease];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSString *str = [self evaluateAsStringInContext:ctx];
    XPValue *val = [XPStringValue stringValueWithString:str];
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
    FNStringJoin *f = [[[FNStringJoin alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
