//
//  FNInsertBefore.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNInsertBefore.h"
#import "XPValue.h"
#import "XPAtomicSequence.h"
#import "XPEmptySequence.h"
#import "XPSequenceEnumeration.h"
#import "XPEGParser.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNInsertBefore

+ (NSString *)name {
    return @"insert-before";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
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

    if ([arg0 isValue] && [arg1 isValue] && [arg2 isValue]) {
        result = [self evaluateAsSequenceInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    //id <XPItem>arg = [self.args[0] evaluateInContext:ctx];
    XPSequenceValue *seq = nil;
    seq.range = self.range;
    return seq;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *val = [self evaluateAsSequenceInContext:ctx];
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
    FNInsertBefore *f = [[[FNInsertBefore alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
