//
//  XPExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"
#import "XPContext.h"
#import "XPStaticContext.h"
#import "XPValue.h"
#import "XPSequenceValue.h"
#import "XPSequenceExtent.h"
#import "XPSequenceEnumeration.h"
#import "XPEGParser.h"
#import "XPAssembler.h"
#import "XPException.h"
#import <PEGKit/PKAssembly.h>

NSString * const XPathErrorDomain = @"XPathErrorDomain";

const NSUInteger XPathErrorCodeCompiletime = 1;
const NSUInteger XPathErrorCodeRuntime = 2;

@implementation XPExpression

//+ (void)initialize {
//    if ([XPExpression class] == self) {
//
//    }
//}


+ (XPExpression *)expressionFromString:(NSString *)exprStr inContext:(id <XPStaticContext>)env error:(NSError **)outErr {
    return [self expressionFromString:exprStr inContext:env simplify:YES error:outErr];
}


+ (XPExpression *)expressionFromString:(NSString *)exprStr inContext:(id <XPStaticContext>)env simplify:(BOOL)simplify error:(NSError **)outErr {
    XPExpression *expr = nil;
    @try {
        XPAssembler *ass = [[[XPAssembler alloc] initWithContext:env] autorelease];
        XPEGParser *parser = [[[XPEGParser alloc] initWithDelegate:ass] autorelease];
        PKAssembly *a = [parser parseString:exprStr error:outErr];
        expr = [a pop];

        if (expr) {
            if (simplify) {
                expr = [expr simplify];
            }
            expr.staticContext = env;
        }
    }
    @catch (XPException *ex) {
        if (outErr) {
            id info = @{NSLocalizedDescriptionKey: [ex name], NSLocalizedFailureReasonErrorKey: [ex reason], XPathExceptionRangeKey: [NSValue valueWithRange:[ex range]]};
            *outErr = [NSError errorWithDomain:XPathErrorDomain code:XPathErrorCodeCompiletime userInfo:info];
        }
    }
    return expr;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.range = NSMakeRange(NSNotFound, 0);
    }
    return self;
}


- (void)dealloc {
    self.staticContext = nil;
    [super dealloc];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    return [[self evaluateInContext:ctx] asBoolean];
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    return [[self evaluateInContext:ctx] asNumber];
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    return [[self evaluateInContext:ctx] asString];
}


- (XPSequenceValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    XPValue *v = [self evaluateInContext:ctx];
    v.range = self.range;
    
    if (![v isSequenceValue]) {
        [XPException raiseIn:self format:@"The value `%@` is not a node-set", v];
    }

    return (XPSequenceValue *)v;
}


- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    XPValue *v = [self evaluateInContext:ctx];

    if ([v isSequenceValue]) {
        if (sorted) {
            [(XPSequenceValue *)v sort];
        }
        id <XPSequenceEnumeration>enm = [(XPSequenceValue *)v enumerateInContext:ctx sorted:sorted];
        return enm;
    }
    
    XPSequenceValue *seq = [[[XPSequenceExtent alloc] initWithContent:@[v]] autorelease];
    if (sorted) [seq sort];
    return [seq enumerate];
}


- (BOOL)isValue {
    return [self isKindOfClass:[XPValue class]];
}


- (BOOL)isContextDocumentNodeSet {
    return NO;
}


- (BOOL)containsReferences {
    return 0 != ([self dependencies] & XPDependenciesVariables);
}


- (BOOL)usesCurrent {
    return 0 != ([self dependencies] & XPDependenciesCurrentNode);
}


- (XPExpression *)simplify {
    return self;
}


- (XPDependencies)dependencies {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (XPDataType)dataType {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NSNotFound;
}

@end
