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

NSString * const XPNamespaceXML = @"http://www.w3.org/XML/1998/namespace";
NSString * const XPNamespaceXSLT = @"http://www.w3.org/1999/XSL/Transform";

@interface XPStandaloneContext ()
@property (nonatomic, retain) NSMutableDictionary *vars;
@property (nonatomic, retain) NSDictionary *funcTab;
@end

@implementation XPStandaloneContext

+ (instancetype)standaloneContext {
    return [[[self alloc] init] autorelease];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.vars = [NSMutableDictionary dictionary];
        self.namespaces = [NSMutableDictionary dictionary];
        self.debugSync = [XPSync sync];

		[self declareNamespaceURI:XPNamespaceXML forPrefix:@"xml"];
		[self declareNamespaceURI:XPNamespaceXSLT forPrefix:@"xsl"];
        [self declareNamespaceURI:@"" forPrefix:@""];
        
        self.funcTab = @{
             [FNAbs name] : [FNAbs class],
             [FNBoolean name] : [FNBoolean class],
             [FNCeiling name] : [FNCeiling class],
             [FNConcat name] : [FNConcat class],
             [FNCompare name] : [FNCompare class],
             [FNContains name] : [FNContains class],
             [FNCount name] : [FNCount class],
             [FNEndsWith name] : [FNEndsWith class],
             [FNFloor name] : [FNFloor class],
             [FNId name] : [FNId class],
             [FNLast name] : [FNLast class],
             [FNLocalName name] : [FNLocalName class],
             [FNLowerCase name] : [FNLowerCase class],
             [FNMatches name] : [FNMatches class],
             [FNName name] : [FNName class],
             [FNNamespaceURI name] : [FNNamespaceURI class],
             [FNNormalizeSpace name] : [FNNormalizeSpace class],
             [FNNormalizeUnicode name] : [FNNormalizeUnicode class],
             [FNNot name] : [FNNot class],
             [FNNumber name] : [FNNumber class],
             [FNPosition name] : [FNPosition class],
             [FNRound name] : [FNRound class],
             [FNReplace name] : [FNReplace class],
             [FNStartsWith name] : [FNStartsWith class],
             [FNString name] : [FNString class],
             [FNStringLength name] : [FNStringLength class],
             [FNSubstring name] : [FNSubstring class],
             [FNSubstringAfter name] : [FNSubstringAfter class],
             [FNSubstringBefore name] : [FNSubstringBefore class],
             [FNSum name] : [FNSum class],
             [FNTranslate name] : [FNTranslate class],
             [FNTrimSpace name] : [FNTrimSpace class],
             [FNUpperCase name] : [FNUpperCase class],
             [FNTitleCase name] : [FNTitleCase class],
        };

    }
    return self;
}


- (void)dealloc {
    self.vars = nil;
    self.funcTab = nil;
    self.namespaces = nil;
    self.debugSync = nil;
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


- (XPFunction *)makeSystemFunction:(NSString *)name {
    XPAssert(_funcTab);
    
    Class cls = [_funcTab objectForKey:name];
    NSAssert1(cls, @"unknown function %@", name);
    
    XPFunction *fn = [[[cls alloc] init] autorelease];
    XPAssert(fn);
    
    return fn;
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
            NSString *msg = [NSString stringWithFormat:@"Prefix %@ has not been declared", prefix];
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
        return nil != [self makeSystemFunction:qname];
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
    XPAssert(_vars);
    
    [_vars setObject:val forKey:name];
}


- (XPValue *)valueForVariable:(NSString *)name {
    NSParameterAssert(name);
    XPAssert(_vars);
    
    return [_vars objectForKey:name];
}

@end
