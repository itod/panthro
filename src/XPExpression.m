//
//  XPExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPExpression.h>
#import <XPath/XPContext.h>
#import <XPath/XPStaticContext.h>
#import <XPath/XPValue.h>
#import <XPath/XPNodeSetValue.h>
#import <XPath/XPNodeEnumerator.h>
#import "NSError+XPAdditions.h"
//#import "XPParser.h"
#import "XPEGParser.h"
#import "XPAssembler.h"
#import <PEGKit/PKAssembly.h>

static XPEGParser *sParser = nil;
static XPAssembler *sAssembler = nil;

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@implementation XPExpression

+ (void)initialize {
    if ([XPExpression class] == self) {
        sAssembler = [[XPAssembler alloc] init];
        sParser = [[XPEGParser alloc] initWithDelegate:sAssembler];
        XPAssert(sParser);
    }
}


+ (XPExpression *)expressionFromString:(NSString *)exprStr inContext:(id <XPStaticContext>)env error:(NSError **)outErr {
    XPAssert(sParser);
    @try {
//        XPExpression *expr = [sParser parseExpression:exprStr inContext:env];
        PKAssembly *a = [sParser parseString:exprStr error:outErr];

        XPExpression *expr = [a pop];
        XPAssert([expr isKindOfClass:[XPExpression class]]);
        
        expr = [expr simplify];
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
    
    if ([v isNodeSetValue]) {
        return (XPNodeSetValue *)v;
    } else {
        [NSException raise:@"XPathException" format:@"The value %@ is not a node-set", v];
        return nil;
    }
}


- (XPNodeEnumerator *)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    XPValue *v = [self evaluateInContext:ctx];

    if ([v isNodeSetValue]) {
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

@end
