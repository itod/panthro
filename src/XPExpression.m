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
#import "XPNodeSetValue.h"
#import "XPNodeEnumeration.h"
#import "XPEGParser.h"
#import "XPAssembler.h"
#import <PEGKit/PKAssembly.h>

NSString * const XPathExceptionName = @"XPath Exception";
NSString * const XPathExceptionRangeKey = @"range";

NSString * const XPathErrorDomain = @"XPathErrorDomain";

const NSUInteger XPathErrorCodeCompiletime = 1;
const NSUInteger XPathErrorCodeRuntime = 2;

static XPEGParser *sParser = nil;
static XPAssembler *sAssembler = nil;

@interface XPExpression ()
@property (nonatomic, retain, readwrite) id <XPStaticContext>staticContext;
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
    return [self expressionFromString:exprStr inContext:env simplify:YES error:outErr];
}


+ (XPExpression *)expressionFromString:(NSString *)exprStr inContext:(id <XPStaticContext>)env simplify:(BOOL)simplify error:(NSError **)outErr {
    XPAssert(sParser);

    XPExpression *expr = nil;
    @try {
        PKAssembly *a = [sParser parseString:exprStr error:outErr];
        expr = [a pop];
        
        if (simplify) {
            expr = [expr simplify];
        }
        [expr setStaticContext:env];
    }
    @catch (NSException *ex) {
        if (outErr) {
            id info = @{NSLocalizedDescriptionKey: [ex name], NSLocalizedFailureReasonErrorKey: [ex reason]};
            *outErr = [NSError errorWithDomain:XPathErrorDomain code:XPathErrorCodeCompiletime userInfo:info];
        }
    }
    return expr;
}


+ (XPFunction *)makeSystemFunction:(NSString *)name {
    XPAssert(sAssembler);
    return [sAssembler makeSystemFunction:name];
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


- (XPNodeSetValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    XPValue *v = [self evaluateInContext:ctx];
    v.range = self.range;
    
    if (![v isNodeSetValue]) {
        [NSException raise:XPathExceptionName format:@"The value %@ is not a node-set", v];
    }

    return (XPNodeSetValue *)v;
}


- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    XPValue *v = [self evaluateInContext:ctx];

    if ([v isNodeSetValue]) {
        if (sorted) {
            [(XPNodeSetValue *)v sort];
        }
        id <XPNodeEnumeration>e = [(XPNodeSetValue *)v enumerate];
        return e;
    }
    [NSException raise:XPathExceptionName format:@"The value is not a node-set"];
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
