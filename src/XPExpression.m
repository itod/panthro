//
//  XPExpression.m
//  Exedore
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPExpression.h>
#import <Exedore/XPContext.h>
#import <Exedore/XPStaticContext.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPNodeSetValue.h>
#import <Exedore/XPNodeEnumerator.h>
#import "NSError+XPAdditions.h"
#import "XPParser.h"

static XPParser *sParser = nil;

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@implementation XPExpression

+ (void)load {
    if ([XPExpression class] == self) {
        sParser = [[XPParser alloc] init];
    }
}


+ (XPExpression *)expressionFromString:(NSString *)exprStr inContext:(id <XPStaticContext>)env error:(NSError **)outErr {
    @try {
        XPExpression *expr = [[sParser parseExpression:exprStr inContext:env] simplify];
        [expr setStaticContext:env];
        return expr;
    }
    @catch (NSException *e) {
        if (outErr) *outErr = [NSError XPathErrorWithCode:47 format:[e reason]];
    }
    return nil;
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


- (XPNodeSetValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    XPValue *v = [self evaluateInContext:ctx];
    
    if ([v isKindOfClass:[XPNodeSetValue class]]) {
        return (XPNodeSetValue *)v;
    } else {
        [NSException raise:@"XPathException" format:@"The value %@ is not a node-set", v];
        return nil;
    }
}


- (XPNodeEnumerator *)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    XPValue *v = [self evaluateInContext:ctx];
    if ([v isValue]) {
        if (sorted) {
            [(XPNodeSetValue *)v sort];
        }
        XPNodeEnumerator *e = [(XPNodeSetValue *)v enumerate];
        return e;
    }
    [NSException raise:@"XPathException" format:@"The value is not a node-set"];
    return nil;
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


- (NSUInteger)dependencies {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSInteger)dataType {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return -1;
}


- (void)display:(NSInteger)level {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}

@synthesize staticContext;
@end
