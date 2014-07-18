//
//  FNIndexOf.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNIndexOf.h"
#import "XPValue.h"
#import "XPNumericValue.h"
#import "XPSequenceEnumeration.h"
#import "XPSequenceValue.h"
#import "XPEmptySequence.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNIndexOf

+ (NSString *)name {
    return @"index-of";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:2 max:3];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    id arg1 = [self.args[1] simplify];
    self.args[1] = arg1;
    
    BOOL isArg2Value = YES;

    // ignoring collation arg for now
    if ([self numberOfArguments] > 2) {
        id arg2 = [self.args[2] simplify];
        self.args[2] = arg2;
        
        isArg2Value = [arg2 isValue];
    }

    if ([arg0 isValue]) {
        if (arg0 == [XPEmptySequence instance]) {
            result = [XPEmptySequence instance];
        } else if ([arg1 isValue] && isArg2Value) {
            result = [self evaluateAsSequenceInContext:nil];
        }
    }
    
    result.range = self.range;
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *val = [self evaluateAsSequenceInContext:ctx];
    return val;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPSequenceValue *result = [XPEmptySequence instance];
    
    XPValue *seq = [self.args[0] evaluateInContext:ctx];

    if (seq != [XPEmptySequence instance]) {
        NSMutableArray *content = [NSMutableArray array];
        
        id <XPItem>target = [[self.args[1] evaluateInContext:ctx] head];
        
        NSUInteger n = 1;
        id <XPSequenceEnumeration>enm = [seq enumerateInContext:ctx sorted:NO];
        while ([enm hasMoreItems]) {
            id <XPItem>item = [enm nextItem];
            if ([target isEqual:item]) {
                [content addObject:[XPNumericValue numericValueWithNumber:n]];
            }
            n++;
        }
        
        if ([content count]) {
            result = [[[XPSequenceExtent alloc] initWithContent:content] autorelease];
        }
    }

    result.range = self.range;
    return result;
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNIndexOf *f = [[[FNIndexOf alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
