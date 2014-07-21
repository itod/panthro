//
//  FNTail.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNTail.h"
#import "XPContext.h"
#import "XPNodeInfo.h"
#import "XPValue.h"
#import "XPEmptySequence.h"
#import "XPSequenceEnumeration.h"
#import "XPSingletonNodeSet.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNTail

+ (NSString *)name {
    return @"tail";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;

    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *val = [self evaluateAsSequenceInContext:ctx];
    return val;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPSequenceValue *result = [XPEmptySequence instance];
    
    id <XPSequenceEnumeration>enm = [[self.args[0] evaluateInContext:ctx] enumerate];
    
    if ([enm hasMoreItems]) {
        [enm nextItem]; // drop head
    }
    
    if ([enm hasMoreItems]) {
        NSMutableArray *content = [NSMutableArray array];
        
        while ([enm hasMoreItems]) {
            [content addObject:[enm nextItem]];
        }
        
        result = [[[XPSequenceExtent alloc] initWithContent:content] autorelease];
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
    FNTail *f = [[[FNTail alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
