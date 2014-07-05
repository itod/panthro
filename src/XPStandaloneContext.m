//
//  XPStandaloneContext.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPStandaloneContext.h"
#import "XPUtils.h"
#import "XPException.h"

#import "XPSync.h"
#import "XPContext.h"
#import "XPExpression.h"
#import "XPFunction.h"

#import "XPNSXMLNodeImpl.h"
#import "XPLibxmlNodeImpl.h"

#import "XPFunction.h"
#import "FNAbs.h"
#import "FNBoolean.h"
#import "FNCeiling.h"
#import "FNConcat.h"
#import "FNCompare.h"
#import "FNContains.h"
#import "FNCount.h"
#import "FNEndsWith.h"
#import "FNFloor.h"
#import "FNId.h"
#import "FNLang.h"
#import "FNLast.h"
#import "FNLocalName.h"
#import "FNLowerCase.h"
#import "FNMatches.h"
#import "FNName.h"
#import "FNNamespaceURI.h"
#import "FNNormalizeSpace.h"
#import "FNNormalizeUnicode.h"
#import "FNNot.h"
#import "FNNumber.h"
#import "FNPosition.h"
#import "FNRound.h"
#import "FNReplace.h"
#import "FNStartsWith.h"
#import "FNString.h"
#import "FNStringLength.h"
#import "FNSubstring.h"
#import "FNSubstringAfter.h"
#import "FNSubstringBefore.h"
#import "FNSum.h"
#import "FNTranslate.h"
#import "FNTrimSpace.h"
#import "FNTitleCase.h"
#import "FNUpperCase.h"

@interface XPStandaloneContext ()
@property (nonatomic, retain) NSMutableDictionary *variables;
@property (nonatomic, retain) NSMutableDictionary *functions;
@property (nonatomic, retain) NSMutableDictionary *namespaces;
@end

@implementation XPStandaloneContext

+ (instancetype)standaloneContext {
    return [[[self alloc] init] autorelease];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.variables = [NSMutableDictionary dictionary];
        self.functions = [NSMutableDictionary dictionary];
        self.namespaces = [NSMutableDictionary dictionary];

#if PAUSE_ENABLED
        self.debugSync = [XPSync sync];
#endif

		[self declareNamespaceURI:XPNamespaceXML forPrefix:@"xml"];
		[self declareNamespaceURI:XPNamespaceXSLT forPrefix:@"xsl"];
        [self declareNamespaceURI:@"" forPrefix:@""];
        
        [self declareSystemFunction:[FNAbs class] forName:[FNAbs name]];
        [self declareSystemFunction:[FNBoolean class] forName:[FNBoolean name]];
        [self declareSystemFunction:[FNCeiling class] forName:[FNCeiling name]];
        [self declareSystemFunction:[FNConcat class] forName:[FNConcat name]];
        [self declareSystemFunction:[FNCompare class] forName:[FNCompare name]];
        [self declareSystemFunction:[FNContains class] forName:[FNContains name]];
        [self declareSystemFunction:[FNCount class] forName:[FNCount name]];
        [self declareSystemFunction:[FNEndsWith class] forName:[FNEndsWith name]];
        [self declareSystemFunction:[FNFloor class] forName:[FNFloor name]];
        [self declareSystemFunction:[FNId class] forName:[FNId name]];
        [self declareSystemFunction:[FNLang class] forName:[FNLang name]];
        [self declareSystemFunction:[FNLast class] forName:[FNLast name]];
        [self declareSystemFunction:[FNLocalName class] forName:[FNLocalName name]];
        [self declareSystemFunction:[FNLowerCase class] forName:[FNLowerCase name]];
        [self declareSystemFunction:[FNMatches class] forName:[FNMatches name]];
        [self declareSystemFunction:[FNName class] forName:[FNName name]];
        [self declareSystemFunction:[FNNamespaceURI class] forName:[FNNamespaceURI name]];
        [self declareSystemFunction:[FNNormalizeSpace class] forName:[FNNormalizeSpace name]];
        [self declareSystemFunction:[FNNormalizeUnicode class] forName:[FNNormalizeUnicode name]];
        [self declareSystemFunction:[FNNot class] forName:[FNNot name]];
        [self declareSystemFunction:[FNNumber class] forName:[FNNumber name]];
        [self declareSystemFunction:[FNPosition class] forName:[FNPosition name]];
        [self declareSystemFunction:[FNRound class] forName:[FNRound name]];
        [self declareSystemFunction:[FNReplace class] forName:[FNReplace name]];
        [self declareSystemFunction:[FNStartsWith class] forName:[FNStartsWith name]];
        [self declareSystemFunction:[FNString class] forName:[FNString name]];
        [self declareSystemFunction:[FNStringLength class] forName:[FNStringLength name]];
        [self declareSystemFunction:[FNSubstring class] forName:[FNSubstring name]];
        [self declareSystemFunction:[FNSubstringAfter class] forName:[FNSubstringAfter name]];
        [self declareSystemFunction:[FNSubstringBefore class] forName:[FNSubstringBefore name]];
        [self declareSystemFunction:[FNSum class] forName:[FNSum name]];
        [self declareSystemFunction:[FNTranslate class] forName:[FNTranslate name]];
        [self declareSystemFunction:[FNTrimSpace class] forName:[FNTrimSpace name]];
        [self declareSystemFunction:[FNUpperCase class] forName:[FNUpperCase name]];
        [self declareSystemFunction:[FNTitleCase class] forName:[FNTitleCase name]];
    }
    return self;
}


- (void)dealloc {
    self.variables = nil;
    self.functions = nil;
    self.namespaces = nil;
#if PAUSE_ENABLED
    self.debugSync = nil;
#endif
    [super dealloc];
}


- (XPExpression *)compile:(NSString *)xpathStr error:(NSError **)outErr {
    NSParameterAssert([xpathStr length]);
    
    XPExpression *result = nil;
    NSError *err = nil;
    
    @autoreleasepool {
        result = [XPExpression expressionFromString:xpathStr inContext:self error:&err];
        
        [result retain]; // +1 to survive autorelase pool drain
        [err retain]; // +1 to survive autorelase pool drain
    }
    
    if (outErr) {
        *outErr = err;
    }
    
    [err autorelease]; // -1 to balance
    return [result autorelease]; // -1 to balance
}


- (id)evaluate:(XPExpression *)expr withContextNode:(id <XPNodeInfo>)ctxNode error:(NSError **)outErr {
    NSParameterAssert(expr);
    NSParameterAssert(ctxNode);
    
    id result = nil;
    NSError *err = nil;
    
    @autoreleasepool {
        XPContext *ctx = [[[XPContext alloc] initWithStaticContext:self] autorelease];
        ctx.contextNode = ctxNode;
        
        @try {
            result = [expr evaluateInContext:ctx];
        } @catch (XPException *ex) {
            result = nil;
            id info = @{NSLocalizedDescriptionKey: [ex name], NSLocalizedFailureReasonErrorKey: [ex reason], XPathExceptionRangeKey: [NSValue valueWithRange:[ex range]]};
            err = [NSError errorWithDomain:XPathErrorDomain code:XPathErrorCodeRuntime userInfo:info];
        }
        
        [result retain]; // +1 to survive autorelase pool drain
        [err retain]; // +1 to survive autorelase pool drain
    }
    
    if (outErr) {
        *outErr = err;
    }
    
    [err autorelease]; // -1 to balance
    return [result autorelease]; // -1 to balance
}


- (id)execute:(NSString *)xpathStr withNSXMLContextNode:(NSXMLNode *)nsxmlCtxNode error:(NSError **)outErr {
    id <XPNodeInfo>ctxNode = [XPNSXMLNodeImpl nodeInfoWithNode:nsxmlCtxNode];
    return [self execute:xpathStr withContextNode:ctxNode error:outErr];
}


- (id)execute:(NSString *)xpathStr withLibxmlContextNode:(void *)libxmlCtxNode parserContext:(xmlParserCtxtPtr)parserCtx error:(NSError **)outErr;{
    id <XPNodeInfo>ctxNode = [XPLibxmlNodeImpl nodeInfoWithNode:libxmlCtxNode parserContext:parserCtx];
    return [self execute:xpathStr withContextNode:ctxNode error:outErr];
}


- (id)execute:(NSString *)xpathStr withContextNode:(id <XPNodeInfo>)ctxNode error:(NSError **)outErr {
    XPExpression *expr = [self compile:xpathStr error:outErr];
    id result = nil;
    if (expr) {
        result = [self evaluate:expr withContextNode:ctxNode error:outErr];
    }
    return result;
}


- (XPFunction *)makeSystemFunction:(NSString *)name error:(NSError **)outErr {
    XPAssert(_functions);
    
    XPFunction *fn = nil;
    
    Class cls = [_functions objectForKey:name];
    if (cls) {
        fn = [[[cls alloc] init] autorelease];
        XPAssert(fn);
    } else {
        if (outErr) {
            NSString *msg = [NSString stringWithFormat:@"Unknown function: `%@()`", name];
            id info = @{NSLocalizedDescriptionKey: msg, NSLocalizedFailureReasonErrorKey: msg};
            *outErr = [NSError errorWithDomain:XPathErrorDomain code:XPathErrorCodeCompiletime userInfo:info];
        }
    }
    
    return fn;
}


- (void)declareSystemFunction:(Class)cls forName:(NSString *)name {
    XPAssert(cls);
    XPAssert([cls isSubclassOfClass:[XPFunction class]]);
    XPAssert([name length]);
    XPAssert(_functions);
    
    _functions[name] = cls;
}


/**
 * Declare a namespace whose prefix can be used in expressions
 */
    
- (void)declareNamespaceURI:(NSString *)uri forPrefix:(NSString *)prefix {
    NSParameterAssert(uri);
    NSParameterAssert(prefix);
    XPAssert(_namespaces);
    _namespaces[prefix] = uri;
}
    

/**
 * Get the system ID of the container of the expression
 * @return "" always
 */
    
- (NSString *)systemId {
    return @"";
}


/**
 * Get the Base URI of the stylesheet element, for resolving any relative URI's used
 * in the expression.
 * Used by the document() function.
 * @return "" always
 */
    
- (NSString *)baseURI {
    return @"";
}


/**
 * Get the line number of the expression within that container
 * @return -1 always
 */
    
- (NSUInteger)lineNumber {
    return NSNotFound;
}


/**
 * Get the URI for a prefix, using this Element as the context for namespace resolution
 * @param prefix The prefix
 * @throw XPathException if the prefix is not declared
 */
    
- (NSString *)namespaceURIForPrefix:(NSString *)prefix error:(NSError **)outErr {
    NSParameterAssert(prefix);
    XPAssert(_namespaces);
    XPAssert(outErr);
    
    NSString *uri = _namespaces[prefix];
    if (!uri) {
        if (outErr) {
            NSString *msg = [NSString stringWithFormat:@"Prefix `%@` has not been declared", prefix];
            id info = @{NSLocalizedDescriptionKey: msg, NSLocalizedFailureReasonErrorKey: msg};
            *outErr = [NSError errorWithDomain:XPathErrorDomain code:XPathErrorCodeCompiletime userInfo:info];
        }
    }

    return uri;
}


/**
 * Determine if an extension element is available
 */
    
- (BOOL)isElementAvailable:(NSString *)qname {
    return NO;
}


/**
 * Determine if a function is available
 */
    
- (BOOL)isFunctionAvailable:(NSString *)qname {
    
    NSString *prefix = XPNameGetPrefix(qname);
    if (![prefix length]) {
        return nil != [self makeSystemFunction:qname error:nil];
    }
    
    return NO;   // no user functions allowed in standalone context.
}


/**
 * Get the effective XSLT version in this region of the stylesheet
 */

- (NSString *)version {
    return @"1.1";
}


- (void)setValue:(XPValue *)val forVariable:(NSString *)name {
    NSParameterAssert(val);
    NSParameterAssert(name);
    XPAssert(_variables);
    
    [_variables setObject:val forKey:name];
}


- (XPValue *)valueForVariable:(NSString *)name {
    NSParameterAssert(name);
    XPAssert(_variables);
    
    return [_variables objectForKey:name];
}


#if PAUSE_ENABLED
- (void)pauseFrom:(XPExpression *)expr withContextNodes:(XPSequenceValue *)ctxNodes result:(XPValue *)result range:(NSRange)range done:(BOOL)isDone {
    XPAssert(expr);
    XPAssert(ctxNodes);
    XPAssert(result);
    XPAssert(NSNotFound != range.location);
    XPAssert(NSNotFound != range.length);
    XPAssert(range.length);

    if (self.debug) {
        id info = @{@"contextNodes": ctxNodes, @"result": result, @"done": @(isDone), @"mainQueryRange": [NSValue valueWithRange:range]};
        [self.debugSync pauseWithInfo:info];
        BOOL resume = [[self.debugSync awaitResume] boolValue];
        
        if (!resume) {
            [XPException raiseIn:expr format:@"User Terminated"];
        }
    }
}
#endif

@end
