//
//  FNData.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNData.h"
#import "XPValue.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNData

+ (NSString *)name {
    return @"data";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:1 max:1];
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    return self;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    id <XPItem>arg = [self.args[0] evaluateInContext:ctx];
    XPValue *val = XPAtomize(arg);
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNData *f = [[[FNData alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
