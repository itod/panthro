//
//  FNHead.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNHead.h"
#import "XPContext.h"
#import "XPNodeInfo.h"
#import <Panthro/XPValue.h>
#import "XPEmptySequence.h"
#import "XPSingletonNodeSet.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNHead

+ (NSString *)name {
    return @"head";
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
    XPValue *result = [XPEmptySequence instance];
    
    id <XPItem>item = [[self.args[0] evaluateInContext:ctx] head];
    
    if (item != [XPEmptySequence instance]) {
        // must be either single atomic value or single node, cuz we just called -head, and sequences can't nest
        if ([item isAtomic]) {
            result = (id)item;
        } else {
            XPAssert([item conformsToProtocol:@protocol(XPNodeInfo)]);
            result = [[[XPSingletonNodeSet alloc] initWithNode:(id)item] autorelease];
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
    FNHead *f = [[[FNHead alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
